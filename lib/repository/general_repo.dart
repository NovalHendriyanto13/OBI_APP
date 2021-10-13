import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:obi_mobile/configs/config.dart' as config;
import 'package:obi_mobile/models/m_general.dart';

class GeneralRepo {
  
  final String apiUrl = config.API_URL;

  Future<M_General> getServerTime() async{

    Map<String, String> header = {
      "Content-Type": "application/json",
    };

    final response = await http.get(
      Uri.http(apiUrl, 'general/server-time'),
      headers: header,
    );

    if (response.statusCode==200) {
      return M_General.fromJson(jsonDecode(response.body));
    }
    else {
      throw Exception('Connect to Api Failed');
    }
  }
   
}