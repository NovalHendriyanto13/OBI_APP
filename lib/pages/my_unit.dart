import 'package:flutter/material.dart';
import 'package:obi_mobile/libraries/drawer_menu.dart';
import 'package:obi_mobile/libraries/bottom_menu.dart';

class MyUnit extends StatefulWidget {
  static String tag = 'my-unit-page';
  static String name = 'My Unit';
  @override
  _MyUnitState createState() => _MyUnitState();
}

class _MyUnitState extends State<MyUnit> {
  DrawerMenu _drawerMenu = new DrawerMenu();
  BottomMenu _bottomMenu = new BottomMenu();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Drawer _menu = _drawerMenu.initialize(context, MyUnit.tag);
    BottomNavigationBar _bottomNav = _bottomMenu.initialize(context, null);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(MyUnit.name),
      ),
      drawer: _menu,
      bottomNavigationBar: _bottomNav,
      body: Container(

      )
    );
  }
}