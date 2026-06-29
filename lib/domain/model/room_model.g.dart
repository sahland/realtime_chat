// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RoomModel _$RoomModelFromJson(Map<String, dynamic> json) => RoomModel(
  id: json['id'] as String,
  userAId: json['user_a_id'] as String,
  userBId: json['user_b_id'] as String,
  createdAt: json['created_at'] as String,
  lastMessage: json['last_message'] == null
      ? null
      : MessageModel.fromJson(json['last_message'] as Map<String, dynamic>),
);

Map<String, dynamic> _$RoomModelToJson(RoomModel instance) => <String, dynamic>{
  'id': instance.id,
  'user_a_id': instance.userAId,
  'user_b_id': instance.userBId,
  'created_at': instance.createdAt,
  'last_message': instance.lastMessage,
};
