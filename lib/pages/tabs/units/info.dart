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

    return ListView(
      padding: EdgeInsets.all(10.0),
      children: [
        carouselSlider,
        Text('Harga Dasar : ' + NumberFormat.simpleCurrency(locale: 'id').format(this.data['HargaLimit']), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)),
        SizedBox(height: 15.0),
        Text('LOT : ' + this.data['NoLot'], style: TextStyle(fontWeight: FontWeight.bold)) ,
        SizedBox(height: 8.0),
        Text(this.data['Merk'] + ' ' + this.data['Tipe'] + ' ' + this.data['Transmisi'], style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 8.0),
        Text(this.data['NoPolisi']),
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