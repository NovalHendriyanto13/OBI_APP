import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:obi_mobile/libraries/drawer_menu.dart';
import 'package:obi_mobile/libraries/bottom_menu.dart';
import 'package:obi_mobile/libraries/check_internet.dart';
import 'package:obi_mobile/models/m_npl.dart';
import 'package:obi_mobile/pages/buy_npl.dart';
import 'package:obi_mobile/repository/npl_repo.dart';

class Npl extends StatefulWidget {
  static String tag = 'npl-page';
  static String name = 'My NPL';

  @override
  _NplState createState() => _NplState();
}

class _NplState extends State<Npl> {
  DrawerMenu _drawerMenu = DrawerMenu();
  BottomMenu _bottomMenu = BottomMenu();
  CheckInternet _checkInternet = CheckInternet();
  NplRepo _nplRepo = NplRepo();
  Future<M_Npl> _dataNpl;

  @override
  void initState() {
    super.initState();

    _checkInternet.check(context);
    
    _dataNpl = _nplRepo.list();
  }

  @override
  Widget build(BuildContext context) {

    Drawer _menu = _drawerMenu.initialize(context, Npl.tag);
    BottomNavigationBar _bottomNav = _bottomMenu.initialize(context, null);

    Widget getNoLot(data) {
      if (data['unit'] != null) {
        return RichText(
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(text: 'No Lot : ', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                TextSpan(text: data['NoLot'], style: TextStyle(color: Colors.black))
              ]
            ),
          );
      }
      return Text('');
    }

    Widget getUnit(data) {
      if (data['unit'] != null) {
        return RichText(
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(text: 'Unit : ', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                TextSpan(text: data['unit'][0]['Merk']+ ' ' +data['unit'][0]['Tipe'], style: TextStyle(color: Colors.black))
              ]
            ),
          );
      }
      return Text('');
    }

    Widget getNominal(data) {
      if (data['unit'] != null) {
        String _price = data['unit'][0]['Nominal'] != null ? NumberFormat.simpleCurrency(locale: 'id', decimalDigits: 0).format(data['unit'][0]['Nominal']) : "";
        return RichText(
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(text: 'Harga : ', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                TextSpan(text: _price, style: TextStyle(color: Colors.black))
              ]
            ),
          );
      }
      return Text('');
    }

    final _dataList = FutureBuilder<M_Npl>(
      future: _dataNpl,
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
                    title: Text(_data[index]['TglAuctions'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0)),
                    subtitle: Column(
                      children: [
                        SizedBox(height:8.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft, 
                              child: RichText(
                                text: TextSpan(
                                  children: <TextSpan>[
                                    TextSpan(text: 'Auction : ', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                                    TextSpan(text: _data[index]['IdAuctions'], style: TextStyle(color: Colors.black))
                                  ]
                                ),
                              )
                            ),
                            getNoLot(_data[index])
                          ],
                        ),
                        SizedBox(height:8.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft, 
                              child: RichText(
                                text: TextSpan(
                                  children: <TextSpan>[
                                    TextSpan(text: 'NPL : ', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                                    TextSpan(text: _data[index]['NPL'], style: TextStyle(color: Colors.black))
                                  ]
                                ),
                              )
                            ),
                            getUnit(_data[index])
                          ],
                        ),
                        SizedBox(height:8.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft, 
                              child: RichText(
                                text: TextSpan(
                                  children: <TextSpan>[
                                    TextSpan(text: 'Status : ', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                                    TextSpan(text: _data[index]['Status'], style: TextStyle(color: Colors.black))
                                  ]
                                ),
                              )
                            ),
                            getNominal(_data[index])
                          ],
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

    final addButton = FloatingActionButton(
      tooltip: 'Beli NPL',
      child: Icon(Icons.add),
      onPressed: () {
        Navigator.of(context).pushNamed(BuyNpl.tag);
      }
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(Npl.name),
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
      floatingActionButton: addButton,
    );
  }
}