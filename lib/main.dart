import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:neonswap/core/game.dart';

void main() {
  runApp(const NeonRunnerApp());
}

class NeonRunnerApp extends StatelessWidget {
  const NeonRunnerApp({super.key});

  @override
  Widget build(BuildContext context) {
    final game = NeonSwapGame();
    return MaterialApp(
      title: 'Neon Runner',
      theme: ThemeData.dark(),
      home: GestureDetector(
        onTapDown: (details) {
          // Swap colors between balls on any tap
          game.handleTap(details.localPosition);
        },
        child: GameWidget(game: game),
      ),
    );
  }
}
