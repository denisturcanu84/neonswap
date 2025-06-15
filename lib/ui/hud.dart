import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../utils/responsive_layout.dart';

class Hud extends PositionComponent with HasGameReference {
  late NeonScoreComponent _scoreComponent;
  final ResponsiveLayout layout;

  Hud({required this.layout});

  @override
  Future<void> onLoad() async {
    _scoreComponent = NeonScoreComponent(
      position: layout.hudPosition,
      layout: layout,
    );
    add(_scoreComponent);
  }

  void updateScore(int score) {
    _scoreComponent.updateScore(score);
  }
}

class NeonScoreComponent extends PositionComponent {
  int _score = 0;
  late TextComponent _scoreText;
  final ResponsiveLayout layout;
  
  NeonScoreComponent({
    required Vector2 position, 
    required this.layout,
  }) : super(position: position, anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    super.onLoad();
    
    _scoreText = TextComponent(
      text: 'SCORE: 0',
      textRenderer: TextPaint(
        style: TextStyle(
          color: Colors.white,
          fontSize: layout.hudFontSize,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(
              color: Colors.cyan,
              blurRadius: 10,
              offset: Offset.zero,
            ),
            Shadow(
              color: Colors.cyan,
              blurRadius: 20,
              offset: Offset.zero,
            ),
          ],
        ),
      ),
      anchor: Anchor.center,
    );
    add(_scoreText);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    
    // Draw responsive background glow panel
    final panelSize = layout.hudPanelSize;
    final panelRect = Rect.fromCenter(
      center: Offset.zero,
      width: panelSize.x,
      height: panelSize.y,
    );
    
    // Outer glow
    final outerGlowPaint = Paint()
      ..color = Colors.cyan.withValues(alpha: 0.2)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15);
    
    canvas.drawRRect(
      RRect.fromRectAndRadius(panelRect.inflate(15), const Radius.circular(20)),
      outerGlowPaint,
    );
    
    // Inner panel
    final panelPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.7)
      ..style = PaintingStyle.fill;
    
    canvas.drawRRect(
      RRect.fromRectAndRadius(panelRect, const Radius.circular(10)),
      panelPaint,
    );
    
    // Panel border
    final borderPaint = Paint()
      ..color = Colors.cyan.withValues(alpha: 0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    
    canvas.drawRRect(
      RRect.fromRectAndRadius(panelRect, const Radius.circular(10)),
      borderPaint,
    );
  }
  
  void updateScore(int score) {
    _score = score;
    _scoreText.text = 'SCORE: $_score';
  }
}