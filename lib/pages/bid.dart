import 'package:flutter/material.dart';
import 'package:obi_mobile/libraries/drawer_menu.dart';
import 'package:obi_mobile/libraries/bottom_menu.dart';

class Bid extends StatefulWidget {
  static String tag = 'bid-page';
  static String name = 'My Bid';

  @override
  _BidState createState() => _BidState();
}

class _BidState extends State<Bid> {

  DrawerMenu _drawerMenu = new DrawerMenu();
  BottomMenu _bottomMenu = new BottomMenu();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Drawer _menu = _drawerMenu.initialize(context, Bid.tag);
    BottomNavigationBar _bottomNav = _bottomMenu.initialize(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(Bid.name),
        backgroundColor: Colors.red,
      ),
      drawer: _menu,
      bottomNavigationBar: _bottomNav,
      // body: L,
    );
  }
}