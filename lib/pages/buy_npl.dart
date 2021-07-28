import 'dart:io';
import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:obi_mobile/pages/npl.dart';
import 'package:obi_mobile/pages/terms_condition.dart';
import 'package:obi_mobile/repository/auction_repo.dart';
import 'package:obi_mobile/repository/npl_repo.dart';
import 'package:obi_mobile/libraries/bottom_menu.dart';
import 'package:obi_mobile/libraries/drawer_menu.dart';
import 'package:obi_mobile/libraries/check_internet.dart';
import 'package:toast/toast.dart';

class BuyNpl extends StatefulWidget {
  static String tag = 'buy-npl-page';
  static String name = 'Beli NPL';

  @override
  _BuyNplState createState() => _BuyNplState();
}

class _BuyNplState extends State<BuyNpl> {
  
  // repo and model
  AuctionRepo _auctionRepo = AuctionRepo();
  NplRepo _nplRepo = NplRepo();
  BottomMenu _bottomMenu = BottomMenu();
  DrawerMenu _drawerMenu = DrawerMenu();
  CheckInternet _checkInternet = CheckInternet();

  // controller
  TextEditingController _auctions = TextEditingController();
  TextEditingController _noRek = TextEditingController();
  TextEditingController _totalNpl = TextEditingController();
  TextEditingController _totalPayment = TextEditingController();
  TextEditingController _an = TextEditingController();
  TextEditingController _uploadTrans = TextEditingController();
  
  // variable
  List _dataAuction = [{"IdAuctions":"","Kota":"","TglAuctions":""}];
  List<String> _dataType = <String>['Mobil','Motor','Alat Berat','Barang Inventaris'];
  List<String> _dataSumberDana = <String>['Gaji','Lain-lain'];
  String _selectedType = 'Mobil';
  String _selectedAuction = "";
  String _selectedSumberDana = 'Lain-lain';
  bool _toc = false;
  int _nplAmount = 5000000;
  File _transImage;
  int _processState = 0;

  @override
  void initState() {
    super.initState();
    _checkInternet.check(context);
    _loadData();
  }

  _loadData() async {
    _auctionRepo.list().then((value) {
      bool status = value.getStatus();
      if (status == true) {
        setState(() {
          _dataAuction.addAll(value.getListData());
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    BottomNavigationBar _bottomNav = _bottomMenu.initialize(context, BuyNpl.tag);
    Drawer _menu = _drawerMenu.initialize(context, BuyNpl.tag);

    Widget buttonText() {
      if(_processState == 1) {
        return CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        );
      }  
      
      return new Text('Beli NPL',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold
        )
      );
    }

    final auctions = DropdownButtonFormField(
      items: _dataAuction.map((e) {
        String v = e["IdAuctions"].toString();
        String t = e["Kota"] + ', ' + e['TglAuctions'];
        if (e["IdAuctions"] == "") {
          v = "";
          t = "Pilih Tanggal";
        }
        return DropdownMenuItem(
          child: Text(t),
          value: v, 
        );
      }).toList(),
      hint: Text('Pilih Tanggal'),
      onChanged: (selected) {
        setState(() {
          _selectedAuction = selected;
        });
      },
      value: _selectedAuction,
      decoration: InputDecoration(
        hintText: 'Pilih Tanggal',
        labelText: 'Tanggal',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(18.0))
      ),
    );

    final noRek = TextFormField(
      controller: _noRek,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        hintText: 'No Rekening Deposit',
        labelText: 'No Rekening Deposit',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(18.0))
      ),
    );

    final type = DropdownButtonFormField(
      items: _dataType.map((e) {
        return DropdownMenuItem(
          child: Text(e.toString()),
          value: e.toString()
        );
      }).toList(),
      value: _selectedType,
      onChanged: (value) {
        setState(() {
          _selectedType = value;
          if (value == 'Motor') {
            _nplAmount = 1000000;
          }
        });
      },
      decoration: InputDecoration(
        hintText: 'Jenis NPL Lelang',
        labelText: 'Jenis NPL Lelang',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(18.0))
      ),
    );

