import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../../data/data.dart';
import '../../../domain/domain.dart';
import '../../../uikit/uikit.dart';
import 'chat_event.dart';
import 'chat_state.dart';

export 'chat_event.dart';
export 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository _repository;
  final Uuid _uuid;

  StreamSubscription? _wsSubscription;
  String _roomId = '';
  String _userId = '';
  Timer? _typingTimer;
  bool _initialReady = true;

  ChatBloc({
    required ChatRepository repository,
    Uuid? uuid,
  })  : _repository = repository,
        _uuid = uuid ?? const Uuid(),
        super(const ChatInitial()) {
    on<ChatStarted>(_onStarted);
    on<ChatMessageSent>(_onMessageSent);
    on<ChatTypingSent>(_onTypingSent);
    on<ChatMessageReceived>(_onMessageReceived);
    on<ChatTypingReceived>(_onTypingReceived);
    on<ChatErrorReceived>(_onErrorReceived);
    on<ChatReconnected>(_onReconnected);
    on<ChatStopped>(_onStopped);
    on<ChatTypingExpired>(_onTypingExpired);
  }

  Future<void> _onStarted(
    ChatStarted event,
    Emitter<ChatState> emit,
  ) async {
    _roomId = event.roomId;
    _userId = event.userId;
    _initialReady = true;

    emit(const ChatLoading());

    try {
      final messages = await _repository.getMessages(
        roomId: _roomId,
        userId: _userId,
      );

      final chatMessages = messages
          .map((m) => ChatMessage(
                message: m,
                text: m.text,
                senderId: m.senderId,
                status: MessageStatus.sent,
              ))
          .toList();

      emit(ChatReady(messages: chatMessages));

      _wsSubscription = _repository.wsEvents.listen(_handleWsEvent);
      _repository.connectToRoom(roomId: _roomId, userId: _userId);
    } catch (e) {
      emit(ChatFailure(message: e.toString()));
    }
  }

  void _handleWsEvent(WsEvent event) {
    switch (event) {
      case WsReadyEvent():
        if (_initialReady) {
          _initialReady = false;
        } else {
          add(const ChatReconnected());
        }
      case WsMessageCreatedEvent():
        final message = MessageModel.fromJson(event.message);
        add(ChatMessageReceived(
          message: message,
          clientMessageId: event.clientMessageId,
        ));
      case WsTypingEvent():
        if (event.userId != _userId) {
          add(ChatTypingReceived(userId: event.userId));
        }
      case WsErrorEvent():
        add(ChatErrorReceived(
          error: event.error,
          clientMessageId: event.clientMessageId,
        ));
    }
  }

  Future<void> _onReconnected(
    ChatReconnected event,
    Emitter<ChatState> emit,
  ) async {
    final currentState = state;
    if (currentState is! ChatReady) return;

    try {
      final serverMessages = await _repository.getMessages(
        roomId: _roomId,
        userId: _userId,
      );

      final serverIds = {for (final m in serverMessages) m.id};
      final pending = currentState.messages
          .where((m) => m.status == MessageStatus.sending)
          .toList();

      final merged = serverMessages
          .map((m) => ChatMessage(
                message: m,
                text: m.text,
                senderId: m.senderId,
                status: MessageStatus.sent,
              ))
          .toList();

      for (final p in pending) {
        final confirmed = p.message != null && serverIds.contains(p.message!.id);
        if (!confirmed) {
          merged.add(p);
        }
      }

      emit(currentState.copyWith(messages: merged));
    } catch (_) {}
  }

  void _onMessageSent(
    ChatMessageSent event,
    Emitter<ChatState> emit,
  ) {
    final currentState = state;
    if (currentState is! ChatReady) return;

    final clientMessageId = _uuid.v4();

    final optimisticMessage = ChatMessage(
      clientMessageId: clientMessageId,
      text: event.text,
      senderId: _userId,
      status: MessageStatus.sending,
    );

    emit(currentState.copyWith(
      messages: [...currentState.messages, optimisticMessage],
    ));

    _repository.sendMessage(
      text: event.text,
      clientMessageId: clientMessageId,
    );
  }

  void _onTypingSent(
    ChatTypingSent event,
    Emitter<ChatState> emit,
  ) {
    _repository.sendTyping();
  }

  void _onMessageReceived(
    ChatMessageReceived event,
    Emitter<ChatState> emit,
  ) {
    final currentState = state;
    if (currentState is! ChatReady) return;

    final messages = List<ChatMessage>.from(currentState.messages);

    if (event.clientMessageId != null) {
      final index = messages.indexWhere(
        (m) => m.clientMessageId == event.clientMessageId,
      );
      if (index != -1) {
        messages[index] = messages[index].copyWith(
          message: event.message,
          status: MessageStatus.sent,
        );
        emit(currentState.copyWith(messages: messages, isTyping: false));
        return;
      }
    }

    final duplicate = messages.any(
      (m) => m.message?.id == event.message.id,
    );
    if (duplicate) return;

    messages.add(ChatMessage(
      message: event.message,
      text: event.message.text,
      senderId: event.message.senderId,
      status: MessageStatus.sent,
    ));

    emit(currentState.copyWith(messages: messages, isTyping: false));
  }

  void _onTypingReceived(
    ChatTypingReceived event,
    Emitter<ChatState> emit,
  ) {
    final currentState = state;
    if (currentState is! ChatReady) return;

    _typingTimer?.cancel();

    emit(currentState.copyWith(
      isTyping: true,
      typingUserId: event.userId,
    ));

    _typingTimer = Timer(AppDuration.typingTimeout, () {
      final s = state;
      if (s is ChatReady) {
        add(const ChatTypingExpired());
      }
    });
  }

  void _onErrorReceived(
    ChatErrorReceived event,
    Emitter<ChatState> emit,
  ) {
    final currentState = state;
    if (currentState is! ChatReady) return;

    if (event.clientMessageId != null) {
      final messages = List<ChatMessage>.from(currentState.messages);
      final index = messages.indexWhere(
        (m) => m.clientMessageId == event.clientMessageId,
      );
      if (index != -1) {
        messages[index] = messages[index].copyWith(
          status: MessageStatus.error,
          errorText: event.error,
        );
        emit(currentState.copyWith(messages: messages));
        return;
      }
    }
  }

  void _onTypingExpired(
    ChatTypingExpired event,
    Emitter<ChatState> emit,
  ) {
    final currentState = state;
    if (currentState is! ChatReady) return;
    emit(currentState.copyWith(isTyping: false, typingUserId: ''));
  }

  void _onStopped(
    ChatStopped event,
    Emitter<ChatState> emit,
  ) {
    _cleanup();
  }

  void _cleanup() {
    _typingTimer?.cancel();
    _wsSubscription?.cancel();
    _repository.disconnectFromRoom();
  }

  @override
  Future<void> close() {
    _cleanup();
    return super.close();
  }
}
