import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lostfound/allwidgets/MainScreen.dart';
import 'package:lostfound/allwidgets/RegisterForm.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email;
  TextEditingController emailController = TextEditingController();
  String password;
  TextEditingController passwordController = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;
  String _error;

  void setPrefs() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool("isLoggedIn", true);
  }

  Widget buildError() {
    if (_error == null) {
      return Container();
    } else {
      return Center(
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20), color: Colors.white),
          width: MediaQuery.of(context).size.width * 0.7,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Error: $_error",
              style: GoogleFonts.poppins(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
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
              child: ListView(
                children: <Widget>[
                  Container(
                    child: Column(
                      children: <Widget>[
                        buildError(),
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
                              color: Colors.black54.withOpacity(0.0),
                              child: Text("Lost & Found",
                                  style: GoogleFonts.poppins(
                                    fontSize: 45,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  )),
                            ),
                          ),
                        ),
                        Center(
                            child: Text(
                          "Login",
                          style: GoogleFonts.poppins(
                              color: Colors.white, fontSize: 20),
                        )),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 8.0),
                          child: TextField(
                            keyboardType: TextInputType.emailAddress,
                            controller: emailController,
                            textAlign: TextAlign.center,
                            autofocus: true,
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                            onChanged: (value) {
                              email = value;
                            },
                            decoration: InputDecoration(
                              fillColor: Colors.black54,
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                              ),
                              hintText: 'Email ',
                              hintStyle: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 8.0),
                          child: TextField(
                            controller: passwordController,
                            textAlign: TextAlign.center,
                            autofocus: true,
                            obscureText: true,
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                            onChanged: (value) {
                              password = value;
                            },
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.black54,
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                              ),
                              hintText: 'Password ',
                              hintStyle: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Login",
                              style: GoogleFonts.poppins(
                                  color: Colors.white, fontSize: 18),
                            ),
                          ),
                          onPressed: () async {
                            try {
                              AuthResult result =
                                  await _auth.signInWithEmailAndPassword(
                                      email: email, password: password);
                              if (result == null) {
                                return null;
                              } else {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MainScreen()));
                                emailController.clear();
                                passwordController.clear();
                                setPrefs();
                              }
                            } catch (error) {
                              setState(() {
                                print("$_error");
                                _error = error.message;
                              });
                            }
                          },
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Text(
                                  "First time user? Register here",
                                  style:
                                      GoogleFonts.poppins(color: Colors.white),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 5, bottom: 50),
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SignUpForm()));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10, bottom: 5),
                                    child: Text(
                                      "Register",
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
