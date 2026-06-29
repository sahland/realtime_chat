import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'core/core.dart';
import 'data/data.dart';
import 'theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();

  final prefs = await SharedPreferences.getInstance();
  final dio = Dio(BaseOptions(baseUrl: AppConfig.apiUrl));

  final repository = ChatRepository(
    usersApi: UsersApiClient(dio),
    roomsApi: RoomsApiClient(dio),
    messagesApi: MessagesApiClient(dio),
    wsService: WsService(),
  );

  final themeStorage = ThemeStorage(prefs: prefs);
  final themeRepository = ThemeRepository(storage: themeStorage);
  final themeController = ThemeController(repository: themeRepository);

  runApp(App(
    repository: repository,
    themeController: themeController,
  ));
}
