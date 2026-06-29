import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../domain/domain.dart';

part 'users_api_client.g.dart';

@RestApi()
abstract class UsersApiClient {
  factory UsersApiClient(Dio dio, {String baseUrl}) = _UsersApiClient;

  @GET('/api/users')
  Future<List<UserModel>> getUsers();

  @POST('/api/users')
  Future<UserModel> createUser(@Body() Map<String, dynamic> body);
}
