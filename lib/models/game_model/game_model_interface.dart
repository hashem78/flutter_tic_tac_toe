import 'package:equatable/equatable.dart';

abstract class IGameModel extends Equatable {
  final int winner;
  final List<int> winningIndicies;
  const IGameModel({
    required this.winner,
    required this.winningIndicies,
  });

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [winner, winningIndicies];
}
