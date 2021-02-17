import 'package:authentication_app/widget/provider_widget.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:authentication_app/Screens/PhoneVerification.dart';
import 'package:authentication_app/constants/TextFormLogin.dart';

class otpscreen extends StatefulWidget {
  String verificationId, phone;
  otpscreen({Key key, @required this.verificationId, @required this.phone})
      : super(key: key);

  @override
  _otpscreenState createState() => _otpscreenState();
}

class _otpscreenState extends State<otpscreen> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final _codeController = TextEditingController();
  String _error;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Column(children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: width * .1),
            child: Column(
              children: [
                Text(
                  'Verify Mobile Number',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                SizedBox(
                  height: 5.0,
                ),

                Text(
                  'Enter 6 digit code sent to ${widget.phone}',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
                ),

                SizedBox(
                  height: 25.0,
                ),

                LoginTextFormField(
                  codeController: _codeController,
                  hintText: 'Enter Verification Code',
                  iconData: Icons.mobile_friendly,
                ),

                SizedBox(
                  height: 6.0,
                ),

                showalert(),

                SizedBox(
                  height: 6.0,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    FlatButton(
                        onPressed: () {
                          //TODO: push back to login screen

                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PhoneVerification(),
                              ),
                              (route) => false);
                        },
                        child: Text(
                          'Change Number',
                          style: TextStyle(color: Colors.blue.shade900),
                        )),
                    SizedBox(
                      width: width * .25,
                    ),
                    FlatButton(
                        onPressed: () async {
                          final authr = Provider.of(context).auth;
                          var result =
                              authr.createUserWithPhone(widget.phone, context);
                          //TODO:call send otp function again
                        },
                        child: Text(
                          'Resend OTP',
                          style: TextStyle(color: Colors.blue.shade900),
                        ))
                  ],
                ),

                // showAlert(),
                SizedBox(
                  height: 22.0,
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: width * .05),
          child: Column(
            // mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(5),
                child: FlatButton(
                  child: Text(
                    "Verify Number",
                    style: TextStyle(fontSize: 23),
                  ),
                  textColor: Colors.white,
                  color: Colors.blueAccent,
                  onPressed: () async {
                    final SharedPreferences sharedPreferences =
                        await SharedPreferences.getInstance();
                    var _credential = PhoneAuthProvider.credential(
                        verificationId: widget.verificationId,
                        smsCode: _codeController.text.trim());
                    _firebaseAuth
                        .signInWithCredential(_credential)
                        .then((UserCredential result) {
                      if (widget.phone != null)
                        sharedPreferences.setString('phone', widget.phone);
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          '/home', (Route<dynamic> route) => false);
                    }).catchError((e) {
                      setState(() {
                        _error = e.code;
                        print(e.code);
                      });
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }

  Widget showalert() {
    if (_error == null) {
      return SizedBox(
        height: 0,
      );
    } else {
      return Container(
        color: Colors.amberAccent,
        width: double.infinity,
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: [
            Icon(Icons.error_outline),
            Expanded(
              child: Text(
                _error,
                maxLines: 2,
              ),
            )
          ],
        ),
      );
    }
  }
}
