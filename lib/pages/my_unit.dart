import 'package:flutter/material.dart';
import 'package:obi_mobile/libraries/drawer_menu.dart';
import 'package:obi_mobile/libraries/bottom_menu.dart';
import 'package:obi_mobile/repository/unit_repo.dart';

class MyUnit extends StatefulWidget {
  static String tag = 'my-unit-page';
  static String name = 'My Unit';
  @override
  _MyUnitState createState() => _MyUnitState();
}

class _MyUnitState extends State<MyUnit> {
  DrawerMenu _drawerMenu = new DrawerMenu();
  BottomMenu _bottomMenu = new BottomMenu();
  UnitRepo _unitRepo = new UnitRepo();

  List _dataList = [];

  @override
  void initState() {
    super.initState();

    _loadData();
  }
  
  _loadData() async{
    _unitRepo.list().then((value) {
      bool status = value.getStatus();
      if (status == true) {
        setState(() {
          _dataList.addAll(value.getListData());
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Drawer _menu = _drawerMenu.initialize(context, MyUnit.tag);
    BottomNavigationBar _bottomNav = _bottomMenu.initialize(context, null);

    final dataRow = _dataList.map((e) {
       print(e);
       return DataRow(
        cells: [
          DataCell(
            Text(e['NoPolisi'])
          ),
          DataCell(
            Text(e['Merk'] + ' ' + e['Tipe'] + ' ' + e['Transmisi'] + ' ' + e['Warna'] + ' ' + e['Tahun'])
          ),
          DataCell(
            Text(e['TglMasukUnit'])
          ),
          DataCell(
            Text(e['TglKeluarUnit'])
          ),
        ]
      );
    }).toList();


    SingleChildScrollView _dataBody() {
      return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: const <DataColumn>[
              DataColumn(
                label: Text('No Polisi')
              ),
              DataColumn(
                label: Text('Unit') 
              ),
              DataColumn(
                label: Text('Tgl Masuk')
              ),
              DataColumn(
                label: Text('Tgl Keluar')
              )
            ],
            rows: dataRow,
          ),
        )
      );
    }

    // print(_dataList);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(MyUnit.name),
      ),
      drawer: _menu,
      bottomNavigationBar: _bottomNav,
      body: Expanded(
        child: _dataBody()
      ),
    );
  }
}