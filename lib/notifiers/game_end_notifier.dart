import '../models/game_model/game_initial_model.dart';
import '../models/game_model/game_model_interface.dart';
import 'package:riverpod/riverpod.dart';

class GameEndNotifier extends StateNotifier<GameModel> {
  GameEndNotifier(this.ref) : super(const GameInitialModel());
  ProviderReference ref;
  void change(GameModel model) {
    state = model;
  }
}
