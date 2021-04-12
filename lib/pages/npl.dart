import 'package:flutter/material.dart';
import 'package:obi_mobile/libraries/drawer_menu.dart';
import 'package:obi_mobile/libraries/bottom_menu.dart';
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
  DrawerMenu _drawerMenu = new DrawerMenu();
  BottomMenu _bottomMenu = new BottomMenu();
  NplRepo _nplRepo = new NplRepo();
  Future<M_Npl> _dataNpl;

  @override
  void initState() {
    super.initState();

    _dataNpl = _nplRepo.list();
  }

  @override
  Widget build(BuildContext context) {

    Drawer _menu = _drawerMenu.initialize(context, Npl.tag);
    BottomNavigationBar _bottomNav = _bottomMenu.initialize();

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
      body: Center(
        child: Container(
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          child: FutureBuilder<M_Npl>(
            future: _dataNpl,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<dynamic> _data = snapshot.data.getData();

                return ListView.builder(
                  itemBuilder: (context, index) {
                    return Container(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(_data[index]['TransID']),
                        ],
                      ),
                    );
                  }
                );
              }
              else if (snapshot.hasError) {
                return Text('Error...');
              }
              return Text('Loading...');
            },
          ),
        ),
      ),
      floatingActionButton: addButton,
    );
  }
}