import 'package:equatable/equatable.dart';

abstract class GameModel extends Equatable {
  final int winner;
  final List<int> winningIndicies;
  const GameModel({
    required this.winner,
    required this.winningIndicies,
  });

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [winner, winningIndicies];
}
