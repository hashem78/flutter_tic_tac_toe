import '../models/game_model/game_initial_model.dart';
import '../models/game_model/game_model_interface.dart';
import 'package:riverpod/riverpod.dart';

class GameEndNotifier extends StateNotifier<IGameModel> {
  GameEndNotifier() : super(const GameInitialModel());
  void change(IGameModel model) {
    state = model;
  }
}
