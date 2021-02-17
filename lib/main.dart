import 'file:///E:/Android_Projects/Authentication_App/lib/Screens/PhoneVerification.dart';
import 'file:///E:/Android_Projects/Authentication_App/lib/AuthService/auth_services.dart';
import 'file:///E:/Android_Projects/Authentication_App/lib/widget/provider_widget.dart';
import 'package:flutter/material.dart';
import 'Screens/WelcomeScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp(),);


}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String login;
  //
  @override
  void initState() {
    getvalidation();
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Provider(auth: AuthService(),
      child: MaterialApp(
        home:login!=null?WelcomeScreen():PhoneVerification(),
        routes: {'/home':(context)=> WelcomeScreen(),
          '/login':(context)=>PhoneVerification()
        },
      ),
    );
  }

  Future getvalidation() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      login= sharedPreferences.getString('phone');
    });

    // super.initState();
  }
}



