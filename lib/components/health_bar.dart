import 'package:flutter/cupertino.dart';
import 'package:test_game/game_controller.dart';

class HeathBar {
  final GameController gameController;
  Rect healthBarRect;
  Rect remainingHealthBarRect;
  HeathBar(this.gameController) {
    double barWidth = gameController.screenSize.width / 1.75;

    healthBarRect = Rect.fromLTWH(
      gameController.screenSize.width / 2 - barWidth / 2,
      gameController.screenSize.height * 0.8,
      barWidth,
      gameController.tileSize * 0.5,
    );
    remainingHealthBarRect = Rect.fromLTWH(
      gameController.screenSize.width / 2 - barWidth / 2,
      gameController.screenSize.height * 0.8,
      barWidth,
      gameController.tileSize * 0.5,
    );
  }

  void render(Canvas c) {
    Paint heathBarColor = Paint()..color = Color(0xFFFF0000);
    Paint reminingHeathColor = Paint()..color = Color(0xFF00FF00);
    c.drawRect(healthBarRect, heathBarColor);
    c.drawRect(remainingHealthBarRect, reminingHeathColor);
  }

  void update(double t) {
    double barWidth = gameController.screenSize.width / 1.75;
    double percentHealth =
        gameController.player.currentHealth / gameController.player.maxHealth;
    remainingHealthBarRect = Rect.fromLTWH(
      gameController.screenSize.width / 2 - barWidth / 2,
      gameController.screenSize.height * 0.8,
      barWidth * percentHealth,
      gameController.tileSize * 0.5,
    );
  }
}
