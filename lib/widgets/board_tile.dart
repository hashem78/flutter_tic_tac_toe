import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../models/game_model/game_draw_model.dart';
import '../models/game_model/game_initial_model.dart';
import '../models/game_model/game_win_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../providers.dart';

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

    if (gameEnd is! GameInitialModel && gameEnd is! GameDrawModel) {
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

    return AbsorbPointer(
      absorbing:
          val != 0 || gameEnd is GameDrawModel || gameEnd is GameWinModel,
      child: GestureDetector(
        onTap: () {
          final notifier = context.read(boardProvider.notifier);
          notifier.updatePosition(context.read(gameEngineProvider), index);
        },
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
      ),
    );
  }
}
