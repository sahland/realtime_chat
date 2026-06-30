// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UsersListResponse _$UsersListResponseFromJson(Map<String, dynamic> json) =>
    UsersListResponse(
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => UserModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$UsersListResponseToJson(UsersListResponse instance) =>
    <String, dynamic>{'items': instance.items};

RoomsListResponse _$RoomsListResponseFromJson(Map<String, dynamic> json) =>
    RoomsListResponse(
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => RoomModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RoomsListResponseToJson(RoomsListResponse instance) =>
    <String, dynamic>{'items': instance.items};

MessagesListResponse _$MessagesListResponseFromJson(
  Map<String, dynamic> json,
) => MessagesListResponse(
  items: (json['items'] as List<dynamic>?)
      ?.map((e) => MessageModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$MessagesListResponseToJson(
  MessagesListResponse instance,
) => <String, dynamic>{'items': instance.items};
