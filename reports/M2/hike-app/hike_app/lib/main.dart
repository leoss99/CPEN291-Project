import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Pages/selectprofilepicture.dart';
import 'Pages/signup.dart';
import 'Pages/loginpage.dart';
import 'Pages/homepage.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(new HikeApp());
}

class HikeApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
      routes: <String, WidgetBuilder> {
        '/loginpage': (BuildContext context)=> new LoginPage(),
        '/landingpage': (BuildContext context)=> new HikeApp(),
        '/signup': (BuildContext context) => new SignupPage(),
        '/homepage': (BuildContext context) => new HomePage(),
        '/selectprofpic': (BuildContext context) => new SelectprofilepicPage(),
      },
    );
  }
}