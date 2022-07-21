import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class HomeSignInWidget extends StatelessWidget{
  
  final Function? goToSignUp;
  final Function? goToSignIn;


  HomeSignInWidget({this.goToSignIn, this.goToSignUp});



  @override
  Widget build(BuildContext context){
    return   Column(
      children: <Widget>[
       
      InkWell(
        onTap: (){
            goToSignIn!();
          },
        child: Container(
      
            padding:EdgeInsets.symmetric(
              vertical: 15.0,
              horizontal: 25.0,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Column( 
              mainAxisAlignment: MainAxisAlignment.center,
              children:<Widget>[
                Icon(
                  // CupertinoIcons.person_crop_square, 
                  FontAwesomeIcons. faceLaugh,
                  color: Colors.red,
                  size: 40.0),
                Text(
                  'Log in', 
                    style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold, 
                    fontSize: 20.0, 
                    height: 2.0,
                    ),
                  ),
              ],
          ),
        ),
      ),


      SizedBox(
          height: 200.0,
        ),
        Container(
            padding:EdgeInsets.symmetric(
              vertical: 12.0,
              horizontal: 20.0,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30.0),
            ),


            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:<Widget>[
        
                InkWell(
                  onTap: (() {
                    goToSignUp!() ;
                  }),
                  child: Text(
                    'Sign up', 
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold, 
                      fontSize: 20.0,
                    ),
                  ),
                ),
              ]
            ),
          ),
      
        
      
        
      //  sign in text
        Text(
          'NOT REGISTER? SIGN UP', 
          style: TextStyle(
            color: Colors.white,
            height: 1.5),
            
      ),
    ],
  );
    }

  }