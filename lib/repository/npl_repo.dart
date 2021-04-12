import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:obi_mobile/configs/config.dart' as config;
import 'package:obi_mobile/models/m_npl.dart';
import 'package:obi_mobile/libraries/session.dart';

class NplRepo {
  
  final String apiUrl = config.API_URL;

  Future<M_Npl> list() async{
    
    Session _session = new Session();
    String token = await _session.getString('token');

    Map<String, String> header = {
      "Content-Type": "application/json",
      "Authorization": "Bearer " + token
    };

    final response = await http.post(
      Uri.http(apiUrl, 'npl'),
      headers: header
    );

    if (response.statusCode==200) {
      return M_Npl.fromJson(jsonDecode(response.body));
    }
    else {
      throw Exception('Connect to Api Failed');
    }
  }
   
}