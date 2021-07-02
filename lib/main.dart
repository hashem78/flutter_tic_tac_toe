import 'dart:io';

import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_tic_tac_toe/engines/minimax_engine.dart';

import 'package:flutter_tic_tac_toe/providers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'engines/online_engine.dart';

import 'widgets/board_widget.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows || Platform.isLinux) {
    DesktopWindow.setMinWindowSize(const Size(600, 600));
    DesktopWindow.setMaxWindowSize(const Size(600, 600));
    DesktopWindow.setWindowSize(const Size(600, 600));
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
      body: ListView(
        children: [
          const BoardWidget(),
          TextButton(
            onPressed: context.read(boardProvider.notifier).reset,
            child: const Text("Reset"),
          ),
          const OpponentDropDownButton(),
          const OnlineRoomToolbox(),
        ],
      ),
    );
  }
}

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

class OpponentDropDownButton extends HookWidget {
  const OpponentDropDownButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dropDownValue = useValueNotifier<int?>(null);
    return Center(
      child: DropdownButton(
        items: const [
          DropdownMenuItem(
            child: Text("AI"),
            value: 0,
          ),
          DropdownMenuItem(
            child: Text('Online'),
            value: 1,
          )
        ],
        hint: const Text('Choose opponent'),
        value: useValueListenable(dropDownValue),
        onChanged: (int? value) {
          if (value != null) {
            dropDownValue.value = value;
            switch (value) {
              case 0:
                context
                    .read(gameEngineProvider.notifier)
                    .change(const MiniMaxGameEngine());
                break;
              case 1:
                context
                    .read(gameEngineProvider.notifier)
                    .change(const OnlineGameEngine());
                break;
            }
          }
        },
      ),
    );
  }
}
