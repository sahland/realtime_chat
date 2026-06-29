import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'app.dart';
import 'core/core.dart';
import 'data/data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();

  final dio = Dio(BaseOptions(baseUrl: AppConfig.apiUrl));

  final repository = ChatRepository(
    usersApi: UsersApiClient(dio),
    roomsApi: RoomsApiClient(dio),
    messagesApi: MessagesApiClient(dio),
    wsService: WsService(),
  );

  runApp(App(repository: repository));
}
