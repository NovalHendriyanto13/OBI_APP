import 'package:flutter/material.dart';
import 'package:obi_mobile/models/m_auction.dart';

class AuctionDetail extends StatefulWidget {
  static String tag = 'auction-detail-page';
  static String name = 'Auction Detail';
  final M_Auction auction;

  AuctionDetail({Key key, @required this.auction}) : super(key: key);

  @override 
  _AuctionDetailState createState() => _AuctionDetailState();
}

class _AuctionDetailState extends State<AuctionDetail> {

  @override
  void initState() {
    super.initState();    
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text(AuctionDetail.name)
          ]
        ),
      ),
    );
  }
}