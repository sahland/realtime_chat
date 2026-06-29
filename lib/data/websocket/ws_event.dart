import 'package:equatable/equatable.dart';

sealed class WsEvent extends Equatable {
  const WsEvent();
}

class WsReadyEvent extends WsEvent {
  final String roomId;
  final String userId;

  const WsReadyEvent({required this.roomId, required this.userId});

  @override
  List<Object?> get props => [roomId, userId];
}

class WsMessageCreatedEvent extends WsEvent {
  final String roomId;
  final String? clientMessageId;
  final Map<String, dynamic> message;

  const WsMessageCreatedEvent({
    required this.roomId,
    this.clientMessageId,
    required this.message,
  });

  @override
  List<Object?> get props => [roomId, clientMessageId, message];
}

class WsTypingEvent extends WsEvent {
  final String roomId;
  final String userId;

  const WsTypingEvent({required this.roomId, required this.userId});

  @override
  List<Object?> get props => [roomId, userId];
}

class WsErrorEvent extends WsEvent {
  final String error;
  final String? roomId;
  final String? clientMessageId;

  const WsErrorEvent({
    required this.error,
    this.roomId,
    this.clientMessageId,
  });

  @override
  List<Object?> get props => [error, roomId, clientMessageId];
}
