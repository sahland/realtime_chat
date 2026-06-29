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

  Future<List<UserModel>> getUsers() => _usersApi.getUsers();

  Future<UserModel> createUser(String name) =>
      _usersApi.createUser({'name': name});

  Future<List<RoomModel>> getRooms(String userId) =>
      _roomsApi.getRooms(userId);

  Future<RoomModel> createDirectRoom({
    required String userAId,
    required String userBId,
  }) =>
      _roomsApi.createDirectRoom({
        'user_a_id': userAId,
        'user_b_id': userBId,
      });

  Future<List<MessageModel>> getMessages({
    required String roomId,
    required String userId,
    int limit = 50,
  }) =>
      _messagesApi.getMessages(roomId, userId, limit);

  Stream<WsEvent> get wsEvents => _wsService.events;

  void connectToRoom({required String roomId, required String userId}) =>
      _wsService.connect(roomId: roomId, userId: userId);

  void disconnectFromRoom() => _wsService.disconnect();

  void sendMessage({required String text, required String clientMessageId}) =>
      _wsService.sendMessage(text: text, clientMessageId: clientMessageId);

  void sendTyping() => _wsService.sendTyping();
}
