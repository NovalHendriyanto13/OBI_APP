import 'package:flutter/material.dart';
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
                        Align(alignment: Alignment.centerLeft, child: Text('NPL : ' + _data[index]['NPL'] )),
                        SizedBox(height:8.0),
                        Align(alignment: Alignment.centerLeft, child: Text('Status : ' + _data[index]['Status'] )),
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