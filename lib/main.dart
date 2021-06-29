import 'dart:io';
import 'dart:isolate';
import 'dart:math';

import 'package:desktop_window/desktop_window.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

enum Winner { x, o, none }

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

class GameInitialModel extends GameModel {
  const GameInitialModel() : super(winner: 0, winningIndicies: const []);
}

class GameDrawModel extends GameModel {
  const GameDrawModel() : super(winner: 0, winningIndicies: const []);
}

class GameWinModel extends GameModel {
  const GameWinModel({
    required int winner,
    required List<int> winningIndicies,
  }) : super(
          winner: winner,
          winningIndicies: winningIndicies,
        );
}

class GameEndNotifier extends StateNotifier<GameModel> {
  GameEndNotifier() : super(const GameInitialModel());
  void change(GameModel model) {
    state = model;
  }
}

final gameEndModelProvider = StateNotifierProvider<GameEndNotifier, GameModel>(
  (ref) => GameEndNotifier(),
);

extension EmptyPlacesX on List<int> {
  List<int> get emptyPlaces {
    final ans = <int>[];
    for (int i = 0; i < length; ++i) {
      if (this[i] == 0) {
        ans.add(i);
      }
    }
    return ans;
  }

  List<int> copyWithIndexTo(int index, int to) {
    final ans = <int>[...this];
    ans[index] = to;
    return ans;
  }
}

class ResultMessage extends Equatable {
  final int winner;
  final int move;
  const ResultMessage({
    required this.winner,
    required this.move,
  });

  ResultMessage copyWith({
    int? winner,
    int? move,
  }) {
    return ResultMessage(
      winner: winner ?? this.winner,
      move: move ?? this.move,
    );
  }

  @override
  List<Object> get props => [winner, move];

  @override
  bool get stringify => true;
}

const drawResultMessage = ResultMessage(winner: -2, move: 0);

class BoardNotifier extends StateNotifier<List<int>> {
  ProviderReference ref;
  BoardNotifier(this.ref) : super([0, 0, 0, 0, 0, 0, 0, 0, 0]);

  Future<void> updateXPosition(int position) async {
    state = state.copyWithIndexTo(position, 1);

    final port = ReceivePort();
    final isolate = await Isolate.spawn(
      _heavyTask,
      [port.sendPort, state],
    );
    port.listen(
      handelResultMessage,
      onDone: () => isolate.kill(priority: Isolate.immediate),
    );
  }

  static List<int> getWinningIndicies(List<int> board) {
    final ans = <int>[];
    for (int i = 0; i < 9; i += 3) {
      if (board[i] == board[i + 1] &&
          board[i] == board[i + 2] &&
          board[i + 1] == board[i + 2]) {
        if (board[i].abs() == 1 &&
            board[i + 1].abs() == 1 &&
            board[i + 2].abs() == 1) {
          ans.add(i);
          ans.add(i + 1);
          ans.add(i + 2);
          return ans;
        }
      }
    }
    for (int i = 0; i < 3; i += 1) {
      if (board[i] == board[i + 3] &&
          board[i] == board[i + 6] &&
          board[i + 3] == board[i + 6]) {
        if (board[i].abs() == 1 &&
            board[i + 3].abs() == 1 &&
            board[i + 6].abs() == 1) {
          ans.add(i);
          ans.add(i + 3);
          ans.add(i + 6);
          return ans;
        }
      }
    }
    for (int i = 0; i <= 0; i += 1) {
      if (board[i] == board[i + 4] &&
          board[i] == board[i + 8] &&
          board[i + 4] == board[i + 8]) {
        if (board[i].abs() == 1 &&
            board[i + 4].abs() == 1 &&
            board[i + 8].abs() == 1) {
          ans.add(i);
          ans.add(i + 4);
          ans.add(i + 8);
          return ans;
        }
      }
    }
    for (int i = 2; i <= 2; i += 1) {
      if (board[i] == board[i + 2] &&
          board[i] == board[i + 4] &&
          board[i + 2] == board[i + 4]) {
        if (board[i].abs() == 1 &&
            board[i + 2].abs() == 1 &&
            board[i + 4].abs() == 1) {
          ans.add(i);
          ans.add(i + 2);
          ans.add(i + 4);
          return ans;
        }
      }
    }
    return ans;
  }

  void handelResultMessage(dynamic message) {
    if (message is ResultMessage) {
      if (message == drawResultMessage) {
        ref.read(gameEndModelProvider.notifier).change(const GameDrawModel());
        return;
      }

      state = state.copyWithIndexTo(message.move, -1);

      if (message.winner != 0) {
        ref.read(gameEndModelProvider.notifier).change(
              GameWinModel(
                winner: message.winner,
                winningIndicies: getWinningIndicies(state),
              ),
            );
      }
    }
  }

