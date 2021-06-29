import 'package:flutter_tic_tac_toe/engines/game_engine_interface.dart';
import 'package:flutter_tic_tac_toe/engines/minimax_engine.dart';
import 'package:flutter_tic_tac_toe/models/game_model/game_initial_model.dart';

import '../models/game_model/game_draw_model.dart';
import '../models/game_model/game_win_model.dart';
import '../models/result_message_model/result_message_draw_model.dart';

import 'package:riverpod/riverpod.dart';
import '../extensions.dart';
import '../providers.dart';

class BoardNotifier extends StateNotifier<List<int>> {
  ProviderReference ref;
  BoardNotifier(this.ref) : super([0, 0, 0, 0, 0, 0, 0, 0, 0]);

  Future<void> updateXPosition(GameEngine gameEngine, int position) async {
    state = state.copyWithIndexTo(position, 1);

    if (gameEngine is MiniMaxGameEngine) {
      MiniMaxGameEngine.startTask(handelResultMessage, state);
    }
  }

  void handelResultMessage(dynamic message) {
    if (message is ResultMessageDrawModel) {
      ref.read(gameEndModelProvider.notifier).change(const GameDrawModel());
      return;
    }

    state = state.copyWithIndexTo(message.move, -1);

    if (message.winner != 0) {
      ref.read(gameEndModelProvider.notifier).change(
            GameWinModel(
              winner: message.winner,
              winningIndicies: state.getWinningIndicies(),
            ),
          );
    }
  }

  void reset() {
    state = List<int>.filled(9, 0);
    ref.read(gameEndModelProvider.notifier).change(const GameInitialModel());
  }

  int operator [](int index) {
    return state[index];
  }
}
