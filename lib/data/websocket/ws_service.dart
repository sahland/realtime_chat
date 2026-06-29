import 'dart:async';
import 'dart:convert';

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

  static const _reconnectDelay = Duration(seconds: 3);

  void connect({required String roomId, required String userId}) {
    _roomId = roomId;
    _userId = userId;
    _disposed = false;
    _establish();
  }

  void _establish() {
    if (_disposed) return;

    final uri = Uri.parse('${AppConfig.wsUrl}/ws?room_id=$_roomId&user_id=$_userId');
    _channel = WebSocketChannel.connect(uri);

    _subscription = _channel!.stream.listen(
      _onData,
      onError: _onError,
      onDone: _onDone,
    );
  }

  void _onData(dynamic raw) {
    final data = jsonDecode(raw as String) as Map<String, dynamic>;
    final type = data['type'] as String?;

    switch (type) {
      case 'ready':
        _eventController.add(WsReadyEvent(
          roomId: data['room_id'] as String,
          userId: data['user_id'] as String,
        ));
      case 'message.created':
        _eventController.add(WsMessageCreatedEvent(
          roomId: data['room_id'] as String,
          clientMessageId: data['client_message_id'] as String?,
          message: data['message'] as Map<String, dynamic>,
        ));
      case 'typing':
        _eventController.add(WsTypingEvent(
          roomId: data['room_id'] as String,
          userId: data['user_id'] as String,
        ));
      case 'error':
        _eventController.add(WsErrorEvent(
          error: data['error'] as String,
          roomId: data['room_id'] as String?,
          clientMessageId: data['client_message_id'] as String?,
        ));
    }
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
    _reconnectTimer = Timer(_reconnectDelay, () {
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
    _channel?.sink.add(jsonEncode(data));
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
