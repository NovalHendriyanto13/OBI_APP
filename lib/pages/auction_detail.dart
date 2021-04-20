import 'package:flutter/material.dart';
import 'package:obi_mobile/libraries/drawer_menu.dart';
import 'package:obi_mobile/models/m_auction.dart';
import 'package:obi_mobile/repository/auction_repo.dart';

class AuctionDetail extends StatefulWidget {
  static String tag = 'auction-detail-page';
  static String name = 'Auction Detail';

  @override 
  _AuctionDetailState createState() => _AuctionDetailState();
}

class _AuctionDetailState extends State<AuctionDetail> {

  DrawerMenu _drawerMenu = new DrawerMenu();
  AuctionRepo _auctionRepo = AuctionRepo();
  
  @override
  void initState() {
    super.initState(); 
  }

  @override
  Widget build(BuildContext context) {

    Drawer _menu = _drawerMenu.initialize(context, AuctionDetail.tag);
    
    final Map param = ModalRoute.of(context).settings.arguments;
    String id = param["IdAuctions"];

    Widget _detailColumn(List _list, int index) {
      final logo = Hero(
        tag: 'otobid_logo', 
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 48.0,
          child: Image.asset('assets/images/logo.png'),
        ) 
      );
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          logo,
          Column(
            children: [
              Text('No Lot : ' + _list[index]['NoLot']),
              Text(_list[index]['NoPolisi'])
            ],
          )
        ],
      );
    }

    final _dataList = Expanded(
      child: FutureBuilder<M_Auction>(
        future: _auctionRepo.detail(id),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List _data = snapshot.data.getListData();

            return ListView.builder(
              itemCount: _data[0]['detail'].length,
              itemBuilder: (BuildContext context, int index) {
                List _list = _data[0]['detail'];
                return Container(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _detailColumn(_list, index),
                      Text('Harga Dasar : xxxx'),
                    ]
                  ),
                );
            });
          }
          else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }

          return CircularProgressIndicator();
        }
      )
    );

    return Scaffold(
      appBar: AppBar(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(param["Kota"], style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            Text(param["TglAuctions"], style: TextStyle(fontSize: 10.0))
          ],
        ),
        backgroundColor: Colors.red,
      ),
      drawer: _menu,
      body: Container(
        color: Colors.grey.shade50,
        child: _dataList,
      ),
    );
  }
}