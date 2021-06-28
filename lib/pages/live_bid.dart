import 'package:carousel_slider/carousel_slider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:vibration/vibration.dart';
import 'package:flutter/material.dart';
import 'package:obi_mobile/libraries/drawer_menu.dart';
import 'package:obi_mobile/libraries/refresh_token.dart';
import 'package:obi_mobile/libraries/check_internet.dart';
import 'package:obi_mobile/libraries/socket_io.dart';
import 'package:obi_mobile/models/m_unit.dart';
import 'package:obi_mobile/models/m_npl.dart';
import 'package:obi_mobile/repository/unit_repo.dart';
import 'package:obi_mobile/repository/bid_repo.dart';
import 'package:obi_mobile/repository/npl_repo.dart';
import 'package:toast/toast.dart';

class LiveBid extends StatefulWidget {
  static String tag = 'live-bid-page';
  static String name = 'Live Bid';
  @override
  _LiveBidState createState() => _LiveBidState();
}

class _LiveBidState extends State<LiveBid>{
  DrawerMenu _drawerMenu = DrawerMenu();
  RefreshToken _refreshToken = RefreshToken();
  CheckInternet _checkInternet = CheckInternet();
  SocketIo _socketIo = SocketIo();
  UnitRepo _unitRepo = UnitRepo();
  BidRepo _bidRepo = BidRepo();
  NplRepo _nplRepo = NplRepo();
  Future<M_Unit> _dataUnit;
  int _process = 0;
  bool _enableBid = false;
  String _selectedNpl = '';
  List _dataNpl;
  String _bidPrice = "0";
  IO.Socket _socket;

  @override
  void initState() {
    super.initState();
    _checkInternet.check(context);
    _refreshToken.run();
    _socket = _socketIo.connect();

  }

  void _vibrate() async{
    if (await Vibration.hasVibrator()) {
        Vibration.vibrate(duration: 1000);
    }
  }

  @override
  Widget build(BuildContext context) {
    Drawer _menu = _drawerMenu.initialize(context, LiveBid.tag);

    final Map param = ModalRoute.of(context).settings.arguments;
    final String id = param['IdUnit'];
    _dataUnit = _unitRepo.detail(id);

    String _connectSocket() {
      _socket.on('getBid', (data) {
        setState(() {
          this._bidPrice = data.toString();
        });
        _vibrate();
      });
      return this._bidPrice;
    }

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
              // height: 300,
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

    final params = {
      "auction_id": param['IdAuctions'],
      "type": param['Jenis'],
    };
    final npl = FutureBuilder<M_Npl>(
      future: _nplRepo.activeNpl(params),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List _data = snapshot.data.getListData();
          return  DropdownButtonFormField(
            items: _data.map((e) {
              String v = e["NPL"].toString();
              return DropdownMenuItem(
                child: Text(e["NPL"]),
                value: e["NPL"], 
              );
            }).toList(),
            hint: Text('Pilih NPL'),
            onChanged: (selected) {
                this._selectedNpl = selected;
            },
            decoration: InputDecoration(
              hintText: 'Pilih NPL',
              labelText: 'Pilih NPL',
              fillColor: Colors.white,
              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(18.0)),
            )
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

    Widget buttonText() {
      if(_process == 1) {
        return CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        );
      }  
      
      return new Text('BID',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold
        )
      );
    }

    final btnSubmit = Padding(
      padding: EdgeInsets.only(left: 3.0, right: 3.0),
      child: MaterialButton(
        onPressed: () {
          if (this._enableBid == false) {
            Toast.show('Status Anda Tidak Aktif', context, duration: Toast.LENGTH_LONG , gravity:  Toast.BOTTOM, backgroundColor: Colors.red);
          }
          else if (this._selectedNpl == '') {
            Toast.show('Anda Belom pilih NPL/ NPL tidak ada', context, duration: Toast.LENGTH_LONG , gravity:  Toast.BOTTOM, backgroundColor: Colors.red);
          }
          else {
            final data = {
              "npl": this._selectedNpl,
              "auction_id": param['IdAuctions'],
              "unit_id": param['IdUnit'],
              "type": param['Jenis'],
              "no_lot": param['NoLot'],
            };

            _bidRepo.live(data).then((value) {
              bool status = value.getStatus();
              if (status == true) {
                final msgSuccess = "Unit ini berhasil anda bid";
                Toast.show(msgSuccess, context, duration: Toast.LENGTH_LONG , gravity:  Toast.BOTTOM, backgroundColor: Colors.green);
              }
              else {
                Map errMessage = value.getMessage();
                String msg = errMessage['message'];
                Toast.show(msg, context, duration: Toast.LENGTH_LONG , gravity:  Toast.BOTTOM, backgroundColor: Colors.red);
              }
            });
          }
        },
        child: buttonText(),
        color: Colors.blue,
        // height: 48.0,
      ),
    );
    
    _connectSocket();

    String price() {
      if (_bidPrice == '0') {
        return param['HargaLimit'].toString();
      }
      else {
        return _bidPrice;
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(LiveBid.name)
      ),
      drawer: _menu,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          ListView(
            padding: EdgeInsets.all(10.0),
            children: [
              carouselSlider,
              Text('Harga Dasar : ' + price(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)),
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
            ],
          ),
          Container(
            color: Colors.grey,
            height: 120.0,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SwitchListTile(
                    title: const Text('Aktif Lelang'),
                    value: _enableBid,
                    onChanged: (value) {
                      setState(() {
                        _enableBid = value;
                      });
                    },
                    activeTrackColor: Colors.lightGreenAccent,
                    activeColor: Colors.green,
                  ),
                  SizedBox(height:5.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(child: npl),
                      Expanded(child: btnSubmit),
                    ],
                  )
                ],
              )
            
          ),
        ],
      ),
    );
  }  
}