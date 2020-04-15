import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/cupertino.dart';
import 'package:test_game/game_controller.dart';

class Player {
  final GameController gameController;
  int maxHealth;
  int currentHealth;
  Rect playerRect;
  bool isDead = false;
  Sprite house;
  Player(this.gameController) {
    house = Sprite('house.png');
    maxHealth = 200;
    currentHealth = 200;
    final size = gameController.tileSize * 1.5;
    playerRect = Rect.fromLTWH(
      gameController.screenSize.width / 2 - size / 2,
      gameController.screenSize.height / 2 - size / 2,
      size,
      size,
    );
  }

  void render(Canvas c) {
    // Paint color = Paint()..color = Color(0xFF0000FF);
    // c.drawRect(playerRect, color);
    house.renderRect(c, playerRect);
  }

  Future<void> update(double t) async {
    //  print(currentHealth);
    if (!isDead && currentHealth <= 0) {
      isDead = true;
      gameController.initialize();
      String name = gameController.storage.getString('name');
      int hightScore = gameController.storage.getInt('highScore');
      String code = gameController.storage.getString('code');
      if ((hightScore ?? 0) <= gameController.score) {
        if (hightScore == null || gameController.score == null) {
          return;
        } else {
          bool isToken = false;
          String id;
          final QuerySnapshot secondCaseResult = await Firestore.instance
              .collection('score')
              .where('name', isEqualTo: name)
              .getDocuments();
          final List<DocumentSnapshot> documentsOfsecondCase =
              secondCaseResult.documents;
          documentsOfsecondCase.forEach((data) {
            isToken = true;
            id = data.documentID;
          });
          if (!isToken) {
            Firestore.instance.collection('score').document().setData({
              'name': name,
              'score': hightScore,
              'code': code,
            });
          } else {
            Firestore.instance.collection('score').document(id).updateData({
              'name': name,
              'score': hightScore,
              'code': code,
            });
          }
        }
      }
    }
  }
}
