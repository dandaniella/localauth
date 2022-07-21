import 'package:finger_print_two/create_login.dart';
import 'package:finger_print_two/home_signin_widget.dart';
import 'package:finger_print_two/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MenuFrame extends StatelessWidget {
  PageController pageController = PageController();

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

                Expanded(
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
