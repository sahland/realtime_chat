import 'package:dio/dio.dart';

import '../../domain/domain.dart';
import '../api/api.dart';
import '../websocket/websocket.dart';

class ChatRepository {
  final UsersApiClient _usersApi;
  final RoomsApiClient _roomsApi;
  final MessagesApiClient _messagesApi;
  final WsService _wsService;

  ChatRepository({
    required UsersApiClient usersApi,
    required RoomsApiClient roomsApi,
    required MessagesApiClient messagesApi,
    required WsService wsService,
  })  : _usersApi = usersApi,
        _roomsApi = roomsApi,
        _messagesApi = messagesApi,
        _wsService = wsService;

  Future<List<UserModel>> getUsers() async {
    try {
      final response = await _usersApi.getUsers();
      return response.items ?? [];
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  Future<UserModel> createUser(String name) async {
    try {
      return await _usersApi.createUser({'name': name});
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  Future<List<RoomModel>> getRooms(String userId) async {
    try {
      final response = await _roomsApi.getRooms(userId);
      return response.items ?? [];
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  Future<RoomModel> createDirectRoom({
    required String userAId,
    required String userBId,
  }) async {
    try {
      return await _roomsApi.createDirectRoom({
        'user_a_id': userAId,
        'user_b_id': userBId,
      });
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  Future<List<MessageModel>> getMessages({
    required String roomId,
    required String userId,
    int limit = 50,
  }) async {
    try {
      final response = await _messagesApi.getMessages(roomId, userId, limit);
      return response.items ?? [];
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  Stream<WsEvent> get wsEvents => _wsService.events;

  void connectToRoom({required String roomId, required String userId}) =>
      _wsService.connect(roomId: roomId, userId: userId);

  void disconnectFromRoom() => _wsService.disconnect();

  void sendMessage({required String text, required String clientMessageId}) =>
      _wsService.sendMessage(text: text, clientMessageId: clientMessageId);

  void sendTyping() => _wsService.sendTyping();

  String _mapDioError(DioException e) {
    return switch (e.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout =>
        'Превышено время ожидания. Проверьте подключение.',
      DioExceptionType.connectionError =>
        'Нет подключения к серверу.',
      DioExceptionType.badResponse =>
        'Ошибка сервера (${e.response?.statusCode ?? '?'}).',
      _ => 'Ошибка сети. Попробуйте ещё раз.',
    };
  }
}
