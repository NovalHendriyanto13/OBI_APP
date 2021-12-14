import 'dart:async';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_countdown_timer/index.dart';
import 'package:flutter/material.dart';
import 'package:chewie_audio/chewie_audio.dart';
import 'package:toast/toast.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:obi_mobile/libraries/drawer_menu.dart';
import 'package:obi_mobile/libraries/refresh_token.dart';
import 'package:obi_mobile/libraries/check_internet.dart';
import 'package:obi_mobile/libraries/session.dart';
import 'package:obi_mobile/libraries/sound.dart';
import 'package:obi_mobile/models/m_npl.dart';
import 'package:obi_mobile/models/m_general.dart';
import 'package:obi_mobile/repository/auction_repo.dart';
import 'package:obi_mobile/repository/bid_repo.dart';
import 'package:obi_mobile/repository/npl_repo.dart';
import 'package:obi_mobile/repository/general_repo.dart';
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
  BidRepo _bidRepo = BidRepo();
  NplRepo _nplRepo = NplRepo();
  GeneralRepo _generalRepo = GeneralRepo();
  AuctionRepo _auctionRepo = AuctionRepo();
  int _process = 0;
  bool _enableBid = false;
  String _selectedNpl = '';
  String _bidPrice = '0';
  String _panggilan;
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
  Future<void> _soundCall;
  ChewieAudioController _bidSoundController;
  ChewieAudioController _openSoundController;
  ChewieAudioController _winSoundController;
  ChewieAudioController _closeSoundController;
  ChewieAudioController _callSoundController;
  List _galleries;
  int userBid;
  bool isClose = false;
  bool isWin = false;
  bool _isOpen;
  bool _playSound;

  @override
  void initState() {
    super.initState();
    _param = widget.data;
    _checkInternet.check(context);
    _refreshToken.run();
    _socket = _socketIo.connect();
    _isOpen = false;
    _playSound = false;
    initBid();
    latestBid();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    _sound.dispose();
    super.dispose();
  }

  initBid() async {
    final String auctionId = _param['IdAuctions'];
    final lastUnit = await _auctionRepo.liveUnit(auctionId);
    final lastUnitData = lastUnit.getData();
    if (lastUnitData.isNotEmpty) {
      setState(() {
        _isOpen = true;
        _param = lastUnitData;
        _param['IdAuctions'] = _param['auction_id'];
        _panggilan = 'Panggilan: ' + _param['panggilan'].toString();
      });
    }
  }

  latestBid() {
    String auctionId = _param['IdAuctions'];
    final String socketName = 'setBid/' + auctionId;
    
    _socket.on(socketName, (res) async {
        bool isBid = false;
        bool isSound = false;
        int userid = await _session.getInt('id');
        String type = '';
        String panggilan = 'Panggilan: ' + res['data']['panggilan'].toString();

        if (res['data']['new'] == 0) {
          if (_param['panggilan'] != res['data']['panggilan']) {
            panggilan = 'Panggilan: ' + res['data']['panggilan'].toString();
            isBid = true;
            type = 'call';
          }

          if (_bidPrice != '0' && _bidPrice != res['data']['price'] && res['data']['panggilan'] == 0) {
            isBid = true;
            type = 'bid';
          }

          _bidPrice = res['data']['price'].toString();

          if (isBid == true) { // sound bid play
            isBid = false;
            isSound = true;
          }

          if (res['data']['close'] == true) {
            if (res['data']['user_id'].toString() == userid.toString()) {
              // win
              panggilan = 'Selamat Anda Menang Unit ini';
              type = 'win';
              isSound = true;
            }
            else {
              // lose
              if (res['data']['npl'] == null) {
                panggilan = 'Unit Tidak Terjual';
              } else {
                panggilan = 'Unit Terjual kepada NPL ' + res['data']['npl'];
              }
              type = 'close';
              isSound = true;
            }
          }
        }
        else if (res['data']['new'] == 1) { // new unit in auction
          type = 'open';
          isSound = true;
        }

        setState(() {
          _param = res['data'];
          _param['IdAuctions'] = _param['auction_id'];
          _isOpen = true;
          _panggilan = panggilan;
          _playSound = isSound;
        });

        getSound(type);
      });
  }

  void getSound(type) {
    if (_playSound == true) {
      if (type == 'close') {
        if (_closeSoundController != null) _closeSoundController.dispose();
        _soundClose = _sound.closePlayerInit();
        _closeSoundController = _sound.getCloseController();
        _closeSoundController.play();
      } else if (type == 'win') {
        if (_winSoundController != null) _winSoundController.dispose();
        _soundWin = _sound.winPlayerInit();
        _winSoundController = _sound.getWinController();
        _winSoundController.play();
      } else if (type == 'bid') {
        if (_bidSoundController != null) _bidSoundController.dispose();
        _soundBid = _sound.bidPlayerInit();
        _bidSoundController = _sound.getBidController();
        _bidSoundController.play();
      } else if (type == 'open') {
        if (_openSoundController != null) _openSoundController.dispose();
        _soundOpen = _sound.openPlayerInit();
        _openSoundController = _sound.getOpenController();
        _openSoundController.play();
      } else if (type == 'call') {
        if (_callSoundController != null) _callSoundController.dispose();
        _soundCall = _sound.callPlayerInit();
        _callSoundController = _sound.getCallController();
        _callSoundController.play();
      }
    }

    setState(() {
      _playSound = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Drawer _menu = _drawerMenu.initialize(context, LiveBid.tag);

    final _type = 'mobil';

    final params = {
      "auction_id": _param['IdAuctions'],
      "type": _type,
    };

    final npl = FutureBuilder<M_Npl>(
      future: _nplRepo.activeNpl(params),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List _data = snapshot.data.getListData();
          if (_data.length > 0) {
            _selectedNpl = _data[0]['NPL'];
          }
          return  DropdownButtonFormField(
            isExpanded: true,          
            items: _data.map((e) {
              return DropdownMenuItem(
                child: Text(e["NPL"]),
                value: e["NPL"], 
              );
            }).toList(),
            hint: Text('Pilih NPL'),
            onChanged: (selected) {
              _selectedNpl = selected;
            },
            value: _selectedNpl,
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
                "unit_id": _param['unit_id'],
                "type": _param['unit']['Jenis'],
                "no_lot": _param['unit']['NoLot'],
              };

              final bidding = await _bidRepo.live(data);
              bool status = bidding.getStatus();
              if (status == true) {
                Map data = bidding.getDataMap();
                setState((){
                  _bidPrice = data['bid_price'].toString();
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

    final countdownLive = FutureBuilder<M_General>(
      future: _generalRepo.getServerTime(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Map _serverTime = snapshot.data.getData();
          String _date = _serverTime["date"];
          String _time = _serverTime["time"];
          final _serverDate = DateTime.parse(_date + ' ' + _time);

          String _auctionStartTime = _param['r_TglAuctions'] + ' ' + _param['StartTime'];
          final _auctionStartDate = DateTime.parse(_auctionStartTime);
          final diffStart = _auctionStartDate.difference(_serverDate).inSeconds;

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
                      return Text(' Sedang Menunggu ... ');
                    }
                  },
                ),
              ])
          );
        }
        return Text('-');
      }
    );

    Widget body() {
      if (_isOpen == false) {
        return countdownLive;
      }
      else {
        _galleries = _param['galleries'];
        if (_galleries.length == 0) {
          _galleries = [{"image": _param['unit']["image"]}];
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

        final Map unitInfo = _param['unit'];
        final String stnk = null != unitInfo['TglBerlakuSTNK'] ? unitInfo['TglBerlakuSTNK'].toString() : 'T/A';
        final String pajak = null != unitInfo['TglBerlakuPajak'] ? unitInfo['TglBerlakuPajak'].toString() : 'T/A';
        return Stack(
          alignment: Alignment.bottomCenter,
          children: [
            ListView(
              padding: EdgeInsets.all(10.0),
              children: [
                carouselSlider,
                Text('Harga Dasar : Rp.' + unitInfo['HargaLimit'].toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0)),
                SizedBox(height: 15.0),
                Text('LOT : ' + unitInfo['NoLot'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)) ,
                SizedBox(height: 8.0),
                Text(unitInfo['Merk'].toString().toUpperCase() + ' ' + unitInfo['Tipe'] + ' ' + unitInfo['Transmisi'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0)),
                SizedBox(height: 8.0),
                Text('NO Polisi: ' + unitInfo['NoPolisi']),
                SizedBox(height: 8.0),
                Row(
                  children: [
                    Text('Eks : ' + unitInfo['GradeExterior'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0)),
                    Text(' | '),
                    Text('Int : ' + unitInfo['GradeInterior'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0)),
                    Text(' | '),
                    Text('Msn :' + unitInfo['GradeMesin'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0))
                  ],
                ),
                SizedBox(height: 8.0),
                Text('Kilometer : ' + unitInfo['Kilometer'].toString(), style: TextStyle(fontSize: 15.0)),
                SizedBox(height: 8.0),
                Text('Transmisi : ' + unitInfo['Transmisi'], style: TextStyle(fontSize: 15.0)),
                SizedBox(height: 8.0),
                Text('Tahun : ' + unitInfo['Tahun'], style: TextStyle(fontSize: 15.0)),
                SizedBox(height: 8.0),
                Text('STNK : ' + stnk, style: TextStyle(fontSize: 15.0)),
                SizedBox(height: 8.0),
                Text('Nota Pajak : ' + pajak, style: TextStyle(fontSize: 15.0)),
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
                              text: 'Rp.' + _param['price'].toString(),
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