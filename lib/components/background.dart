import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class BackgroundComponent extends Component with HasGameReference {
  late final List<StarParticle> stars;
  late final List<FloatingParticle> particles;
  
  @override
  Future<void> onLoad() async {
    super.onLoad();
    
    // Create stars
    stars = List.generate(100, (index) => StarParticle(
      position: Vector2(
        math.Random().nextDouble() * game.size.x,
        math.Random().nextDouble() * game.size.y,
      ),
      brightness: 0.3 + math.Random().nextDouble() * 0.7,
    ));
    
    // Create floating particles
    particles = List.generate(30, (index) => FloatingParticle(
      position: Vector2(
        math.Random().nextDouble() * game.size.x,
        math.Random().nextDouble() * game.size.y,
      ),
      color: math.Random().nextBool() ? Colors.cyan : Colors.red,
      speed: 10 + math.Random().nextDouble() * 20,
    ));
  }
  
  @override
  void render(Canvas canvas) {
    super.render(canvas);
    
    // Dark space background
    final rect = Rect.fromLTWH(0, 0, game.size.x, game.size.y);
    canvas.drawRect(rect, Paint()..color = const Color(0xFF0A0A0F));
    
    // Draw stars
    for (final star in stars) {
      star.render(canvas);
    }
    
    // Draw floating particles
    for (final particle in particles) {
      particle.render(canvas);
    }
  }
  
  @override
  void update(double dt) {
    super.update(dt);
    
    // Update particles
    for (final particle in particles) {
      particle.update(dt);
      
      // Reset particle if it goes off screen
      if (particle.position.x > game.size.x + 50) {
        particle.position.x = -50;
        particle.position.y = math.Random().nextDouble() * game.size.y;
      }
    }
  }
}

class StarParticle {
  Vector2 position;
  double brightness;
  double twinkle = 0;
  
  StarParticle({required this.position, required this.brightness});
  
  void render(Canvas canvas) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: brightness * (0.5 + 0.5 * math.sin(twinkle)))
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1);
    
    canvas.drawCircle(Offset(position.x, position.y), 1, paint);
    twinkle += 0.02;
  }
}

class FloatingParticle {
  Vector2 position;
  Color color;
  double speed;
  double life = 1.0;
  double size = 2.0;
  
  FloatingParticle({
    required this.position,
    required this.color,
    required this.speed,
  });
  
  void update(double dt) {
    position.x += speed * dt;
    life -= dt * 0.1;
    if (life <= 0) {
      life = 1.0;
    }
  }
  
  void render(Canvas canvas) {
    final alpha = life * 0.6;
    final paint = Paint()
      ..color = color.withValues(alpha: alpha)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
    
    canvas.drawCircle(Offset(position.x, position.y), size, paint);
  }
}
