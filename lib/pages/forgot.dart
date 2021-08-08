import 'package:flutter/material.dart';
import 'package:obi_mobile/repository/user_repo.dart';
import 'package:toast/toast.dart';
import 'package:obi_mobile/libraries/check_internet.dart';
import 'package:obi_mobile/pages/login.dart';
import 'dart:async';

class Forgot extends StatefulWidget {
  static String tag = 'forgot-page';
  static String name = 'Forgot Password';
  
  @override
  _ForgotState createState() => _ForgotState();
}

class _ForgotState extends State<Forgot> {

  UserRepo _userRepo = UserRepo();
  CheckInternet _checkInternet = CheckInternet();

  @override
  void initState() {
    super.initState();
    _checkInternet.check(context);
  }

  final logo = Hero(
    tag: 'otobid_logo', 
    child: CircleAvatar(
      backgroundColor: Colors.transparent,
      radius: 48.0,
      child: Image.asset('assets/images/logo.png'),
    ) 
  );

  TextEditingController _email = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final email = TextFormField(
      controller: _email,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        hintText: 'Email',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
      ),
    );

    final button = TextButton(
      child: Text('Kirim', 
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold
        )
      ),
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
            side: BorderSide(color:Colors.blue)
          )
        ),
        backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
      ),
      onPressed: () {
        String uEmail = _email.text.toString();
        final delay = 5;

        _userRepo.forgot(uEmail).then((value) {
          bool status = value.getStatus();
          if (status == true) {
            Toast.show('Permintaan Password berhasil di kirim', context, duration: Toast.LENGTH_LONG , gravity: Toast.TOP);

            Duration _duration = Duration(seconds: delay);
            Timer _timer = Timer(_duration, () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context)=>Login()));
            });
          }
          else {
            Map errMessage = value.getMessage();
            String msg = errMessage['message'];
            Toast.show(msg, context, duration: Toast.LENGTH_LONG , gravity:  Toast.TOP, backgroundColor: Colors.orange);
          }
        });
      }, 
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(Forgot.name),
        backgroundColor: Colors.red,
      ),
      body: Container(
        child: Center(
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(left: 24.0, right: 24.0),
            children: <Widget>[
              logo,
              SizedBox(height: 48.0),
              Text('Masukan Email Anda'),
              SizedBox(height: 10.0),
              email,
              SizedBox(height: 24.0),
              button
            ]
          ),
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
      )
    );
  }
}