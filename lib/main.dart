import 'package:flutter/material.dart';
import 'package:lostfound/allwidgets/LoginScreen.dart';
import 'package:lostfound/allwidgets/MainScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  //WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<bool> getprefs() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool loggedIn = preferences.getBool("isLoggedIn");
    if (loggedIn == null) {
      loggedIn = false;
    }
    return loggedIn;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: getprefs(),
        // ignore: missing_return
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          } else if (snapshot.data == true) {
            return MainScreen();
          } else {
            return LoginScreen();
          }
        },
      ),
    );
  }
}
