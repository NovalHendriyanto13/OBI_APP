import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:obi_mobile/configs/config.dart' as config;
import 'package:obi_mobile/libraries/search.dart';
import 'package:obi_mobile/models/m_auction.dart';
import 'package:obi_mobile/libraries/session.dart';
import 'package:obi_mobile/libraries/refresh_token.dart';

class AuctionRepo {
  
  final String apiUrl = config.API_URL;
  RefreshToken _refreshToken = RefreshToken();

  Future<M_Auction> list() async{

    await _refreshToken.run();

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

    await _refreshToken.run();
    
    Session _session = new Session();
    String token = await _session.getString('token');

    Map<String, String> header = {
      "Content-Type": "application/json",
      "Authorization": "Bearer " + token
    };

    final response = await http.post(
      Uri.http(apiUrl, 'auction_detail/' + id.toString()),
      headers: header,
    );

    if (response.statusCode==200) {
      return M_Auction.fromJson(jsonDecode(response.body));
    }
    else {
      throw Exception('Connect to Api Failed');
    }
  }

  Future<M_Auction> unit(param) async{

    await _refreshToken.run();
    
    Session _session = new Session();
    String token = await _session.getString('token');

    final data = jsonEncode(param);
    var response;

    Map<String, String> header = {
      "Content-Type": "application/json",
      "Authorization": "Bearer " + token
    };

    if (param != null) {
      response = await http.post(
        Uri.http(apiUrl, 'auction_detail'),
        headers: header,
        body: data
      );
    }
    else {
      response = await http.post(
        Uri.http(apiUrl, 'auction_detail'),
        headers: header,
      );
    }

    if (response.statusCode==200) {
      return M_Auction.fromJson(jsonDecode(response.body));
    }
    else {
      throw Exception('Connect to Api Failed');
    }
  }

  Future<M_Auction> nowNext() async{

    await _refreshToken.run();
    
    Session _session = new Session();
    String token = await _session.getString('token');

    Map<String, String> header = {
      "Content-Type": "application/json",
      "Authorization": "Bearer " + token
    };

    final response = await http.post(
      Uri.http(apiUrl, 'now-next'),
      headers: header,
    );

    if (response.statusCode==200) {
      return M_Auction.fromJson(jsonDecode(response.body));
    }
    else {
      throw Exception('Connect to Api Failed');
    }
  }

  Future<M_Auction> search(id, param) async{

    await _refreshToken.run();
    
    Session _session = new Session();
    String token = await _session.getString('token');

    Map<String, String> header = {
      "Content-Type": "application/json",
      "Authorization": "Bearer " + token
    };

    final data = jsonEncode(param);

    final response = await http.post(
      Uri.http(apiUrl, 'auction-detail-search/' + id.toString()),
      headers: header,
      body: data
    );

    if (response.statusCode==200) {
      return M_Auction.fromJson(jsonDecode(response.body));
    }
    else {
      throw Exception('Connect to Api Failed');
    }
  }

  Future<M_Auction> liveUnit(id) async{

    await _refreshToken.run();
    
    Session _session = new Session();
    String token = await _session.getString('token');

    Map<String, String> header = {
      "Content-Type": "application/json",
      "Authorization": "Bearer " + token
    };

    final response = await http.get(
      Uri.http(apiUrl, 'live-auction-unit/' + id.toString()),
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