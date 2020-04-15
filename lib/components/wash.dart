import 'dart:ui';

import 'package:flame/sprite.dart';
import 'package:test_game/game_controller.dart';

class Wash {
  final GameController gameController;
  Sprite wash;
  Rect washRect;
  Wash(this.gameController) {
    wash = Sprite('wash.png');
     final size = gameController.tileSize * 3;
    washRect = Rect.fromLTWH(
      gameController.screenSize.width / 2 - size / 2,
      gameController.screenSize.height / 1.5 - size / 2,
      size,
      size,
    );
  }

   void render(Canvas c) {
    wash.renderRect(c, washRect);
  }
}
