import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:obi_mobile/libraries/drawer_menu.dart';
import 'package:obi_mobile/libraries/bottom_menu.dart';
import 'package:obi_mobile/libraries/refresh_token.dart';
import 'package:obi_mobile/libraries/check_internet.dart';
import 'package:obi_mobile/libraries/search_bar.dart';
import 'package:obi_mobile/models/m_auction.dart';
import 'package:obi_mobile/pages/auction_detail.dart';
import 'package:obi_mobile/pages/live_bid.dart';
import 'package:obi_mobile/repository/auction_repo.dart';

class Room extends StatefulWidget {
  static String tag = 'ongoing-page';
  static String name = 'Ruang Lelang';

  @override
  _RoomState createState() => _RoomState();
}

class _RoomState extends State<Room> with SingleTickerProviderStateMixin{
  DrawerMenu _drawerMenu = DrawerMenu();
  BottomMenu _bottomMenu = BottomMenu();
  RefreshToken _refreshToken = RefreshToken();
  CheckInternet _checkInternet = CheckInternet();
  AuctionRepo _auctionRepo = AuctionRepo();

  Future<M_Auction> _dataList;
  AnimationController _liveAnimation;
  AnimationController _submitAnimation;

  final delay = 1;
  final _now = DateTime.now();
  
  @override
  void initState() {
    super.initState();

    _checkInternet.check(context);
    _refreshToken.run();
    _dataList = _auctionRepo.nowNext();
    _liveAnimation = AnimationController(vsync: this, duration: Duration(seconds: delay));
    _liveAnimation.repeat(reverse: true);
  }

  @override
  void dispose() {
    _liveAnimation.dispose();
    _submitAnimation.dispose();
    super.dispose();
  }

  Widget _blinkInfo(data) {
    String textInfo = 'SUBMIT BID';
    Color color = Colors.orange;
    if (data['Online'].toString().toLowerCase() == 'floor') {
      textInfo = 'LIVE BID';
      color = Colors.green;
    }
    return FadeTransition(
        opacity: _liveAnimation,
        child: Material(child: Text(textInfo), color: color, textStyle: TextStyle(fontWeight: FontWeight.bold),),
      );
  }

  void navigatorAuction(data) {
    if (data['Online'].toString().toLowerCase() == 'floor') {
      Navigator.push(context, MaterialPageRoute(builder: (context) => AuctionDetail(), settings: RouteSettings(arguments: data)));
    }
    else {
      Navigator.push(context, MaterialPageRoute(builder: (context) => AuctionDetail(), settings: RouteSettings(arguments: data)));
    }
  }

  @override
  Widget build(BuildContext context) {
    SearchBar _searchBar = new SearchBar(context, true, true);
    Drawer _menu = _drawerMenu.initialize(context, Room.tag);
    BottomNavigationBar _bottomNav = _bottomMenu.initialize(context, Room.tag);

    final _listNow = Expanded(
      child: FutureBuilder<M_Auction>(
        future: _dataList,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List _now = snapshot.data.getListData();
            if (_now == null) {
              return Center(child: Text('Could not connect API'));
            }
            if (_now[0]['now'].length <= 0) {
              return Center(child: Text('No Data Found'));
            }
            else {
              return ListView.builder(
                itemCount: _now[0]['now'].length,
                itemBuilder: (BuildContext context, int index) {
                  List data = _now[0]['now'];
                  final dateNow = data[index]['TglAuctions'] + ' ' + data[index]['StartTime'];
                  return GestureDetector(
                    child: Card(
                      child: ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:[
                            Text((data[index]['Kota']).toString().toUpperCase()),
                            _blinkInfo(data[index])
                          ]
                        ),
                        subtitle: Text(dateNow),
                        trailing: Icon(Icons.more_vert),
                      ),
                    ),
                    onTap: () {
                      navigatorAuction(data[index]);
                    },
                  );
                }
              );
            }
          }
          else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          return Center(child: Text('No Data Found'));
        }
      )
    );

    final _listNext = Expanded(
      child: FutureBuilder<M_Auction>(
        future: _dataList,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List _next = snapshot.data.getListData();
            if (_next == null) {
              return Center(child: Text('Could not connect API'));
            }
            if (_next[0]['next'].length <= 0) {
              return Center(child: Text('No Data Found'));
            }
              else {
              return ListView.builder(
                itemCount: _next[0]['next'].length,
                itemBuilder: (BuildContext context, int index) {
                  List data = _next[0]['next'];
                  final dateNext = data[index]['TglAuctions'] + ' ' + data[index]['StartTime'];
                  return GestureDetector(
                    child: Card(
                      child: ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:[
                            Text((data[index]['Kota']).toString().toUpperCase()),
                            _blinkInfo(data[index])
                          ]
                        ),
                        subtitle: Text(dateNext),
                        trailing: Icon(Icons.more_vert),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => AuctionDetail(), settings: RouteSettings(arguments: data[index])));
                    },
                  );
                }
              );
            }
          }
          else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          return Center(child: Text('No Data Found'));
        }
      )
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(Room.name),
        backgroundColor: Colors.red,
        actions: _searchBar.build(),
      ),
      drawer: _menu,
      bottomNavigationBar: _bottomNav,
      body: Container(
        padding: EdgeInsets.all(12.0),
        color: Colors.blueGrey.shade50,
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Berlangsung', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)),
            _listNow,
            SizedBox(height: 10.0),
            Text('Akan Datang', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)),
            _listNext,
          ],
        ),
      ),
    );
  }
}