import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finger_print_two/menu_frame%20copy.dart';
import 'package:finger_print_two/menu_frame.dart';
import 'package:finger_print_two/signed_home_page.dart';
import 'package:finger_print_two/signed_in_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';

class OcrAuth extends StatefulWidget {
  const OcrAuth({Key? key}) : super(key: key);

  @override
  State<OcrAuth> createState() => _OcrAuth();
}

class _OcrAuth extends State<OcrAuth> {
  bool textScanning = false;
  final FirebaseAuth auth = FirebaseAuth.instance;

  XFile? imageFile;
  XFile? imageFile_;
  var array = [];
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? c_number;
  String? middle_name;
  String scannedText = "";
  String surname = "";
  String lastword = "";
  String f_name = "";
  String m_name = "N/A";
  String s_name = "";
  String id = "";
  File? file;
  File? file_;
  List parts = ["hello"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Text Recognition example"),
      ),
      body: Center(
          child: SingleChildScrollView(
        child: Container(
            margin: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (textScanning) const CircularProgressIndicator(),
                if (!textScanning && imageFile == null)
                  Container(
                    width: 300,
                    height: 300,
                    color: Colors.grey[300]!,
                  ),
                if (imageFile != null) Image.file(File(imageFile!.path)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        padding: const EdgeInsets.only(top: 10),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            onPrimary: Colors.grey,
                            shadowColor: Colors.grey[400],
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0)),
                          ),
                          onPressed: () {
                            getImage(ImageSource.gallery);
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 5),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.image,
                                  size: 30,
                                ),
                                Text(
                                  "Gallery",
                                  style: TextStyle(
                                      fontSize: 13, color: Colors.grey[600]),
                                )
                              ],
                            ),
                          ),
                        )),
                    Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        padding: const EdgeInsets.only(top: 10),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            onPrimary: Colors.grey,
                            shadowColor: Colors.grey[400],
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0)),
                          ),
                          onPressed: () {
                            getImage(ImageSource.camera);
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 5),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.camera_alt,
                                  size: 30,
                                ),
                                Text(
                                  "Camera",
                                  style: TextStyle(
                                      fontSize: 13, color: Colors.grey[600]),
                                )
                              ],
                            ),
                          ),
                        )),
                  ],
                ),
                //TRY LANGS
                const SizedBox(
                  height: 20,
                ),

                const SizedBox(
                  height: 20,
                ),

                ///Display Scanned Text
                // Container(
                //   child: Text(
                //     scannedText,
                //     style: TextStyle(fontSize: 20),
                //   ),
                // ),

                const SizedBox(
                  height: 20,
                ),

                Container(
                    child: Text('Check the extracted information before saving',
                        style: TextStyle(
                          color: Colors.red[500],
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center)),

                Container(
                  child: TextFormField(
                    controller: TextEditingController()..text = id,
                    onChanged: (text) {
                      id = text;
                    },
                    autovalidateMode: AutovalidateMode.always,
                    validator: (mname) {
                      if (mname!.isEmpty) {
                        return 'This field is mandatory';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'UMID ID NUMBER',
                    ),
                    style: TextStyle(fontSize: 20),
                  ),
                ),

                Container(
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.always,
                    controller: TextEditingController()..text = s_name,
                    onChanged: (text) {
                      s_name = text;
                    },
                    validator: (mname) {
                      if (mname!.isEmpty) {
                        return 'This field is mandatory';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Surname',
                    ),
                    style: TextStyle(fontSize: 20),
                  ),
                ),

                Container(
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.always,
                    controller: TextEditingController()..text = f_name,
                    onChanged: (text) {
                      f_name = text;
                    },
                    validator: (mname) {
                      if (mname!.isEmpty) {
                        return 'This field is mandatory';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Given Name',
                    ),
                    style: TextStyle(fontSize: 20),
                  ),
                ),

                Container(
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.always,
                    controller: TextEditingController()..text = m_name,
                    onChanged: (text) {
                      m_name = text;
                    },
                    validator: (mname) {
                      if (mname!.isEmpty) {
                        return 'This field is mandatory';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Middle Name',
                    ),
                    style: TextStyle(fontSize: 20),
                  ),
                ),

                Container(
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.always,
                    onChanged: (textValue) {
                      setState(() {
                        c_number = textValue;
                      });
                    },
                    validator: (pwValue) {
                      if (pwValue!.isEmpty) {
                        return 'This field is mandatory';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Contact Number',
                    ),
                    style: TextStyle(fontSize: 20),
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),

                Text(
                  'Upload ID Photo',
                  style: TextStyle(
                    color: Color.fromARGB(255, 43, 44, 44),
                    fontSize: 26.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                if (imageFile_ == null)
                  Container(
                    width: 300,
                    height: 300,
                    color: Colors.grey[300]!,
                  ),
                if (imageFile_ != null) Image.file(File(imageFile_!.path)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        padding: const EdgeInsets.only(top: 10),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            onPrimary: Colors.grey,
                            shadowColor: Colors.grey[400],
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0)),
                          ),
                          onPressed: () {
                            getImage_(ImageSource.gallery);
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 5),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.image,
                                  size: 30,
                                ),
                                Text(
                                  "Gallery",
                                  style: TextStyle(
                                      fontSize: 13, color: Colors.grey[600]),
                                )
                              ],
                            ),
                          ),
                        )),
                    Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        padding: const EdgeInsets.only(top: 10),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            onPrimary: Colors.grey,
                            shadowColor: Colors.grey[400],
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0)),
                          ),
                          onPressed: () {
                            getImage_(ImageSource.camera);
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 5),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.camera_alt,
                                  size: 30,
                                ),
                                Text(
                                  "Camera",
                                  style: TextStyle(
                                      fontSize: 13, color: Colors.grey[600]),
                                )
                              ],
                            ),
                          ),
                        )),
                  ],
                ),

                const SizedBox(
                  height: 20,
                ),

                InkWell(
                  onTap: () {
                    //  userSetup(s_name);
                    createUSer(name: s_name);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 70,
                    ),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 255, 238, 0),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      'SAVE',
                      style: TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            )),
      )),
    );
  }

