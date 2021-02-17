import 'file:///E:/Android_Projects/Authentication_App/lib/widget/provider_widget.dart';
import 'package:flutter/material.dart';
import 'package:authentication_app/constants/TextFormLogin.dart';
import 'package:auto_size_text/auto_size_text.dart';

class PhoneVerification extends StatefulWidget {
  @override
  _PhoneVerificationState createState() => _PhoneVerificationState();
}

class _PhoneVerificationState extends State<PhoneVerification> {
  String finalphone;
  String _phone;
  String _error;
  String smsCode;
  final _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: width * .1),
        child: Column(children: [
          Expanded(
            child: Column(
              children: [
                // SizedBox(height: height * 0.15),
                Image(image: AssetImage('assets/images/htlogo.jpeg'),width: width*0.3,),
                SizedBox(height: height * 0.05),
                Text(
                  'Enter Mobile Number',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10.0,
                ),
                AutoSizeText(
                  'Enter 10 digit mobile number to receive verification code',
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
                ),
                SizedBox(
                  height: height * 0.05,
                ),
                LoginTextFormField(
                  codeController: _textController,
                  hintText: '+91 Mobile Number',
                  iconData: Icons.mobile_friendly,
                ),
                SizedBox(
                  height: 12.0,
                ),
                showAlert(),
                // SizedBox(height: 12.0),
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            ),
          ),
          Column(
            // mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(5),
                child: MaterialButton(
                  color: Colors.blue,
                  onPressed: () {
                    _phone = _textController.text.trim();
                    submit(_phone);
                  },
                  child: Text(
                    'GET VERIFICATION CODE',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
              ),
            ],
          ),
        ]),
      ),
    );
  }

  Widget showAlert() {
    if (_error != null) {
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
    } else
      return SizedBox(
        height: 0,
      );
  }

  void submit(String _phone) async {
    final authr = Provider.of(context).auth;
    var result = authr.createUserWithPhone(_phone, context);
    if (_phone == "") {
      setState(() {
        _error = "Enter your phone number";
      });
    }
    // ignore: unrelated_type_equality_checks
    if (result == "error") {
      setState(() {
        _error = "Your p";
      });
    }
  }
}
