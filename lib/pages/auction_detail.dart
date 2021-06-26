import 'package:flutter/material.dart';
import 'package:obi_mobile/libraries/drawer_menu.dart';
import 'package:obi_mobile/libraries/bottom_menu.dart';
import 'package:obi_mobile/libraries/search_bar.dart';
import 'package:obi_mobile/libraries/check_internet.dart';
import 'package:obi_mobile/models/m_auction.dart';
import 'package:obi_mobile/pages/unit.dart';
import 'package:obi_mobile/repository/auction_repo.dart';
import 'package:obi_mobile/repository/brand_repo.dart';
import 'package:obi_mobile/pages/home.dart';

class AuctionDetail extends StatefulWidget {
  static String tag = 'auction-detail-page';
  static String name = 'Auction Detail';

  @override 
  _AuctionDetailState createState() => _AuctionDetailState();
}

class _AuctionDetailState extends State<AuctionDetail> {

  DrawerMenu _drawerMenu = DrawerMenu();
  BottomMenu _bottomMenu = BottomMenu();
  AuctionRepo _auctionRepo = AuctionRepo();
  CheckInternet _checkInternet = CheckInternet();

  BrandRepo _brandRepo = BrandRepo();

  List _dataBrand = [{"Merk":"Semua Merk"}];
  String _selectedBrand = "";
  List<String> _dataTransmission = <String>["","Automatic(A/T)","Manual(M/T)"];
  String _selectedTransmission = "";
  List<int> _dataYear = List<int>.generate(30, (index) => 2021-index);
  int _selectedStartYear = 0;
  int _selectedEndYear = 0;
  String _selectedSort = 'nolot';
  Map _searchText = {};

  TextEditingController _type = TextEditingController();
  TextEditingController _color = TextEditingController();
  TextEditingController _startPrice = TextEditingController();
  TextEditingController _endPrice = TextEditingController();
  
  @override
  void initState() {
    super.initState(); 
    _checkInternet.check(context);
    _loadData();
  }

  _loadData() async{
    _brandRepo.list().then((value) {
      bool status = value.getStatus();
      if (status == true) {
        setState(() {
          _dataBrand.addAll(value.getListData());
        });
      }
    });
    _dataYear.add(0);
  }

