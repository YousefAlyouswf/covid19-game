import 'dart:math';
import 'dart:ui';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_game/components/enemy.dart';
import 'package:test_game/components/enemy_spawners.dart';
import 'package:test_game/components/health_bar.dart';
import 'package:test_game/components/high_score.dart';
import 'package:test_game/components/score_text.dart';
import 'package:test_game/components/wash.dart';
import 'state.dart';
import 'components/player.dart';

class GameController extends Game {
  final SharedPreferences storage;
  Random rand;
  Size screenSize;
  double tileSize;
  Player player;
  List<Enemy> enemies;
  HeathBar heathBar;
  EnemySpawners enemySpawners;
  int score;
  ScoerText scoerText;
  StateScreen state;
  HighScore highScore;
  Wash wash;
  GameController(this.storage) {
    initialize();
  }

  void initialize() async {
    resize(await Flame.util.initialDimensions());
    state = StateScreen.menu;
    rand = Random();
    player = Player(this);
    enemies = List<Enemy>();
    enemySpawners = EnemySpawners(this);
    heathBar = HeathBar(this);
    score = 0;
    scoerText = ScoerText(this);
    highScore = HighScore(this);
    wash = Wash(this);
  }

  void render(Canvas canvas) {
    Rect background = Rect.fromLTWH(0, 0, screenSize.width, screenSize.height);
    Paint backgroundPaint = Paint()..color = Color(0xFFFAFAFA);
    canvas.drawRect(background, backgroundPaint);

    if (state == StateScreen.menu) {
      highScore.render(canvas);
      //  startButton.render(canvas);
      wash.render(canvas);
    } else {
      player.render(canvas);
      enemies.forEach((Enemy enemy) {
        enemy.render(canvas);
      });
      scoerText.render(canvas);
      heathBar.render(canvas);
    }
  }

  void update(double t) {
    if (state == StateScreen.menu) {
      highScore.update(t);
    } else {
      enemySpawners.update(t);
      enemies.forEach((Enemy enemy) {
        enemy.update(t);
      });
      enemies.removeWhere((Enemy enemy) {
        return enemy.isDead;
      });
      player.update(t);
      heathBar.update(t);
      scoerText.update(t);
    }
  }

  void resize(Size size) {
    screenSize = size;
    tileSize = screenSize.width / 10;
  }

  void onTapDown(TapDownDetails d) {
    if (state == StateScreen.menu) {
      state = StateScreen.playing;
    } else {
      enemies.forEach((Enemy enemy) {
        if (enemy.enemyRect.contains(d.globalPosition)) {
          enemy.onTapDown();
        }
      });
    }
  }

  void spawnEnemy() {
    double x, y;
    switch (rand.nextInt(4)) {
      case 0:
        //Top case
        x = rand.nextDouble() * screenSize.width;
        y = -tileSize * 2.5;
        break;
      case 1:
        //Right case
        x = screenSize.width + tileSize * 2.5;
        y = rand.nextDouble() * screenSize.height;
        break;
      case 2:
        //Bottom case
        x = rand.nextDouble() * screenSize.width;
        y = screenSize.height + tileSize * 2.5;
        break;
      case 3:
        //Left case
        x = -tileSize * 2.5;
        y = rand.nextDouble() * screenSize.height;
        break;
    }
    enemies.add(Enemy(this, x, y));
  }
}
