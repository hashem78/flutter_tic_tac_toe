import '../models/game_model/game_model_interface.dart';
import 'notifiers/game_end_notifier.dart';
import 'package:riverpod/riverpod.dart';

import 'notifiers/board_notifier.dart';

final gameEndModelProvider = StateNotifierProvider<GameEndNotifier, IGameModel>(
  (ref) => GameEndNotifier(),
);
final boardProvider = StateNotifierProvider<BoardNotifier, List<int>>(
  (ref) => BoardNotifier(ref),
);
