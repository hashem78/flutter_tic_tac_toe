import 'result_message_model_interface.dart';

class ResultMessageWinModel extends IResultMessageModel {
  const ResultMessageWinModel({
    required int winner,
    required int move,
  }) : super(
          winner: winner,
          move: move,
        );
}
