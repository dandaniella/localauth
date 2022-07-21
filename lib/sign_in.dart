// import 'package:facial_recognition/sign_in_page.dart';
import 'package:finger_print_two/signed_in_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:local_auth/local_auth.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInLoginState createState() => _SignInLoginState();
}

class _SignInLoginState extends State<SignIn> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final LocalAuthentication auth = LocalAuthentication();
  final FlutterSecureStorage storage = FlutterSecureStorage();
  String? email, password;
  bool? _useTouchId = true;
  bool userHasTouchID = false;

  @override
  void initState() {
    super.initState();
    getSecureStorage();
  }

  void getSecureStorage() async {
    final isUsingBio = await storage.read(key: 'usingBiometric');
    setState(() {
      userHasTouchID = isUsingBio == 'true';
    });
  }

  void authenticate() async {
    final canCheck = await auth.canCheckBiometrics;

    if (canCheck) {
      List<BiometricType> availableBiometric =
          await auth.getAvailableBiometrics();
      final authenticated = await auth.authenticate(
          localizedReason: 'Required to Authenticate Biometrics');
      if (authenticated) {
        final userStoredEmail = await storage.read(key: 'email');
        final userStoredPAssword = await storage.read(key: 'password');

        _signIn(em: userStoredEmail, pw: userStoredPAssword);
      }
    } else {
      print("Can't Check");
    }
  }

  void _signIn({String? em, String? pw}) {
    _auth
        .signInWithEmailAndPassword(email: em!, password: pw!)
        .then((authResult) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return SignedInPage(
          user: authResult.user,
          wantsTouchid: _useTouchId,
          password: password,
        );
      }));
    }).catchError((err) {
      print(err.code);
      // if(err.code == 'wrong-password' || err.code == 'user-not-found'){
      showCupertinoDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              title: Text('Wrong email and password, please try again'),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            );
          });
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Text(
            'SIGN IN',
            style: TextStyle(
              color: Colors.white,
              fontSize: 26.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            height: 12.0,
          ),
          TextField(
            onChanged: (textVal) {
              setState(() {
                email = textVal;
              });
            },
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.white,
                ),
              ),
              hintText: "Enter Email",
              hintStyle: TextStyle(
                color: Colors.white.withOpacity(0.4),
              ),
              focusColor: Colors.white,
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.white,
                ),
              ),
            ),
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
            ),
          ),
          SizedBox(
            height: 12.0,
          ),
          TextField(
            onChanged: (textVal) {
              setState(() {
                password = textVal;
              });
            },
            obscureText: true,
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.white,
                ),
              ),
              hintText: "Password",
              hintStyle: TextStyle(
                color: Colors.white.withOpacity(0.4),
              ),
              focusColor: Colors.white,
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.white,
                ),
              ),
            ),
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
            ),
          ),
          SizedBox(
            height: 12.0,
          ),
          userHasTouchID
              ? InkWell(
                  onTap: () => authenticate(),
                  child: Container(
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(color: Colors.purple, width: 2.0)),
                      child: Icon(FontAwesomeIcons.fingerprint)),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    // Checkbox(
                    //     activeColor: Color.fromARGB(255, 255, 230, 0),
                    //     value: _useTouchId,
                    //     onChanged: (newValue) {
                    //       setState(() {
                    //         _useTouchId = newValue;
                    //       });
                    //     }),
                    Text(
                      'Require Fingerprint Authentication',
                      style: TextStyle(color: Colors.white, fontSize: 16.0),
                    )
                  ],
                ),
          SizedBox(
            height: 12.0,
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                InkWell(
                  onTap: () {
                    _signIn(em: email, pw: password);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 13.0,
                      horizontal: 100.0,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: Text(
                      'LOG IN',
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 81, 0),
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 12.0,
          ),
          Text(
            'Agreed to Terms and Condition',
            style: TextStyle(
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}
