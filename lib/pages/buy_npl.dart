import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:obi_mobile/models/m_auction.dart';
import 'package:obi_mobile/repository/auction_repo.dart';
import 'package:obi_mobile/libraries/bottom_menu.dart';
import 'package:obi_mobile/libraries/drawer_menu.dart';

class BuyNpl extends StatefulWidget {
  static String tag = 'buy-npl-page';
  static String name = 'Beli NPL';

  @override
  _BuyNplState createState() => _BuyNplState();
}

class _BuyNplState extends State<BuyNpl> {
  
  // repo and model
  AuctionRepo _auctionRepo = new AuctionRepo();
  BottomMenu _bottomMenu = new BottomMenu();
  DrawerMenu _drawerMenu = new DrawerMenu();

  // controller
  TextEditingController _auctions = TextEditingController();
  TextEditingController _noRek = TextEditingController();
  TextEditingController _type = TextEditingController();
  TextEditingController _totalNpl = TextEditingController();
  TextEditingController _totalPayment = TextEditingController();
  TextEditingController _an = TextEditingController();
  
  // variable
  List _dataAuction;
  List<String> _dataType = <String>['Mobil','Motor','Alat Berat','Barang Inventaris'];
  String _selectedType = 'Mobil'; 
  String _selectedAuction = "";
  bool _toc = false;

  @override
  void initState() {
    super.initState();

    // _loadData();
  }

  _loadData() async {
    _auctionRepo.list().then((value) {
      // print('asdsadasda');
      // setState(() {
      //   _dataAuction = value.getListData();
      // });
    });
  }

  @override
  Widget build(BuildContext context) {

    BottomNavigationBar _bottomNav = _bottomMenu.initialize(context, BuyNpl.tag);
    Drawer _menu = _drawerMenu.initialize(context, BuyNpl.tag);

    final auctions = TextFormField(
      controller: _auctions,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          hintText: 'Tanggal Lelang',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(18.0))
        ),
    );
    // 
    // final auctions = DropdownButtonFormField(
    //   items: _dataAuction.map((e) {
    //     return DropdownMenuItem(
    //       child: Text(e["Kota"] + ', ' + Text(e['TglAuctions'])),
    //       value: e['IdAuctions'], 
    //     );
    //   }).toList(),
    //   hint: Text('Pilih Tanggal'),
    //   // onChanged: (selected) {
    //   //   setState(() {
    //   //     _selectedBrand = selected;
    //   //   });
    //   // },
    //   // value: _selectedBrand,
    // );

    final noRek = TextFormField(
      controller: _noRek,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        hintText: 'No Rekening Deposit',
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
        });
      },
      decoration: InputDecoration(
        hintText: 'Jenis NPL Lelang',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(18.0))
      ),
    );

    final totalNpl = TextFormField(
      controller: _totalNpl,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          hintText: 'Jumlah NPL',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(18.0))
        ),
    );

    final totalPayment = TextFormField(
      controller: _totalPayment,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          hintText: 'Total Payment',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(18.0))
        ),
    );

    // final upload = TextFormField(
    //   controller: _auctions,
    //     keyboardType: TextInputType.text,
    //     decoration: InputDecoration(
    //       hintText: 'Tanggal Lelang',
    //       contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
    //       border: OutlineInputBorder(borderRadius: BorderRadius.circular(18.0))
    //     ),
    // );
    // 
    final an = TextFormField(
      controller: _an,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          hintText: 'Transfer Atas Nama',
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
        child: Text('Beli NPL', 
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
        onPressed: () => {

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
              noRek,
              SizedBox(height: 8.0),
              type,
              SizedBox(height: 8.0),
              totalNpl,
              SizedBox(height: 8.0),
              totalPayment,
              SizedBox(height: 8.0),
              an,
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