import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flame/flame.dart';
import 'package:flame/util.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_game/game_controller.dart';

class StartApp extends StatelessWidget {
  TextEditingController controllerPhone = TextEditingController();

  void getUserName(BuildContext context) async {
    bool isToken = false;
    SharedPreferences refs = await SharedPreferences.getInstance();
    if (refs.getString('name') == '' || refs.getString('name') == null) {
      enterYourName(context).then((name) async {
        final QuerySnapshot secondCaseResult = await Firestore.instance
            .collection('score')
            .where('name', isEqualTo: name)
            .getDocuments();
        final List<DocumentSnapshot> documentsOfsecondCase =
            secondCaseResult.documents;
        documentsOfsecondCase.forEach((data) {
          isToken = true;
        });
        if (!isToken) {
          refs.setString('name', name);
        } else {
          Fluttertoast.showToast(
              msg: "$name being used by another player",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black,
              textColor: Colors.white,
              fontSize: 16.0);
        }

        if (refs.getString('name') == '' || refs.getString('name') == null) {
          return;
        } else {
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
          await flameUtil.setOrientation(DeviceOrientation.portraitUp);
          SharedPreferences storage = await SharedPreferences.getInstance();
          GameController gameController = GameController(storage);
          runApp(gameController.widget);
          TapGestureRecognizer tapper = TapGestureRecognizer();
          tapper.onTapDown = gameController.onTapDown;
          flameUtil.addGestureRecognizer(tapper);
        }
      });
    } else {
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
      await flameUtil.setOrientation(DeviceOrientation.portraitUp);
      SharedPreferences storage = await SharedPreferences.getInstance();
      GameController gameController = GameController(storage);
      runApp(gameController.widget);
      TapGestureRecognizer tapper = TapGestureRecognizer();
      tapper.onTapDown = gameController.onTapDown;
      flameUtil.addGestureRecognizer(tapper);
    }
  }

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
                      onPressed: () {
                        getUserName(context);
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

  Future<String> enterYourName(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (_) => new _SystemPadding(
        child: new AlertDialog(
          title: Text(
            "Type Your Name",
            textAlign: TextAlign.start,
            style: TextStyle(color: Colors.black),
          ),
          contentPadding: const EdgeInsets.all(16.0),
          content: new Row(
            children: <Widget>[
              new Expanded(
                child: new TextField(
                  keyboardType: TextInputType.text,
                  controller: controllerPhone,
                  textAlign: TextAlign.start,
                  autofocus: true,
                  decoration: new InputDecoration(
                    hintText: 'Your Name',
                  ),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            new FlatButton(
                child: const Text('Play'),
                onPressed: () {
                  Navigator.of(context).pop(
                    controllerPhone.text.toString(),
                  );
                })
          ],
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
                    String i = (index + 1).toString();
                    DocumentSnapshot score = snapshot.data.documents[index];
                    return ListTile(
                      title: i == '1'
                          ? Text(
                              score['name'],
                              maxLines: 1,
                              style: TextStyle(
                                  color: Colors.red[900],
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold),
                            )
                          : i == '2'
                              ? Text(
                                  score['name'],
                                  maxLines: 1,
                                  style: TextStyle(
                                      color: Colors.red[600],
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                )
                              :i == '3'
                              ? Text(
                                  score['name'],
                                  maxLines: 1,
                                  style: TextStyle(
                                      color: Colors.red[300],
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ): Text(
                                  score['name'],
                                ),
                      trailing: Text(
                        'Score: ${score['score'].toString()}',
                        style: TextStyle(fontSize: 18),
                      ),
                      leading: Container(
                        width: 100,
                        height: 100,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            i == '1'
                                ? Image.asset(
                                    'assets/images/crown.png',
                                    width: 35,
                                    height: 35,
                                  )
                                :  i == '2'
                                ? Image.asset(
                                    'assets/images/crown2.png',
                                    width: 35,
                                    height: 35,
                                  ): i == '3'
                                ? Image.asset(
                                    'assets/images/crown3.png',
                                    width: 35,
                                    height: 35,
                                  ):Text(
                                    i,
                                    style: TextStyle(fontSize: 30),
                                  ),
                            Image.asset(
                              'icons/flags/png/${score['code']}.png',
                              package: 'country_icons',
                              height: 30,
                              width: 30,
                            ),
                          ],
                        ),
                      ),
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

class _SystemPadding extends StatelessWidget {
  final Widget child;

  _SystemPadding({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return new AnimatedContainer(
        duration: const Duration(milliseconds: 300), child: child);
  }
}