    final totalNpl = TextFormField(
      controller: _totalNpl,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: 'Jumlah NPL',
        labelText: 'Jumlah NPL',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(18.0))
      ),
      onChanged: (text) async {
        if (_selectedType == 'Motor') {
          setState((){
            this._nplAmount = 1000000;
          });
        }
        if (text != '') {
          int val = int.parse(text);
          _totalPayment..text = (val * this._nplAmount).toString();
        }
        else {
          _totalPayment..text = "";
        }
      },
    );

    final totalPayment = TextFormField(
      controller: _totalPayment,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: 'Total Payment',
        labelText: 'Total Payment',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(18.0))
      ),
    );

    final upload = TextFormField(
      controller: _uploadTrans,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        hintText: 'Upload Bukti Transfer',
        labelText: 'Upload Bukti Transfer',
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
              _transImage = file;      
            });
            _uploadTrans..text = fileInfo.name.toString();
          }
      },
    );
    
    final an = TextFormField(
      controller: _an,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          hintText: 'Transfer Atas Nama',
          labelText: 'Transfer Atas Nama',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(18.0))
        ),
    );

    final sumberDana = DropdownButtonFormField(
      items: _dataSumberDana.map((e) {
        return DropdownMenuItem(
          child: Text(e.toString()),
          value: e.toString()
        );
      }).toList(),
      value: _selectedSumberDana,
      onChanged: (value) {
        setState(() {
          _selectedSumberDana = value;
        });
      },
      decoration: InputDecoration(
        hintText: 'Sumber Dana',
        labelText: 'Sumber Dana',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(18.0))
      ),
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
          setState(() {
              _processState = 1;
            });
          
          final delay = 5;

          var param = {
            'auction_id': _selectedAuction.toString(),
            'type': _selectedType.toString(),
            'an': _an.text.toString(),
            'deposit': _totalPayment.text.toString(),
            'qty': _totalNpl.text.toString(),
            'nominal': _nplAmount.toString(),
            'norek': _noRek.text.toString()
          };

          _nplRepo.create(param, _transImage).then((value) {
            bool status = value.getStatus();
            if (status == true) {
              String data = value.getStringData();
              Toast.show(data, context, duration: Toast.LENGTH_LONG , gravity: Toast.BOTTOM);

              Duration _duration = Duration(seconds: delay);
              Timer _timer = Timer(_duration, () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context)=>Npl()));
              });
            }
            else {
              Map errMessage = value.getMessage();
              String msg = errMessage['message'];
              Toast.show(msg, context, duration: Toast.LENGTH_LONG , gravity:  Toast.TOP, backgroundColor: Colors.red);
            }

            setState(() {
              _processState = 0;
            });
          });
        }, 
      );

    return Scaffold(
      appBar: AppBar(
        title: Text(BuyNpl.name),
        backgroundColor: Colors.red,
      ),
      drawer: _menu,
      bottomNavigationBar: _bottomNav,
      body: Container(
        padding: EdgeInsets.all(12.0),
        color: Colors.blueGrey.shade50,
        child: Center(
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(left: 24.0, right: 24.0),
            children: <Widget>[
              SizedBox(height: 10.0),
              auctions,
              SizedBox(height: 8.0),
              totalNpl,
              SizedBox(height: 8.0),
              totalPayment,
              SizedBox(height: 8.0),
              noRek,
              SizedBox(height: 8.0),
              type,
              SizedBox(height: 8.0),
              an,
              SizedBox(height: 8.0),
              sumberDana,
              SizedBox(height: 8.0),
              upload,
              SizedBox(height: 8.0),
              toc,
              SizedBox(height: 8.0),
              button
            ],
          ),
        ),
      )
    );
  }
}