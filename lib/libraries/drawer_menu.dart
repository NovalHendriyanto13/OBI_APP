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

  Drawer initialize(BuildContext context, String pageTag) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountEmail: Text(''),
            accountName: Text('Username'),
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage('assets/images/profile_default.png'),
            ),
            decoration: BoxDecoration(
              color: Colors.red
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