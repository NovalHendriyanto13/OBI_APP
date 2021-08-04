import 'package:flutter/material.dart';
import 'package:obi_mobile/libraries/session.dart';
import 'package:obi_mobile/pages/change.dart';
import 'package:obi_mobile/pages/home.dart';
import 'package:obi_mobile/pages/login.dart';
import 'package:obi_mobile/pages/my_unit.dart';
import 'package:obi_mobile/pages/npl.dart';
import 'package:obi_mobile/pages/profile.dart';
import 'package:obi_mobile/pages/bid.dart';

class DrawerMenu {

  String name='';
  String email='';

  void logout() async {
    Session _session = new Session();
    _session.setInt('id', 0);
    _session.setString('token', '');
    _session.setString('username', '');
    _session.setString('pass', '');
    _session.setString('email', '');
    _session.setString('name', '');
    _session.setInt('expireIn', 0);
    _session.setBool('isLogin', false); 
  }

  getName() async {
    Session _session = new Session();
    String _name = await _session.getString('name');

    return _name;
  }

  getEmail() async {
    Session _session = new Session();
    String _email = await _session.getString('email');

    return _email;
  }

  Drawer initialize(BuildContext context, String pageTag) {

    getName().then((e) => this.name = e );
    getEmail().then((e) => this.email = e );

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountEmail: Text(this.email),
            accountName: Text(this.name, style: TextStyle(fontSize: 20.0),),
            currentAccountPicture: Center(
              child: CircleAvatar(
                backgroundImage: AssetImage('assets/images/profile_default.png'),
            )),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end:Alignment(0.8, 0.0),
                colors: [
                  Colors.red.shade900,
                  Colors.red.shade400
                ]
              )
            )
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              if (pageTag == Home.tag) {
                Navigator.pop(context);
              }
              else {
                Navigator.pop(context);
                Navigator.of(context).pushNamed(Home.tag);
              }
            },
          ),
          ListTile(
            leading: Icon(Icons.person_outline),
            title: Text('Profile'),
            onTap: () {
              if (pageTag == Profile.tag) {
                Navigator.pop(context);
              }
              else {
                Navigator.pop(context);
                Navigator.of(context).pushNamed(Profile.tag);
              }
            },
          ),
          ListTile(
            leading: Icon(Icons.lock),
            title: Text('Ubah Password'),
            onTap: () {
              if (pageTag == Change.tag) {
                Navigator.pop(context);
              }
              else {
                Navigator.pop(context);
                Navigator.of(context).pushNamed(Change.tag);
              }
            },
          ),
          ListTile(
            leading: Icon(Icons.confirmation_number),
            title: Text('My NPL'),
            onTap: () {
              if (pageTag == Npl.tag) {
                Navigator.pop(context);
              }
              else {
                Navigator.pop(context);
                Navigator.of(context).pushNamed(Npl.tag);
              }
            },
          ),
          ListTile(
            leading: Icon(Icons.sync_alt_outlined),
            title: Text('My Bid'),
            onTap: () {
              if (pageTag == Bid.tag) {
                Navigator.pop(context);
              }
              else {
                Navigator.pop(context);
                Navigator.of(context).pushNamed(Bid.tag);
              }
            }
          ),
          ListTile(
            leading: Icon(Icons.drive_eta),
            title: Text('My Unit'),
            onTap: () {
              if (pageTag == MyUnit.tag) {
                Navigator.pop(context);
              }
              else {
                Navigator.pop(context);
                Navigator.of(context).pushNamed(MyUnit.tag);
              }
            }
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () {
              logout();

              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Login()));
            },
          )
        ],
      ),
    );
  }
}