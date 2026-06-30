import 'package:json_annotation/json_annotation.dart';

import 'user_model.dart';
import 'room_model.dart';
import 'message_model.dart';

part 'list_response.g.dart';

@JsonSerializable()
class UsersListResponse {
  @JsonKey(name: 'items')
  final List<UserModel>? items;

  const UsersListResponse({this.items});

  factory UsersListResponse.fromJson(Map<String, dynamic> json) =>
      _$UsersListResponseFromJson(json);
}

@JsonSerializable()
class RoomsListResponse {
  @JsonKey(name: 'items')
  final List<RoomModel>? items;

  const RoomsListResponse({this.items});

  factory RoomsListResponse.fromJson(Map<String, dynamic> json) =>
      _$RoomsListResponseFromJson(json);
}

@JsonSerializable()
class MessagesListResponse {
  @JsonKey(name: 'items')
  final List<MessageModel>? items;

  const MessagesListResponse({this.items});

  factory MessagesListResponse.fromJson(Map<String, dynamic> json) =>
      _$MessagesListResponseFromJson(json);
}
