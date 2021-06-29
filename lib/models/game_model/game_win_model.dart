import 'game_model_interface.dart';

class GameWinModel extends IGameModel {
  const GameWinModel({
    required int winner,
    required List<int> winningIndicies,
  }) : super(
          winner: winner,
          winningIndicies: winningIndicies,
        );
}
