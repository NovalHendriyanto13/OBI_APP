import 'package:flutter/material.dart';
import 'package:obi_mobile/libraries/drawer_menu.dart';
import 'package:obi_mobile/libraries/refresh_token.dart';
import 'package:obi_mobile/libraries/check_internet.dart';
import 'package:obi_mobile/models/m_unit.dart';
import 'package:obi_mobile/repository/unit_repo.dart';
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
  DrawerMenu _drawerMenu = DrawerMenu();
  RefreshToken _refreshToken = RefreshToken();
  CheckInternet _checkInternet = CheckInternet();
  UnitRepo _unitRepo = UnitRepo();
  TabController _tabController;
  Future<M_Unit> _dataUnit;
  String _lastBid = '0';

  List<Widget> _tabList = <Widget>[
    Tab(child: Text('Info Unit')),
    Tab(child: Text('Dokumen')),
    Tab(child: Text('Lelang'))
  ];

  @override
  void initState() {
    super.initState();
    _checkInternet.check(context);
    
    _refreshToken.run();
    _tabController = TabController(vsync: this, length: _tabList.length);
  }

  @override
  Widget build(BuildContext context) {
    Drawer _menu = _drawerMenu.initialize(context, Unit.tag);

    final Map param = ModalRoute.of(context).settings.arguments;
    final String id = param['IdUnit'];
    _dataUnit = _unitRepo.detail(id);

    final paramLastBid = {
      'auction_id': param['IdAuctions'],
      'unit_id': param['IdUnit'] 
    };

    param['last_bid'] = _lastBid;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text("LOT : "  + param["NoLot"], style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            Text(param["Merk"].toString().toUpperCase() + " " + param['Tipe'])
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
            info.Info(data: param, detail: _dataUnit),
            doc.Document(data: param, detail: _dataUnit),
            bid.Bid(data: param, detail: _dataUnit),
          ]
        )
      )
    );
  }
}