import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:obi_mobile/configs/config.dart' as config;
import 'package:obi_mobile/models/m_bid.dart';
import 'package:obi_mobile/libraries/session.dart';

class BidRepo {
  
  final String apiUrl = config.API_URL;

  Future<M_Bid> list() async{
    
    Session _session = new Session();
    String token = await _session.getString('token');

    Map<String, String> header = {
      "Content-Type": "application/json",
      "Authorization": "Bearer " + token
    };

    final response = await http.post(
      Uri.http(apiUrl, 'bid'),
      headers: header
    );

    if (response.statusCode==200) {
      return M_Bid.fromJson(jsonDecode(response.body));
    }
    else {
      throw Exception('Connect to Api Failed');
    }
  }

  Future<M_Bid> submit(params) async {

    Session _session = new Session();
    String token = await _session.getString('token');

    Map<String, String> header = {
      "Content-Type": "application/json",
      "Authorization": "Bearer " + token
    };

    final data = jsonEncode(params);

    final response = await http.post(
      Uri.http(apiUrl, 'submit-bid'),
      headers: header,
      body: data
    );

    if (response.statusCode==200) {
      return M_Bid.fromJson(jsonDecode(response.body));
    }
    else {
      throw Exception('Connect to Api Failed');
    }
  }
  
  Future<M_Bid> live(params) async {

    Session _session = new Session();
    String token = await _session.getString('token');

    Map<String, String> header = {
      "Content-Type": "application/json",
      "Authorization": "Bearer " + token
    };

    final data = jsonEncode(params);

    final response = await http.post(
      Uri.http(apiUrl, 'live-bid'),
      headers: header,
      body: data
    );

    if (response.statusCode==200) {
      return M_Bid.fromJson(jsonDecode(response.body));
    }
    else {
      throw Exception('Connect to Api Failed');
    }
  }

  Future<M_Bid> lastBid(params) async {

    Session _session = new Session();
    String token = await _session.getString('token');

    Map<String, String> header = {
      "Content-Type": "application/json",
      "Authorization": "Bearer " + token
    };

    final data = jsonEncode(params);

    final response = await http.post(
      Uri.http(apiUrl, 'last-bid'),
      headers: header,
      body: data
    );

    if (response.statusCode==200) {
      return M_Bid.fromJson(jsonDecode(response.body));
    }
    else {
      throw Exception('Connect to Api Failed');
    }
  }

  Future<M_Bid> lastUserBid(params) async {

    Session _session = new Session();
    String token = await _session.getString('token');

    Map<String, String> header = {
      "Content-Type": "application/json",
      "Authorization": "Bearer " + token
    };

    final data = jsonEncode(params);

    final response = await http.post(
      Uri.http(apiUrl, 'last-user-bid'),
      headers: header,
      body: data
    );

    if (response.statusCode==200) {
      return M_Bid.fromJson(jsonDecode(response.body));
    }
    else {
      throw Exception('Connect to Api Failed');
    }
  }

  Future<M_Bid> deleteBid(params) async {

    Session _session = new Session();
    String token = await _session.getString('token');

    Map<String, String> header = {
      "Content-Type": "application/json",
      "Authorization": "Bearer " + token
    };

    final data = jsonEncode(params);

    final response = await http.post(
      Uri.http(apiUrl, 'cancel-bid'),
      headers: header,
      body: data
    );

    if (response.statusCode==200) {
      return M_Bid.fromJson(jsonDecode(response.body));
    }
    else {
      throw Exception('Connect to Api Failed');
    }
  }
}