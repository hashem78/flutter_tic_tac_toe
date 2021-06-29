import 'dart:io';

import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_tic_tac_toe/providers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'widgets/board_tile.dart';

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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: SizedBox.fromSize(
              child: const BoardWidget(),
              size: const Size(300, 400),
            ),
          ),
          TextButton(
            onPressed: context.read(boardProvider.notifier).reset,
            child: const Text("Reset"),
          ),
        ],
      ),
    );
  }
}

class BoardWidget extends StatelessWidget {
  const BoardWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      //shrinkWrap: true,
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
    );
  }
}
