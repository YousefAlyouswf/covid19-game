import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_game/game_controller.dart';

class ScoerText {
  final GameController gameController;
  TextPainter textPainter;
  Offset position;

  ScoerText(this.gameController) {
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
    if ((textPainter.text ?? '') != gameController.score.toString()) {
      textPainter.text = TextSpan(
        text: gameController.score.toString(),
        style: TextStyle(
          color: Colors.black,
          fontSize: 70,
        ),
      );
      textPainter.layout();
      position = Offset(
          (gameController.screenSize.width / 2) - (textPainter.width / 2),
          (gameController.screenSize.height * 0.2) - (textPainter.height / 2));
    }
  }
}
