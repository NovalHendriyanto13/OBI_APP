import 'package:intl/intl.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
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
  String _lastPrice = '0';
  bool expiredBid = true;
  List<String> _usedNpl = []; 
  
  Bid({this.data, this.detail});

  @override
  Widget build(BuildContext context) {
    TextEditingController _bid = TextEditingController();
    final _now = DateTime.now();
    final _nowDt = DateFormat('yyyy-MM-dd HH:mm').format(_now);
    String _auctionDateTime = this.data['TglAuctions'] + ' ' + this.data['EndTime'];
    String _auctionStartTime = this.data['TglAuctions'] + ' ' + this.data['StartTime'];
    final _d1 = DateTime.parse(_nowDt);
    final _auctionEndDate = DateTime.parse(_auctionDateTime);
    final _auctionStartDate = DateTime.parse(_auctionStartTime);
    final diffEnd = _auctionEndDate.difference(_d1).inSeconds;
    final diffStart = _auctionStartDate.difference(_d1).inSeconds;
    //open auction
    if (diffStart <= 0 && diffEnd > 0) {
      this.expiredBid = false;
    }

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
      "type": this.data['Jenis'],
    };
    

    Widget npl = FutureBuilder<M_Npl>(
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
          onPressed: () async {
            if (this.expiredBid) {
              String expireMsg = 'Auction Sudah di tutup';
              if (this.data['Status'].toString() == '1') {
                expireMsg = 'Auction Sudah di tutup, Silakan Hubungi Customer Service Kami Untuk Info Unit ini';
              }
              else if (this.data['Status'].toString() == '2') {
                expireMsg = 'Auction Sudah di tutup, Unit ini sudah terjual';
              }
              Toast.show(expireMsg, context, duration: Toast.LENGTH_LONG , gravity:  Toast.BOTTOM, backgroundColor: Colors.red);
            }
            else {
              FocusScope.of(context).unfocus();
              if (_usedNpl.contains(this._selectedNpl)) {
                String usedMsg = 'NPL sudah terpakai';
                Toast.show(usedMsg, context, duration: Toast.LENGTH_LONG , gravity:  Toast.BOTTOM, backgroundColor: Colors.red);
              }
              else {
                String bidPrice = _bid.text.toString();
                final data = {
                  "npl": this._selectedNpl,
                  "auction_id": this.data['IdAuctions'],
                  "unit_id": this.data['IdUnit'],
                  "type": this.data['Jenis'],
                  "no_lot": this.data['NoLot'],
                  "bid_price" : bidPrice
                };

                final biding = await _bidRepo.submit(data);
                bool statusBid = biding.getStatus();
                if (statusBid == true) {
                  final msgSuccess = "Unit ini berhasil anda bid";
                  _lastPrice = bidPrice.toString();
                  _usedNpl.add(this._selectedNpl);
                  Toast.show(msgSuccess, context, duration: Toast.LENGTH_LONG , gravity:  Toast.BOTTOM, backgroundColor: Colors.green);
                }
                else {
                  Map errMessage = biding.getMessage();
                  String msg = errMessage['message'];
                  Toast.show(msg, context, duration: Toast.LENGTH_LONG , gravity:  Toast.BOTTOM, backgroundColor: Colors.red);
                }
              }
            }
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

    join() {
      return TextButton(
        child: Text(
          'Ikut Live Auction Sekarang', 
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
        onPressed: () {
          if (this.expiredBid) {
            String expireMsg = 'Auction Belum Di Buka';
            Toast.show(expireMsg, context, duration: Toast.LENGTH_LONG , gravity:  Toast.BOTTOM, backgroundColor: Colors.red);
          }
          else {
            Navigator.push(context, MaterialPageRoute(builder: (context) => LiveBid(), settings: RouteSettings(arguments: this.data)));
          }
        },
      );
    }

    int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * diffEnd;
    void onEnd() {
      this.expiredBid = true;
    }
    Widget bidPage() {
      if (this.data['Online'].toString().trim() == 'floor') {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children:[
              Text('Lelang Akan dimulai pada',
                style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 24.0),
              ),
              CountdownTimer(
                endTime: endTime,
                onEnd: onEnd,
                textStyle: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
              ),
              join(),           
            ],
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
                  CountdownTimer(endTime: endTime),
                  SizedBox(height: 10.0),
                  Text('Harga Penawaran: Rp.' + _lastPrice),
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
        Text('Harga Dasar : ' + NumberFormat.simpleCurrency(locale: 'id').format(this.data['HargaLimit']), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)),
        SizedBox(height: 15.0),
        bidPage()
      ],
    );
  }
}