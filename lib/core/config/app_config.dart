import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static String get apiUrl => dotenv.env['API_URL'] ?? 'http://localhost:8088';
  static String get wsUrl => dotenv.env['WS_URL'] ?? 'ws://localhost:8088';
}
