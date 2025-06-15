import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import '../components/ball.dart';
import '../components/gate.dart';

class CollisionSystem extends Component with HasGameReference {
  @override
  Future<void> onLoad() async {
    super.onLoad();
  }

  void handleCollision(GateComponent gate, BallComponent ball) {
    if (ball.currentColor != gate.color) {
      game.pauseEngine();
    }
  }
}