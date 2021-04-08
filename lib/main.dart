import 'package:flutter/material.dart';
import 'package:obi_mobile/pages/splash.dart';
import 'package:obi_mobile/pages/login.dart';
import 'package:obi_mobile/pages/home.dart';
import 'package:obi_mobile/pages/reg.dart';
import 'package:obi_mobile/pages/forgot.dart';
import 'package:obi_mobile/pages/npl.dart';
import 'package:obi_mobile/pages/buy_npl.dart';
import 'package:obi_mobile/pages/profile.dart';
import 'package:obi_mobile/pages/change.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final routes = <String, WidgetBuilder>{
    Login.tag : (context) => Login(),
    Splash.tag : (context) => Splash(),
    Home.tag : (context) => Home(),
    Reg.tag : (context) => Reg(),
    Forgot.tag : (context) => Forgot(),
    Npl.tag : (context) => Npl(),
    BuyNpl.tag : (context) => BuyNpl(),
    Profile.tag : (context) => Profile(),
    Change.tag : (context) => Change() 
  };
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OTOBID MOBILE',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      // home: MyHomePage(title: 'Flutter Demo Home Page'),
      home: Splash(),
      routes: routes,
    );
  }
}
