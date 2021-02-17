// import 'dart:io';

import 'file:///E:/Android_Projects/Authentication_App/lib/Screens/PhoneVerification.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';


class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Container(child:MaterialButton(child: Text('Logout'),onPressed: ()async{
      logoutuser();
    },),
      color: Colors.green,
    );
  }

  void logoutuser()async{
    SharedPreferences sharedPreferences= await SharedPreferences.getInstance();
    setState(() {
      sharedPreferences.setString('phone', null);
    });
    await _firebaseAuth.signOut();
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => PhoneVerification(),), (route) => false);
  }
}



