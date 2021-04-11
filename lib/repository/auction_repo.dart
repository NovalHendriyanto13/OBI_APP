import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:obi_mobile/configs/config.dart' as config;
import 'package:obi_mobile/models/m_auction.dart';
import 'package:obi_mobile/libraries/session.dart';

class AuctionRepo {
  
  final String apiUrl = config.API_URL;

  Future<M_Auction> list() async{

    Session _session = new Session();
    String token = await _session.getString('token');

    Map<String, String> header = {
      "Content-Type": "application/json",
      "Authorization": "Bearer " + token
    };

    final response = await http.post(
      Uri.http(apiUrl, 'auction'),
      headers: header,
    );

    if (response.statusCode==200) {
      return M_Auction.fromJson(jsonDecode(response.body));
    }
    else {
      throw Exception('Connect to Api Failed');
    }
  }

  Future<M_Auction> detail(id) async{
    
    Session _session = new Session();
    String token = await _session.getString('token');

    Map<String, String> header = {
      "Content-Type": "application/json",
      "Authorization": "Bearer " + token
    };

    final response = await http.post(
      Uri.http(apiUrl, 'user/' + id.toString()),
      headers: header,
    );

    if (response.statusCode==200) {
      return M_Auction.fromJson(jsonDecode(response.body));
    }
    else {
      throw Exception('Connect to Api Failed');
    }
  }
 
}