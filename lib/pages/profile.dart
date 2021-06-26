import 'package:flutter/material.dart';
import 'package:obi_mobile/models/m_user.dart';
import 'package:obi_mobile/libraries/drawer_menu.dart';
import 'package:obi_mobile/libraries/bottom_menu.dart';
import 'package:obi_mobile/libraries/check_internet.dart';
import 'package:obi_mobile/repository/user_repo.dart';

class Profile extends StatefulWidget {
  static String tag = 'profile-page';
  static String name = 'My Profile';

  @override
  _ProfileState createState() => new _ProfileState();
}

class _ProfileState extends State<Profile> {

  DrawerMenu _drawerMenu = new DrawerMenu();
  BottomMenu _bottomMenu = BottomMenu();
  CheckInternet _checkInternet = CheckInternet();
  UserRepo _userRepo = UserRepo();

  TextEditingController _name;
  TextEditingController _email;
  TextEditingController _mobile;
  TextEditingController _address;
  TextEditingController _ktp;
  TextEditingController _npwp;
  TextEditingController _bank;
  TextEditingController _branch;
  TextEditingController _noRek;
  TextEditingController _anRek;
  TextEditingController _pob;
  TextEditingController _dob;
  
  @override
  void initState() {
    super.initState();
    _checkInternet.check(context);
  }

  @override
  Widget build(BuildContext context) {
    Drawer _menu = _drawerMenu.initialize(context, Profile.tag);
    BottomNavigationBar _bottomNav = _bottomMenu.initialize(context, null);

    return Scaffold(
      appBar: AppBar(
        title: Text(Profile.name),
        backgroundColor: Colors.red,
      ),
      drawer: _menu,
      bottomNavigationBar: _bottomNav,
      body: Center(
        child: FutureBuilder<M_User> (
          future: _userRepo.detail(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var data = snapshot.data.getSingleData();

              _name = TextEditingController()..text= data['Nama'];
              _email = TextEditingController()..text= data['Email'];
              _mobile = TextEditingController()..text= data['NoTelp'];
              _address = TextEditingController()..text= data['Alamat'];
              _ktp = TextEditingController()..text= data['NoKTP'];
              _npwp = TextEditingController()..text= data['NoNPWP'];
              _bank = TextEditingController()..text= data['Bank'];
              _noRek = TextEditingController()..text= data['NoRek'];
              _branch = TextEditingController()..text= data['Cabang'];
              _anRek = TextEditingController()..text= data['AtasNama'];
              _pob = TextEditingController()..text= data['TempatLahir'];
              _dob = TextEditingController()..text= data['TglLahir'];

              final name = TextFormField(
                controller: _name,
                enabled: false,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: 'Nama Lengkap',
                  contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(18.0))
                ),
              );

              final email = TextFormField(
                controller: _email,
                enabled: false,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'Email Address',
                  contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(18.0))
                ),
              );

              final mobile = TextFormField(
                controller: _mobile,
                enabled: false,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: 'No Hp / Ponsel',
                  contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(18.0))
                ),
              );

              final address = TextFormField(
                controller: _address,
                enabled: false,
                keyboardType: TextInputType.streetAddress,
                decoration: InputDecoration(
                  hintText: 'Alamat',
                  contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(18.0))
                ),
              );

              final ktp = TextFormField(
                controller: _ktp,
                enabled: false,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: 'No KTP',
                  contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(18.0))
                ),
              );

              final npwp = TextFormField(
                controller: _npwp,
                enabled: false,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: 'No NPWP',
                  contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(18.0))
                ),
              );

              final bank = TextFormField(
                controller: _bank,
                enabled: false,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: 'Nama Bank',
                  contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(18.0))
                ),
              );

              final branch = TextFormField(
                controller: _branch,
                enabled: false,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: 'Cabang Bank',
                  contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(18.0))
                ),
              );

              final noRek = TextFormField(
                controller: _noRek,
                enabled: false,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: 'No Rekening',
                  contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(18.0))
                ),
              );

              final anRek = TextFormField(
                controller: _anRek,
                enabled: false,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: 'A.N Rekening',
                  contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(18.0))
                ),
              );

              final dob = TextFormField(
                controller: _dob,
                enabled: false,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: 'Tempat Lahir',
                  contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(18.0))
                ),
              );

              final pob = TextFormField(
                controller: _pob,
                enabled: false,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: 'Tempat Lahir',
                  contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(18.0))
                ),
              );

              final button = TextButton(
                child: Text('Permintaan Ubah Data', 
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
                onPressed: () {}
              );

              return ListView(
                shrinkWrap: true,
                padding: EdgeInsets.only(left: 24.0, right: 24.0),
                children: <Widget>[
                  SizedBox(height: 8.0),
                  Text('Nama', style: TextStyle(fontSize: 12.0)),
                  SizedBox(height: 5.0),
                  name,
                  SizedBox(height: 8.0),
                  Text('Email', style: TextStyle(fontSize: 12.0)),
                  SizedBox(height: 5.0),
                  email,
                  SizedBox(height: 8.0),
                  Text('Tempat Lahir', style: TextStyle(fontSize: 12.0)),
                  SizedBox(height: 5.0),
                  pob,
                  SizedBox(height: 8.0),
                  Text('Tanggal Lahir', style: TextStyle(fontSize: 12.0)),
                  SizedBox(height: 5.0),
                  dob,
                  SizedBox(height: 8.0),
                  Text('Hp No', style: TextStyle(fontSize: 12.0)),
                  SizedBox(height: 5.0),
                  mobile,
                  SizedBox(height: 8.0),
                  Text('Alamat', style: TextStyle(fontSize: 12.0)),
                  SizedBox(height: 5.0),
                  address,
                  SizedBox(height: 8.0),
                  Text('No. KTP', style: TextStyle(fontSize: 12.0)),
                  SizedBox(height: 5.0),
                  ktp,
                  SizedBox(height: 8.0),
                  Text('No. NPWP', style: TextStyle(fontSize: 12.0)),
                  SizedBox(height: 5.0),
                  npwp,
                  SizedBox(height: 8.0),
                  Text('Bank', style: TextStyle(fontSize: 12.0)),
                  SizedBox(height: 5.0),
                  bank,
                  SizedBox(height: 8.0),
                  Text('Cabang Bank', style: TextStyle(fontSize: 12.0)),
                  SizedBox(height: 5.0),
                  branch,
                  SizedBox(height: 8.0),
                  Text('No Rekening', style: TextStyle(fontSize: 12.0)),
                  SizedBox(height: 5.0),
                  noRek,
                  SizedBox(height: 8.0),
                  Text('Atas Nama Rekening', style: TextStyle(fontSize: 12.0)),
                  SizedBox(height: 5.0),
                  anRek,
                  SizedBox(height: 8.0),
                  button
                ]
              );
            }
            else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        )
      ),
    );
  }
}