import 'package:equatable/equatable.dart';

import 'chat_message.dart';

export 'chat_message.dart';

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
