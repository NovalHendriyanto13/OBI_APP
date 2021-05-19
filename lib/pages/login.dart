import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:obi_mobile/libraries/session.dart';
import 'package:obi_mobile/libraries/refresh_token.dart';
import 'package:obi_mobile/libraries/check_internet.dart';
import 'package:obi_mobile/pages/reg.dart';
import 'package:obi_mobile/pages/forgot.dart';
import 'package:obi_mobile/pages/home.dart';
import 'package:obi_mobile/repository/user_repo.dart';

class Login extends StatefulWidget {
  static String tag = 'login-page';

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  UserRepo _userRepo = UserRepo();
  Session _session = Session();
  RefreshToken _refreshToken = RefreshToken();
  CheckInternet _checkInternet = CheckInternet();

  TextEditingController _username = TextEditingController();
  TextEditingController _password = TextEditingController();

  int _loginProcessState = 0;

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

  @override
  Widget build(BuildContext context) {

    Widget buttonText() {
      if(_loginProcessState == 1) {
        return CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        );
      }  
      
      return new Text('Log In',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold
        )
      );
    }

    final username = TextFormField(
      controller: _username,
      keyboardType: TextInputType.text,
      autofocus: true,
      decoration: InputDecoration(
        hintText: 'Username',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
      ),
    );

    final password = TextFormField(
      controller: _password,
      autofocus: false,
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'Password',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
      ),
    );

    final btnLogin = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: MaterialButton(
          onPressed: () {
            // _session.setBool('isLogin', true);
            // Navigator.of(context).pushNamed(Home.tag);
            String uname = _username.text.toString();
            String upass = _password.text.toString();

            String email, name, token;
            int id, expireIn;
            bool isLogin = false;

            setState(() {
              _loginProcessState = 1;
            });

            _userRepo.login(uname, upass).then((value) {
              isLogin = value.getStatus();
              if (isLogin == true) {
                Map data = value.getData();
                token = data['token'];
                id = data['data']['id'];
                email = data['data']['email'];
                name = data['data']['name'];
                expireIn = data['expire_in'];
              
                _session.setString('token', token);
                _session.setInt('id', id);
                _session.setString('username', uname);
                _session.setString('pass', upass);
                _session.setString('email', email);
                _session.setString('name', name);
                _session.setInt('expireIn', expireIn);
                _session.setBool('isLogin', isLogin);
                // _session.setString()

                _refreshToken.setTime();
                
                Toast.show('Selamat Datang,' + name, context, duration: Toast.LENGTH_LONG , gravity: Toast.BOTTOM);
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Home()));
              }
              else {
                Map errMessage = value.getMessage();
                String msg = errMessage['message'];
                Toast.show(msg, context, duration: Toast.LENGTH_LONG , gravity:  Toast.BOTTOM, backgroundColor: Colors.red.shade50);
              }

              setState(() {
                _loginProcessState = 0;
              });
            });
          },
          child: buttonText(),
          color: Colors.blue,
          height: 48.0,
      ),
    );

    final forgotLabel = TextButton(
      child: Text(
        'Lupa Password?',
        style: TextStyle(color: Colors.blue),
      ),
      onPressed: () {
        Navigator.of(context).pushNamed(Forgot.tag);
      },
    );

    final registerLabel = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child:RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: TextStyle(color: Colors.black),
          children: <TextSpan>[
            TextSpan(text: 'Belum punya akun? '),
            TextSpan(
              text: 'Daftar Disini',
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.of(context).pushNamed(Reg.tag);
                }
            )
          ] 
        )
      )
    );

    return Scaffold(
      body: Container(
        child: Center(
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(left: 24.0, right: 24.0),
            children: <Widget>[
              logo,
              SizedBox(height: 48.0),
              Align(
                alignment: Alignment.center,
                child: Container(
                  child: Text('Silakan Masukan Username dan Password', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
              SizedBox(height:10.0),
              username,
              SizedBox(height: 8.0),
              password,
              SizedBox(height: 24.0),
              btnLogin,
              forgotLabel,
              SizedBox(height:140.0),
              registerLabel
            ],
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