import 'package:flutter_countdown_timer/index.dart';
import 'package:intl/intl.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:obi_mobile/models/m_bid.dart';
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
  String _strOpen = 'Open In ';
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
      _strOpen = 'Closed In ';
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
            FocusScope.of(context).unfocus();
            String bidPrice = _bid.text.toString();
            if (this.expiredBid) {
              String expireMsg = 'Auction Sudah di tutup';
              if (this.data['Status'].toString() == '1') {
                expireMsg = 'Auction Sudah di tutup, Silakan Hubungi Customer Service Kami Untuk Info Unit ini';
              }
              else if (this.data['Status'].toString() == '2') {
                expireMsg = 'Auction Sudah di tutup, Unit ini sudah terjual';
              }
              Toast.show(expireMsg, context, duration: Toast.LENGTH_LONG , gravity:  Toast.BOTTOM, backgroundColor: Colors.orange);
            }
            else {
              if (this.data['Status'].toString() == '2') {
                final expireMsg = 'Unit ini sudah terjual';
                Toast.show(expireMsg, context, duration: Toast.LENGTH_LONG , gravity:  Toast.BOTTOM, backgroundColor: Colors.orange);
              }
              else {
                if (_usedNpl.contains(this._selectedNpl)) {
                  String usedMsg = 'NPL sudah terpakai';
                  Toast.show(usedMsg, context, duration: Toast.LENGTH_LONG , gravity:  Toast.BOTTOM, backgroundColor: Colors.orange);
                }
                else if (bidPrice == '') {
                  Toast.show("Nominal Bid Harus Diisi", context, duration: Toast.LENGTH_LONG , gravity:  Toast.BOTTOM, backgroundColor: Colors.orange);
                }
                else {
                  _lastPrice = NumberFormat.simpleCurrency(locale: 'id', decimalDigits: 0).format(int.parse(bidPrice));
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
                    
                    _usedNpl.add(this._selectedNpl);
                    Toast.show(msgSuccess, context, duration: Toast.LENGTH_LONG , gravity:  Toast.BOTTOM, backgroundColor: Colors.green);
                  }
                  else {
                    Map errMessage = biding.getMessage();
                    String msg = errMessage['message'];
                    Toast.show(msg, context, duration: Toast.LENGTH_LONG , gravity:  Toast.BOTTOM, backgroundColor: Colors.orange);
                  }
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
          onPressed: () async{
            this._selectedNpl = '';
            _bid..text = '';

            _lastPrice = 'Rp. 0';

            final paramCancel = {
              "auction_id": this.data['IdAuctions'],
              "unit_id": this.data['IdUnit'],
              "no_lot": this.data['NoLot']
            };

            await _bidRepo.deleteBid(paramCancel);
            Toast.show('Unit ini telah anda cancel', context, duration: Toast.LENGTH_LONG , gravity:  Toast.BOTTOM, backgroundColor: Colors.green);
          },
          child: Text('Cancel', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          color: Colors.red,
          height: 48.0,
      ),
    );

    int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * diffEnd;
    int startTime = DateTime.now().millisecondsSinceEpoch + 1000 * diffStart;
    void onEnd() {
      this.expiredBid = true;
    }
    Widget bidPage(){
      if (this.data['Online'].toString().trim() == 'floor') {
        this.expiredBid = false;
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children:[
              Text('Lelang Akan dimulai pada',
                style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 24.0),
              ),
              CountdownTimer(
                endTime: startTime,
                onEnd: onEnd,
                textStyle: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
                widgetBuilder: (_, CurrentRemainingTime time) {
                  if (time != null) {
                    String days = time.days != null ? time.days.toString() + ' Days, ' : '';
                    String hours = time.hours != null ? time.hours.toString(): '00';
                    String min = time.min != null ? time.min.toString(): '00';
                    String sec = time.sec != null ? time.sec.toString(): '00';
                    return Text(_strOpen + days + hours + ':' + min + ':' + sec);
                  } else {
                    return Text('Auction Sedang Berlangsung');
                  }
                },
              ),
              TextButton(
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
                  this.data['IdUnit'] = '0';
                  this.data['r_TglAuctions'] = this.data['TglAuctions'];
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LiveBid(this.data)));
                },
              ),     
            ],
          )
        );
      }
      else {
        final _lastBid = _bidRepo.lastUserBid({
          "auction_id": this.data['IdAuctions'],
          "unit_id": this.data['IdUnit'],
        });
        return FutureBuilder<M_Bid>(
          future: _lastBid,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List _dataLastBid = snapshot.data.getData();
              _lastPrice = _dataLastBid.length > 0 ? NumberFormat.simpleCurrency(locale: 'id', decimalDigits: 0).format(_dataLastBid[0]['Nominal']) : "Rp. 0,00";
              return Card(
                child: ListTile(
                  title: Text('Auction #' + this.data['IdAuctions'], style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CountdownTimer(
                        endTime: endTime,
                        onEnd: onEnd,
                        widgetBuilder: (_, CurrentRemainingTime time) {
                          if (time != null) {
                            String days = time.days != null ? time.days.toString() + ' Days, ' : '';
                            String hours = time.hours != null ? time.hours.toString(): '00';
                            String min = time.min != null ? time.min.toString(): '00';
                            String sec = time.sec != null ? time.sec.toString(): '00';
                            return Text(_strOpen + days + hours + ':' + min + ':' + sec);
                          } else {
                            return Text('Auction sudah di tutup');
                          }
                        },
                      ),
                      SizedBox(height: 10.0),
                      Text('Harga Penawaran: ' + _lastPrice),
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
            else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          }); 
      }
    }

    final isSold = this.data['Status'] == 2 ? '( SOLD )' : '';
    return ListView(
      padding: EdgeInsets.all(10.0),
      children: [
        carouselSlider,
        Row(
          children: [
            Expanded(child: Text('Harga Dasar : ' + NumberFormat.simpleCurrency(locale: 'id', decimalDigits: 0).format(this.data['HargaLimit']), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0))),
            Text(isSold,style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0, color: Colors.red)),
          ],
        ),
        SizedBox(height: 15.0),
        bidPage()
      ],
    );
  }
}