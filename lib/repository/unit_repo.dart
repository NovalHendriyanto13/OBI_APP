import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:obi_mobile/configs/config.dart' as config;
import 'package:obi_mobile/models/m_unit.dart';
import 'package:obi_mobile/libraries/session.dart';

class UnitRepo {
  
  final String apiUrl = config.API_URL;

  Future<M_Unit> list() async{
    Session _session = new Session();
    String token = await _session.getString('token');
    int userId = await _session.getInt('id');

    final data = jsonEncode({
      "UserID": userId,
    });

    Map<String, String> header = {
      "Content-Type": "application/json",
      "Authorization": "Bearer " + token
    };

    final response = await http.post(
      Uri.http(apiUrl, 'unit'),
      headers: header,
      body: data
    );

    if (response.statusCode==200) {
      return M_Unit.fromJson(jsonDecode(response.body));
    }
    else {
      throw Exception('Connect to Api Failed');
    }
  }

  Future<M_Unit> detail(id) async{
    Session _session = new Session();
    String token = await _session.getString('token');
    
    Map<String, String> header = {
      "Content-Type": "application/json",
      "Authorization": "Bearer " + token
    };

    final response = await http.post(
      Uri.http(apiUrl, 'unit/' + id.toString()),
      headers: header,
    );

    if (response.statusCode==200) {
      return M_Unit.fromJson(jsonDecode(response.body));
    }
    else {
      throw Exception('Connect to Api Failed');
    }
  }
   
}