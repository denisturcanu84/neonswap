import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class SwapEffectComponent extends PositionComponent with HasGameReference {
  final Color color1, color2;
  late double _progress;
  List<ParticleData>? _particles;
  final double duration = 0.5;
  
  SwapEffectComponent({
    required Vector2 position,
    required this.color1,
    required this.color2,
  }) : super(position: position) {
    _progress = 0.0;
  }
  
  @override
  Future<void> onLoad() async {
    super.onLoad();
    _particles = _generateParticles();
  }
  
  List<ParticleData> _generateParticles() {
    final particles = <ParticleData>[];
    final random = math.Random();
    
    // Create particles that travel between the two ball positions
    // Use actual ball positions from the game
    final topBallY = -game.size.y * 0.2; // Top ball offset from center  
    final bottomBallY = game.size.y * 0.2; // Bottom ball offset from center
    
    for (int i = 0; i < 20; i++) {
      particles.add(ParticleData(
        startPos: Vector2(0, topBallY), 
        endPos: Vector2(0, bottomBallY), 
        color: i % 2 == 0 ? color1 : color2,
        delay: random.nextDouble() * 0.3,
        size: 3 + random.nextDouble() * 4,
      ));
    }
    
    return particles;
  }
  
  @override
  void update(double dt) {
    super.update(dt);
    _progress += dt / duration;
    
    if (_progress >= 1.0) {
      removeFromParent();
    }
  }
  
  @override
  void render(Canvas canvas) {
    super.render(canvas);
    
    if (_particles == null) return;
    
    for (final particle in _particles!) {
      final particleProgress = math.max(0.0, (_progress - particle.delay) / (1.0 - particle.delay));
      if (particleProgress <= 0) continue;
      
      // Interpolate position
      final currentPos = particle.startPos + (particle.endPos - particle.startPos) * particleProgress;
      
      // Calculate alpha based on progress (fade in and out)
      final alpha = math.sin(particleProgress * math.pi);
      
      final paint = Paint()
        ..color = particle.color.withValues(alpha: alpha * 0.8)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
      
      canvas.drawCircle(
        Offset(position.x + currentPos.x, position.y + currentPos.y),
        particle.size,
        paint,
      );
    }
  }
}

class ParticleData {
  final Vector2 startPos;
  final Vector2 endPos;
  final Color color;
  final double delay;
  final double size;
  
  ParticleData({
    required this.startPos,
    required this.endPos,
    required this.color,
    required this.delay,
    required this.size,
  });
}
