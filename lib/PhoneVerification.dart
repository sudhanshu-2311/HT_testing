import 'package:flutter/material.dart';
import 'package:authentication_app/WelcomeScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';



class PhoneVerification extends StatefulWidget {
  @override
  _PhoneVerificationState createState() => _PhoneVerificationState();
}

class _PhoneVerificationState extends State<PhoneVerification> {
  String number;
  String smsCode;
  final _textController = TextEditingController();
  final _codeController = TextEditingController();
  @override
  void initState() {
    initializeFirebase();
    super.initState();
  }

  void initializeFirebase() async {
    try {
      await Firebase.initializeApp();
    } catch (e) {
      print('error');
    }
  }

  Future<void> _letsbegin(String phone,BuildContext context) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    await _auth.verifyPhoneNumber(
      phoneNumber:'+91'+phone,
      // '+91' + _textController.text,
      timeout: Duration(seconds: 5),
      verificationCompleted: (PhoneAuthCredential credential) async {
        Navigator.pop(context);
        UserCredential result = await _auth.signInWithCredential(credential);
        User user = result.user;
        if (user != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => WelcomeScreen()),
          );
        } else {
          print('Error');
        }
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          print('The provided phone number is not valid.');
        }
      },
      codeSent: (String verificationId, int resendToken) {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return AlertDialog(
                title: Text('Enter the OTP'),
                content: Column(
                  children: <Widget>[
                    TextField(
                      onChanged: (value)
                      {
                        smsCode=value;
                      },
                      // controller: _codeController,
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
                actions: <Widget>[
                  FlatButton(
                    textColor: Colors.white,
                    color: Colors.blue,
                    child: Text('Verify'),
                    onPressed: () async {
                      // final code=_codeController.text.trim();
                      PhoneAuthCredential phoneAuthCredential =
                      PhoneAuthProvider.credential(
                          verificationId: verificationId,
                          smsCode:smsCode);
                      UserCredential result = await _auth.signInWithCredential(phoneAuthCredential);
                      User user = result.user;
                      if (user != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => WelcomeScreen()),
                        );
                      } else {
                        print('Error');
                      }
                    },
                  ),
                ],
              );
            });
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextField(
                keyboardType: TextInputType.number,
                controller: _textController,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: 'Enter your mobile number',
                  icon: Icon(Icons.mobile_friendly_sharp),
                  contentPadding: EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 20.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(2.0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                    BorderSide(color: Colors.grey, width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(2.0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                    BorderSide(color: Colors.grey, width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(2.0)),
                  ),
                ),
              ),
              SizedBox(
                height: 32.0,
              ),
              Padding(
                padding: EdgeInsets.all(5),
                child: MaterialButton(
                  color: Colors.blue,
                  onPressed: () {
                    final phone=_textController.text.trim();
                    _letsbegin(phone,context);
                  },
                  child: Text('Send OTP'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


}
