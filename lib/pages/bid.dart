import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:obi_mobile/libraries/drawer_menu.dart';
import 'package:obi_mobile/libraries/bottom_menu.dart';
import 'package:obi_mobile/libraries/check_internet.dart';
import 'package:obi_mobile/libraries/refresh_token.dart';
import 'package:obi_mobile/models/m_bid.dart';
import 'package:obi_mobile/repository/bid_repo.dart';

class Bid extends StatefulWidget {
  static String tag = 'bid-page';
  static String name = 'My Bid';

  @override
  _BidState createState() => _BidState();
}

class _BidState extends State<Bid> {

  DrawerMenu _drawerMenu = DrawerMenu();
  BottomMenu _bottomMenu = BottomMenu();
  RefreshToken _refreshToken = RefreshToken();
  CheckInternet _checkInternet = CheckInternet();
  BidRepo _bidRepo = BidRepo();

  Future<M_Bid> _dataBid;

  @override
  void initState() {
    super.initState();
    _checkInternet.check(context);
    _refreshToken.run();
    _dataBid = _bidRepo.list();
  }

  @override
  Widget build(BuildContext context) {
    Drawer _menu = _drawerMenu.initialize(context, Bid.tag);
    BottomNavigationBar _bottomNav = _bottomMenu.initialize(context, null);

    final _dataList = FutureBuilder<M_Bid>(
      future: _dataBid,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<dynamic> _data = snapshot.data.getData();
          if (_data.length <= 0) {
            return Center(
              child: Text('No Data Found'),
            );
          }
          else {
            return ListView.builder(
              itemCount: _data.length,
              itemBuilder: (context, index) {
                String _price = _data[index]['HargaTerbentuk'] != null ? NumberFormat.simpleCurrency(locale: 'id', decimalDigits: 0).format(_data[index]['HargaTerbentuk']) : "Rp. 0";
                return Card(
                  child: ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Tanggal Auction:' +_data[index]['TglAuctions'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0)),
                      ]),
                    subtitle: Column(
                      children: [
                        Text('Auction : ' + _data[index]['IdAuctions'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),),
                        SizedBox(height:5.0),
                        Text(_data[index]['Merk'] + ' ' + _data[index]['Tipe'] + ' (' + _data[index]['Tahun'] + ')', style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height:5.0),
                        Align(
                          alignment: Alignment.centerLeft, 
                          child: RichText(
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(text: 'No Lot : ', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                                TextSpan(text: _data[index]['NoLOT'], style: TextStyle(color: Colors.black))
                              ]
                            ),
                          )
                        ),
                        SizedBox(height:5.0),
                        Align(
                          alignment: Alignment.centerLeft, 
                          child: RichText(
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(text: 'No Polisi : ', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                                TextSpan(text: _data[index]['NoPolisi'], style: TextStyle(color: Colors.black))
                              ]
                            ),
                          )
                        ),
                        SizedBox(height:5.0),
                        Align(
                          alignment: Alignment.centerLeft, 
                          child: RichText(
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(text: 'Tanggal Penawaran : ', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                                TextSpan(text: _data[index]['BidTime'], style: TextStyle(color: Colors.black))
                              ]
                            ),
                          )
                        ),
                        SizedBox(height:5.0),
                        Align(
                          alignment: Alignment.centerLeft, 
                          child: RichText(
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(text: 'Harga Penawaran : ', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                                TextSpan(text: NumberFormat.simpleCurrency(locale: 'id', decimalDigits: 0).format(_data[index]['Nominal']), style: TextStyle(color: Colors.black))
                              ]
                            ),
                          )
                        ),
                        SizedBox(height:5.0),
                        Align(
                          alignment: Alignment.centerLeft, 
                          child: RichText(
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(text: 'Tanggal Pemenang : ', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                                TextSpan(text: _data[index]['WinnerTime'], style: TextStyle(color: Colors.black))
                              ]
                            ),
                          )
                        ),
                        SizedBox(height: 5.0),
                        Align(
                          alignment: Alignment.centerLeft, 
                          child: RichText(
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(text: 'Harga Terbentuk : ', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                                TextSpan(text: _price, style: TextStyle(color: Colors.black))
                              ]
                            ),
                          )
                        ),
                        SizedBox(height:5.0),
                        Align(
                          alignment: Alignment.centerRight, 
                          child: RichText(
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(text: 'Status : ', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                                TextSpan(text: _data[index]['statusbidx'], style: TextStyle(color: Colors.red))
                              ]
                            ),
                          )
                        ),
                      ],
                    ),
                  ),
                );
              }
            );
          }
        }
        else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        return Center(child: Text('No Data Found'));
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(Bid.name),
        backgroundColor: Colors.red,
      ),
      drawer: _menu,
      bottomNavigationBar: _bottomNav,
      body: Container(
        padding: EdgeInsets.all(8.0),
        color: Colors.blueGrey.shade50,
        child: Container(
          child: _dataList,
        )
      ),
    );
  }
}