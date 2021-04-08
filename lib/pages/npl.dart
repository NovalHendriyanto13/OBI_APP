import 'package:flutter/material.dart';
import 'package:obi_mobile/libraries/drawer_menu.dart';
import 'package:obi_mobile/libraries/bottom_menu.dart';
import 'package:obi_mobile/pages/buy_npl.dart';

class Npl extends StatefulWidget {
  static String tag = 'npl-page';
  static String name = 'My NPL';

  @override
  _NplState createState() => _NplState();
}

class _NplState extends State<Npl> {
  DrawerMenu _drawerMenu = new DrawerMenu();
  BottomMenu _bottomMenu = new BottomMenu();

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
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            // addButton
          ],
        ),
      ),
      floatingActionButton: addButton,
    );
  }
}