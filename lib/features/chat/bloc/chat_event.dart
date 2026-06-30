import 'package:equatable/equatable.dart';

import '../../../domain/domain.dart';

sealed class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

class ChatStarted extends ChatEvent {
  final String roomId;
  final String userId;

  const ChatStarted({required this.roomId, required this.userId});

  @override
  List<Object?> get props => [roomId, userId];
}

class ChatMessageSent extends ChatEvent {
  final String text;

  const ChatMessageSent({required this.text});

  @override
  List<Object?> get props => [text];
}

class ChatTypingSent extends ChatEvent {
  const ChatTypingSent();
}

class ChatMessageReceived extends ChatEvent {
  final MessageModel message;
  final String? clientMessageId;

  const ChatMessageReceived({
    required this.message,
    this.clientMessageId,
  });

  @override
  List<Object?> get props => [message, clientMessageId];
}

class ChatTypingReceived extends ChatEvent {
  final String userId;

  const ChatTypingReceived({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class ChatErrorReceived extends ChatEvent {
  final String error;
  final String? clientMessageId;

  const ChatErrorReceived({
    required this.error,
    this.clientMessageId,
  });

  @override
  List<Object?> get props => [error, clientMessageId];
}

class ChatReconnected extends ChatEvent {
  const ChatReconnected();
}

class ChatStopped extends ChatEvent {
  const ChatStopped();
}

class ChatTypingExpired extends ChatEvent {
  const ChatTypingExpired();
}
