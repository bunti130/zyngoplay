import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'api_service.dart';

class SocketService {
  static IO.Socket? socket;

  static void connect() {
    socket = IO.io(ApiService.baseUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket!.connect();

    socket!.onConnect((_) {
      print('Connected to Socket.io server');
    });

    socket!.onDisconnect((_) => print('Disconnected from Socket.io server'));
  }

  static void joinMatchmaking(String game) {
    if (socket != null && ApiService.userId != null) {
      socket!.emit('join_matchmaking', {
        'game': game,
        'userId': ApiService.userId,
      });
    }
  }

  static void disconnect() {
    socket?.disconnect();
  }
}
