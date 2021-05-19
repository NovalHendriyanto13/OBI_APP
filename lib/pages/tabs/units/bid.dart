import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:obi_mobile/models/m_unit.dart';
import 'package:obi_mobile/pages/live_bid.dart';

class Bid extends StatelessWidget {
  final Map data;
  final Future<M_Unit> detail;
  int _process = 0;

  Bid({this.data, this.detail});

  @override
  Widget build(BuildContext context) {
    TextEditingController _npl = TextEditingController();
    TextEditingController _bid = TextEditingController();

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

    Widget bidPage() {
      print(this.data);
      if (this.data['Online'].toString().trim() == 'floor') {
        return Center(
          child: TextButton(
            child: Text(
              'Ikut Live Auction Sekarang',
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => LiveBid(), settings: RouteSettings(arguments: this.data)));
            },
          )
        );
      }
      else {
        return Card(
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
          );
      }
    }

    return ListView(
      padding: EdgeInsets.all(10.0),
      children: [
        carouselSlider,
        Text('Harga Dasar : ' + this.data['HargaLimit'].toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)),
        SizedBox(height: 15.0),
        bidPage()
      ],
    );
  }
}