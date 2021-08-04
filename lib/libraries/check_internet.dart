import 'package:obi_mobile/configs/config.dart' as config;
import 'dart:io';
import 'package:flutter/material.dart';

class CheckInternet {
  Future<bool> checkInternet() async {
    try {
      final response = await InternetAddress.lookup(config.CHECK_INTERNET);
      if (response.isNotEmpty) {
        return true;
      }
    }
    on SocketException catch(err) {
      print(err);
      return false;
    }
  }

  check(BuildContext context) async {
    bool check = await this.checkInternet();
    if (check == false) {
      return showDialog(
        context: context, 
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Internet Connection Error'),
            content: const Text('No Internet Connection. Make sure that Wi-Fi or mobile data is turned on, then try again'),
            actions: <Widget>[
              TextButton(
                onPressed: () => { Navigator.pop(context, 'OK') }, 
                child: const Text('OK')
              )
            ],
          );
        }
      );
    }
  }
}