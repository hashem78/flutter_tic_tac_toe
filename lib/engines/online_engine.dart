import 'package:socket_io_client/socket_io_client.dart';

import 'game_engine.dart';

class OnlineGameEngine extends GameEngine {
  const OnlineGameEngine();
  static Socket? socket;
  static void createRoom(
    void Function(List<int> board) stateChangeHandeler,
    void Function(dynamic) winningHandeler,
    void Function(dynamic) drawHandeler,
    String room,
  ) {
    if (socket == null) {
      socket = io(
        "https://368d004015c9.ngrok.io",
        OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect()
            .build(),
      );

      socket!.connect();
      socket!.emit('room-create', room);

      socket!.emit('room-join', room);

      socket!.on(
        'board-state',
        (data) {
          stateChangeHandeler(List<int>.from(data));
        },
      );

      socket!.on('disconnect', (_) => socket!.dispose());
      socket!.on('draw', drawHandeler);
      socket!.on('win', winningHandeler);
    }
  }

  static void updateBoard(int position) {
    socket?.emit('update-board-state', position);
  }

  static void leave() {
    socket?.dispose();
    socket = null;
  }

  static void joinRoom(
    void Function(List<int> board) stateChangeHandeler,
    void Function(dynamic) winningHandeler,
    void Function(dynamic) drawHandeler,
    String room,
  ) {
    socket?.dispose();
    socket = io(
      "https://368d004015c9.ngrok.io",
      OptionBuilder().setTransports(['websocket']).disableAutoConnect().build(),
    );
    socket!.connect();
    socket!.emit('room-join', room);

    socket!.on(
      'board-state',
      (data) => stateChangeHandeler(List<int>.from(data)),
    );

    socket!.on('disconnect', (_) => socket!.dispose());
    socket!.on('draw', drawHandeler);
    socket!.on('win', winningHandeler);
  }

  static void reset() {
    if (socket != null) {
      socket!.emit('reset');
    }
  }
}
