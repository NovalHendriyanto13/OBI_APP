import 'dart:async';
import 'package:intl/intl.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:vibration/vibration.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:obi_mobile/libraries/drawer_menu.dart';
import 'package:obi_mobile/libraries/refresh_token.dart';
import 'package:obi_mobile/libraries/check_internet.dart';
import 'package:obi_mobile/models/m_unit.dart';
import 'package:obi_mobile/models/m_npl.dart';
import 'package:obi_mobile/repository/unit_repo.dart';
import 'package:obi_mobile/repository/bid_repo.dart';
import 'package:obi_mobile/repository/npl_repo.dart';
import 'package:obi_mobile/repository/auction_repo.dart';
import 'package:obi_mobile/libraries/socket_io.dart';

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
  UnitRepo _unitRepo = UnitRepo();
  BidRepo _bidRepo = BidRepo();
  NplRepo _nplRepo = NplRepo();
  AuctionRepo _auctionRepo = AuctionRepo();
  Future<M_Unit> _dataUnit;
  int _process = 0;
  bool _enableBid = false;
  String _selectedNpl = '';
  String _bidPrice = "0";
  bool _isSocket = false;
  String _panggilan = "0";
  String id = "";
  Timer timer;
  Map _param;
  SocketIo _socketIo = SocketIo();
  IO.Socket _socket;

  @override
  void initState() {
    super.initState();
    _checkInternet.check(context);
    _refreshToken.run();
    _socket = _socketIo.connect();
    initLiveBid();
    timer = Timer.periodic(Duration(seconds: 2), (timer) { updatePrice(); });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  initLiveBid() async{
    if (_param != null) {
      final paramLastBid = {
        'auction_id': _param['IdAuctions'],
        'unit_id': _param['IdUnit'] 
      };
      _socket.emit('initLive', paramLastBid);
      _socket.on('getLastLive', (res) async {
        bool isVibrate = false;
        if (res['is_new'] == 0) {
          if (_bidPrice != res['price'].toString()) {
            _bidPrice = res['price'].toString();
            isVibrate = true;
          }
          if (_panggilan != res['panggilan'].toString()) {
            _panggilan = res['panggilan'].toString();
            id = res['IdUnit'];
            isVibrate = true;
          }
          if (_param['IdAuctions'] != res['unit']['IdAuctions']) {
            _isSocket = true;
            _param = res['unit'];
            id = res['IdUnit'];
            isVibrate = true;
          }
          setState(() {
            _isSocket = _isSocket;
            _param = _param;
            id = id;
            _bidPrice = _bidPrice;
            _panggilan = _panggilan;
          });

          if (isVibrate) {
            _vibrate();
          }
        }
        else if (res['is_new'] == 1) {
           setState(() {
            _isSocket = true;
            _param = res['unit'];
            _panggilan = "0";
            _bidPrice = res['price'].toString();
            id = res['IdUnit'];
          });
          _vibrate();
        }
      });
    }
  }

  updatePrice() async{
    if (_param != null) {
      final paramLastBid = {
        'auction_id': _param['IdAuctions'],
        'unit_id': _param['IdUnit'] 
      };
      _socket.emit('setLastLive', paramLastBid);
      _socket.on('getLastLive', (res) async {
        bool isVibrate = false;
        if (res['is_new'] == 0) {
          if (_bidPrice != res['price'].toString()) {
            _bidPrice = res['price'].toString();
            isVibrate = true;
          }
          if (_panggilan != res['panggilan'].toString()) {
            _panggilan = res['panggilan'].toString();
            id = res['IdUnit'];
            isVibrate = true;
          }
          if (_param['IdAuctions'] != res['unit']['IdAuctions']) {
            _isSocket = true;
            _param = res['unit'];
            id = res['IdUnit'];
            isVibrate = true;
          }
          setState(() {
            _isSocket = _isSocket;
            _param = _param;
            id = id;
            _bidPrice = _bidPrice;
            _panggilan = _panggilan;
          });

          if (isVibrate) {
            _vibrate();
          }
        }
        else if (res['is_new'] == 1) {
           setState(() {
            _isSocket = true;
            _param = res['unit'];
            _panggilan = "0";
            _bidPrice = res['price'].toString();
            id = res['IdUnit'];
          });
          _vibrate();
        }
      });
    }
  }

  void _vibrate() async{
    if (await Vibration.hasVibrator()) {
        Vibration.vibrate(duration: 500);
    }
  }

  @override
  Widget build(BuildContext context) {
    Drawer _menu = _drawerMenu.initialize(context, LiveBid.tag);

    final Map param = ModalRoute.of(context).settings.arguments;
    id = param['IdUnit'];
    
    if (_isSocket == false) {
      setState(() {
        _param = param;
        id = _param['IdUnit'];
      });
    }
    _dataUnit = _unitRepo.detail(id);

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
      "auction_id": _param['IdAuctions'],
      "type": _param['Jenis'],
    };
    final npl = FutureBuilder<M_Npl>(
      future: _nplRepo.activeNpl(params),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List _data = snapshot.data.getListData();
          return  DropdownButtonFormField(
            isExpanded: true,          
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
      child: ButtonTheme(
        minWidth: 200.0,
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
                "auction_id": _param['IdAuctions'],
                "unit_id": _param['IdUnit'],
                "type": _param['Jenis'],
                "no_lot": _param['NoLot'],
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
        ),
      )
    );
    
    String price() {
      if (_bidPrice == '0') {
        print('ini');
        print(_param);
        return _param['HargaLimit'].toString();
        // return (NumberFormat.simpleCurrency(locale: 'id').format(_param['HargaLimit']));
      }
      else {
        int _bp = int.parse(_bidPrice);
        print('itu');
        return _bidPrice;
        // return (NumberFormat.simpleCurrency(locale: 'id').format(_bp));
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
              // Text('Harga Dasar : ' + NumberFormat.simpleCurrency(locale: 'id').format(_param['HargaLimit']), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)),
              Text('Harga Dasar : ' + _param['HargaLimit'].toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)),
              SizedBox(height: 15.0),
              Text('LOT : ' + _param['NoLot'], style: TextStyle(fontWeight: FontWeight.bold)) ,
              SizedBox(height: 8.0),
              Text(_param['Merk'] + ' ' + _param['Tipe'] + ' ' + _param['Transmisi'], style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8.0),
              Row(
                children: [
                  Text('Eks : ' + _param['GradeExterior']),
                  Text(' | '),
                  Text('Int : ' + _param['GradeInterior']),
                  Text(' | '),
                  Text('Msn :' + _param['GradeMesin'])
                ],
              ),
              SizedBox(height: 8.0),
              Text('Kilometer : '),
              SizedBox(height: 8.0),
              Text('No Rangka : '),
              SizedBox(height: 8.0),
              Text('No Mesin : '),
              SizedBox(height: 8.0),
              Text('STNK : ' + _param['TglBerlakuSTNK'].toString()),
              SizedBox(height: 8.0),
              Text('Nota Pajak : ' + _param['TglBerlakuPajak'].toString()),
              SizedBox(height: 8.0),
              Text('BPKB : '),
              SizedBox(height: 8.0),
              Text('info : '),
              SizedBox(height: 8.0),
            ],
          ),
          
          Container(
            color: Colors.grey,
            child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 5.0),
                    child: RichText(
                      textAlign: TextAlign.left,
                      text: TextSpan(
                        style: TextStyle(color: Colors.black),
                        children: [
                          TextSpan(text: ' Panggilan '),
                          TextSpan(
                            text: _panggilan,
                            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 20.0),
                          )
                        ] 
                      )
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5.0),
                    child: RichText(
                      textAlign: TextAlign.left,
                      text: TextSpan(
                        style: TextStyle(color: Colors.black),
                        children: [
                          TextSpan(text: 'Harga Penawaran '),
                          TextSpan(
                            text: price(),
                            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 20.0),
                          ),
                        ] 
                      )
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5.0, left: 5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: Text('Aktif Lelang')),
                        Expanded(
                          child: SwitchListTile(
                            title: const Text('On/Off'),
                            value: _enableBid,
                            onChanged: (value) {
                              setState(() {
                                _enableBid = value;
                              });
                            },
                            activeTrackColor: Colors.lightGreenAccent,
                            activeColor: Colors.green,
                          ),
                        )
                      ],
                    ),
                  ),
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