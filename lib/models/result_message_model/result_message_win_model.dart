import 'result_message_model.dart';

class ResultMessageWinModel extends ResultMessageModel {
  const ResultMessageWinModel({
    required int winner,
    required int move,
  }) : super(
          winner: winner,
          move: move,
        );
}
