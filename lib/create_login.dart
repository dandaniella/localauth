import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finger_print_two/menu_frame.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';


class CreateLogin extends StatefulWidget {
  // const CreateLogin({Key? key}) : super(key: key);
  
  final Function? cancelBackToHome;

  CreateLogin({this.cancelBackToHome});

  @override
  _CreateLoginState createState() => _CreateLoginState();
}

class _CreateLoginState extends State<CreateLogin> {
  
  final FirebaseAuth _auth =FirebaseAuth.instance;
  String? email, password, passwordConfirm;
  bool? _termsagreed = false;
  bool? saveAttempted =false;
  final formKey = GlobalKey<FormState>();

void _createUser({String? email, String? pw}){
  _auth.createUserWithEmailAndPassword(email: email!, password: pw!).then((authResult){
    //  userSetup(authResult.user!.uid);
  // final docUser =FirebaseFirestore.instance.collection('users').doc(authResult.user!.uid);

  //   final json={
  //   'uid':_auth.currentUser!.uid,
  //   'fname':null,
  //   'lname':null,
  //   'Mname':null,
  //   'UmidId':null,
  //   'validated':1,
  //    };
  //  docUser.set(json);

    Fluttertoast.showToast(
        msg: "Success! \n Your account has been created",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        textColor: Color.fromARGB(255, 21, 180, 87),
        
        fontSize: 16.0
    );  
    
    Navigator.push(context, MaterialPageRoute(builder: (context){
      return MenuFrame();
    }
    
    )
    );
  }).catchError((err){
    if(err.code == 'email-already-in-use'){
      showCupertinoDialog(context: context, builder: (context){
        return CupertinoAlertDialog(
          title: Text('This email already has an account associated with it'), 
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text('OK'),
              onPressed: (){
                Navigator.pop(context);
              },)
          ],
        );
      });
    }
  });
}

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Container(
        child: Column(
          children: <Widget>[
            Text(
              'CREATE YOUR LOGIN',
              style: TextStyle(
                color: Colors.white,
                fontSize: 26.0,
                fontWeight: FontWeight.w600,
              ),
            ),
    
            
            SizedBox(
                height: 12.0,  
            ),
    
            TextFormField( 
              autovalidateMode: AutovalidateMode.always,
         
              onChanged: (textValue){
                setState(() {
                  email=textValue;
                });
              },
              validator: (emailValue){
                if(emailValue!.isEmpty){
                  return 'This field is mandatory';
                }
                 String p = "[a-zA-Z0-9\+\.\_\%\-\+]{1,256}" +
                    "\\@" +
                    "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}" +
                    "(" +
                    "\\." +
                    "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}" +
                    ")+";
                RegExp regExp = new RegExp(p);

                if (regExp.hasMatch(emailValue)) {
                  // So, the email is valid
                  return null;
                }
                return 'This is not a valid email';
              },
              decoration: InputDecoration(
                errorStyle: TextStyle(
                  color: Colors.white
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white,),),
                hintText: "Enter Email",
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.4),),
                focusColor: Colors.white,
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white,),
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
            
            TextFormField(
              autovalidateMode: AutovalidateMode.always,
               onChanged: (textValue){
                setState(() {
                  password=textValue;
                });
              },
                validator: (pwValue){
                if(pwValue!.isEmpty){
                  return 'This field is mandatory';
                }
                if(pwValue.length <8){
                  return 'Password must be atleast 8 characters';
                }
                return null;
              },
            obscureText: true,
              decoration: InputDecoration(
                errorStyle: TextStyle(
                  color: Colors.white
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white,),), 
                hintText: "Password",
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.4),),
                focusColor: Colors.white,
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white,),
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
            
            TextFormField(
              autovalidateMode: AutovalidateMode.always,
               onChanged: (textValue){
                setState(() {
                  passwordConfirm=textValue;
                });
              },
                validator: (pwConValue){
                if(pwConValue != password){
                  return 'Passwords must match';
                }
    
                return null;
              },
             obscureText: true,
              decoration: InputDecoration(
                errorStyle: TextStyle(
                  color: Colors.white
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white,),),
                hintText: "Re-Enter Password",
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.4),),
                focusColor: Colors.white,
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white,),
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
    
            Row(
              children: <Widget>[
                Checkbox(
                  activeColor: Color.fromARGB(255, 255, 230, 0),
                  value: _termsagreed, 
                  onChanged: (newValue) {
                  setState((){
                    _termsagreed = newValue;
                  });
                }),
              Text(
                'Agreed to Terms and Condition', 
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0
                ),)
              ],),
            
            SizedBox(
                  height: 12.0,  
                ),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                InkWell(
                   onTap: (() {
                      widget.cancelBackToHome!();
                    }),
                  child: Text(
                    'CANCEL', 
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),),
                ),
    
    
                SizedBox(
                  width: 38.0,  
                ),
    
                InkWell(
                  onTap: () {
                    if(formKey.currentState!.validate()){
                      formKey.currentState!.save();
                      _createUser(email:email, pw: password);
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 25,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30
                      ),
                    ),
                               
                  child: Text(
                    'SAVE', 
                    style: TextStyle(
                      color: Color.fromARGB(255, 255, 81, 0),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),),
                               ),
                ),
              ],),
            
            SizedBox(
              height: 12.0,  
            ),
    
            InkWell(
              onTap: () {
                    if(formKey.currentState!.validate()){
                      formKey.currentState!.save();
                      _createUser(email:email, pw: password);
                    }
                  },
              child: Text(
                'Agreed to Terms and Condition',
                style: TextStyle(
                  color: Colors.white,
                ), ),
            )
          ],
        ),
      ),
    );
  }
}

