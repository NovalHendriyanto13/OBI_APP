import 'package:flutter/material.dart';
import 'package:obi_mobile/libraries/drawer_menu.dart';
import 'package:obi_mobile/libraries/bottom_menu.dart';
import 'package:obi_mobile/models/m_auction.dart';
import 'package:obi_mobile/pages/unit.dart';
import 'package:obi_mobile/repository/auction_repo.dart';
import 'package:obi_mobile/pages/home.dart';

class AuctionDetail extends StatefulWidget {
  static String tag = 'auction-detail-page';
  static String name = 'Auction Detail';

  @override 
  _AuctionDetailState createState() => _AuctionDetailState();
}

class _AuctionDetailState extends State<AuctionDetail> {

  DrawerMenu _drawerMenu = new DrawerMenu();
  BottomMenu _bottomMenu = new BottomMenu();
  AuctionRepo _auctionRepo = AuctionRepo();
  
  @override
  void initState() {
    super.initState(); 
  }

  @override
  Widget build(BuildContext context) {

    Drawer _menu = _drawerMenu.initialize(context, AuctionDetail.tag);
    BottomNavigationBar _bottomNav = _bottomMenu.initialize(context, Home.tag);
    
    final Map param = ModalRoute.of(context).settings.arguments;
    String id = param["IdAuctions"];

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
                return GestureDetector( 
                  child : Card(
                    child: Column(
                      children: [
                        ListTile(
                          leading: ConstrainedBox(
                            constraints: BoxConstraints(
                              minWidth: 80,
                              minHeight: 80,
                              maxWidth: 100,
                              maxHeight: 100,
                            ),
                            child: Image.network(_list[index]['image'], fit: BoxFit.cover,),
                          ),
                          title: Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('No Lot : ' + _list[index]['NoLot'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0)),
                                Text(_list[index]['Merk'] + ' ' + _list[index]['Tipe'] + ' ' + _list[index]['Transmisi'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0)),
                              ],),
                          ),
                          subtitle: Column(
                            // mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(_list[index]['NoPolisi']),
                                    Text('|'),
                                    Text(_list[index]['Tahun']),
                                    Text('|'),
                                    Text(_list[index]['Warna'])
                                  ]
                                )
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Eks : ' + _list[index]['GradeExterior']),
                                  Text('Int : ' + _list[index]['GradeInterior']),
                                  Text('Msn : ' + _list[index]['GradeMesin'])
                                ]
                              ),
                              Align(alignment: Alignment.centerLeft, child: Text('STNK : ' + _list[index]['TglBerlakuSTNK'].toString())),
                              Align(alignment: Alignment.centerLeft, child: Text('PAJAK : ' + _list[index]['TglBerlakuPajak'].toString())),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                          Padding(
                            padding: EdgeInsets.only(left: 12.0, bottom: 10.0),
                            child: Align(alignment: Alignment.centerLeft, child: Text('Harga : ' + _list[index]['HargaLimit'].toString(), style: TextStyle(fontWeight: FontWeight.bold)))
                        ),
                          Padding(
                            padding: EdgeInsets.only(right: 12.0, bottom: 10.0),
                            child: Align(alignment: Alignment.centerLeft, child: Text('DETAIL', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue.shade300)))
                          )
                        ])

                      ]
                    ),
                  ),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Unit(), settings: RouteSettings(arguments: _list[index])));
                  },
              );
            });
          }
          else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }

          return Center(
            child: CircularProgressIndicator()
          );
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
      bottomNavigationBar: _bottomNav,
      body: Container(
        padding: EdgeInsets.all(12.0),
        color: Colors.blueGrey.shade50,
        child: _dataList,
      ),
    );
  }
}