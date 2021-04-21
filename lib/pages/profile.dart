import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:obi_mobile/libraries/drawer_menu.dart';
import 'package:obi_mobile/libraries/bottom_menu.dart';
import 'package:obi_mobile/repository/user_repo.dart';

class Profile extends StatefulWidget {
  static String tag = 'profile-page';
  static String name = 'My Profile';

  @override
  _ProfileState createState() => new _ProfileState();
}

class _ProfileState extends State<Profile> {

  DrawerMenu _drawerMenu = new DrawerMenu();
  BottomMenu _bottomMenu = new BottomMenu();
  UserRepo _userRepo = new UserRepo();

  TextEditingController _name;
  TextEditingController _email;
  TextEditingController _phone;
  TextEditingController _mobile;
  TextEditingController _address;
  TextEditingController _ktp;
  TextEditingController _npwp;
  TextEditingController _bank;
  TextEditingController _branch;
  TextEditingController _noRek;
  TextEditingController _anRek;
  
  @override
  void initState() {
    super.initState();
    getProfile();
  }

  getProfile() async{
    _userRepo.detail().then((value) {
      bool status = value.getStatus();
      
      if (status == true) {
        var data = value.getSingleData();

        data = data.toString();

        print(data["Nama"]);

        _name = TextEditingController(text: data['Nama']);
        _email = TextEditingController(text: data['Email']);
        _mobile = TextEditingController(text: data['NoTelp']);
        _address = TextEditingController(text: data['Alamat']);
        _ktp = TextEditingController(text: data['NoKTP']);
        _npwp = TextEditingController(text: data['NoNPWP']);
        _bank = TextEditingController(text: data['Bank']);
        _noRek = TextEditingController(text: data['NoRek']);
        _branch = TextEditingController(text: data['Cabang']);
        _anRek = TextEditingController(text: data['AtasNama']);

      }
      else {
        Map errMessage = value.getMessage();
        String msg = errMessage['message'];
        Toast.show(msg, context, duration: Toast.LENGTH_LONG , gravity:  Toast.TOP, backgroundColor: Colors.red);
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    Drawer _menu = _drawerMenu.initialize(context, Profile.tag);
    BottomNavigationBar _bottomNav = _bottomMenu.initialize(context, null);

    final name = TextFormField(
      controller: _name,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        hintText: 'Nama Lengkap',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(18.0))
      ),
    );

    final email = TextFormField(
      controller: _email,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        hintText: 'Email Address',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(18.0))
      ),
    );

    // final phone = TextFormField(
    //   controller: _phone,
    //   keyboardType: TextInputType.phone,
    //   decoration: InputDecoration(
    //     hintText: 'No Telepon',
    //     contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
    //     border: OutlineInputBorder(borderRadius: BorderRadius.circular(18.0))
    //   ),
    // );

    final mobile = TextFormField(
      controller: _mobile,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        hintText: 'No Hp / Ponsel',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(18.0))
      ),
    );

    final address = TextFormField(
      controller: _address,
      keyboardType: TextInputType.streetAddress,
      decoration: InputDecoration(
        hintText: 'Alamat',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(18.0))
      ),
    );

    final ktp = TextFormField(
      controller: _ktp,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        hintText: 'No KTP',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(18.0))
      ),
    );

    final npwp = TextFormField(
      controller: _npwp,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        hintText: 'No NPWP',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(18.0))
      ),
    );

    final bank = TextFormField(
      controller: _bank,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        hintText: 'Nama Bank',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(18.0))
      ),
    );

    final branch = TextFormField(
      controller: _branch,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        hintText: 'Cabang Bank',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(18.0))
      ),
    );

    final noRek = TextFormField(
      controller: _noRek,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        hintText: 'No Rekening',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(18.0))
      ),
    );

    final anRek = TextFormField(
      controller: _anRek,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        hintText: 'A.N Rekening',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(18.0))
      ),
    );

    // final uploadKtp = TextFormField(
    //   controller: _uploadKtp,
    //   keyboardType: TextInputType.,
    // );
    // 
    // 

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
        final data = jsonEncode({
          "Nama": _name.text.toString(),
          "Email": _email.text.toString(),
          "NoTelp": _mobile.text.toString(),
          "Alamat": _address.text.toString(),
          "NoKTP": _ktp.text.toString(),
          "NoNPWP": _npwp.text.toString(), 
          "Bank": _bank.text.toString(),
          "NoRek": _noRek.text.toString(),
          "Cabang": _branch.text.toString(),
          "AtasNama": _anRek.text.toString()
        });

        print(data.toString());
        _userRepo.update(data).then((value) {
          bool status = value.getStatus();
          if (status == true) {
            Toast.show('Profile Berhasil Di Update', context, duration: Toast.LENGTH_LONG , gravity: Toast.BOTTOM);
          }
          else {
            Map errMessage = value.getMessage();
            String msg = errMessage['message'];
            Toast.show(msg, context, duration: Toast.LENGTH_LONG , gravity:  Toast.BOTTOM, backgroundColor: Colors.red.shade50);
          }
        });
      }, 
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(Profile.name),
        backgroundColor: Colors.red,
      ),
      drawer: _menu,
      bottomNavigationBar: _bottomNav,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            SizedBox(height: 8.0),
            name,
            SizedBox(height: 8.0),
            email,
            SizedBox(height: 8.0),
            mobile,
            SizedBox(height: 8.0),
            address,
            SizedBox(height: 8.0),
            ktp,
            SizedBox(height: 8.0),
            npwp,
            SizedBox(height: 8.0),
            bank,
            SizedBox(height: 8.0),
            branch,
            SizedBox(height: 8.0),
            noRek,
            SizedBox(height: 8.0),
            anRek,
            SizedBox(height: 8.0),
            button
          ],
        )
      ),
    );
  }
}