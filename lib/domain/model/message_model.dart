import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'message_model.g.dart';

@JsonSerializable()
class MessageModel extends Equatable {
  @JsonKey(name: 'id')
  final int id;

  @JsonKey(name: 'room_id')
  final String roomId;

  @JsonKey(name: 'sender_id')
  final String senderId;

  @JsonKey(name: 'text')
  final String text;

  @JsonKey(name: 'created_at')
  final String createdAt;

  const MessageModel({
    required this.id,
    required this.roomId,
    required this.senderId,
    required this.text,
    required this.createdAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) =>
      _$MessageModelFromJson(json);

  Map<String, dynamic> toJson() => _$MessageModelToJson(this);

  @override
  List<Object?> get props => [id, roomId, senderId, text, createdAt];
}
