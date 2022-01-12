import 'package:flutter_countdown_timer/index.dart';
import 'package:flutter_html/style.dart';
import 'package:intl/intl.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:obi_mobile/models/m_bid.dart';
import 'package:obi_mobile/models/m_general.dart';
import 'package:toast/toast.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:obi_mobile/models/m_npl.dart';
import 'package:obi_mobile/models/m_unit.dart';
import 'package:obi_mobile/pages/live_bid.dart';
import 'package:obi_mobile/repository/bid_repo.dart';
import 'package:obi_mobile/repository/npl_repo.dart';
import 'package:obi_mobile/repository/general_repo.dart';

import '../../../models/m_bid.dart';

class Bidder extends StatelessWidget {
  final Map data;
  final Future<M_Unit> detail;
  BidRepo _bidRepo = BidRepo();
  
  Bidder({this.data, this.detail});

  @override
  Widget build(BuildContext context) {

    final params = {
      "auction_id": this.data['IdAuctions'],
      "unit_id": this.data['IdUnit'],
      "no_lot": this.data['NoLot'],
    };

    final bidders = FutureBuilder<M_Bid>(
      future: _bidRepo.bidder(params),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List data = snapshot.data.getData();
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child:Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: Center(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    sortColumnIndex: 0,
                    sortAscending: true,
                    showBottomBorder: true,
                    headingTextStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.black
                    ),
                    columns: [
                      DataColumn(
                        label: Text('Tanggal & Waktu'),
                      ),
                      DataColumn(
                        label: Text('ID User')
                      ),
                      DataColumn(
                        label: Text('Nominal')
                      )
                    ],
                    rows: data.map(
                      (bidder) => DataRow(
                        cells: [
                          DataCell(
                            Container(
                              width: 150,
                              child: Text(
                                bidder['BidTime'],
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                          DataCell(
                            Container(
                              width: 50,
                              child: Text(
                                bidder['UserID'].toString(),
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                          DataCell(
                            Container(
                              width: 100,
                              child: Text(
                                NumberFormat.simpleCurrency(locale: 'id', decimalDigits: 0).format(bidder['Nominal']).toString(),
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ]
                      )
                    ).toList()
                    // rows: [],
                  )
                )
              )
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
    
    return bidders;
  }
}