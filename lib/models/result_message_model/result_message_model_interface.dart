import 'package:equatable/equatable.dart';

abstract class IResultMessageModel extends Equatable {
  final int winner;
  final int move;
  const IResultMessageModel({
    required this.winner,
    required this.move,
  });

  @override
  List<Object> get props => [winner, move];

  @override
  bool get stringify => true;
}
