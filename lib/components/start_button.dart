import 'package:flutter/material.dart';
import 'package:test_game/game_controller.dart';

class StartButton {
  final GameController gameController;
  TextPainter textPainter;
  Offset position;

  StartButton(this.gameController) {
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
    textPainter.text = TextSpan(
      text: "Start Game",
      style: TextStyle(
        color: Colors.black,
        fontSize: 50,
      ),
    );
    textPainter.layout();
    position = Offset(
        (gameController.screenSize.width / 2) - (textPainter.width / 2),
        (gameController.screenSize.height * 0.7) - (textPainter.height / 2));
  }
}
