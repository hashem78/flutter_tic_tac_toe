import '../engines/game_engine_interface.dart';
import '../engines/minimax_engine.dart';
import '../engines/online_engine.dart';
import '../models/game_model/game_initial_model.dart';

import '../models/game_model/game_draw_model.dart';
import '../models/game_model/game_win_model.dart';
import '../models/result_message_model/result_message_draw_model.dart';

import 'package:riverpod/riverpod.dart';
import '../extensions.dart';
import '../providers.dart';

class BoardNotifier extends StateNotifier<List<int>> {
  ProviderReference ref;
  BoardNotifier(this.ref) : super([0, 0, 0, 0, 0, 0, 0, 0, 0]);

  Future<void> updatePosition(GameEngine gameEngine, int position) async {
    if (gameEngine is MiniMaxGameEngine) {
      state = state.copyWithIndexTo(position, 1);
      MiniMaxGameEngine.startTask(handelMinimaxResultMessage, state);
    } else if (gameEngine is OnlineGameEngine) {
      OnlineGameEngine.updateBoard(position);
    }
  }

  void handelMinimaxResultMessage(dynamic message) {
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
    final gameEngine = ref.read(gameEngineProvider);
    if (gameEngine is OnlineGameEngine) {
      OnlineGameEngine.reset();
    } else {
      state = List<int>.filled(9, 0);
    }
    ref.read(gameEndModelProvider.notifier).change(const GameInitialModel());
  }

  void change(List<int> board) {
    state = board;
  }

  int operator [](int index) {
    return state[index];
  }
}
