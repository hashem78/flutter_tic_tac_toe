import 'package:flutter/material.dart';

import 'board_tile.dart';

class BoardWidget extends StatelessWidget {
  const BoardWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
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
