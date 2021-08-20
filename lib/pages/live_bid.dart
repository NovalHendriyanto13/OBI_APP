import 'dart:async';
import 'package:intl/intl.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_countdown_timer/index.dart';
import 'package:vibration/vibration.dart';
import 'package:flutter/material.dart';
import 'package:chewie_audio/chewie_audio.dart';
import 'package:video_player/video_player.dart';
import 'package:toast/toast.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:obi_mobile/libraries/drawer_menu.dart';
import 'package:obi_mobile/libraries/refresh_token.dart';
import 'package:obi_mobile/libraries/check_internet.dart';
import 'package:obi_mobile/libraries/session.dart';
import 'package:obi_mobile/libraries/sound.dart';
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
  final Map data;
  
  LiveBid(this.data);

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
  String _panggilan = "Panggilan : 0";
  String id = "";
  Timer timer;
  Map _param;
  Session _session = new Session();
  SocketIo _socketIo = SocketIo();
  IO.Socket _socket;
  Sound _sound = Sound();
  Future<void> _soundBid;
  Future<void> _soundOpen;
  Future<void> _soundWin;
  Future<void> _soundClose;
  ChewieAudioController _bidSoundController;
  ChewieAudioController _openSoundController;
  ChewieAudioController _winSoundController;
  ChewieAudioController _closeSoundController;
  VideoPlayerController _bidPlayer;
  VideoPlayerController _openPlayer;
  VideoPlayerController _winPlayer;
  VideoPlayerController _closePlayer;
  List _galleries;
  int userBid;
  bool isClose = false;
  bool isWin = false;

  @override
  void initState() {
    super.initState();
    _param = widget.data;
    _checkInternet.check(context);
    _refreshToken.run();
    _socket = _socketIo.connect();
    // _soundBid = _sound.bidPlayerInit();
    // _soundOpen = _sound.openPlayerInit();
    // _soundWin = _sound.winPlayerInit();
    // _soundClose = _sound.closePlayerInit();
    _bidSoundController = _sound.getBidController();
    _openSoundController = _sound.getOpenController();
    _winSoundController = _sound.getWinController();
    _closeSoundController = _sound.getCloseController();
    initBid();
    timer = Timer.periodic(Duration(seconds: 1), (timer) { updateBid(); });
  }

  @override
  void dispose() {
    timer.cancel();
    _sound.dispose();
    super.dispose();
  }

  initBid() async{
    if (_param != null) {
      final paramInitBid = {
        'auction_id': _param['IdAuctions'],
      };
      _socket.emit('initLive', paramInitBid);
      getLastBid();
    }
  }

  updateBid() async{

    if (_param != null) {
      final paramLastBid = {
        'auction_id': _param['IdAuctions'],
        'unit_id': _param['IdUnit'] 
      };
      _socket.emit('setLastLive', paramLastBid);
      getLastBid();
    }
  }

  getLastBid() {
    _socket.on('getLastLive', (res) async {
        bool isBid = false;
        int userid = await _session.getInt('id');

        print(res);
        if (res['is_new'] == 0) {
          if (_bidPrice != res['price'].toString()) {
            _bidPrice = res['price'].toString();
            _param = res['unit'];
            isBid = true;
          }
          if (_panggilan != res['panggilan'].toString()) {
            _panggilan = 'Panggilan : ' + res['panggilan'].toString();
            id = res['IdUnit'];
            _param = res['unit'];
            isBid = true;
          }
          if (_param['IdAuctions'] != res['unit']['IdAuctions']) {
            _isSocket = true;
            _param = res['unit'];
            id = res['IdUnit'];
            isBid = true;
          }

          if (isBid) {
            if (_soundBid == null) {
              _soundBid = _sound.bidPlayerInit();
            }
            // _bidSoundController = _sound.getBidController();
            _bidSoundController.play();
          }
          if (res['close'] == true) {
            if (res['user_id'] == userid) {
              // win
              _panggilan = 'Selamat Anda Menang Unit ini';
            }
            else {
              // lose
              _panggilan = 'Unit Terjual ke NPL ' + res['npl'];
            }
          }

          setState(() {
            _isSocket = _isSocket;
            _param = _param;
            id = id;
            _bidPrice = _bidPrice;
            _panggilan = _panggilan;
            _galleries = res['galleries'];
          });
        }
        else if (res['is_new'] == 1) {
           setState(() {
            _isSocket = true;
            _param = res['unit'];
            _panggilan = "0";
            _bidPrice = res['price'].toString();
            id = res['IdUnit'];
            _galleries = res['galleries'];
          });
          // _soundOpen = _sound.openPlayerInit();
          // _openSoundController = _sound.getOpenController();
          // _openSoundController.play();
        }
      });
  }

  void _vibrate() async{
    if (await Vibration.hasVibrator()) {
        Vibration.vibrate(duration: 500);
    }
  }

  @override
  Widget build(BuildContext context) {
    Drawer _menu = _drawerMenu.initialize(context, LiveBid.tag);

    final _type = _param['Jenis'] != null ? _param['Jenis'] : 'mobil';

    final params = {
      "auction_id": _param['IdAuctions'],
      "type": _type,
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
          onPressed: () async{
            if (this._enableBid == false) {
              Toast.show('Status Anda Tidak Aktif', context, duration: Toast.LENGTH_LONG , gravity:  Toast.BOTTOM, backgroundColor: Colors.orange);
            }
            else if (this._selectedNpl == '') {
              Toast.show('Anda Belom pilih NPL/ NPL tidak ada', context, duration: Toast.LENGTH_LONG , gravity:  Toast.BOTTOM, backgroundColor: Colors.orange);
            }
            else {
              final data = {
                "npl": this._selectedNpl,
                "auction_id": _param['IdAuctions'],
                "unit_id": _param['IdUnit'],
                "type": _param['Jenis'],
                "no_lot": _param['NoLot'],
              };

              final bidding = await _bidRepo.live(data);
              bool status = bidding.getStatus();
              if (status == true) {
                List data = bidding.getData();
                setState((){
                  _bidPrice = data[0]['bid_price'].toString();
                });

                final msgSuccess = "Unit ini berhasil anda bid";
                Toast.show(msgSuccess, context, duration: Toast.LENGTH_LONG , gravity:  Toast.BOTTOM, backgroundColor: Colors.green);
              }
              else {
                Map errMessage = bidding.getMessage();
                String msg = errMessage['message'];
                Toast.show(msg, context, duration: Toast.LENGTH_LONG , gravity:  Toast.BOTTOM, backgroundColor: Colors.orange);
              }
            }
          },
          child: buttonText(),
          color: Colors.blue,
        ),
      )
    );
    
    String price() {
      if (_bidPrice == '0') {
        return 'Rp.' + _param['HargaLimit'].toString();
      }
      else {
        return 'Rp.' + _bidPrice;
      }
    }

    Widget body() {
      if (_param['IdUnit'].toString() == '0') {
        final _now = DateTime.now();
        final _nowDt = DateFormat('yyyy-MM-dd HH:mm').format(_now);
        String _auctionStartTime = _param['r_TglAuctions'] + ' ' + _param['StartTime'];
        final _d1 = DateTime.parse(_nowDt);
        final _auctionStartDate = DateTime.parse(_auctionStartTime);
        final diffStart = _auctionStartDate.difference(_d1).inSeconds;
        int startTime = DateTime.now().millisecondsSinceEpoch + 1000 * diffStart;
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Auction Belum Di Buka', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)),
              CountdownTimer(
                endTime: startTime,
                widgetBuilder: (_, CurrentRemainingTime time) {
                  if (time != null) {
                    String days = time.days != null ? time.days.toString() + ' Days, ' : '';
                    String hours = time.hours != null ? time.hours.toString(): '00';
                    String min = time.min != null ? time.min.toString(): '00';
                    String sec = time.sec != null ? time.sec.toString(): '00';
                    return Text("Open In : " + days + hours + ':' + min + ':' + sec, style: TextStyle(fontSize: 15.0),);
                  } else {
                    return Text(' ... ');
                  }
                },
              ),
            ])
        );
      }
      else {
        if (_galleries == null) {
          _galleries = [{"image": _param["image"]}];
        }
        final carouselSlider = CarouselSlider(
          items: _galleries.map<Widget>((i) {
            return Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(i['image']),
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
        return Stack(
          alignment: Alignment.bottomCenter,
          children: [
            ListView(
              padding: EdgeInsets.all(10.0),
              children: [
                carouselSlider,
                // Text('Harga Dasar : ' + NumberFormat.simpleCurrency(locale: 'id').format(_param['HargaLimit']), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)),
                Text('Harga Dasar : Rp.' + _param['HargaLimit'].toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)),
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
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(LiveBid.name)
      ),
      drawer: _menu,
      body: body()
    );
  }  
}