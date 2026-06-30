import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../domain/domain.dart';

part 'rooms_api_client.g.dart';

@RestApi()
abstract class RoomsApiClient {
  factory RoomsApiClient(Dio dio, {String baseUrl}) = _RoomsApiClient;

  @GET('/api/rooms')
  Future<RoomsListResponse> getRooms(@Query('user_id') String userId);

  @POST('/api/rooms/direct')
  Future<RoomModel> createDirectRoom(@Body() Map<String, dynamic> body);
}
