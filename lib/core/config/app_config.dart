import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static String get apiUrl => dotenv.env['API_URL'] ?? 'http://localhost:8088';
  static String get wsUrl => dotenv.env['WS_URL'] ?? 'ws://localhost:8088';

  static const connectTimeout = Duration(seconds: 10);
  static const receiveTimeout = Duration(seconds: 10);
  static const sendTimeout = Duration(seconds: 10);

  static const wsReconnectMin = Duration(seconds: 1);
  static const wsReconnectMax = Duration(seconds: 30);
}
