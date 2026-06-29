import 'package:equatable/equatable.dart';

import '../../../domain/domain.dart';

enum MessageStatus { sending, sent, error }

class ChatMessage extends Equatable {
  final MessageModel? message;
  final String? clientMessageId;
  final String text;
  final String senderId;
  final MessageStatus status;
  final String? errorText;

  const ChatMessage({
    this.message,
    this.clientMessageId,
    required this.text,
    required this.senderId,
    required this.status,
    this.errorText,
  });

  ChatMessage copyWith({
    MessageModel? message,
    MessageStatus? status,
    String? errorText,
  }) {
    return ChatMessage(
      message: message ?? this.message,
      clientMessageId: clientMessageId,
      text: text,
      senderId: senderId,
      status: status ?? this.status,
      errorText: errorText ?? this.errorText,
    );
  }

  @override
  List<Object?> get props => [
        message,
        clientMessageId,
        text,
        senderId,
        status,
        errorText,
      ];
}

sealed class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object?> get props => [];
}

class ChatInitial extends ChatState {
  const ChatInitial();
}

class ChatLoading extends ChatState {
  const ChatLoading();
}

class ChatReady extends ChatState {
  final List<ChatMessage> messages;
  final bool isTyping;
  final String typingUserId;

  const ChatReady({
    required this.messages,
    this.isTyping = false,
    this.typingUserId = '',
  });

  ChatReady copyWith({
    List<ChatMessage>? messages,
    bool? isTyping,
    String? typingUserId,
  }) {
    return ChatReady(
      messages: messages ?? this.messages,
      isTyping: isTyping ?? this.isTyping,
      typingUserId: typingUserId ?? this.typingUserId,
    );
  }

  @override
  List<Object?> get props => [messages, isTyping, typingUserId];
}

class ChatFailure extends ChatState {
  final String message;

  const ChatFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
