import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finger_print_two/get_username.dart';
import 'package:finger_print_two/ocr_recognition.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:local_auth/local_auth.dart';

class SignedInHomePage extends StatefulWidget {
  // final String? userEmail;
  // final bool umid_id;

  // SignedInHomePage({required this.umid_id});

  @override
  _SignedInHomePage createState() => _SignedInHomePage();
}

class _SignedInHomePage extends State<SignedInHomePage> {
  final LocalAuthentication auth = LocalAuthentication();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool isActivated = false;
  bool isValidated = false;

  @override
  void initState() {
    super.initState();
    isActivatedCod();
  }

  isActivatedCod() async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    Query query = FirebaseFirestore.instance
        .collection("users")
        .where("uid", isEqualTo: _auth.currentUser!.uid)
        .where("validated", isEqualTo: "validated");
    QuerySnapshot querySnapshot = await query.get();
    final _docData = querySnapshot.docs.map((doc) => doc.data()).toList();

    Query queryReg = FirebaseFirestore.instance
        .collection("users")
        .where("uid", isEqualTo: _auth.currentUser!.uid);
    QuerySnapshot queryRegSnapshot = await queryReg.get();
    final _docDataQueryReg =
        queryRegSnapshot.docs.map((doc) => doc.data()).toList();

    if (_docDataQueryReg.isNotEmpty) {
      print(_docDataQueryReg);
      setState(() {
        isActivated = true;
      });
      if (_docData.isNotEmpty) {
        setState(() {
          isValidated = true;
        });
      }
      return SignedInHomePage();
    } else {
      setState(() {
        isActivated = false;
      });
    }

    // users.doc(_auth.currentUser!.uid).get().then(function(document){
    // })

    CollectionReference usersCol =
        FirebaseFirestore.instance.collection('users');
    String value = "";
    var collection = FirebaseFirestore.instance.collection('users');
    var docSnapshot = await collection.doc('id').get();
    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data();
      value = data?['validated'];
      // <-- The value you want to retrieve.
      // Call setState if needed.
    }
    print(value);
    print("ITO YUNG QUERY");
    print(querySnapshot);

    List lists = [];
    FirebaseFirestore.instance
        .collection('users')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        String a = doc["fname"];
        lists.add(a);
        print(doc["fname"]);
        print(lists);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 50.0),
            child: Column(
              children: <Widget>[
                Icon(
                  FontAwesomeIcons.burger,
                  size: 80.0,
                  color: Color.fromARGB(255, 255, 94, 1),
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'FOOD',
                        style: TextStyle(
                          color: Color.fromARGB(255, 129, 14, 5),
                          fontWeight: FontWeight.bold,
                          fontSize: 30.0,
                          height: 1.5,
                        ),
                      ),
                      Text(
                        '|APP',
                        style: TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontWeight: FontWeight.bold,
                          fontSize: 30.0,
                          height: 1.5,
                        ),
                      ),
                    ]),
                Text(
                  'Order Food Online!',
                  style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                      height: 1.5),
                ),

                // log in container
                SizedBox(
                  height: 350,
                ),

                //////here

                isValidated && isActivated
                    ? Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 12.0,
                          horizontal: 20.0,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              InkWell(
                                onTap: () {
                                  showCupertinoDialog(
                                      context: context,
                                      builder: (context) {
                                        return CupertinoAlertDialog(
                                          title: Text(
                                              'You can now order using \n Cash on Delivery!'),
                                          actions: <Widget>[
                                            CupertinoDialogAction(
                                              child: Text('OK'),
                                              onPressed: () {
                                                Navigator.pop(context);
                                                // Navigator.push(
                                                //     context,
                                                //     MaterialPageRoute(
                                                //         builder: (context) => SignedInHomePage()));
                                              },
                                            )
                                          ],
                                        );
                                      });
                                },
                                child: Text(
                                  'COD',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0,
                                  ),
                                ),
                              ),
                            ]),
                      )
                    : !isActivated
                        ? Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 12.0,
                              horizontal: 20.0,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => OcrAuth()));
                                    },
                                    child: Text(
                                      'Activate COD',
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0,
                                      ),
                                    ),
                                  ),
                                ]),
                          )
                        : Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 12.0,
                              horizontal: 20.0,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  InkWell(
                                    onTap: () {
                                      showCupertinoDialog(
                                          context: context,
                                          builder: (context) {
                                            return CupertinoAlertDialog(
                                              title: Text(
                                                  'Wait to activate COD on your Account'),
                                              actions: <Widget>[
                                                CupertinoDialogAction(
                                                  child: Text('OK'),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                    // Navigator.push(
                                                    //     context,
                                                    //     MaterialPageRoute(
                                                    //         builder: (context) => SignedInHomePage()));
                                                  },
                                                )
                                              ],
                                            );
                                          });
                                    },
                                    child: Text(
                                      'Waiting for Validation',
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0,
                                      ),
                                    ),
                                  ),
                                ]),
                          ),

                ////COD
                SizedBox(
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 12.0,
                    horizontal: 20.0,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        InkWell(
                          onTap: (() {}),
                          child: Text(
                            'Online Payment',
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                      ]),
                ),
              ],
            ),
          ),
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 255, 217, 1),
              Color.fromARGB(255, 255, 81, 95),
            ],
          ),
        ),
      ),
    );
  }

  ///
  Future createUSer({required String documentId}) async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(documentId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          // print("${data['fname']}");
          // return Text("fname: ${data['full_name']} ${data['last_name']}");
          print(data['fname']);
          return data['fname'];
        }

        return Text("loading");
      },
    );
  }
}
