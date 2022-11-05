import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:lostfound/allwidgets/LoginScreen.dart';
import 'package:lostfound/allwidgets/LostForm.dart';
import 'package:lostfound/allwidgets/FoundForm.dart';
import 'package:lostfound/allwidgets/ExploreScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui';

// ignore: must_be_immutable
class MainScreen extends StatelessWidget {
  static const String idScreen = "mainScreen";
  FirebaseAuth auth = FirebaseAuth.instance;

  void logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("isLoggedIn", false);
  }

  @override
  Widget build(BuildContext context) {
    Future<bool> _onBack() {
      return showDialog(
        context: (context),
        builder: (context) => AlertDialog(
          title: Text("Do you want to quit?"),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: Text("Yes"),
            ),
            FlatButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: Text("No"),
            ),
          ],
        ),
      );
    }

    return WillPopScope(
      onWillPop: _onBack,
      child: Scaffold(
        bottomNavigationBar: BottomAppBar(
          color: Colors.cyan.withOpacity(0.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.exit_to_app),
                        iconSize: 40,
                        color: Colors.white,
                        onPressed: () {
                          auth.signOut();
                          logout();
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()));
                        },
                      ),
                      Text(
                        "Sign Out",
                        style: GoogleFonts.poppins(
                            color: Colors.white, fontSize: 15),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        resizeToAvoidBottomInset: false,
        //backgroundColor: Colors.cyan.withAlpha(11),
        body: Container(
          constraints: BoxConstraints.expand(),
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/wallets.jpeg"), fit: BoxFit.none),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.2),
              ),
              //backgroundColor: Colors.cyan,

              child: SingleChildScrollView(
                child: Center(
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.fromLTRB(50, 20, 50, 1),
                        child: Image.asset(
                          'assets/logo.png',
                          width: 120,
                          height: 120,
                        ),
                      ),
                      Hero(
                        tag: 'lostandfound',
                        child: Container(
                          margin: EdgeInsets.only(top: 10, bottom: 20),
                          child: Material(
                            color: Colors.cyan.withOpacity(0.0),
                            child: Text("Lost & Found",
                                style: GoogleFonts.poppins(
                                  fontSize: 45,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                )),
                          ),
                        ),
                      ),
                      //Spacer(),
                      Container(
                        margin: EdgeInsets.fromLTRB(25, 10, 25, 30),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.white,
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ExploreScreen()));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              children: [
                                Text(
                                  "Explore",
                                  style: GoogleFonts.poppins(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                Text(
                                  "Look through list to see recently lost items and found items.",
                                  style: GoogleFonts.poppins(
                                    color: Colors.black87,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      //Spacer(),
                      Container(
                        margin: EdgeInsets.fromLTRB(25, 10, 25, 30),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                        ),
                        child: ElevatedButton(
                          //fillColor: Colors.blue,
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LostForm()));
                          },
                          //elevation: 6,
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Text(
                              "Create an advert for your Lost item",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.robotoSlab(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(25, 10, 25, 30),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                        ),
                        child: ElevatedButton(
                          //fillColor: Colors.cyan[200],
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => FoundForm()));
                          },
                          //elevation: 6,
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Text(
                              "Create an advert for an item Found ",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.robotoSlab(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
