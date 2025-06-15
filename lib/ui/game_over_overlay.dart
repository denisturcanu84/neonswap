import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class GameOverOverlay extends PositionComponent with HasGameReference {
  final int finalScore;
  final VoidCallback onRestart;
  
  GameOverOverlay({
    required this.finalScore,
    required this.onRestart,
  }) : super(size: Vector2(400, 300), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    super.onLoad();
    
    // Position at center of screen
    position = Vector2(game.size.x / 2, game.size.y / 2);
    
    // Game Over title
    final titleText = TextComponent(
      text: 'GAME OVER',
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.red,
          fontSize: 48,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(
              color: Colors.red,
              blurRadius: 15,
              offset: Offset(0, 0),
            ),
            Shadow(
              color: Colors.red,
              blurRadius: 30,
              offset: Offset(0, 0),
            ),
          ],
        ),
      ),
      position: Vector2(0, -100),
      anchor: Anchor.center,
    );
    add(titleText);
    
    // Final score
    final scoreText = TextComponent(
      text: 'FINAL SCORE: $finalScore',
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.cyan,
          fontSize: 24,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(
              color: Colors.cyan,
              blurRadius: 10,
              offset: Offset(0, 0),
            ),
          ],
        ),
      ),
      position: Vector2(0, -20),
      anchor: Anchor.center,
    );
    add(scoreText);
    
    // Restart instruction
    final restartText = TextComponent(
      text: 'TAP TO RESTART',
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          shadows: [
            Shadow(
              color: Colors.white,
              blurRadius: 5,
              offset: Offset(0, 0),
            ),
          ],
        ),
      ),
      position: Vector2(0, 60),
      anchor: Anchor.center,
    );
    add(restartText);
  }
  
  @override
  void render(Canvas canvas) {
    super.render(canvas);
    
    // Semi-transparent background
    final backgroundRect = Rect.fromCenter(
      center: Offset.zero,
      width: game.size.x,
      height: game.size.y,
    );
    
    final backgroundPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.8);
    
    canvas.drawRect(backgroundRect, backgroundPaint);
    
    // Panel background
    final panelRect = Rect.fromCenter(
      center: Offset.zero,
      width: size.x,
      height: size.y,
    );
    
    // Outer glow
    final outerGlowPaint = Paint()
      ..color = Colors.red.withValues(alpha: 0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);
    
    canvas.drawRRect(
      RRect.fromRectAndRadius(panelRect.inflate(20), const Radius.circular(30)),
      outerGlowPaint,
    );
    
    // Panel
    final panelPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.9);
    
    canvas.drawRRect(
      RRect.fromRectAndRadius(panelRect, const Radius.circular(20)),
      panelPaint,
    );
    
    // Panel border
    final borderPaint = Paint()
      ..color = Colors.red.withValues(alpha: 0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    
    canvas.drawRRect(
      RRect.fromRectAndRadius(panelRect, const Radius.circular(20)),
      borderPaint,
    );
  }
}
