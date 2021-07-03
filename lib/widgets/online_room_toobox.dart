import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../engines/online_engine.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../providers.dart';

class OnlineRoomToolbox extends HookWidget {
  const OnlineRoomToolbox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gameEngine = useProvider(gameEngineProvider);
    if (gameEngine is OnlineGameEngine) {
      final textController = useTextEditingController();
      return Column(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width / 2,
            child: TextField(
              controller: textController,
              decoration: const InputDecoration(
                isDense: true,
                border: InputBorder.none,
                filled: true,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  context
                      .read(gameEngineProvider.notifier)
                      .joinRoom(textController.text);
                },
                child: const Text('Join'),
              ),
              TextButton(
                onPressed: () {
                  context
                      .read(gameEngineProvider.notifier)
                      .createRoom(textController.text);
                },
                child: const Text('Create'),
              ),
            ],
          ),
        ],
      );
    } else {
      return const SizedBox();
    }
  }
}
