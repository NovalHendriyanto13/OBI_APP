import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class BuyNpl extends StatefulWidget {
  static String tag = 'buy-npl-page';
  static String name = 'Beli NPL';

  @override
  _BuyNplState createState() => _BuyNplState();
}

class _BuyNplState extends State<BuyNpl> {
  
  TextEditingController _auctions = TextEditingController();
  TextEditingController _noRek = TextEditingController();
  TextEditingController _type = TextEditingController();
  TextEditingController _totalNpl = TextEditingController();
  TextEditingController _totalPayment = TextEditingController();
  TextEditingController _an = TextEditingController();

  bool _toc = false;

  @override
  Widget build(BuildContext context) {

    final auctions = TextFormField(
      controller: _auctions,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          hintText: 'Tanggal Lelang',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(18.0))
        ),
    );

    final noRek = TextFormField(
      controller: _noRek,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          hintText: 'No Rekening Deposit',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(18.0))
        ),
    );

    final type = TextFormField(
      controller: _type,
        keyboardType: TextInputType.text,
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
      body: Center(
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
    );
  }
}