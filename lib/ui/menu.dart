import 'package:flutter/material.dart';
import 'package:neonswap/core/game.dart';

class MenuOverlay extends StatelessWidget {
  const MenuOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Game Menu', style: TextStyle(color: Colors.white)),
    );
  }
}