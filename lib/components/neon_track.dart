import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class NeonTrackComponent extends Component {
  final Vector2 position;
  final Vector2 size;
  final Color color;
  final double glowIntensity;
  
  NeonTrackComponent({
    required this.position,
    required this.size,
    required this.color,
    this.glowIntensity = 1.0,
  });
  
  @override
  void render(Canvas canvas) {
    super.render(canvas);
    
    final rect = Rect.fromLTWH(position.x, position.y, size.x, size.y);
    
    final outerGlowPaint = Paint()
      ..color = color.withValues(alpha: 0.3 * glowIntensity)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15);
    
    final outerRect = rect.inflate(15);
    canvas.drawRRect(
      RRect.fromRectAndRadius(outerRect, const Radius.circular(20)),
      outerGlowPaint,
    );
    
    final middleGlowPaint = Paint()
      ..color = color.withValues(alpha: 0.5 * glowIntensity)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    
    final middleRect = rect.inflate(8);
    canvas.drawRRect(
      RRect.fromRectAndRadius(middleRect, const Radius.circular(15)),
      middleGlowPaint,
    );
    
    final innerGlowPaint = Paint()
      ..color = color.withValues(alpha: 0.8 * glowIntensity)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
    
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(10)),
      innerGlowPaint,
    );
    
    final corePaint = Paint()..color = color.withValues(alpha: 0.9);
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(8)),
      corePaint,
    );
    
    final highlightRect = Rect.fromLTWH(
      position.x,
      position.y,
      size.x,
      size.y * 0.3,
    );
    final highlightPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.4 * glowIntensity);
    canvas.drawRRect(
      RRect.fromRectAndRadius(highlightRect, const Radius.circular(8)),
      highlightPaint,
    );
  }
}

class NeonSeparatorComponent extends Component {
  final Vector2 position;
  final Vector2 size;
  
  NeonSeparatorComponent({
    required this.position,
    required this.size,
  });
  
  @override
  void render(Canvas canvas) {
    super.render(canvas);
    
    final rect = Rect.fromLTWH(position.x, position.y, size.x, size.y);
    
    // Glow effect
    final glowPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);
    
    canvas.drawRect(rect.inflate(5), glowPaint);
    
    // Core line
    final linePaint = Paint()..color = Colors.white.withValues(alpha: 0.6);
    canvas.drawRect(rect, linePaint);
    
    // Add some pulsing dots along the line
    final dotPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.8)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);
    
    for (double x = 50; x < size.x; x += 100) {
      canvas.drawCircle(
        Offset(position.x + x, position.y + size.y / 2),
        3,
        dotPaint,
      );
    }
  }
}
