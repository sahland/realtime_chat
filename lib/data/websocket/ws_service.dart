import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:web_socket_channel/web_socket_channel.dart';

import '../../core/core.dart';
import 'ws_event.dart';

class WsService {
  WebSocketChannel? _channel;
  StreamSubscription? _subscription;
  Timer? _reconnectTimer;

  final _eventController = StreamController<WsEvent>.broadcast();
  Stream<WsEvent> get events => _eventController.stream;

  String? _roomId;
  String? _userId;
  bool _disposed = false;
  int _reconnectAttempt = 0;

  void connect({required String roomId, required String userId}) {
    _roomId = roomId;
    _userId = userId;
    _disposed = false;
    _reconnectAttempt = 0;
    _establish();
  }

  void _establish() {
    if (_disposed) return;

    try {
      final uri = Uri.parse(
        '${AppConfig.wsUrl}/ws?room_id=$_roomId&user_id=$_userId',
      );
      _channel = WebSocketChannel.connect(uri);

      _subscription = _channel!.stream.listen(
        _onData,
        onError: _onError,
        onDone: _onDone,
      );
    } catch (_) {
      _scheduleReconnect();
    }
  }

  void _onData(dynamic raw) {
    try {
      final data = jsonDecode(raw as String) as Map<String, dynamic>;
      final type = data['type'] as String?;

      final event = switch (type) {
        'ready' => WsReadyEvent(
            roomId: data['room_id'] as String,
            userId: data['user_id'] as String,
          ),
        'message.created' => WsMessageCreatedEvent(
            roomId: data['room_id'] as String,
            clientMessageId: data['client_message_id'] as String?,
            message: data['message'] as Map<String, dynamic>,
          ),
        'typing' => WsTypingEvent(
            roomId: data['room_id'] as String,
            userId: data['user_id'] as String,
          ),
        'error' => WsErrorEvent(
            error: data['error'] as String,
            roomId: data['room_id'] as String?,
            clientMessageId: data['client_message_id'] as String?,
          ),
        _ => null,
      };

      if (event != null) {
        _reconnectAttempt = 0;
        _eventController.add(event);
      }
    } catch (_) {}
  }

  void _onError(Object error) {
    _scheduleReconnect();
  }

  void _onDone() {
    _scheduleReconnect();
  }

  void _scheduleReconnect() {
    if (_disposed) return;
    _reconnectTimer?.cancel();

    final minMs = AppConfig.wsReconnectMin.inMilliseconds;
    final maxMs = AppConfig.wsReconnectMax.inMilliseconds;
    final delayMs = min(minMs * pow(2, _reconnectAttempt).toInt(), maxMs);
    _reconnectAttempt++;

    _reconnectTimer = Timer(Duration(milliseconds: delayMs), () {
      _subscription?.cancel();
      _establish();
    });
  }

  void sendMessage({required String text, required String clientMessageId}) {
    _send({
      'type': 'message.send',
      'text': text,
      'client_message_id': clientMessageId,
    });
  }

  void sendTyping() {
    _send({'type': 'typing'});
  }

  void _send(Map<String, dynamic> data) {
    try {
      _channel?.sink.add(jsonEncode(data));
    } catch (_) {}
  }

  void disconnect() {
    _disposed = true;
    _reconnectTimer?.cancel();
    _subscription?.cancel();
    _channel?.sink.close();
  }

  void dispose() {
    disconnect();
    _eventController.close();
  }
}
