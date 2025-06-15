import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';
import 'dart:math' as Math;
import 'ball.dart';
import '../core/game.dart';

class GateComponent extends PositionComponent with CollisionCallbacks, HasGameReference<NeonSwapGame> {
  Color get color => gateColor;
  final Color gateColor;
  final _paint = Paint();
  final double speed;
  final VoidCallback onPass;
  final VoidCallback onFail;

  GateComponent({
    required super.position,
    required this.gateColor,
    Vector2? size,
    this.speed = 150.0,
    VoidCallback? onPass,
    VoidCallback? onFail,
  }) : onPass = onPass ?? (() {}),
       onFail = onFail ?? (() {}),
       super(size: size ?? Vector2(35, 80), anchor: Anchor.center) {
    _paint
      ..color = gateColor.withValues(alpha: 1.0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    add(RectangleHitbox(collisionType: CollisionType.passive));
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    
    final halfWidth = size.x / 2;
    final halfHeight = size.y / 2;
    
    final outerGlowPaint = Paint()
      ..color = gateColor.withValues(alpha: 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15);
    
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(-halfWidth - 15, -halfHeight - 15, size.x + 30, size.y + 30),
        const Radius.circular(20),
      ),
      outerGlowPaint,
    );
    
    final mediumGlowPaint = Paint()
      ..color = gateColor.withValues(alpha: 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(-halfWidth - 6, -halfHeight - 6, size.x + 12, size.y + 12),
        const Radius.circular(12),
      ),
      mediumGlowPaint,
    );
    
    final innerGlowPaint = Paint()
      ..color = gateColor.withValues(alpha: 0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
    
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(-halfWidth - 2, -halfHeight - 2, size.x + 4, size.y + 4),
        const Radius.circular(10),
      ),
      innerGlowPaint,
    );
    
    final mainPaint = Paint()
      ..color = gateColor.withValues(alpha: 0.9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6;
    
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(-halfWidth, -halfHeight, size.x, size.y),
        const Radius.circular(8),
      ),
      mainPaint,
    );
    
    // Draw bright inner edge
    final brightPaint = Paint()
      ..color = gateColor.withValues(alpha: 1.0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(-halfWidth + 3, -halfHeight + 3, size.x - 6, size.y - 6),
        const Radius.circular(5),
      ),
      brightPaint,
    );
    
    // Add some energy particles around the gate
    final particlePaint = Paint()
      ..color = gateColor.withValues(alpha: 0.8)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);
    
    // Small energy dots around the gate (centered)
    for (int i = 0; i < 6; i++) {
      final angle = (i / 6) * 2 * 3.14159;
      final radius = 30 + (DateTime.now().millisecondsSinceEpoch % 1000) / 100;
      final x = radius * Math.cos(angle);
      final y = radius * Math.sin(angle);
      
      canvas.drawCircle(
        Offset(x, y),
        2,
        particlePaint,
      );
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.x -= speed * dt;
    
    // Remove when off-screen
    if (position.x < -size.x) {
      removeFromParent();
    }
  }

@override
  bool onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is BallComponent && other.currentColor != gateColor) {
      onFail();
      return true;
    }
    if (other is BallComponent && other.currentColor == gateColor) {
      onPass();
      return true;
    }
    return false;
  }
}