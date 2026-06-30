import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../domain/domain.dart';

part 'messages_api_client.g.dart';

@RestApi()
abstract class MessagesApiClient {
  factory MessagesApiClient(Dio dio, {String baseUrl}) = _MessagesApiClient;

  @GET('/api/rooms/{room_id}/messages')
  Future<MessagesListResponse> getMessages(
    @Path('room_id') String roomId,
    @Query('user_id') String userId,
    @Query('limit') int limit,
  );
}
