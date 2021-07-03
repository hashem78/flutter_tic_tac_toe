import 'game_model.dart';

class GameWinModel extends GameModel {
  const GameWinModel({
    required int winner,
    required List<int> winningIndicies,
  }) : super(
          winner: winner,
          winningIndicies: winningIndicies,
        );
}