////GET IMAGE
  void getImage(ImageSource source) async {
    try {
      //yung source
      final pickedImage = await ImagePicker().pickImage(source: source);

      if (pickedImage != null) {
        file = File(pickedImage.path);
        textScanning = true;
        imageFile = pickedImage;
        setState(() {});
        getRecognisedText(pickedImage);
      }
    } catch (e) {
      textScanning = false;
      imageFile = null;
      scannedText = "Error occured while scanning";
      setState(() {});
    }
  }

  void getImage_(ImageSource source) async {
    try {
      //yung source
      final pickedImage = await ImagePicker().pickImage(source: source);
      if (pickedImage != null) {
        file_ = File(pickedImage.path);
        imageFile_ = pickedImage;
        setState(() {});
        // getRecognisedText(pickedImage);
      }
    } catch (e) {
      textScanning = false;
      imageFile_ = null;
      scannedText = "Error occured while scanning";
      setState(() {});
    }
  }

  void getRecognisedText(XFile image) async {
    final inputImage = InputImage.fromFilePath(image.path);
    final textDetector = GoogleMlKit.vision.textDetector();
    RecognisedText recognisedText = await textDetector.processImage(inputImage);
    await textDetector.close();
    scannedText = "";
    surname = "";

    for (TextBlock block in recognisedText.blocks) {
      for (TextLine line in block.lines) {
        array.add(line.text);
        scannedText = scannedText + line.text + "\n";
      }
    }

    array.forEach((e) => print(e));

    for (int i = 0; i < array.length; i++) {
      if (array[i] == "SURNAME") {
        s_name = array[i + 1];
      }
      if (array[i] == "GIVEN NAME") {
        f_name = array[i + 1];
      }
      if (array[i] == "MIDDLE NAME") {
        m_name = array[i + 1];
      }
      if (array[i] == "Unified Multi-Purpose ID") {
        id = array[i + 1];
      }
      //  if(array[i]=="GIVEN NAME"){ surname=array[i+1];}
      //  if(array[i]=="GIVEN NAME"){ surname=array[i+1];}
    }

    print(array.contains("SURNAME"));

    print(s_name + ", " + f_name + " " + m_name + "\n ID:" + id);

    textScanning = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }

// Stream<List<User>>readUsers() => FirebaseFirestore.instance.collection('users')
// .snapshots().map((snapshot)=>
//   snapshot.docs.map((doc) => User.fromJson(doc.data())).toList());

// static User fromJson(Map<String,dynamic> json) =>user

  Future createUSer({required String name}) async {
    print("database");
    final docUser = FirebaseFirestore.instance
        .collection('users')
        .doc(auth.currentUser!.uid);
    // final FirebaseAuth _auth= FirebaseAuth.instance;
    final filename = id;
    final filename_ = id;
    List? idlist = [];
    List umidId = [];
    final destination = 'files/$filename';
    final destination_ = 'files/$filename';
    final destinations_ = '$filename/id';
    final destinations = '$filename/face';
    CollectionReference users_ = FirebaseFirestore.instance.collection('users');
    final ref = FirebaseStorage.instance.ref(destinations_);
    final ref_ = FirebaseStorage.instance.ref(destinations);
    bool flag = false;

    ref.putFile(file!);
    ref_.putFile(file_!);

    await FirebaseFirestore.instance
        .collection('users')
        .get()
        .then((snapshot) => snapshot.docs.forEach((document) {
              print(document.reference.id);
              // idlist.add(document.reference.id);
              if (auth.currentUser!.uid == document.reference.id) {
                flag = true;
                print("this is the ID");
                print(id);
              }
            }));
    await FirebaseFirestore.instance
        .collection('users')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        String a = doc["UmidId"];
        umidId.add(a);
        if (a == id) {
          flag = true;
          print("MERON NA UMID ID");
        }
      });
    });
    print(umidId);
    if (flag) {
      showCupertinoDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              title: Text('A user  with specified ID alredy exist.'),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SignedInHomePage()));
                  },
                )
              ],
            );
          });
    } else {
      print(_auth.currentUser!.uid);
      final json = {
        'uid': _auth.currentUser!.uid,
        'fname': f_name,
        'lname': s_name,
        'Mname': m_name,
        'UmidId': id,
        'validated': "notValidated",
      };
      print(id);
      await docUser.set(json).then((done) => {
            showCupertinoDialog(
                context: context,
                builder: (context) {
                  return CupertinoAlertDialog(
                    title: Text('Registered Successfully'),
                    actions: <Widget>[
                      CupertinoDialogAction(
                        child: Text('OK'),
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MenuFrametwo()));
                        },
                      )
                    ],
                  );
                })
          });
    }
    // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
    //   return SignedInHomePage();
    // }));
  }
}
