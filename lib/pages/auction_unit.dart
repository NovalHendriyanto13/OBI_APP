import 'package:flutter/material.dart';
import 'package:obi_mobile/libraries/drawer_menu.dart';
import 'package:obi_mobile/libraries/bottom_menu.dart';
import 'package:obi_mobile/repository/auction_repo.dart';
import 'package:obi_mobile/models/m_auction.dart';

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

    final _dataList = Expanded(
      child: FutureBuilder<M_Auction>(
        future: _auctionRepo.unit(param),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List _data = snapshot.data.getListData();

            return ListView.builder(
              itemCount: _data[0]['detail'].length,
              itemBuilder: (BuildContext context, int index) {
                List _list = _data[0]['detail'];
                return Card(
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(_list[index]['NoPolisi']),
                                Text('|'),
                                Text(_list[index]['Tahun']),
                                Text('|'),
                                Text(_list[index]['Warna'])
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
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 12.0, bottom: 10.0),
                        child: Align(alignment: Alignment.centerLeft, child: Text('Harga : ' + _list[index]['HargaLimit'].toString(), style: TextStyle(fontWeight: FontWeight.bold)))
                      )
                    ]
                  )
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
        color: Colors.grey.shade50,
        child: _dataList,
      ),
    );
  }
}