import 'package:flutter/material.dart';
import 'package:authentication_app/WelcomeScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
class PhoneVerification  extends StatefulWidget {
  @override
  _PhoneVerificationState createState() => _PhoneVerificationState();
}

class _PhoneVerificationState extends State<PhoneVerification > {
   String number;
   String smsCode;
   final _textController= TextEditingController();
   @override
   void initState() {
     initializeFirebase();
    super.initState();
  }
  void initializeFirebase() async{
     try{
       await Firebase.initializeApp();
     }catch(e)
    {
      print('error');
    }
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
               onChanged: (value)
                {
                  number=value;
                },
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: 'Enter your Mobile No.',
                ),
              ),
              SizedBox(
                height: 32.0,
              ),
              Padding(
                  padding: EdgeInsets.all(5),
                child: MaterialButton(
                  color: Colors.green,
                  onPressed: (){
                  _letsbegin(context);
                  },
                 child:  Text(
                   'Send OTP'
                 ),
                ),
              ),
            ],

          ),
        ),
      ),
    );
  }
   Future<void> _letsbegin( BuildContext context) async
   {

     FirebaseAuth _auth=FirebaseAuth.instance;
     await _auth.verifyPhoneNumber(
         phoneNumber: '+91'+ number,
         timeout: Duration(seconds: 60),
         verificationCompleted: (PhoneAuthCredential credential) async {
           // Navigator.pop(context);
          UserCredential result= await _auth.signInWithCredential(credential);
          User user=result.user;
          if(user!=null) {
            Navigator.push(context,
              MaterialPageRoute(builder: (context) => WelcomeScreen()),
            );
          }
          else{
            print('Error');
          }
         },
         verificationFailed: (FirebaseAuthException e) {
           if (e.code == 'invalid-phone-number') {
             print('The provided phone number is not valid.');
           }
         },
         codeSent: (String verificationId, int resendToken)  {
           showDialog(
               context: context,
               barrierDismissible: false,
               builder: (context){
                 return AlertDialog(
                   title: Text('Enter the OTP'),
                   content: Column(
                     children: <Widget>[
                       TextField(
                         // onChanged: (value)
                         // {
                         //   _textController=value;
                         // },
                         controller: _textController,
                         keyboardType: TextInputType.number,
                       ),
                     ],
                   ),
                   actions:<Widget> [
                     FlatButton(
                       child: Text('Verify'),
                       onPressed: () async {
                         PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: _textController.text);
                         UserCredential result= await _auth.signInWithCredential(phoneAuthCredential);
                         User user=result.user;
                         if(user!=null) {
                           Navigator.push(context,
                             MaterialPageRoute(builder: (context) => WelcomeScreen()),
                           );
                         }else{
                           print('Error');
                         }
                       },
                     ),
                   ],
                 );
               }
           );
         },
         codeAutoRetrievalTimeout: (String verificationId) {
         },
     );
         }

}