import 'package:flutter/material.dart';
import 'package:obi_mobile/libraries/drawer_menu.dart';
import 'package:obi_mobile/libraries/bottom_menu.dart';
import 'package:obi_mobile/repository/auction_repo.dart';
import 'package:obi_mobile/models/m_auction.dart';
import 'package:obi_mobile/pages/unit.dart';

class AuctionUnit extends StatefulWidget {
  static String tag = 'auction-unit-page';
  static String name = 'Auction Unit';

  @override
  _AuctionUnitState createState() => _AuctionUnitState();
}

class _AuctionUnitState extends State<AuctionUnit> {
  DrawerMenu _drawerMenu = new DrawerMenu();
  BottomMenu _bottomMenu = new BottomMenu();
  AuctionRepo _auctionRepo = new AuctionRepo();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Drawer _menu = _drawerMenu.initialize(context, AuctionUnit.tag);
    BottomNavigationBar _bottomNav = _bottomMenu.initialize(context, AuctionUnit.tag);
    
    final Map param = ModalRoute.of(context).settings.arguments;

    final _dataList = Container(
      child: FutureBuilder<M_Auction>(
        future: _auctionRepo.unit(param),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List _data = snapshot.data.getListData();

            return ListView.builder(
              shrinkWrap: true,
              itemCount: _data.length,
              itemBuilder: (BuildContext context, int index) {
                List _list = _data;
                return GestureDetector( 
                  child : Card(
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      children: [
                        Container(
                          height: 150,
                          padding: EdgeInsets.all(0),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 6,
                                child: Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(_list[index]['image']),
                                      fit: BoxFit.fill
                                    )
                                  ),
                                ),
                              ),
                              Spacer(flex: 1),
                              Expanded(
                                flex: 14,
                                child: Container(
                                  padding: EdgeInsets.all(5.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Auction #' + _list[index]['IdAuctions'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0)),
                                          Text('No Lot : ' + _list[index]['NoLot'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0)),
                                          Text((_list[index]['Merk'] + ' ' + _list[index]['Tipe'] + ' ' + _list[index]['Transmisi']).toString().toUpperCase(), style: TextStyle(fontWeight: FontWeight.bold)),
                                        ]
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(_list[index]['NoPolisi'].toString()),
                                          Text('|'),
                                          Text(_list[index]['Tahun'].toString()),
                                          Text('|'),
                                          Text(_list[index]['Warna'].toString()),
                                        ]
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
                                  )
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 5.0),
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
        title: Text(AuctionUnit.name),
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