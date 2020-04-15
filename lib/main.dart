import 'package:flutter/material.dart';
import 'package:ipfinder/ipfinder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_game/start_app.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();

    Ipfinder ipfinder = Ipfinder('b22bfa0edbe8bf00fe3cde41e567fa824fc33688');
    IpResponse auth = await ipfinder.authentication();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('country', auth.countryName.toString());
    prefs.setString('code', auth.countryCode.toLowerCase());
  } catch (e) {}

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StartApp(),
    );
  }
}
