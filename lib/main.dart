import 'dart:io';

import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'widgets/board_widget.dart';
import 'widgets/online_room_toobox.dart';
import 'widgets/opponent_dropdownbutton.dart';
import 'widgets/reset_button.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows || Platform.isLinux) {
    DesktopWindow.setMinWindowSize(const Size(600, 600));
    DesktopWindow.setMaxWindowSize(const Size(600, 600));
    DesktopWindow.setWindowSize(const Size(600, 600));
  }
  runApp(const ProviderScope(child: MyApp()));
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
        children: const [
          BoardWidget(),
          ResetButton(),
          OpponentDropDownButton(),
          OnlineRoomToolbox(),
        ],
      ),
    );
  }
}