  // returns which player wins
  static int getScore(List<int> board, int depth, int player) {
    //check rows
    for (int i = 0; i < 9; i += 3) {
      if (board[i] == board[i + 1] &&
          board[i] == board[i + 2] &&
          board[i + 1] == board[i + 2]) {
        if (board[i].abs() == 1 &&
            board[i + 1].abs() == 1 &&
            board[i + 2].abs() == 1) {
          if (player == board[i]) {
            return 10 - depth;
          } else {
            return -10 + depth;
          }
        }
      }
    }
    //check coloumns
    for (int i = 0; i < 3; i += 1) {
      if (board[i] == board[i + 3] &&
          board[i] == board[i + 6] &&
          board[i + 3] == board[i + 6]) {
        if (board[i].abs() == 1 &&
            board[i + 3].abs() == 1 &&
            board[i + 6].abs() == 1) {
          if (player == board[i]) {
            return 10 - depth;
          } else {
            return -10 + depth;
          }
        }
      }
    }
    //check main diagonal
    for (int i = 0; i <= 0; i += 1) {
      if (board[i] == board[i + 4] &&
          board[i] == board[i + 8] &&
          board[i + 4] == board[i + 8]) {
        if (board[i].abs() == 1 &&
            board[i + 4].abs() == 1 &&
            board[i + 8].abs() == 1) {
          if (player == board[i]) {
            return 10 - depth;
          } else {
            return -10 + depth;
          }
        }
      }
    }
    //check anti diagonal
    for (int i = 2; i <= 2; i += 1) {
      if (board[i] == board[i + 2] &&
          board[i] == board[i + 4] &&
          board[i + 2] == board[i + 4]) {
        if (board[i].abs() == 1 &&
            board[i + 2].abs() == 1 &&
            board[i + 4].abs() == 1) {
          if (player == board[i]) {
            return 10 - depth;
          } else {
            return -10 + depth;
          }
        }
      }
    }
    return 0;
  }

  static int findBestMove(List<int> board) {
    int bestMove = -1;
    int bestScore = -9999;

    for (final emptyPlace in board.emptyPlaces) {
      final newBoard = board.copyWithIndexTo(emptyPlace, -1);

      int score = -miniMax(newBoard, 0, 1);

      if (score > bestScore) {
        bestScore = score;
        bestMove = emptyPlace;
      }
    }
    return bestMove;
  }

  static int miniMax(List<int> board, int depth, int player) {
    int boardState = getScore(board, depth, player);
    if (boardState != 0) {
      return boardState;
    }
    if (!board.contains(0)) {
      return 0;
    }

    int maxScore = -9999;
    for (final emptyPlace in board.emptyPlaces) {
      int score = -miniMax(
        board.copyWithIndexTo(emptyPlace, player),
        depth + 1,
        -player,
      );
      maxScore = max(maxScore, score);
    }
    return maxScore;
  }

  static void _heavyTask(List<Object> data) {
    final port = data[0] as SendPort;
    final state = data[1] as List<int>;

    final move = findBestMove(state);
    // if there are no empty places
    // end the game
    if (move == -1) {
      port.send(drawResultMessage);
      return;
    }
    final finalState = state.copyWithIndexTo(move, -1);
    final finalScore = getScore(finalState, 0, 1);
    int winner = 0;
    if (finalScore == 10) {
      winner = 1;
    } else if (finalScore == -10) {
      winner = -1;
    }

    port.send(
      ResultMessage(winner: winner, move: move),
    );
  }

  int operator [](int index) {
    return state[index];
  }
}

final boardProvider = StateNotifierProvider<BoardNotifier, List<int>>(
  (ref) => BoardNotifier(ref),
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows || Platform.isLinux) {
    DesktopWindow.setMinWindowSize(const Size(300, 300));
    DesktopWindow.setMaxWindowSize(const Size(300, 300));
    DesktopWindow.setWindowSize(const Size(300, 300));
  }
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends HookWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        itemCount: 9,
        itemBuilder: (context, index) {
          return BoardTile(
            color: index.isEven ? Colors.white : Colors.green,
            index: index,
          );
        },
      ),
    );
  }
}

class BoardTile extends HookWidget {
  const BoardTile({
    Key? key,
    required this.color,
    required this.index,
  }) : super(key: key);
  final Color color;

  final int index;
  @override
  Widget build(BuildContext context) {
    final val = useProvider(boardProvider.select((value) => value[index]));
    final gameEnd = useProvider(gameEndModelProvider);

    Color charColor = Colors.black;

    if (gameEnd is! GameInitialModel) {
      if (gameEnd.winningIndicies.contains(index)) {
        charColor = Colors.blue;
      }
    }

    String text;
    if (val == 0) {
      text = "";
    } else if (val == 1) {
      text = "X";
    } else {
      text = "O";
    }

    return GestureDetector(
      onTap: val == 0 && gameEnd is! GameDrawModel && gameEnd is! GameWinModel
          ? () {
              final notifier = context.read(boardProvider.notifier);
              notifier.updateXPosition(index);
            }
          : null,
      child: ColoredBox(
        color: color,
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 50,
              color: charColor,
            ),
          ),
        ),
      ),
    );
  }
}
