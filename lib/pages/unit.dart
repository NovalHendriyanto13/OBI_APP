import 'package:flutter/material.dart';
import 'package:obi_mobile/libraries/drawer_menu.dart';
import 'package:obi_mobile/libraries/refresh_token.dart';
import 'package:obi_mobile/models/m_unit.dart';
import 'package:obi_mobile/pages/tabs/units/info.dart' as info;
import 'package:obi_mobile/pages/tabs/units/document.dart' as doc;
import 'package:obi_mobile/pages/tabs/units/bid.dart' as bid;

class Unit extends StatefulWidget {
  static String tag = 'unit-page';
  static String name = 'Unit';
  @override
  _UnitState createState() => _UnitState();
}

class _UnitState extends State<Unit> with SingleTickerProviderStateMixin{
  DrawerMenu _drawerMenu = new DrawerMenu();
  RefreshToken _refreshToken = new RefreshToken();
  TabController _tabController;

  List<Widget> _tabList = <Widget>[
    Tab(child: Text('Info Unit')),
    Tab(child: Text('Dokument')),
    Tab(child: Text('Penawaran'))
  ];
  @override
  void initState() {
    super.initState();
    // _refreshToken.run();

    _tabController = TabController(vsync: this, length: _tabList.length);
  }

  @override
  Widget build(BuildContext context) {
    Drawer _menu = _drawerMenu.initialize(context, Unit.tag);

    final Map param = ModalRoute.of(context).settings.arguments;
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text("LOT : "  + param["NoLot"], style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            Text(param["Merk"] + " " + param['Tipe'])
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: _tabList
        ),
      ),
      drawer: _menu,
      body: Container(
        padding: EdgeInsets.only(left: 12.0, right: 12.0),
        color: Colors.blueGrey.shade50,
        child: TabBarView(
          controller: _tabController,
          children: [
            info.Info(data: param),
            doc.Document(data: param),
            bid.Bid(data: param),
          ]
        )
      )
    );
  }
}