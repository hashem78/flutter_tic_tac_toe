import 'dart:isolate';
import 'dart:math';

import 'package:flutter_tic_tac_toe/engines/game_engine_interface.dart';
import 'package:flutter_tic_tac_toe/models/result_message_model/result_message_draw_model.dart';
import 'package:flutter_tic_tac_toe/models/result_message_model/result_message_win_model.dart';

import '../extensions.dart';

class MiniMaxGameEngine extends GameEngine {
  const MiniMaxGameEngine();

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

  static void _task(List<Object> data) {
    final port = data[0] as SendPort;
    final state = data[1] as List<int>;

    final move = findBestMove(state);

    if (move == -1) {
      port.send(const ResultMessageDrawModel());
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
      ResultMessageWinModel(winner: winner, move: move),
    );
  }

  static Future<void> startTask(
    Function(dynamic message) resultHandeler,
    List<int> state,
  ) async {
    final port = ReceivePort();
    final isolate = await Isolate.spawn(
      MiniMaxGameEngine._task,
      [port.sendPort, state],
    );
    port.listen(
      resultHandeler,
      onDone: () => isolate.kill(priority: Isolate.immediate),
    );
  }
}
