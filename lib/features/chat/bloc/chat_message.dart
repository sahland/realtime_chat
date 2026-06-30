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
