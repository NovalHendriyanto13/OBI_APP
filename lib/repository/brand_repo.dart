import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:obi_mobile/configs/config.dart' as config;
import 'package:obi_mobile/models/m_brand.dart';
import 'package:obi_mobile/libraries/session.dart';

class BrandRepo {
  
  final String apiUrl = config.API_URL;

  Future<M_Brand> list() async{

    Session _session = new Session();
    String token = await _session.getString('token');

    Map<String, String> header = {
      "Content-Type": "application/json",
      "Authorization": "Bearer " + token
    };

    final response = await http.post(
      Uri.http(apiUrl, 'brand'),
      headers: header,
    );

    if (response.statusCode==200) {
      return M_Brand.fromJson(jsonDecode(response.body));
    }
    else {
      throw Exception('Connect to Api Failed');
    }
  }

  Future<M_Brand> detail(id) async{
    
    Session _session = new Session();
    String token = await _session.getString('token');

    Map<String, String> header = {
      "Content-Type": "application/json",
      "Authorization": "Bearer " + token
    };

    final response = await http.post(
      Uri.http(apiUrl, 'brand/' + id.toString()),
      headers: header,
    );

    if (response.statusCode==200) {
      return M_Brand.fromJson(jsonDecode(response.body));
    }
    else {
      throw Exception('Connect to Api Failed');
    }
  }

  Future<M_Brand> type() async{
    
    Session _session = new Session();
    String token = await _session.getString('token');

    Map<String, String> header = {
      "Content-Type": "application/json",
      "Authorization": "Bearer " + token
    };

    final response = await http.post(
      Uri.http(apiUrl, 'brand-type'),
      headers: header,
    );

    if (response.statusCode==200) {
      return M_Brand.fromJson(jsonDecode(response.body));
    }
    else {
      throw Exception('Connect to Api Failed');
    }
  }
 
}