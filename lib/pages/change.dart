import 'package:flutter/material.dart';
import 'package:obi_mobile/libraries/drawer_menu.dart';
import 'package:obi_mobile/libraries/bottom_menu.dart';
import 'package:obi_mobile/libraries/check_internet.dart';
import 'package:obi_mobile/repository/user_repo.dart';
import 'package:obi_mobile/pages/home.dart';
import 'package:toast/toast.dart';

class Change extends StatefulWidget {
  static String tag = 'change-page';
  static String name = 'Change Password';

  @override
  _ChangeState createState() => new _ChangeState();
}

class _ChangeState extends State<Change> {

  DrawerMenu _drawerMenu = DrawerMenu();
  BottomMenu _bottomMenu = BottomMenu();
  CheckInternet _checkInternet = CheckInternet();

  UserRepo _userRepo = UserRepo();

  TextEditingController _oldPassword = TextEditingController();
  TextEditingController _newPassword = TextEditingController();
  TextEditingController _rePassword = TextEditingController();
  int _processState = 0;

  @override
  initState() {
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
    Drawer _menu = _drawerMenu.initialize(context, Change.tag);
    BottomNavigationBar _bottomNav = _bottomMenu.initialize(context, Home.tag);

    Widget buttonText() {
      if(_processState == 1) {
        return CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        );
      }  
      
      return new Text('Change Password',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold
        )
      );
    }

    final oldPassword = TextFormField(
      controller: _oldPassword,
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'Password Lama',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(18.0))
      ),
    );

    final newPassword = TextFormField(
      controller: _newPassword,
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'Password Baru',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(18.0))
      ),
    );

    final rePassword = TextFormField(
      controller: _rePassword,
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'Ulangi Password Baru',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(18.0))
      ),
    );

    final button = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: MaterialButton(
          onPressed: () {
            String uOldPassword = _oldPassword.text.toString();
            String uNewPassword = _newPassword.text.toString();
            String uRePassword = _rePassword.text.toString();

            setState(() {
              _processState = 1;
            });

            _userRepo.changePassword(uOldPassword, uNewPassword, uRePassword).then((value) {
              bool status = value.getStatus();
              if (status == true) {
                Toast.show('Password Anda Berhasil di Ubah', context, duration: Toast.LENGTH_LONG , gravity: Toast.TOP);
              }
              else {
                Map errMessage = value.getMessage();
                String msg = errMessage['message'];
                Toast.show(msg, context, duration: Toast.LENGTH_LONG , gravity:  Toast.TOP, backgroundColor: Colors.orange);
              }

              setState(() {
                _processState = 0;
              });
            });
          },
          child: buttonText(),
          color: Colors.blue,
          height: 48.0,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(Change.name),
        backgroundColor: Colors.red,
      ),
      drawer: _menu,
      bottomNavigationBar: _bottomNav,
      body: Container( 
        padding: EdgeInsets.all(12.0),
        color: Colors.blueGrey.shade50,
        child : Center(
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(left: 24.0, right: 24.0),
            children: <Widget>[
              logo,
              SizedBox(height: 48.0),
              Text('Password Lama', style: TextStyle(fontSize: 12.0)),
              SizedBox(height: 5.0),
              oldPassword,
              SizedBox(height: 8.0),
              Text('Password Baru', style: TextStyle(fontSize: 12.0)),
              SizedBox(height: 5.0),
              newPassword,
              SizedBox(height: 8.0),
              Text('Ulang Password Baru', style: TextStyle(fontSize: 12.0)),
              SizedBox(height: 5.0),
              rePassword,
              SizedBox(height: 10.0),
              button
            ],
          )
        ),
      )
    );
  }
}
