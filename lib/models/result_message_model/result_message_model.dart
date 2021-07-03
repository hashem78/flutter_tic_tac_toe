import 'package:equatable/equatable.dart';

class ResultMessageModel extends Equatable {
  final int winner;
  final int move;
  const ResultMessageModel({
    required this.winner,
    required this.move,
  });

  @override
  List<Object> get props => [winner, move];

  @override
  bool get stringify => true;
}
