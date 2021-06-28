import 'package:file_picker/file_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:obi_mobile/libraries/check_internet.dart';
import 'package:obi_mobile/pages/terms_condition.dart';
import 'package:obi_mobile/repository/user_repo.dart';
import 'package:toast/toast.dart';
import 'package:intl/intl.dart';
import 'dart:io';

class Reg extends StatefulWidget {
  static String tag = 'reg-page';
  static String name = 'Registrasi Peserta Lelang';

  @override
  _RegState createState() => new _RegState();
}

class _RegState extends State<Reg> {
  CheckInternet _checkInternet = CheckInternet();

  DateTime currentDate = DateTime.now();
  TextEditingController _name = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _phone = TextEditingController();
  TextEditingController _mobile = TextEditingController();
  TextEditingController _address = TextEditingController();
  TextEditingController _ktp = TextEditingController();
  TextEditingController _npwp = TextEditingController();
  TextEditingController _bank = TextEditingController();
  TextEditingController _branch = TextEditingController();
  TextEditingController _noRek = TextEditingController();
  TextEditingController _anRek = TextEditingController();
  TextEditingController _pob = TextEditingController();
  TextEditingController _uploadKtp = TextEditingController();
  TextEditingController _uploadNpwp = TextEditingController();
  TextEditingController _dob;
  File _ktpImage;
  File _npwpImage;

  bool _toc = false;
  int _regProcessState = 0;

  @override
  void initState() {
    super.initState();
    _checkInternet.check(context);
  }
  
  @override
  Widget build(BuildContext context) {
    Widget buttonText() {
      if(_regProcessState == 1) {
        return CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        );
      }  
      
      return new Text('Registrasi',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold
        )
      );
    }

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

    final phone = TextFormField(
      controller: _phone,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        hintText: 'No Telepon',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 10.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(18.0))
      ),
    );

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
      keyboardType: TextInputType.text,
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

    final pob = TextFormField(
      controller: _pob,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        hintText: 'Tempat Lahir',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(18.0))
      ),
    );

    Future<void> _selectDate(BuildContext context) async {
      final DateTime pickedDate = await showDatePicker(
          context: context,
          initialDate: currentDate,
          firstDate: DateTime(1950),
          lastDate: DateTime(2050));
      if (pickedDate != null && pickedDate != currentDate) {
        setState(() {
          currentDate = pickedDate;
          String formatCurrentDate = DateFormat('yyyy-MM-dd').format(currentDate);
          _dob = TextEditingController()..text = formatCurrentDate;
        });
         
      }
    }

    final dob = TextFormField(
      controller: _dob,
      keyboardType: TextInputType.datetime,
      decoration: InputDecoration(
        hintText: 'Tanggal Lahir',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(18.0))
      ),
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
        _selectDate(context);
      },
      onSaved: (String val) {  },
    );


    final uploadKtp = TextFormField(
      controller: _uploadKtp,
      keyboardType: TextInputType.datetime,
      decoration: InputDecoration(
        hintText: 'Upload Ktp',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(18.0))
      ),
      onTap: () async{
        FocusScope.of(context).requestFocus(new FocusNode());
        FilePickerResult fileResult = await FilePicker.platform.pickFiles(
          type: FileType.image
        );
        if (fileResult != null) {
          File file = File(fileResult.files.single.path);
          PlatformFile fileInfo = fileResult.files.first;
          setState(() {
            _ktpImage = file;      
          });
          _uploadKtp..text = fileInfo.name.toString();
        }
      },
    );

    final uploadNpwp = TextFormField(
      controller: _uploadNpwp,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        hintText: 'Upload Npwp',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(18.0))
      ),
      onTap: () async{
        FocusScope.of(context).requestFocus(new FocusNode());
        FilePickerResult fileResult = await FilePicker.platform.pickFiles(
          type: FileType.image
        );
        if (fileResult != null) {
          File file = File(fileResult.files.single.path);
          PlatformFile fileInfo = fileResult.files.first;
          setState(() {
            _npwpImage = file;          
          });
          _uploadNpwp..text = fileInfo.name.toString();
        }
      },
    );

    final toc = CheckboxListTile(
      controlAffinity: ListTileControlAffinity.leading,
      title: RichText(
        text: TextSpan(
          style: TextStyle(color: Colors.black),
          children: <TextSpan>[
            TextSpan(text :'Dengan Mendaftar, anda menyetujui '),
            TextSpan(
              text: 'Pernyataan Kesepatakatan Lelang',
              style: TextStyle(color: Colors.blue),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.of(context).pushNamed(TermCondition.tag);
                }
            )
          ]
        )      
      ),
      value: _toc, 
      onChanged:(bool value){
        setState(() {
          _toc = value;
        });
      }        
    );
      
    final button = TextButton(
      child: buttonText(),
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
        if (_toc == false) {
          Toast.show("Silakan centang Syarat dan Ketentuan terlebih dahulu!", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM, backgroundColor: Colors.red);
        }
        else {
          setState(() {
            _regProcessState = 1;
          });
          
          String uName = _name.text.toString();
          String uEmail = _email.text.toString();
          String uPhone = _phone.text.toString();
          String uAddress = _address.text.toString();
          String uKtp = _ktp.text.toString();
          String uNpwp = _npwp.text.toString();
          String uBank = _bank.text.toString();
          String uBranch = _branch.text.toString();
          String uNoRek = _noRek.text.toString();
          String uAnRek = _anRek.text.toString();
          String uPob = _pob.text.toString();
          String uDob = '';
          if (_dob != null) {
            uDob = _dob.text.toString();
          }

          UserRepo userRepo = UserRepo();
          var params = {
            'name': uName,
            'email': uEmail,
            'phone_no': uPhone,
            'identity_no': uKtp,
            'address': uAddress,
            'npwp_no': uNpwp,
            'bank': uBank,
            'branch_bank': uBranch,
            'account_no': uNoRek,
            'account_name': uAnRek,
            'birth_date': uDob,
            'birth_place': uPob
          };

          userRepo.register(params, _ktpImage, _npwpImage).then((value) {
            bool status = value.getStatus();
            if (status == true) {
              Map data = value.getData();
              Toast.show("Registrasi Berhasil", context, duration: Toast.LENGTH_LONG , gravity: Toast.BOTTOM);
            }
            else {
              String errMessage = value.getStringMessage();
              Toast.show(errMessage, context, duration: Toast.LENGTH_LONG , gravity:  Toast.BOTTOM, backgroundColor: Colors.red);
            }

            setState(() {
              _regProcessState = 0;
            });
          });
        }
      }, 
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(Reg.name),
        backgroundColor: Colors.red,
      ),
      body: Container(
        child: Center(
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(left: 24.0, right: 24.0),
            children: <Widget>[
              SizedBox(height: 8.0),
              name,
              SizedBox(height: 8.0),
              email,
              SizedBox(height: 8.0),
              pob,
              SizedBox(height: 8.0),
              dob,
              SizedBox(height: 8.0),
              mobile,
              SizedBox(height: 8.0),
              phone,
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
              uploadKtp,
              SizedBox(height: 8.0),
              uploadNpwp,
              SizedBox(height: 8.0),
              toc,
              SizedBox(height: 8.0),
              button
            ],
          )
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