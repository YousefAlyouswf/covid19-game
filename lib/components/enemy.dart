import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flame/sprite.dart';

import '../game_controller.dart';

class Enemy {
  final GameController gameController;
  int health;
  int damage;
  double speed;
  Rect enemyRect;
  bool isDead = false;
  Sprite covid1;
  Sprite covid2;
  Sprite covid3;
  Enemy(this.gameController, double x, double y) {
    covid1 = Sprite('covid1.png');
    covid2 = Sprite('covid2.png');
    covid3 = Sprite('covid3.png');
    health = 3;
    damage = 1;
    speed = gameController.tileSize * 2;
    enemyRect = Rect.fromLTWH(
      x,
      y,
      gameController.tileSize * 1.2,
      gameController.tileSize * 1.2,
    );

   
  }
  void render(Canvas c) {
    // Color color;

    switch (health) {
      case 1:
        covid3.renderRect(c, enemyRect);
        break;
      case 2:
        covid2.renderRect(c, enemyRect);
        break;
      case 3:
        covid1.renderRect(c, enemyRect);
        break;
      default:
        covid1.renderRect(c, enemyRect);
        break;
    }
    // Paint enemyColor = Paint()..color = color;
    //c.drawRect(enemyRect, enemyColor);
  }

  void update(double t) {
    if (!isDead) {
      double stepDestance = speed * t;
      Offset toPlyer =
          gameController.player.playerRect.center - enemyRect.center;
      if (stepDestance <= toPlyer.distance - gameController.tileSize * 1.3) {
        Offset stepToPlyer =
            Offset.fromDirection(toPlyer.direction, stepDestance);
        enemyRect = enemyRect.shift(stepToPlyer);
      } else {
        attack();
      }
    }
  }

  void onTapDown() {
    if (!isDead) {
      health--;
      if (health <= 0) {
        isDead = true;
        gameController.score++;
        if (gameController.score >
            (gameController.storage.getInt('highScore') ?? 0)) {
          gameController.storage.setInt('highScore', gameController.score);
        }
      }
    }
  }

  void attack() {
    if (!gameController.player.isDead) {
      gameController.player.currentHealth -= damage;
    }
  }
}
