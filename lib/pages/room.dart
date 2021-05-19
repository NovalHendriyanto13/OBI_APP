import 'package:flutter/material.dart';
import 'package:obi_mobile/libraries/drawer_menu.dart';
import 'package:obi_mobile/libraries/bottom_menu.dart';
import 'package:obi_mobile/libraries/refresh_token.dart';
import 'package:obi_mobile/libraries/check_internet.dart';
import 'package:obi_mobile/libraries/search_bar.dart';
import 'package:obi_mobile/models/m_auction.dart';
import 'package:obi_mobile/pages/auction_detail.dart';
import 'package:obi_mobile/repository/auction_repo.dart';

class Room extends StatefulWidget {
  static String tag = 'ongoing-page';
  static String name = 'Ruang Lelang';

  @override
  _RoomState createState() => _RoomState();
}

class _RoomState extends State<Room> {
  DrawerMenu _drawerMenu = DrawerMenu();
  BottomMenu _bottomMenu = BottomMenu();
  RefreshToken _refreshToken = RefreshToken();
  CheckInternet _checkInternet = CheckInternet();
  AuctionRepo _auctionRepo = AuctionRepo();

  Future<M_Auction> _dataList;
  
  @override
  void initState() {
    super.initState();

    _checkInternet.check(context);

    _refreshToken.run();

    _dataList = _auctionRepo.nowNext();
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
            if (_now[0]['now'].length <= 0) {
              return Center(child: Text('No Data Found'));
            }
            else {
              return ListView.builder(
                itemCount: _now[0]['now'].length,
                itemBuilder: (BuildContext context, int index) {
                  List data = _now[0]['now'];
                  return GestureDetector(
                    child: Card(
                      child: ListTile(
                        title: Text((data[index]['Kota']).toString().toUpperCase()),
                        subtitle: Text(data[index]['TglAuctions']),
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

    final _listNext = Expanded(
      child: FutureBuilder<M_Auction>(
        future: _dataList,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List _next = snapshot.data.getListData();
            if (_next[0]['next'].length <= 0) {
              return Center(child: Text('No Data Found'));
            }
              else {
              return ListView.builder(
                itemCount: _next[0]['next'].length,
                itemBuilder: (BuildContext context, int index) {
                  List data = _next[0]['next'];
                  return GestureDetector(
                    child: Card(
                      child: ListTile(
                        title: Text(data[index]['Kota']),
                        subtitle: Text(data[index]['TglAuctions']),
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
          return Center(child: Text('No Data Displayed'));
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