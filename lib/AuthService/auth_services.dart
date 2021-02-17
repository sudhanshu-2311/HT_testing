import 'file:///E:/Android_Projects/Authentication_App/lib/Screens/otpscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  // final GoogleSignIn _googleSignIn = GoogleSignIn();

  Stream<String> get onAuthStateChanged => _firebaseAuth.authStateChanges().map(
        (User user) => user?.uid,
      );

  // GET UID
  Future<String> getCurrentUID() async {
    return (_firebaseAuth.currentUser).uid;
  }

  // GET CURRENT USER
  Future getCurrentUser() async {
    return _firebaseAuth.currentUser;
  }

  Future createUserWithPhone(String phone, BuildContext context) async {
    _firebaseAuth.verifyPhoneNumber(
        phoneNumber: '+91' + phone,
        timeout: Duration(seconds: 0),
        verificationCompleted: (AuthCredential authCredential) {
          _firebaseAuth
              .signInWithCredential(authCredential)
              .then((UserCredential result) {
            Navigator.of(context).pop(); // to pop the dialog box
            Navigator.of(context).pushReplacementNamed('/home');
          }).catchError((e) {
            return "error";
          });
        },
        verificationFailed: (FirebaseAuthException exception) {
          return "error";
        },
        codeSent: (String verificationId, [int forceResendingToken]) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => otpscreen(
                  verificationId: verificationId,
                  phone: phone,
                ),
              ),
              (route) => false);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          verificationId = verificationId;
        });
  }
}