  @override
  Widget build(BuildContext context) {

    Drawer _menu = _drawerMenu.initialize(context, AuctionDetail.tag);
    BottomNavigationBar _bottomNav = _bottomMenu.initialize(context, Home.tag);
    SearchBar _searchBar = new SearchBar(context, false, false);
    
    final Map param = ModalRoute.of(context).settings.arguments;
    String id = param["IdAuctions"];

    final _dataList = Container(
      child: FutureBuilder<M_Auction>(
        future: _auctionRepo.detail(id),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List _data = snapshot.data.getListData();
            if (_data == null) {
              return Center(child: Text('Could not connect to API'));
            }
            List _dataDetail = _data[0]['detail'];
            List _prevData = _data[0]['detail'];
            List _filteredList = [];

            if (_searchText.length > 0) {
              _dataDetail = _prevData;
              if (_searchText['brand'] != '') {
                _filteredList = _dataDetail.where((element) => element["Merk"].toString().toLowerCase() == _searchText['brand'].toString().toLowerCase()).toList();
                _dataDetail = _filteredList;
              }
              if (_searchText['transmission'] != '') {
                _filteredList = _dataDetail.where((element) => element["Transmisi"].toString().toLowerCase() == _searchText['transmission'].toString().toLowerCase()).toList();
                _dataDetail = _filteredList;
              }
              if (_searchText['type'] != '') {
                _filteredList = _dataDetail.where((element) => element["Tipe"].toString().toLowerCase() == _searchText['type'].toString().toLowerCase()).toList();
                _dataDetail = _filteredList;
              }
              if (_searchText['color'] != '') {
                _filteredList = _dataDetail.where((element) => element["Warna"].toString().toLowerCase() == _searchText['color'].toString().toLowerCase()).toList();
                _dataDetail = _filteredList;
              }
              if (_searchText['start_year'] != 0) {
                _filteredList = _dataDetail.where((element) => int.parse(element["Tahun"]) >= _searchText['start_year']).toList();
                _dataDetail = _filteredList;
              }
              if (_searchText['end_year'] != 0) {
                _filteredList = _dataDetail.where((element) => int.parse(element["Tahun"]) <= _searchText['end_year']).toList();
                _dataDetail = _filteredList;
              }
              if (_searchText['start_price'] != '') {
                _filteredList = _dataDetail.where((element) => int.parse(element["HargaLimit"]) >= _searchText['start_price']).toList();
                _dataDetail = _filteredList;
              }
              if (_searchText['end_price'] != '') {
                _filteredList = _dataDetail.where((element) => int.parse(element["HargaLimit"]) <= _searchText['end_price']).toList();
                _dataDetail = _filteredList;
              }
            }
            if (_selectedSort == 'nolot') {
              _dataDetail.sort((a, b)=> a['NoLot'].compareTo(b['NoLot']));
            }
            else if (_selectedSort == 'minprice') {
              _dataDetail.sort((a, b) => a['HargaLimit'].compareTo(b['HargaLimit']));
            }
            else if (_selectedSort == 'maxprice') {
              _dataDetail.sort((a, b) => -a['HargaLimit'].compareTo(b['HargaLimit']));
            }
            return ListView.builder(
              shrinkWrap: true,
              itemCount: _dataDetail.length == 0 ? 1 : _dataDetail.length,
              itemBuilder: (BuildContext context, int index) {
                List _list = _dataDetail;
                return _list.length == 0 ? Center(child: Text('No Data Found')) : GestureDetector( 
                  child : Card(
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      children: [
                        Container(
                          height: 150,
                          padding: EdgeInsets.all(0),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 6,
                                child: Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(_list[index]['image']),
                                      fit: BoxFit.cover
                                    )
                                  ),
                                ),
                              ),
                              Spacer(flex: 1),
                              Expanded(
                                flex: 14,
                                child: Container(
                                  padding: EdgeInsets.all(5.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('No Lot : ' + _list[index]['NoLot'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0)),
                                          Text((_list[index]['Merk'] + ' ' + _list[index]['Tipe'] + ' ' + _list[index]['Transmisi']).toString().toUpperCase(), style: TextStyle(fontWeight: FontWeight.bold)),
                                        ]
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('No Polisi : ' + _list[index]['NoPolisi'].toString()),
                                          Text('|'),
                                          Text('Tahun : ' + _list[index]['Tahun'].toString()),
                                        ]
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Eks : ' + _list[index]['GradeExterior']),
                                          Text('Int : ' + _list[index]['GradeInterior']),
                                          Text('Msn : ' + _list[index]['GradeMesin'])
                                        ]
                                      ),
                                      Align(alignment: Alignment.centerLeft, child: Text('Warna : ' + _list[index]['Warna'].toString())),
                                      Align(alignment: Alignment.centerLeft, child: Text('STNK : ' + _list[index]['TglBerlakuSTNK'].toString())),
                                      Align(alignment: Alignment.centerLeft, child: Text('PAJAK : ' + _list[index]['TglBerlakuPajak'].toString())),
                                    ],
                                  )
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 5.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                          Padding(
                            padding: EdgeInsets.only(left: 12.0, bottom: 10.0),
                            child: Align(alignment: Alignment.centerLeft, child: Text('Rp. ' + _list[index]['HargaLimit'].toString(), style: TextStyle(fontWeight: FontWeight.bold)))
                        ),
                          Padding(
                            padding: EdgeInsets.only(right: 12.0, bottom: 10.0),
                            child: Align(alignment: Alignment.centerLeft, child: Text('DETAIL', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue.shade300)))
                          )
                        ])
                      ]
                    ),
                  ),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Unit(), settings: RouteSettings(arguments: _list[index])));
                  },
              );
            });
          }
          else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }

          return Center(
            child: CircularProgressIndicator()
          );
        }
      )
    );

    final merk = DropdownButtonFormField(
      items: _dataBrand.map((e) {
        String v = e["Merk"].toString();
        if (e["Merk"] == "Semua Merk") {
          v = "";
        }
        return DropdownMenuItem(
          child: Text(e["Merk"]),
          value: v, 
        );
      }).toList(),
      hint: Text('Semua Merk'),
      decoration: InputDecoration(
        hintText: 'Semua Merk',
        labelText: 'Semua Merk',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(18.0))
      ),
      onChanged: (selected) {
        setState(() {
          _selectedBrand = selected;
        });
      },
      value: _selectedBrand,
    );

    final type = TextFormField(
      controller: _type,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        hintText: 'Tipe',
        labelText: 'Tipe',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(18.0))
      ),
    );

    final color = TextFormField(
      controller: _color,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          hintText: 'Warna',
          labelText: 'Warna',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(18.0))
        ),
    );

    final transmission = DropdownButtonFormField(
      items: _dataTransmission.map((e) {
        String t = e.toString();
        String v = "";
        if (e == "") {
          t = "Semua Transmission";
        }
        if (t == "Automatic(A/T)") {
          v = "A/T";
        }
        else if (t == "Manual(M/T)") {
          v = "M/T";
        }
        return DropdownMenuItem(
          child: Text(t),
          value: v, 
        );
      }).toList(),
      hint: Text('Transmission'),
      decoration: InputDecoration(
        hintText: 'Transmission',
        labelText: 'Transmission',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(18.0))
      ),
      onChanged: (selected) {
        setState(() {
          _selectedTransmission = selected;
        });
      },
      value: _selectedTransmission,
    );

    final startPrice = TextFormField(
      controller: _startPrice,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          hintText: 'Min Price',
          labelText: 'Min Price',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(18.0))
        ),
    );

    final endPrice =  TextFormField(
      controller: _endPrice,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          hintText: 'Max Price',
          labelText: 'Max Price',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(18.0))
        ),
    );

    final startYear = DropdownButtonFormField(
      items: _dataYear.map((e) {
        String v;
        if (e == 0) {
          v = "Semua Tahun";
        }
        else {
          v = e.toString();
        }
        return DropdownMenuItem(
          child: Text(v),
          value: e, 
        );
      }).toList(),
      hint: Text('Min Tahun'),
      decoration: InputDecoration(
        hintText: 'Min Tahun',
        labelText: 'Min Tahun',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(18.0))
      ),
      onChanged: (selected) {
        setState(() {
          _selectedStartYear = selected;
        });
      },
      value: _selectedStartYear,
    );

    final endYear = DropdownButtonFormField(
      items: _dataYear.map((e) {
        String v;
        if (e == 0) {
          v = "Semua Tahun";
        }
        else {
          v = e.toString();
        }
        return DropdownMenuItem(
          child: Text(v),
          value: e, 
        );
      }).toList(),
      hint: Text('Max Tahun'),
      decoration: InputDecoration(
        hintText: 'Max Tahun',
        labelText: 'Max Tahun',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(18.0))
      ),
      onChanged: (selected) {
        setState(() {
          _selectedEndYear = selected;
        });
      },
      value: _selectedEndYear,
    );

    final button = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: MaterialButton(
          onPressed: () {
            Navigator.of(context).pop();
            setState(() {
              _searchText = {
                "brand": _selectedBrand,
                "type": _type.text.toString(),
                "color": _color.text.toString(),
                "transmission": _selectedTransmission,
                "start_year": _selectedStartYear,
                "end_year": _selectedEndYear,
                "start_price": _startPrice.text.toString(),
                "end_price": _endPrice.text.toString()
              };
            });
            // Navigator.pushReplacement(
            //   context,
            //   MaterialPageRoute(
            //       builder: (BuildContext context) => super.widget, settings: RouteSettings(arguments: filters)));
          },
          child: Text('Tampilkan',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold
            )
          ),
          color: Colors.blue,
          height: 48.0,
      ),
    );

    Widget _popupSearchDialog(BuildContext context) {
      return new AlertDialog(
        title: const Text('Filter Unit'),
        content: Stack(
          children: <Widget>[
            Positioned(
              top: -40.0,
              child: InkResponse(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: CircleAvatar(
                  child: Icon(Icons.close),
                  backgroundColor: Colors.red,
                ),
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  merk,
                  color,
                  type,
                  transmission,
                  startYear,
                  endYear,
                  startPrice,
                  endPrice,
                  button
                ])
            )
          ])
      );
    }

    trailing(String selected) {
      if (_selectedSort == selected) {
        return Icon(Icons.check);
      }
    }
    Widget _popupSortDialog(BuildContext context) {
      return new AlertDialog(
        title: const Text('Sort Unit'),
        content: ListView(
          children: ListTile.divideTiles(
            context: context,
            tiles: [
              ListTile(
                title: Text('Nomor Lot'),
                trailing: trailing('nolot'),
                onTap: () {
                  setState(() {
                    _selectedSort = 'nolot';
                  });
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text('Harga Terendah'),
                trailing: trailing('minprice'),
                onTap: () {
                  setState(() {
                    _selectedSort = 'minprice';
                  });
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text('Harga Tertinggi'),
                trailing: trailing('maxprice'),
                onTap: () {
                  setState(() {
                    _selectedSort = 'maxprice';
                  });
                  Navigator.of(context).pop();
                },
              )
            ]
          ).toList()
        )
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(param["Kota"], style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            Text(param["TglAuctions"], style: TextStyle(fontSize: 10.0))
          ],
        ),
        backgroundColor: Colors.red,
        actions: _searchBar.build(),
      ),
      drawer: _menu,
      bottomNavigationBar: _bottomNav,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Stack(
        children: [
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: EdgeInsets.only(bottom: 60.0, left: 10.0),
              child: FloatingActionButton.extended(
                label: const Text('Filter'),
                icon: const Icon(Icons.search),
                onPressed: () {
                  showDialog(
                    context: context, 
                    builder: (BuildContext context) => _popupSearchDialog(context),
                  );
                },
              ),
            )
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: EdgeInsets.only(bottom: 60.0, right: 10.0),
              child: FloatingActionButton.extended(
                label: const Text('Sort'),
                icon: const Icon(Icons.sort),
                onPressed: () {
                  showDialog(
                    context: context, 
                    builder: (BuildContext context) => _popupSortDialog(context),
                  );
                },
              ),
            )
          ),
        ]
      ),
      body: Container(
        padding: EdgeInsets.all(12.0),
        color: Colors.blueGrey.shade50,
        child: _dataList,
      ),
    );
  }
}