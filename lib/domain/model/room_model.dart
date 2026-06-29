import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'message_model.dart';

part 'room_model.g.dart';

@JsonSerializable()
class RoomModel extends Equatable {
  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'user_a_id')
  final String userAId;

  @JsonKey(name: 'user_b_id')
  final String userBId;

  @JsonKey(name: 'created_at')
  final String createdAt;

  @JsonKey(name: 'last_message')
  final MessageModel? lastMessage;

  const RoomModel({
    required this.id,
    required this.userAId,
    required this.userBId,
    required this.createdAt,
    this.lastMessage,
  });

  factory RoomModel.fromJson(Map<String, dynamic> json) =>
      _$RoomModelFromJson(json);

  Map<String, dynamic> toJson() => _$RoomModelToJson(this);

  @override
  List<Object?> get props => [id, userAId, userBId, createdAt, lastMessage];
}
