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

class _SplashState extends State<Splash> {
  String _title = config.APP_NAME;
  String _versionCode = '1.0';
  final delay = 5;
  // bool _isLogin;

  Session _session = Session();

  @override
  void initState() {
    super.initState();

    loadWidget();
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
      body: InkWell(
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Expanded(
              flex: 7,
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(_title),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0)
                    ),
                    CircularProgressIndicator()
                  ],
                ),
              ),
            ),
            // Expanded(
            //   child: Column(
            //     children: <Widget>[
            //       CircularProgressIndicator(),
            //       Container(
            //         height:10
            //       ),
            //       Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceAround,
            //         children: <Widget>[
            //           Spacer(),
            //           Text(_versionCode),
            //           Spacer(
            //             flex: 4
            //           ),
            //           Text('Android'),
            //           Spacer()
            //         ],
            //       )
            //     ],
            //   )
            // )
          ],),
      ),
    );
  }
}