import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:obi_mobile/libraries/drawer_menu.dart';
import 'package:obi_mobile/libraries/refresh_token.dart';
import 'package:obi_mobile/models/m_unit.dart';
import 'package:obi_mobile/repository/unit_repo.dart';
import 'package:obi_mobile/pages/tabs/units/info.dart' as info;
import 'package:obi_mobile/pages/tabs/units/document.dart' as doc;
import 'package:obi_mobile/pages/tabs/units/bid.dart' as bid;

class LiveBid extends StatefulWidget {
  static String tag = 'live-bid-page';
  static String name = 'Live Bid';
  @override
  _LiveBidState createState() => _LiveBidState();
}

class _LiveBidState extends State<LiveBid>{
  DrawerMenu _drawerMenu = new DrawerMenu();
  RefreshToken _refreshToken = new RefreshToken();
  UnitRepo _unitRepo = new UnitRepo();
  Future<M_Unit> _dataUnit;
  int _process = 0;
  bool _enableBid = false;

  @override
  void initState() {
    super.initState();
    _refreshToken.run();
  }

  @override
  Widget build(BuildContext context) {
    Drawer _menu = _drawerMenu.initialize(context, LiveBid.tag);
    TextEditingController _npl = TextEditingController();

    final Map param = ModalRoute.of(context).settings.arguments;
    _dataUnit = _unitRepo.detail(param['IdUnit']);

    final carouselSlider = FutureBuilder<M_Unit>(
      future: _dataUnit,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List _data = snapshot.data.getListData();
          return CarouselSlider(
            items: _data[0]['galleries'].map<Widget>((i) {
              return Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(i['Image']),
                      fit: BoxFit.fill
                    )
                  )
                );
            }).toList(),
            options: CarouselOptions(
              height: 300,
              aspectRatio: 16/9,
              viewportFraction: 0.8,
              initialPage: 0,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 3),
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: true,
              scrollDirection: Axis.horizontal,
            ),
          );
        }
        else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      }
    );

    final npl = TextFormField(
      controller: _npl,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        hintText: 'NPL',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
      ),
    );

    Widget buttonText() {
      if(_process == 1) {
        return CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        );
      }  
      
      return new Text('Submit',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold
        )
      );
    }

    final btnSubmit = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: MaterialButton(
          onPressed: () {
            
          },
          child: buttonText(),
          color: Colors.blue,
          height: 48.0,
      ),
    );
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
      ),
      drawer: _menu,
      body: Container(
        padding: EdgeInsets.only(left: 12.0, right: 12.0),
        color: Colors.blueGrey.shade50,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            ListView(
              padding: EdgeInsets.all(10.0),
              children: [
                carouselSlider,
                Text('Harga Dasar : ' + param['HargaLimit'].toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)),
                SizedBox(height: 15.0),
                Text('LOT : ' + param['NoLot'], style: TextStyle(fontWeight: FontWeight.bold)) ,
                SizedBox(height: 8.0),
                Text(param['Merk'] + ' ' + param['Tipe'] + ' ' + param['Transmisi'], style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 8.0),
                Row(
                  children: [
                    Text('Eks : ' + param['GradeExterior']),
                    Text(' | '),
                    Text('Int : ' + param['GradeInterior']),
                    Text(' | '),
                    Text('Msn :' + param['GradeMesin'])
                  ],
                ),
                SizedBox(height: 8.0),
                Text('Kilometer : '),
                SizedBox(height: 8.0),
                Text('No Rangka : '),
                SizedBox(height: 8.0),
                Text('No Mesin : '),
                SizedBox(height: 8.0),
                Text('STNK : ' + param['TglBerlakuSTNK'].toString()),
                SizedBox(height: 8.0),
                Text('Nota Pajak : ' + param['TglBerlakuPajak'].toString()),
                SizedBox(height: 8.0),
                Text('BPKB : '),
                SizedBox(height: 8.0),
                Text('info : '),
                SizedBox(height: 8.0),
                Card(
                  child: ListTile(
                    title: Text('Auction #' + param['IdAuctions'], style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('Closed In : 00 00 00'),
                        SizedBox(height: 10.0),
                        npl,
                        SizedBox(height: 10.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            btnSubmit,
                          ],
                        )
                      ],
                    ),
                  )
                )
              ],
            ),
            Container(
              height: 40.0, 
              color: Colors.red,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Switch(
                    value: _enableBid, 
                    onChanged: (value) {
                      setState(() {
                        _enableBid = value;
                      });
                    },
                    activeTrackColor: Colors.lightGreenAccent,
                    activeColor: Colors.green,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      npl,
                      btnSubmit
                    ]
                  ),
                ],
              ) 
            ),
          ]
        )
      )
    );
  }
}