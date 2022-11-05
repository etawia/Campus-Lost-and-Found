import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class ProfileScreen extends StatefulWidget {
  String uid, collection;
  String email;
  String name;
  String number;
  ProfileScreen(
      {this.uid, this.collection, this.email, this.name, this.number});
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String currentUserName;
  String publisher;
  Firestore _firestore = Firestore.instance;
  String userEmail;
  String uid;
  String collection;
  Future<FirebaseUser> getCurrentUser() async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    FirebaseUser currentUser = await _auth.currentUser();
    return currentUser;
  }

  void setUserData() async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    FirebaseUser currentUser = await _auth.currentUser();
    currentUserName = currentUser.email.toString();
    publisher = userEmail;

    List<String> combinedName = [currentUserName, publisher];
    combinedName.sort();

    await _firestore
        .collection("chatroom")
        .document("${combinedName[0]}${combinedName[1]}")
        .collection("chats")
        .document()
        .setData({
      "sender": null,
      "receiver": null,
      "text": null,
      "time": null,
    });
  }

  void setChatData() async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    FirebaseUser currentUser = await _auth.currentUser();
    await _firestore
        .collection("user")
        .document("${currentUser.email.toString()}")
        .collection("contacts")
        .add({
      "email": widget.email.toString(),
      "name": widget.name.toString(),
      "number": widget.number.toString(), //prepare to delete
    });
  }

  void getUserData() {
    uid = widget.uid;
    collection = widget.collection;
    userEmail = widget.email;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //backgroundColor: Colors.cyan,
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text(
            "Profile Page",
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ),
        body: Container(
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
                child: Center(
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 15.0, horizontal: 20),
                          child: Text(
                            "Submitted By : ",
                            style: GoogleFonts.poppins(
                                color: Colors.white, fontSize: 20),
                          ),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.38,
                          width: MediaQuery.of(context).size.width * 0.9,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                          ),
                          child: StreamBuilder<DocumentSnapshot>(
                            stream: _firestore
                                .collection("$collection")
                                .document("$uid")
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return Container(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      backgroundColor: Colors.white,
                                    ));
                              } else {
                                String name = snapshot.data["name"];
                                String email = snapshot.data["email"];
                                String number = snapshot.data["num"];
                                return Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.white,
                                  ),
                                  child: Column(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Text(
                                          "$name",
                                          style: GoogleFonts.poppins(
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 15,
                                            right: 15,
                                            top: 8,
                                            bottom: 8),
                                        child: Text(
                                          "Email: $email",
                                          style: GoogleFonts.poppins(
                                            fontSize: 20,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(8),
                                        child: Center(
                                          child: new TextButton.icon(
                                            icon: Icon(Icons.call),
                                            label: new Text("Call me"),
                                            onPressed: () =>
                                                launch("tel:$number"),
                                            style: TextButton.styleFrom(
                                                textStyle:
                                                    TextStyle(fontSize: 20)),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(bottom: 4),
                                        child: RawMaterialButton(
                                          onPressed: () {
                                            launch("sms:$number");
                                          },
                                          fillColor: Colors.green,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Text(
                                              "Send Message",
                                              style: GoogleFonts.poppins(
                                                  color: Colors.white,
                                                  fontSize: 15),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )));
  }
}
