import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:obi_mobile/libraries/drawer_menu.dart';
import 'package:obi_mobile/libraries/bottom_menu.dart';
import 'package:obi_mobile/libraries/refresh_token.dart';
import 'package:obi_mobile/libraries/check_internet.dart';
import 'package:obi_mobile/models/m_unit.dart';
import 'package:obi_mobile/repository/unit_repo.dart';

class MyUnit extends StatefulWidget {
  static String tag = 'my-unit-page';
  static String name = 'My Unit';
  @override
  _MyUnitState createState() => _MyUnitState();
}

class _MyUnitState extends State<MyUnit> {
  DrawerMenu _drawerMenu = DrawerMenu();
  BottomMenu _bottomMenu = BottomMenu();
  RefreshToken _refreshToken = RefreshToken();
  CheckInternet _checkInternet = CheckInternet();
  UnitRepo _unitRepo = UnitRepo();

  Future<M_Unit> _dataUnit;

  @override
  void initState() {
    super.initState();
    _checkInternet.check(context);
    _refreshToken.run();
    _dataUnit = _unitRepo.list();
  }
  
  @override
  Widget build(BuildContext context) {
    Drawer _menu = _drawerMenu.initialize(context, MyUnit.tag);
    BottomNavigationBar _bottomNav = _bottomMenu.initialize(context, null);

    final _dataList = FutureBuilder<M_Unit>(
      future: _dataUnit,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List _data = snapshot.data.getListData();

          if (_data.length <= 0) {
            return Center(
              child: Text('No Data Found'),
            );
          }
          else {

            return ListView.builder(
              itemCount: _data.length,
              itemBuilder: (BuildContext context, int index) {
                _outUnit() {
                  if (_data[index]['TglKeluarUnit'] != null) {
                    return DateFormat('d MMMM yyyy').format(DateTime.parse(_data[index]['TglKeluarUnit']));
                  }
                  return '-';
                }

                _inUnit() {
                  if (_data[index]['TglKeluarUnit'] != null) {
                    DateFormat('d MMMM yyyy').format(DateTime.parse(_data[index]['TglMasukUnit']));
                  }
                  return '-';
                }
                return Card(
                  child: ListTile(
                    title: Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text((_data[index]['Merk'] + ' ' + _data[index]['Tipe'] + ' ' + _data[index]['Transmisi']).toString().toUpperCase(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0)),
                        ],),
                    ),
                    subtitle: Column(
                      children: [
                        SizedBox(height:8.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_data[index]['NoPolisi']),
                            Text('|'),
                            Text(_data[index]['Tahun']),
                            Text('|'),
                            Text(_data[index]['Warna'])
                          ]
                        ),
                        SizedBox(height:8.0),
                        Align(alignment: Alignment.centerLeft, child: Text('Tgl Masuk : ' + _inUnit() )),
                        SizedBox(height:8.0),
                        Align(alignment: Alignment.centerLeft, child: Text('Tgl Keluar : ' + _outUnit() )),
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
        return Center(
          child: CircularProgressIndicator(),
        );
      }
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(MyUnit.name),
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
    );
  }
}