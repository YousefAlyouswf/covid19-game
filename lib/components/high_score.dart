import 'package:flutter/material.dart';
import 'package:test_game/game_controller.dart';

class HighScore {
  final GameController gameController;
  TextPainter textPainter;
  Offset position;

  HighScore(this.gameController) {
    textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    position = Offset.zero;
  }

  void render(Canvas c) {
    textPainter.paint(c, position);
  }

  void update(double t) {
    int highScore = gameController.storage.getInt('highScore') ?? 0;
    textPainter.text = TextSpan(
      text: "High Score: $highScore",
      style: TextStyle(
        color: Colors.black,
        fontSize: 40,
      ),
    );
    textPainter.layout();
    position = Offset(
        (gameController.screenSize.width / 2) - (textPainter.width / 2),
        (gameController.screenSize.height * 0.2) - (textPainter.height / 2));
  }
}
