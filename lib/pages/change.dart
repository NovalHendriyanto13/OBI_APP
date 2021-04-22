import 'package:flutter/material.dart';
import 'package:obi_mobile/libraries/drawer_menu.dart';
import 'package:obi_mobile/libraries/bottom_menu.dart';
import 'package:obi_mobile/repository/user_repo.dart';
import 'package:obi_mobile/pages/home.dart';
import 'package:toast/toast.dart';

class Change extends StatefulWidget {
  static String tag = 'change-page';
  static String name = 'Ubah Password';

  @override
  _ChangeState createState() => new _ChangeState();
}

class _ChangeState extends State<Change> {

  DrawerMenu _drawerMenu = new DrawerMenu();
  BottomMenu _bottomMenu = new BottomMenu();

  UserRepo _userRepo = UserRepo();

  TextEditingController _oldPassword = TextEditingController();
  TextEditingController _newPassword = TextEditingController();
  TextEditingController _rePassword = TextEditingController();

  @override
  initState() {
    super.initState();
    // relogin
    // relogin();
  }

  @override
  Widget build(BuildContext context) {
    Drawer _menu = _drawerMenu.initialize(context, Change.tag);
    BottomNavigationBar _bottomNav = _bottomMenu.initialize(context, Home.tag);

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

    final button = TextButton(
      child: Text('Update', 
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
        String uOldPassword = _oldPassword.text.toString();
        String uNewPassword = _newPassword.text.toString();
        String uRePassword = _rePassword.text.toString();

        _userRepo.changePassword(uOldPassword, uNewPassword, uRePassword).then((value) {
          bool status = value.getStatus();
          if (status == true) {
            Toast.show('Password Anda Berhasil di Ubah', context, duration: Toast.LENGTH_LONG , gravity: Toast.TOP);
          }
          else {
            Map errMessage = value.getMessage();
            String msg = errMessage['message'];
            Toast.show(msg, context, duration: Toast.LENGTH_LONG , gravity:  Toast.TOP, backgroundColor: Colors.red);
          }
        });
      }, 
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
              SizedBox(height: 8.0),
              oldPassword,
              SizedBox(height: 8.0),
              newPassword,
              SizedBox(height: 8.0),
              rePassword,
              SizedBox(height: 8.0),
              button
            ],
          )
        ),
      )
    );
  }
}
