import 'package:flutter/material.dart';
import 'package:obi_mobile/libraries/bottom_menu.dart';
import 'package:obi_mobile/libraries/drawer_menu.dart';
import 'package:obi_mobile/models/m_area.dart';
import 'package:obi_mobile/repository/area_repo.dart';
import 'package:obi_mobile/libraries/check_internet.dart';

class Area extends StatefulWidget {
  static String tag = 'area-page';
  static String name = 'Titip Jual';

  @override
  _AreaState createState() => _AreaState();
}

class _AreaState extends State<Area> {
  // class
  DrawerMenu _drawerMenu = DrawerMenu();
  BottomMenu _bottomMenu = BottomMenu();
  AreaRepo _areaRepo = AreaRepo();
  CheckInternet _checkInternet = CheckInternet();
  Future<M_Area> _dataArea;
  
  @override
  void initState() {
    super.initState();
    _checkInternet.check(context);
    _dataArea = _areaRepo.list();
  }

  @override
  Widget build(BuildContext context) {
    Drawer _menu = _drawerMenu.initialize(context, Area.tag);
    BottomNavigationBar _bottomNav = _bottomMenu.initialize(context, Area.tag);

    final _dataList = Expanded(
    child: FutureBuilder<M_Area>(
      future: _dataArea,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<dynamic> _data = snapshot.data.getListData();

          return ListView.builder(
            padding: EdgeInsets.all(5.0),
            itemCount: _data.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                  child: ListTile(
                    title: Text(_data[index]["Kota"], style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold)),
                    subtitle: Text(_data[index]["Alamat"]),     
                ),
              );
            },
          );
        }
        else if (snapshot.hasError) {
          return Text('Error...');
        }

        return Text('Loading...');
      },
    )
  );

    return Scaffold(
      appBar: AppBar(
        title: Text(Area.name),
        backgroundColor: Colors.red,
      ),
      drawer: _menu,
      bottomNavigationBar: _bottomNav,
      body: Container(
        padding: EdgeInsets.all(12.0),
        color: Colors.grey.shade50,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text("Apabila Anda Ingin Melakukan Penjualan Melalui Lelang, Hubungi Kami: ", style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),),
            _dataList,
          ],
        )
      ),
    );
  }
}