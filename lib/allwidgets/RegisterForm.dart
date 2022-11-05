import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:lostfound/allwidgets/LoginScreen.dart';
import 'package:lostfound/allwidgets/progressDialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  TextEditingController userName = TextEditingController();
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String usersname;
  String fname;
  String lname;
  String email;
  String password;

  var alertStyle = AlertStyle(
    animationType: AnimationType.grow,
    isCloseButton: false,
    isOverlayTapDismiss: false,
    descStyle: TextStyle(fontWeight: FontWeight.bold),
    descTextAlign: TextAlign.start,
    animationDuration: Duration(milliseconds: 400),
    alertBorder: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(0.0),
      side: BorderSide(
        color: Colors.grey,
      ),
    ),
    titleStyle: TextStyle(
      color: Colors.red,
    ),
    alertAlignment: Alignment.center,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text('Sign Up Form'),
          centerTitle: true,
        ),
        resizeToAvoidBottomInset: false,
        body: Container(
            constraints: BoxConstraints.expand(),
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/wallets.jpeg"), fit: BoxFit.none),
            ),
            child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.1),
                  ),
                  child: SingleChildScrollView(
                    child: Container(
                        child: Form(
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: TextField(
                              controller: userName,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                labelText: 'Enter username',
                                labelStyle: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: TextField(
                              controller: firstName,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                labelText: 'Enter First Name',
                                labelStyle: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              onChanged: (value) {
                                fname = value;
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: TextField(
                              controller: lastName,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                labelText: 'Enter Last Name',
                                labelStyle: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              onChanged: (value) {
                                lname = value;
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: TextField(
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                labelText: 'Enter email',
                                labelStyle: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              onChanged: (value) {
                                email = value;
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: TextField(
                              controller: passwordController,
                              keyboardType: TextInputType.text,
                              obscureText: true,
                              decoration: InputDecoration(
                                labelText: 'Enter password',
                                labelStyle: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              onChanged: (value) {
                                password = value;
                              },
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 25, horizontal: 20),
                            child: ElevatedButton(
                              onPressed: () async {
                                if (userName.text == null ||
                                    userName.text.trim().length == 0 ||
                                    firstName.text == null ||
                                    firstName.text.trim().length == 0 ||
                                    lastName.text == null ||
                                    lastName.text.trim().length == 0 ||
                                    emailController.text == null ||
                                    emailController.text.trim().length == 0 ||
                                    passwordController.text == null ||
                                    passwordController.text.length < 6) {
                                  return Alert(
                                    context: context,
                                    style: alertStyle,
                                    type: AlertType.info,
                                    title: "Incomplete Information",
                                    desc: "Please fill all the fields",
                                    buttons: [
                                      DialogButton(
                                        child: Text(
                                          "OK",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20),
                                        ),
                                        onPressed: () => Navigator.pop(context),
                                        padding: EdgeInsets.zero,
                                        color: Color.fromRGBO(0, 179, 134, 1.0),
                                        radius: BorderRadius.circular(0),
                                      ),
                                    ],
                                  ).show();
                                } else {
                                  registerNewUSer(context);
                                }
                              },
                              child: Text(
                                "Submit",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )),
                  ),
                ))));
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  DatabaseReference userRef =
      FirebaseDatabase.instance.reference().child("users");
  void registerNewUSer(BuildContext context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return ProgressDialog(
            message: "Registering, Please wait",
          );
        });
    final AuthResult userCredential = (await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password)
        .catchError((errMsg) {
      Navigator.pop(context);
      displayToastMessage("Error: " + errMsg.toString(), context);
    }));

    // User Created
    if (userCredential != null) {
      // Save User Info into database
      Map userDataMap = {
        "username": userName.text.trim(),
        "firstname": firstName.text.trim(),
        "lastname": lastName.text.trim(),
        "email": emailController.text.trim(),
      };
      //userRef.child(userCredential.user.uid).set(userDataMap);
      userRef = FirebaseDatabase.instance
          .reference()
          .child('users/${userCredential.user.uid}');
      userRef.set(userDataMap);

      displayToastMessage(
          "Congratulations, your Account has been Created Successsfully",
          context);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
    } else {
      displayToastMessage("User cannot be created", context);
    }
  }

  displayToastMessage(String message, BuildContext context) {
    Fluttertoast.showToast(msg: message);
  }
}
