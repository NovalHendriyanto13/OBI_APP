import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:obi_mobile/models/m_npl.dart';
import 'package:obi_mobile/models/m_unit.dart';
import 'package:obi_mobile/pages/live_bid.dart';
import 'package:obi_mobile/repository/bid_repo.dart';
import 'package:obi_mobile/repository/npl_repo.dart';

class Bid extends StatelessWidget {
  final Map data;
  final Future<M_Unit> detail;
  int _process = 0;
  String _selectedNpl = '';
  BidRepo _bidRepo = BidRepo();
  NplRepo _nplRepo = NplRepo();
  List _dataNpl = [];

  Bid({this.data, this.detail});

  @override
  Widget build(BuildContext context) {
    TextEditingController _bid = TextEditingController();
print(this.data);
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

    final params = {
      "auction_id": this.data['IdAuctions'],
      "type": "mobil",
    };
    
    final npl = FutureBuilder<M_Npl>(
      future: _nplRepo.activeNpl(params),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List _data = snapshot.data.getListData();
          return  DropdownButtonFormField(
            items: _data.map((e) {
              String v = e["NPL"].toString();
              return DropdownMenuItem(
                child: Text(e["NPL"]),
                value: e["NPL"], 
              );
            }).toList(),
            hint: Text('Pilih NPL'),
            onChanged: (selected) {
                this._selectedNpl = selected;
            },
            decoration: InputDecoration(
              hintText: 'Pilih NPL',
              labelText: 'Pilih NPL',
              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(18.0))
            )
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
    
    final bid = TextFormField(
      controller: _bid,
      keyboardType: TextInputType.number,
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
            String bidPrice = _bid.text.toString();
            final data = {
              "npl": this._selectedNpl,
              "auction_id": this.data['IdAuctions'],
              "unit_id": this.data['IdUnit'],
              "type": "mobil",
              "no_lot": this.data['NoLot'],
              "bid_price" : bidPrice
            };

            _bidRepo.submit(data).then((value) {
              bool status = value.getStatus();
              if (status == true) {
                final msgSuccess = "Unit ini berhasil anda bid";
                Toast.show(msgSuccess, context, duration: Toast.LENGTH_LONG , gravity:  Toast.TOP, backgroundColor: Colors.red);
              }
              else {
                Map errMessage = value.getMessage();
                String msg = errMessage['message'];
                Toast.show(msg, context, duration: Toast.LENGTH_LONG , gravity:  Toast.TOP, backgroundColor: Colors.red);
              }
              print(value.toString());
            });
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
            this._selectedNpl = '';
            _bid..text = '';
          },
          child: Text('Cancel', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          color: Colors.red,
          height: 48.0,
      ),
    );

    Widget bidPage() {
      if (this.data['Online'].toString().trim() == 'floor') {
        return Center(
          child: TextButton(
            child: Text(
              'Ikut Live Auction Sekarang',
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 24.0),
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