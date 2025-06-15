import 'package:flame/game.dart';
import 'package:flame/events.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vmath;
import '../components/ball.dart';
import '../components/gate.dart';
import '../components/background.dart';
import '../components/neon_track.dart';
import '../components/swap_effect.dart';
import '../systems/collision_system.dart';
import '../systems/gate_spawner.dart';
import '../systems/state_manager.dart';
import '../ui/hud.dart';
import '../ui/game_over_overlay.dart';
import '../utils/responsive_layout.dart';


class NeonSwapGame extends FlameGame with HasCollisionDetection {
  late final GameState state;
  late final Hud hud;
  late final BallComponent topBall;
  late final BallComponent bottomBall;
  late final GateSpawner gateSpawner;
  late final CollisionSystem collisionSystem;
  late final BackgroundComponent background;
  late final NeonTrackComponent topTrack;
  late final NeonTrackComponent bottomTrack;
  late final ResponsiveLayout layout;
  GameOverOverlay? gameOverOverlay;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    
    layout = ResponsiveLayout(size);
    
    state = GameState();
    collisionSystem = CollisionSystem();
    add(collisionSystem);

    background = BackgroundComponent();
    add(background);

    topTrack = NeonTrackComponent(
      position: Vector2(0, layout.topTrackY - layout.trackHeight / 2),
      size: Vector2(size.x, layout.trackHeight),
      color: Colors.cyan,
      glowIntensity: 1.2,
    );
    add(topTrack);

    bottomTrack = NeonTrackComponent(
      position: Vector2(0, layout.bottomTrackY - layout.trackHeight / 2),
      size: Vector2(size.x, layout.trackHeight),
      color: Colors.red,
      glowIntensity: 1.2,
    );
    add(bottomTrack);

    topBall = BallComponent(
      position: Vector2(100, layout.topBallY),
      radius: layout.ballRadius,
    );
    add(topBall);

    bottomBall = BallComponent(
      position: Vector2(100, layout.bottomBallY),
      radius: layout.ballRadius,
    );
    bottomBall.changeColor(BallComponent.redColor);
    add(bottomBall);

    hud = Hud(layout: layout);
    add(hud);

    gateSpawner = GateSpawner(
      topBall: topBall,
      bottomBall: bottomBall,
      layout: layout,
      onPass: () {
        state.incrementScore();
        hud.updateScore(state.score);
      },
      onFail: () => _gameOver(),
    );
    add(gateSpawner);
  }

  void _gameOver() {
    pauseEngine();
    gameOverOverlay = GameOverOverlay(
      finalScore: state.score,
      onRestart: resetGame,
    );
    add(gameOverOverlay!);
  }

  void handleTap(Offset position) {
    if (gameOverOverlay != null) {
      resetGame();
      return;
    }
    
    final swapEffect = SwapEffectComponent(
      position: Vector2(100, size.y * 0.5),
      color1: topBall.currentColor,
      color2: bottomBall.currentColor,
    );
    add(swapEffect);
    
    final tempColor = topBall.currentColor;
    topBall.changeColor(bottomBall.currentColor);
    bottomBall.changeColor(tempColor);
  }

  @override
  void onTapDown(TapDownEvent event) {
    final position = event.localPosition;
    handleTap(Offset(position.x, position.y));
  }

  void resetGame() {
    if (gameOverOverlay != null) {
      gameOverOverlay!.removeFromParent();
      gameOverOverlay = null;
    }
    
    state.reset();
    gateSpawner.reset();
    hud.updateScore(0);
    
    topBall.resetPosition();
    bottomBall.resetPosition();
    topBall.changeColor(BallComponent.blueColor);
    bottomBall.changeColor(BallComponent.redColor);
    
    resumeEngine();
  }
}