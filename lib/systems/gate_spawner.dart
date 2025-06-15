import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../components/ball.dart';
import '../components/gate.dart';
import '../utils/responsive_layout.dart';

enum SpawnPattern {
  both,
  topOnly,
  bottomOnly,
  staggered,
}

class GateSpawner extends Component with HasGameReference {
  final BallComponent topBall;
  final BallComponent bottomBall;
  final ResponsiveLayout layout;
  final VoidCallback onPass;
  final VoidCallback onFail;
  final Random _random = Random();
  late double spawnInterval;
  double _timer = 0.0;
  late double scrollSpeed;
  int _spawnCount = 0;
  double _lastTopGateTime = -10.0;
  double _lastBottomGateTime = -10.0;
  Color? _lastTopGateColor;
  Color? _lastBottomGateColor;
  double _gameTime = 0.0;
  
  final List<Color> availableColors = [
    Colors.cyan,
    Colors.red,
  ];

  GateSpawner({
    required this.topBall,
    required this.bottomBall,
    required this.layout,
    required this.onPass,
    required this.onFail,
  }) {
    spawnInterval = layout.spawnInterval;
    scrollSpeed = layout.baseScrollSpeed;
  }

  @override
  void update(double dt) {
    super.update(dt);
    _timer += dt;
    _gameTime += dt;
    
    _updateDifficulty();

    if (_timer >= spawnInterval) {
      _timer = 0.0;
      _spawnSmartGates();
      _spawnCount++;
    }
  }
  
  /// Scales difficulty based on game time, affecting spawn rate and scroll speed
  void _updateDifficulty() {
    final difficultyFactor = (_gameTime / 30.0).clamp(0.0, 2.0);
    
    spawnInterval = (layout.spawnInterval - difficultyFactor).clamp(1.0, layout.spawnInterval);
    scrollSpeed = layout.baseScrollSpeed + (difficultyFactor * 80.0);
  }
  
  /// Spawns gates using pattern logic and proper positioning for track layout
  void _spawnSmartGates() {
    final gameSize = game.size;
    final xPos = gameSize.x + 100;
    final topGateY = layout.topTrackCenterY - (layout.ballOffset * 0.4);
    final extraBottomSpacing = layout.ballOffset * 0.6;
    final bottomGateY = layout.bottomTrackCenterY + layout.ballOffset + extraBottomSpacing;
    
    final spawnPattern = _chooseSpawnPattern();
    
    switch (spawnPattern) {
      case SpawnPattern.both:
        _spawnBothGates(xPos, topGateY, bottomGateY);
        break;
      case SpawnPattern.topOnly:
        _spawnTopGate(xPos, topGateY);
        break;
      case SpawnPattern.bottomOnly:
        _spawnBottomGate(xPos, bottomGateY);
        break;
      case SpawnPattern.staggered:
        _spawnStaggeredGates(xPos, topGateY, bottomGateY);
        break;
    }
  }
  
  /// Returns spawn pattern based on difficulty progression
  SpawnPattern _chooseSpawnPattern() {
    final difficultyLevel = (_gameTime / 10.0).floor();
    
    if (difficultyLevel == 0) {
      return _random.nextDouble() < 0.7 
        ? (_random.nextBool() ? SpawnPattern.topOnly : SpawnPattern.bottomOnly)
        : SpawnPattern.both;
    } else if (difficultyLevel == 1) {
      final rand = _random.nextDouble();
      if (rand < 0.4) return SpawnPattern.both;
      if (rand < 0.7) return SpawnPattern.topOnly;
      if (rand < 0.9) return SpawnPattern.bottomOnly;
      return SpawnPattern.staggered;
    } else {
      final rand = _random.nextDouble();
      if (rand < 0.5) return SpawnPattern.both;
      if (rand < 0.7) return SpawnPattern.staggered;
      if (rand < 0.85) return SpawnPattern.topOnly;
      return SpawnPattern.bottomOnly;
    }
  }

  /// Spawns two gates simultaneously with guaranteed different colors
  void _spawnBothGates(double xPos, double topGateY, double bottomGateY) {
    final topColor = availableColors[_random.nextInt(availableColors.length)];
    final bottomColor = availableColors.firstWhere((color) => color != topColor);
    
    final topGate = GateComponent(
      position: Vector2(xPos, topGateY),
      gateColor: topColor,
      size: layout.gateSize,
      onPass: onPass,
      onFail: onFail,
      speed: scrollSpeed,
    );

    final bottomGate = GateComponent(
      position: Vector2(xPos, bottomGateY),
      gateColor: bottomColor,
      size: layout.gateSize,
      onPass: onPass,
      onFail: onFail,
      speed: scrollSpeed,
    );

    addAll([topGate, bottomGate]);
    _lastTopGateTime = _gameTime;
    _lastBottomGateTime = _gameTime;
    _lastTopGateColor = topColor;
    _lastBottomGateColor = bottomColor;
  }
  
  void _spawnTopGate(double xPos, double topGateY) {
    final gateColor = availableColors[_random.nextInt(availableColors.length)];
    
    final gate = GateComponent(
      position: Vector2(xPos, topGateY),
      gateColor: gateColor,
      size: layout.gateSize,
      onPass: onPass,
      onFail: onFail,
      speed: scrollSpeed,
    );

    add(gate);
    _lastTopGateTime = _gameTime;
    _lastTopGateColor = gateColor;
  }
  
  void _spawnBottomGate(double xPos, double bottomGateY) {
    final gateColor = availableColors[_random.nextInt(availableColors.length)];
    
    final gate = GateComponent(
      position: Vector2(xPos, bottomGateY),
      gateColor: gateColor,
      size: layout.gateSize,
      onPass: onPass,
      onFail: onFail,
      speed: scrollSpeed,
    );

    add(gate);
    _lastBottomGateTime = _gameTime;
    _lastBottomGateColor = gateColor;
  }
  
  /// Creates incomplete staggered pattern - only spawns first gate
  void _spawnStaggeredGates(double xPos, double topGateY, double bottomGateY) {
    if (_random.nextBool()) {
      _spawnTopGate(xPos, topGateY);
    } else {
      _spawnBottomGate(xPos, bottomGateY);
    }
  }

  void reset() {
    _timer = 0.0;
    _spawnCount = 0;
    _gameTime = 0.0;
    _lastTopGateTime = -10.0;
    _lastBottomGateTime = -10.0;
    _lastTopGateColor = null;
    _lastBottomGateColor = null;
    spawnInterval = layout.spawnInterval;
    scrollSpeed = layout.baseScrollSpeed;
  }
}