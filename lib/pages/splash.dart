import 'package:flutter/material.dart';
import 'package:obi_mobile/pages/login.dart';
import 'package:obi_mobile/pages/home.dart';
import 'package:obi_mobile/libraries/session.dart';
import 'dart:async';
import 'package:obi_mobile/configs/config.dart' as config;

class Splash extends StatefulWidget {
  static String tag = 'splash-page';
  
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> with TickerProviderStateMixin {

  // variable
  String _title = config.APP_NAME;
  String _versionCode = 'v.1.0';
  final delay = 5;
  // bool _isLogin;

  // class
  Session _session = Session();
  AnimationController _controller;
  Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
      value: 0.1
    );
    
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    );

    _controller.forward();
    loadWidget();
    
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  loadWidget() async {
    var _duration = Duration(seconds: delay);
    return Timer(_duration, navigation);
  }

  void navigation() async {
    final _isLogin = await _session.getBool('isLogin');

    if (_isLogin == true) { 
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context)=>Home()));
    }
    else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context)=>Login()));
    }
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: Container(
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ScaleTransition(
                  scale: _animation,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: 48.0,
                      child: Image.asset('assets/images/logo.png'),
                    ),
                  ),
                ),
                Text(_title, style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.bold)),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0)
                ),
                SizedBox(height: 20.0),
                SizedBox(
                  width: 100.0,
                  child: LinearProgressIndicator(),
                ),
              ],
            ),
            Container(
              child: Padding(
                padding: EdgeInsets.only(right: 10.0, bottom: 10.0),
                child: Align(
                  alignment: FractionalOffset.bottomRight,
                  child: Text(_versionCode, style: TextStyle(color: Colors.grey.shade400))
                )
              )
            )
          ],
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end:Alignment(0.8, 0.0),
            colors: [
              Colors.red.shade400,
              Colors.grey.shade200
            ]
          )
        ),
      ),
    );
  }
}