import 'package:flutter/material.dart';
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
                return Card(
                  child: ListTile(
                    title: Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_data[index]['TglAuctions'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0)),
                        ],),
                    ),
                    subtitle: Column(
                      children: [
                        SizedBox(height:8.0),
                        Align(alignment: Alignment.centerLeft, child: Text('Auction : ' + _data[index]['IdAuctions'] )),
                        SizedBox(height:8.0),
                        Align(alignment: Alignment.centerLeft, child: Text('Lot : ' + _data[index]['NoLOT'] )),
                        SizedBox(height:8.0),
                        Align(alignment: Alignment.centerLeft, child: Text('No Polisi : ' + _data[index]['NoPolisi'] )),
                        SizedBox(height:8.0),
                        Align(alignment: Alignment.centerLeft, child: Text('Status : ' + _data[index]['statusbidx'] )),
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
        return Center(
          child: CircularProgressIndicator(),
        );
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