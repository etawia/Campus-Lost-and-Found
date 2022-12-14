import 'dart:io';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class LostForm extends StatefulWidget {
  @override
  _LostFormState createState() => _LostFormState();
}

class _LostFormState extends State<LostForm> {
  FirebaseStorage storage;
  String _id;
  FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseUser _user;
  Firestore _firestore = Firestore.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDateTime();
    getUser();
  }

  void getDateTime() {
    DateTime dateLost = DateTime.now();
    dataformatted = DateFormat('dd-MM-yyyy').format(dateLost);
    timeFromDate = Timestamp.fromDate(dateLost);
  }

  bool image1uploaded = false;
  bool firstTimeUploading1 = true;

  bool image2uploaded = false;
  bool firstTimeUploading2 = true;

  Timestamp timeFromDate;
  String dataformatted;

  String name;
  String item;
  String location;
  String description;

  File image1;
  File image2;

  TextEditingController controller1 = new TextEditingController();
  TextEditingController controller2 = new TextEditingController();
  TextEditingController controller3 = new TextEditingController();
  TextEditingController controller4 = new TextEditingController();

  void updateData() {
    _id = _firestore.collection("lost").document().documentID;
    _firestore.collection("lost").document(_id).setData({
      "name": controller1.text,
      "itemlost": controller2.text,
      "location": controller4.text,
      "description": controller3.text,
      "timeLost": timeFromDate,
      "email": _user.email,
      "uid": _id,
    });
  }

  void uploadImage1() async {
    if (image1uploaded) {
      StorageReference storage =
          FirebaseStorage.instance.ref().child("$_id+image1");
      StorageUploadTask uploadTask = storage.putFile(image1);
      StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    }
  }

  void uploadImage2() async {
    if (image2uploaded) {
      StorageReference storage1 =
          FirebaseStorage.instance.ref().child("$_id+image2");
      StorageUploadTask uploadTask = storage1.putFile(image2);
      StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    }
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1990),
        lastDate: DateTime(2100));

    setState(() {
      dataformatted = DateFormat('dd-MM-yyyy').format(picked);
      timeFromDate = Timestamp.fromDate(picked);
    });
  }

  Future<Widget> giveChild1() async {
    if (!image1uploaded) {
      return Container(
        margin: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
        width: MediaQuery.of(context).size.width * 0.45,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), color: Colors.black54),
        child: IconButton(
          onPressed: () {
            setState(() {
              image1uploaded = true;
            });
          },
          icon: Icon(
            Icons.add_circle,
            size: 35,
            color: Colors.white,
          ),
        ),
      );
    }
    if (image1uploaded && firstTimeUploading1) {
      return Container(
        margin: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
        width: MediaQuery.of(context).size.width * 0.45,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), color: Colors.black54),
        child: FutureBuilder(
          future: setFileImage1(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.white,
                ),
              );
            } else {
              firstTimeUploading1 = false;
              return Container(
                  margin: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                  width: MediaQuery.of(context).size.width * 0.45,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.black54),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.file(
                        snapshot.data,
                        fit: BoxFit.fill,
                      )));
            }
          },
        ),
      );
    } else if (image1uploaded == true && firstTimeUploading1 == false) {
      return Container(
        margin: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
        width: MediaQuery.of(context).size.width * 0.45,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), color: Colors.black54),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.file(
              image1,
              fit: BoxFit.cover,
            )),
      );
    }
  }

  Future<Widget> giveChild2() async {
    if (!image2uploaded) {
      return Container(
        margin: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
        width: MediaQuery.of(context).size.width * 0.45,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), color: Colors.black54),
        child: IconButton(
          onPressed: () {
            setState(() {
              image2uploaded = true;
            });
          },
          icon: Icon(
            Icons.add_circle,
            size: 35,
            color: Colors.white,
          ),
        ),
      );
    }
    if (image2uploaded && firstTimeUploading2) {
      return Container(
        margin: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
        width: MediaQuery.of(context).size.width * 0.45,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), color: Colors.black54),
        child: FutureBuilder(
          future: setFileImage2(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.white,
                ),
              );
            } else {
              firstTimeUploading2 = false;
              return Container(
                  margin: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                  width: MediaQuery.of(context).size.width * 0.45,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.black54),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.file(
                        snapshot.data,
                        fit: BoxFit.fill,
                      )));
            }
          },
        ),
      );
    } else if (image2uploaded == true && firstTimeUploading2 == false) {
      return Container(
        margin: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
        width: MediaQuery.of(context).size.width * 0.40,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), color: Colors.black54),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.file(
              image2,
              fit: BoxFit.fill,
            )),
      );
    }
  }

  Future setFileImage1() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image == null) {
      setState(() {
        image1uploaded = false;
      });
    }
    image1 = image;
    return image1;
  }

  Future setFileImage2() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image == null) {
      setState(() {
        image2uploaded = false;
      });
    }
    image2 = image;
    return image2;
  }

  void getUser() async {
    _user = await _auth.currentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text(
            "Lost item",
          ),
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
                  child: Builder(
                    builder: (context) => SafeArea(
                      child: ListView(
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  margin: EdgeInsets.all(15),
                                  child: Text(
                                    "Enter your name",
                                    style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 2),
                                child: TextField(
                                  cursorColor: Colors.white,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                  onChanged: (NAME) {
                                    name = NAME;
                                  },
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(15)),
                                    ),
                                    filled: true,
                                    fillColor: Colors.black54,
                                    hintStyle: TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  controller: controller1,
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  margin: EdgeInsets.all(15),
                                  child: Text(
                                    "What did you lose ?",
                                    style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 2),
                                child: TextField(
                                  cursorColor: Colors.white,
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                  onChanged: (String ITEM) {
                                    item = ITEM;
                                  },
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(15)),
                                    ),
                                    filled: true,
                                    fillColor: Colors.black54,
                                    hintStyle: TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  controller: controller2,
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  margin: EdgeInsets.all(15),
                                  child: Text(
                                    "When did you lose it ?",
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ),
                              Row(
                                children: <Widget>[
                                  Container(
                                    margin:
                                        EdgeInsets.only(bottom: 10, left: 15),
                                    child: Card(
                                      color: Colors.black54,
                                      elevation: 6,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 15),
                                        child: Text(
                                          "$dataformatted",
                                          style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontSize: 25,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Container(
                                      margin: EdgeInsets.all(15),
                                      decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.circular(18),
                                      ),
                                      child: RawMaterialButton(
                                        elevation: 10,
                                        onPressed: () {
                                          _selectDate(context);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Text(
                                            "Select Date",
                                            style: GoogleFonts.poppins(
                                              fontSize: 20,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  margin: EdgeInsets.only(bottom: 5, left: 20),
                                  child: Text(
                                    "Where ?",
                                    style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    right: 80, top: 5, bottom: 5, left: 20),
                                child: TextField(
                                  cursorColor: Colors.white,
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                  onChanged: (location1) {
                                    location = location1;
                                  },
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(15)),
                                    ),
                                    filled: true,
                                    fillColor: Colors.black54,
                                    hintStyle: TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  controller: controller4,
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  child: Text(
                                    "Give a brief Description",
                                    style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 15),
                                child: TextField(
                                  maxLines: 5,
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                  maxLength: 300,
                                  onChanged: (DESCRIPTION) {
                                    description = DESCRIPTION;
                                  },
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(15)),
                                    ),
                                    filled: true,
                                    fillColor: Colors.black54,
                                  ),
                                  controller: controller3,
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  margin: EdgeInsets.all(15),
                                  child: Text(
                                    "Add Images (Optional, yet helpful! )",
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                height: 150,
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  children: <Widget>[
                                    FutureBuilder(
                                      future: giveChild1(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Center(
                                            child: CircularProgressIndicator(
                                              backgroundColor: Colors.white,
                                            ),
                                          );
                                        } else
                                          return Container(
                                            child: snapshot.data,
                                          );
                                      },
                                    ),
                                    FutureBuilder(
                                      future: giveChild2(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Center(
                                            child: CircularProgressIndicator(
                                              backgroundColor: Colors.white,
                                            ),
                                          );
                                        } else
                                          return Container(
                                            child: snapshot.data,
                                          );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.all(20),
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (controller1.text.toString() == "" ||
                                        controller2.text.toString() == "" ||
                                        controller3.text.toString() == "" ||
                                        controller4.text.toString() == "") {
                                      return Alert(
                                          context: context,
                                          title: "Incomplete Information",
                                          desc: "One or more fields are empty",
                                          buttons: [
                                            DialogButton(
                                              child: Text(
                                                "Okay",
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                            ),
                                          ]).show();
                                    } else {
                                      updateData();
                                      uploadImage1();
                                      uploadImage2();
                                      controller1.clear();
                                      controller2.clear();
                                      controller3.clear();
                                      controller4.clear();
                                      setState(() {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text(
                                              "Your response has been submitted."),
                                        ));
                                        image1uploaded = false;
                                        image2uploaded = false;
                                      });
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 8.0),
                                    child: Text(
                                      "Submit",
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 20,
                                      ),
                                      // ignore: missing_return
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ))));
  }
}
