import 'dart:convert';

import 'package:flutter_tic_tac_toe/engines/game_engine_interface.dart';
import 'package:flutter_tic_tac_toe/engines/minimax_engine.dart';
import 'package:flutter_tic_tac_toe/engines/online_engine.dart';
import 'package:flutter_tic_tac_toe/models/game_model/game_win_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../providers.dart';

class GameEngineNotifier extends StateNotifier<GameEngine> {
  GameEngineNotifier(this.ref) : super(const MiniMaxGameEngine());
  ProviderReference ref;
  void change(GameEngine engine) {
    state = engine;
  }

  void createRoom(String room) {
    OnlineGameEngine.createRoom(
      onlineResultHandeler,
      onlineWinningHandeler,
      (p0) {},
      room,
    );
  }

  void joinRoom(String room) {
    OnlineGameEngine.joinRoom(
      onlineResultHandeler,
      onlineWinningHandeler,
      (p0) {},
      room,
    );
  }

  void onlineWinningHandeler(dynamic data) {
    final decodedJson = jsonDecode(data);
    final winner = decodedJson['winner'];
    final winningIndicies = List<int>.from(decodedJson['winningIndicies']);
    ref.read(gameEndModelProvider.notifier).change(
          GameWinModel(
            winner: winner,
            winningIndicies: winningIndicies,
          ),
        );
  }

  void onlineResultHandeler(List<int> board) {
    ref.read(boardProvider.notifier).change(board);
  }
}
