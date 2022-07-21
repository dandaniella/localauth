import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finger_print_two/ocr_recognition.dart';
import 'package:finger_print_two/signed_home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:local_auth/local_auth.dart';

class SignedInPage extends StatefulWidget {
  // final String? userEmail;
  final User? user;
  final bool? wantsTouchid;
  final String? password;

  SignedInPage(
      {@required this.user,
      @required this.wantsTouchid,
      @required this.password});

  @override
  _SignedInPageState createState() => _SignedInPageState();
}

class _SignedInPageState extends State<SignedInPage> {
  final LocalAuthentication auth = LocalAuthentication();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final storage = new FlutterSecureStorage();
  bool isValidated = false;

  @override
  void initState() {
    super.initState();
    if (widget.wantsTouchid!) {
      authenticate();
    }
  }

  void authenticate() async {
    final canCheck = await auth.canCheckBiometrics;

    if (canCheck) {
      List<BiometricType> availableBiometric =
          await auth.getAvailableBiometrics();
      final authenticated = await auth.authenticate(
          localizedReason: 'Required to Authenticate Biometrics');
      if (authenticated) {
        storage.write(key: 'email', value: widget.user!.email);
        storage.write(key: 'password', value: widget.password);
        storage.write(key: 'usingBiometric', value: 'true');
      }
    } else {
      print("Can't Check");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SignedInHomePage();
  }
}
