import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:obi_mobile/models/m_unit.dart';

class Info extends StatelessWidget {
  final Map data;
  final Future<M_Unit> detail;

  Info({this.data, this.detail});
  
  @override
  Widget build(BuildContext context) {
    final carouselSlider = FutureBuilder<M_Unit>(
      future: this.detail,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List _data = snapshot.data.getListData();
          return CarouselSlider(
            items: _data[0]['galleries'].map<Widget>((i) {
              return Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(i['Image']),
                      fit: BoxFit.fill
                    )
                  )
                );
            }).toList(),
            options: CarouselOptions(
              height: 300,
              aspectRatio: 16/9,
              viewportFraction: 0.8,
              initialPage: 0,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 3),
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: true,
              scrollDirection: Axis.horizontal,
            ),
          );
        }
        else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      }
    );

    final isSold = this.data['Status'] == 2 ? '( SOLD )' : '';
    final String stnk = null != this.data['TglBerlakuSTNK'] ? this.data['TglBerlakuSTNK'].toString() : 'T/A';
    final String pajak = null != this.data['TglBerlakuPajak'] ? this.data['TglBerlakuPajak'].toString() : 'T/A';
    return ListView(
      padding: EdgeInsets.all(10.0),
      children: [
        carouselSlider,
        Row(
          children: [
            Expanded(child: Text('Harga Dasar : ' + NumberFormat.simpleCurrency(locale: 'id', decimalDigits: 0).format(this.data['HargaLimit']), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0))),
            Text(isSold,style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0, color: Colors.red)),
          ],
        ),
        SizedBox(height: 15.0),
        Text('LOT : ' + this.data['NoLot'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)) ,
        SizedBox(height: 8.0),
        Text(this.data['Merk'].toString().toUpperCase() + ' ' + this.data['Tipe'] + ' ' + this.data['Transmisi'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0)),
        SizedBox(height: 8.0),
        Text('NO Polisi: ' + this.data['NoPolisi']),
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
        Text('Kilometer : ' + this.data['Kilometer'].toString(), style: TextStyle(fontSize: 15.0)),
        SizedBox(height: 8.0),
        Text('Transmisi : ' + this.data['Transmisi'], style: TextStyle(fontSize: 15.0)),
        SizedBox(height: 8.0),
        Text('Tahun : ' + this.data['Tahun'], style: TextStyle(fontSize: 15.0)),
        SizedBox(height: 8.0),
        Text('STNK : ' + stnk, style: TextStyle(fontSize: 15.0)),
        SizedBox(height: 8.0),
        Text('Nota Pajak : ' + pajak, style: TextStyle(fontSize: 15.0)),
        SizedBox(height: 8.0),
      ],
    );
  }
}