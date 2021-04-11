import 'package:flutter/material.dart';
import 'package:obi_mobile/libraries/drawer_menu.dart';
import 'package:obi_mobile/libraries/bottom_menu.dart';
import 'package:obi_mobile/libraries/search_bar.dart';
import 'package:obi_mobile/models/m_auction.dart';
import 'package:obi_mobile/pages/buy_npl.dart';
import 'package:obi_mobile/pages/auction_detail.dart';
import 'package:obi_mobile/repository/auction_repo.dart';
import 'package:obi_mobile/repository/brand_repo.dart';

class Home extends StatefulWidget {
  static String tag = 'home-page';
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  DrawerMenu _drawerMenu = new DrawerMenu();
  BottomMenu _bottomMenu = new BottomMenu();
  AuctionRepo _auctionRepo = new AuctionRepo();
  BrandRepo _brandRepo = new BrandRepo();
  Future<M_Auction> _dataAuction;
  List _dataBrand = [{
    "Merk":"Semua Merk"
  }];
  List<int> _dataYear = List<int>.generate(30, (index) => 2021-index);
  String _selectedBrand = "";
  int _selectedYear = 2021;
  
  @override
  void initState() {
    super.initState();

    _dataAuction = _auctionRepo.list();
    _loadList();
  }

  _loadList() async{
    _brandRepo.list().then((value) {
      bool status = value.getStatus();
      if (status == true) {
        setState(() {
          _dataBrand.addAll(value.getListData());
          // _dataBrand = value.getListData();
        });
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    Drawer _menu = _drawerMenu.initialize(context, Home.tag);
    BottomNavigationBar _bottomNav = _bottomMenu.initialize();
    SearchBar _searchBar = SearchBar(context, true, true);

    Widget _locations = Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Jadwal Lelang', 
            style: TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.bold,
            )),
          Padding(
            padding: EdgeInsets.only(top: 12),
            child: RichText(
              text: TextSpan(
                text: 'Lihat Semua',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          )
        ],
      )
    );

    Widget _schedule = Expanded(
      child: SizedBox(
        // color: Colors.blueGrey.shade50,
        height: 350.0,
        child: FutureBuilder<M_Auction>(
          future: _dataAuction,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<dynamic> _data = snapshot.data.getListData();
              if (_data.length.isOdd) {
                _data.add({
                  "Kota":"",
                  "TglAuctions":"",
                });
              }
              return GridView.builder(
                // scrollDirection: Axis.horizontal,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 4.0,
                  mainAxisSpacing: 4.0,
                ), 
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    padding: EdgeInsets.all(10.0),
                    color: Colors.white,
                    child: GestureDetector(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_data[index]['Kota'], 
                            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.red.shade400)),
                          SizedBox(height: 10.0),
                          Text(_data[index]['TglAuctions'])
                        ],
                      ),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => AuctionDetail(auction: _data[index])));
                      },
                    ), 
                  );
                },
                itemCount: _data.length,
                
              );
            }
            else if (snapshot.hasError) {
              return Text('Error...');
            }
            return Text('Loading...');
          },
        ) 
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
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            const Radius.circular(8.0),
          ),
        ),
      ),
      onChanged: (selected) {
        setState(() {
          _selectedBrand = selected;
        });
      },
      value: _selectedBrand,
    );

    final year = DropdownButtonFormField(
      items: _dataYear.map((e) {
        return DropdownMenuItem(
          child: Text(e.toString()),
          value: e, 
        );
      }).toList(),
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            const Radius.circular(8.0),
          ),
        ),
      ),
      onChanged: (selected) {
        setState(() {
          _selectedYear = selected;
        });
      },
      value: _selectedYear,
    );

    final button = TextButton(
      child: Text('Cari', 
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold
        )
      ),
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
            side: BorderSide(color:Colors.blue)
          )
        ),
        backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
      ),
      onPressed: () {}
    );

    Widget _filterItems = Card(
      margin: EdgeInsets.all(12.0),
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: merk),
                SizedBox(width: 10.0),
                Expanded(child: year)
              ],
            ),
            SizedBox(height: 10.0),
            Row(
              children: [
                Expanded(child: merk),
                SizedBox(width: 10.0),
                Expanded(child: merk)
              ],
            ),
            SizedBox(height: 10.0),
            button
          ]
        )
      ),
    );

    final buttonNpl = TextButton(
      child: Text('Beli NPL', 
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold
        )
      ),
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
            side: BorderSide(color:Colors.blue)
          )
        ),
        backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
      ),
      onPressed: () {
        Navigator.of(context).pushNamed(BuyNpl.tag);
      }
    );

    Widget buyNpl = Card(
      color: Colors.blue.shade300,
      margin: EdgeInsets.all(12.0),
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          children: <Widget>[
            Text("Mudah Beli NPL", style: TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
              color: Colors.white
            )),
            SizedBox(height:10.0),
            Text("Tinggal Klik", style: TextStyle(
              fontSize: 18.0,
              color: Colors.white
            )),
            SizedBox(height: 10.0),
            buttonNpl
          ]
        ),
      )
    );
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        backgroundColor: Colors.red,
        actions: _searchBar.build(),
      ),
      drawer: _menu,
      bottomNavigationBar: _bottomNav,
      body: Container(
        padding: EdgeInsets.only(left: 12.0, right: 12.0),
        color: Colors.blueGrey.shade50,
        child: ListView(
          // mainAxisAlignment: MainAxisAlignment.start,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _locations,
            SizedBox(height:10.0),
            _schedule,
            SizedBox(height:20.0),
            Text("Cari Barang", style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold)),
            SizedBox(height:10.0),
            _filterItems,
            SizedBox(height:20.0),
            Text("Pembelian NPL", style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold)),
            SizedBox(height:10.0),
            buyNpl
          ],
        ),
      ),      
    );
  }

}