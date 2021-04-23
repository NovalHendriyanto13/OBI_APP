import 'package:flutter/material.dart';

class Bid extends StatelessWidget {
  final Map data;
  int _process = 0;

  Bid({this.data});

  @override
  Widget build(BuildContext context) {
    TextEditingController _npl = TextEditingController();
    TextEditingController _bid = TextEditingController();

    final npl = TextFormField(
      controller: _npl,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        hintText: 'NPL',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
      ),
    );
    
    final bid = TextFormField(
      controller: _bid,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        hintText: 'Penawaran Anda',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
      ),
    );

    Widget buttonText() {
      if(_process == 1) {
        return CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        );
      }  
      
      return new Text('Submit',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold
        )
      );
    }

    final btnSubmit = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: MaterialButton(
          onPressed: () {
            
          },
          child: buttonText(),
          color: Colors.blue,
          height: 48.0,
      ),
    );

    final btnCancel = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: MaterialButton(
          onPressed: () {
            
          },
          child: Text('Cancel', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          color: Colors.red,
          height: 48.0,
      ),
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Harga Limit : ' + this.data['HargaLimit'].toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)),
        SizedBox(height: 15.0),
        Card(
          child: ListTile(
            title: Text('Auction #' + this.data['IdAuctions'], style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('Closed In : 00 00 00'),
                SizedBox(height: 10.0),
                npl,
                SizedBox(height: 10.0),
                bid,
                SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    btnSubmit,
                    btnCancel
                  ],
                )
              ],
            ),
          )
        )
      ],
    );
  }
}