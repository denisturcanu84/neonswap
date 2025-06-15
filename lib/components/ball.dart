import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';
import '../core/game.dart';

class BallComponent extends CircleComponent with HasGameReference<NeonSwapGame> {
  static const Color blueColor = Colors.cyan;
  static const Color redColor = Colors.red;
  
  Color currentColor = blueColor;
  final Vector2 trackPosition;

  BallComponent({
    required Vector2 position,
    double radius = 20,
  }) : trackPosition = position.clone(),
       super(position: position, radius: radius, anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    super.onLoad();
    paint = Paint()..color = currentColor;
    add(CircleHitbox(collisionType: CollisionType.active));
  }

  @override
  void render(Canvas canvas) {
    final outerGlowPaint = Paint()
      ..color = currentColor.withValues(alpha: 0.15)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 25);
    
    canvas.drawCircle(
      Offset(radius, radius),
      radius + 20,
      outerGlowPaint,
    );
    
    final mediumGlowPaint = Paint()
      ..color = currentColor.withValues(alpha: 0.4)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
    
    canvas.drawCircle(
      Offset(radius, radius),
      radius + 8,
      mediumGlowPaint,
    );
    
    final innerGlowPaint = Paint()
      ..color = currentColor.withValues(alpha: 0.7)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    
    canvas.drawCircle(
      Offset(radius, radius),
      radius + 2,
      innerGlowPaint,
    );
    
    final corePaint = Paint()
      ..color = currentColor.withValues(alpha: 0.9)
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(
      Offset(radius, radius),
      radius - 2,
      corePaint,
    );
    
    final brightCorePaint = Paint()
      ..color = currentColor.withValues(alpha: 1.0)
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(
      Offset(radius, radius),
      radius - 8,
      brightCorePaint,
    );
    
    final centerPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.8)
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(
      Offset(radius, radius),
      radius - 15,
      centerPaint,
    );
    
    final highlightPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.6)
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(
      Offset(radius - 6, radius - 6),
      radius * 0.25,
      highlightPaint,
    );
  }

  void swapColor() {
    currentColor = currentColor == blueColor ? redColor : blueColor;
    paint.color = currentColor;
  }

  void changeColor(Color newColor) {
    currentColor = newColor;
    paint.color = currentColor;
  }

  void resetPosition() {
    position = trackPosition.clone();
  }
}