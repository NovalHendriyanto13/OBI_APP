import 'package:flutter/material.dart';

class Info extends StatelessWidget {
  final Map data;

  Info({this.data});
  
  @override
  Widget build(BuildContext context) {

    return ListView(
      padding: EdgeInsets.all(10.0),
      children: [
        Text('Harga Limit : ' + this.data['HargaLimit'].toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)),
        SizedBox(height: 15.0),
        Text('LOT : ' + this.data['NoLot'], style: TextStyle(fontWeight: FontWeight.bold)) ,
        SizedBox(height: 8.0),
        Text(this.data['Merk'] + ' ' + this.data['Tipe'] + ' ' + this.data['Transmisi'], style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 8.0),
        Row(
          children: [
            Text('Eks : ' + this.data['GradeExterior']),
            Text(' | '),
            Text('Int : ' + this.data['GradeInterior']),
            Text(' | '),
            Text('Msn :' + this.data['GradeMesin'])
          ],
        ),
        SizedBox(height: 8.0),
        Text('Kilometer : '),
        SizedBox(height: 8.0),
        Text('No Rangka : '),
        SizedBox(height: 8.0),
        Text('No Mesin : '),
        SizedBox(height: 8.0),
        Text('STNK : ' + this.data['TglBerlakuSTNK'].toString()),
        SizedBox(height: 8.0),
        Text('Nota Pajak : ' + this.data['TglBerlakuPajak'].toString()),
        SizedBox(height: 8.0),
        Text('BPKB : '),
        SizedBox(height: 8.0),
        Text('info : '),
        SizedBox(height: 8.0),
      ],
    );
  }
}