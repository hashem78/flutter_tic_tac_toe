import 'package:flutter_tic_tac_toe/engines/game_engine_interface.dart';
import 'package:flutter_tic_tac_toe/notifiers/game_engine_notifier.dart';

import '../models/game_model/game_model_interface.dart';
import 'notifiers/game_end_notifier.dart';
import 'package:riverpod/riverpod.dart';

import 'notifiers/board_notifier.dart';

final gameEndModelProvider = StateNotifierProvider<GameEndNotifier, GameModel>(
  (ref) => GameEndNotifier(ref),
);
final boardProvider = StateNotifierProvider<BoardNotifier, List<int>>(
  (ref) => BoardNotifier(ref),
);
final gameEngineProvider =
    StateNotifierProvider<GameEngineNotifier, GameEngine>(
  (ref) => GameEngineNotifier(ref),
);
