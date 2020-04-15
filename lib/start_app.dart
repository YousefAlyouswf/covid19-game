import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flame/flame.dart';
import 'package:flame/util.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_game/game_controller.dart';

class StartApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'Fight Corona Virus',
                style: TextStyle(
                    color: Colors.red[900],
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
              Image.asset('assets/images/covid1.png'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Container(
                    child: RaisedButton(
                      textColor: Colors.white,
                      color: Colors.red,
                      onPressed: () async {
                        WidgetsFlutterBinding.ensureInitialized();
                        Util flameUtil = Util();
                        await flameUtil.fullScreen();
                        await Flame.images.loadAll(<String>[
                          'covid1.png',
                          'house.png',
                          'covid2.png',
                          'covid3.png',
                          'wash.png',
                        ]);
                        await flameUtil
                            .setOrientation(DeviceOrientation.portraitUp);
                        SharedPreferences storage =
                            await SharedPreferences.getInstance();
                        GameController gameController = GameController(storage);
                        runApp(gameController.widget);
                        TapGestureRecognizer tapper = TapGestureRecognizer();
                        tapper.onTapDown = gameController.onTapDown;
                        flameUtil.addGestureRecognizer(tapper);
                      },
                      child: Text('START GAME'),
                    ),
                  ),
                  Container(
                    child: RaisedButton(
                      textColor: Colors.white,
                      color: Colors.blue,
                      onPressed: () async {
                        _showDialog(context);
                      },
                      child: Text('Global Score'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDialog(BuildContext context) {
    // flutter defined function
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: StreamBuilder(
            stream: Firestore.instance
                .collection('score')
                .orderBy('score', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Text('Loading...');
              } else {
                return ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (BuildContext context, int index) {
                    DocumentSnapshot score = snapshot.data.documents[index];
                    return ListTile(
                      title: Text(score['name']),
                      trailing: Text(score['score'].toString()),
                    );
                  },
                );
              }
            },
          ),
        );
      },
    );
  }
}
