import 'package:finger_print_two/create_login.dart';
import 'package:finger_print_two/home_signin_widget.dart';
import 'package:finger_print_two/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:local_auth/local_auth.dart';
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

class MenuFrametwo extends StatefulWidget {
  @override
  _MenuFrametwo createState() => _MenuFrametwo();
}

class _MenuFrametwo extends State<MenuFrametwo> {
  PageController pageController = PageController();
  final LocalAuthentication auth = LocalAuthentication();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FlutterSecureStorage storage = FlutterSecureStorage();
  String? email, password;
  bool? _useTouchId = false;
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
                  height: 60,
                ),
                userHasTouchID
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                            Text(
                              'Please place your finger over the sensor',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  fontSize: 15.0,
                                  // fontWeight: FontWeight.,
                                  height: 1.5),
                            ),
                            SizedBox(
                              height: 60,
                            ),
                            InkWell(
                              onTap: () => authenticate(),
                              child: Container(
                                padding: const EdgeInsets.all(40),
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(0, 100, 17, 17),
                                  border: Border.all(
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      width: 2.0),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(100),
                                  ),
                                ),
                                child: Icon(
                                  FontAwesomeIcons.fingerprint,
                                  size: 100.0,
                                  color: Color.fromARGB(255, 255, 255, 255),
                                ),
                              ),
                            )
                          ])
                    : Expanded(
                        child: PageView(
                        physics: NeverScrollableScrollPhysics(),
                        controller: pageController,
                        children: <Widget>[
                          HomeSignInWidget(
                            goToSignIn: () {
                              pageController.animateToPage(2,
                                  duration: Duration(milliseconds: 200),
                                  curve: Curves.easeIn);
                            },
                            goToSignUp: () {
                              pageController.animateToPage(1,
                                  duration: Duration(milliseconds: 200),
                                  curve: Curves.easeIn);
                            },
                          ),
                          CreateLogin(cancelBackToHome: () {
                            pageController.animateToPage(0,
                                duration: Duration(milliseconds: 200),
                                curve: Curves.easeIn);
                          }),
                          SignIn(),
                        ],
                      )),
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
}
