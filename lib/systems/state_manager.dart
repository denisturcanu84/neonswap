class GameState {
  int score = 0;
  int highScore = 0;
  bool isPaused = false;
  
  void reset() {
    score = 0;
    isPaused = false;
  }

  void incrementScore() => score++;
  void resetScore() => score = 0;
}