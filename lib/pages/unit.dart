import 'package:flutter/material.dart';
import 'package:obi_mobile/libraries/drawer_menu.dart';
import 'package:obi_mobile/libraries/refresh_token.dart';

class Unit extends StatefulWidget {
  static String tag = 'unit-page';
  static String name = 'Unit';
  @override
  _UnitState createState() => _UnitState();
}

class _UnitState extends State<Unit> {
  DrawerMenu _drawerMenu = new DrawerMenu();
  RefreshToken _refreshToken = new RefreshToken();
  @override
  void initState() {
    super.initState();

    _refreshToken.run();
  }

  @override
  Widget build(BuildContext context) {
    Drawer _menu = _drawerMenu.initialize(context, Unit.tag);

    final Map param = ModalRoute.of(context).settings.arguments;
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(Unit.name),
      ),
      drawer: _menu,
      body: Container(
        child: Text(param.toString())
      )
    );
  }
}