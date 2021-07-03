import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../providers.dart';
import '../engines/minimax_engine.dart';
import '../engines/online_engine.dart';

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
