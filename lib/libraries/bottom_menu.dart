import 'package:flutter/material.dart';
import 'package:obi_mobile/pages/area.dart';
import 'package:obi_mobile/pages/home.dart';
import 'package:obi_mobile/pages/buy_npl.dart';
import 'package:obi_mobile/pages/bid.dart';

class BottomMenu {
  BottomNavigationBar initialize(BuildContext context) {
    int _currentIndex = 0;
    List _pageList = [
      Home.tag,
      BuyNpl.tag,
      Bid.tag,
      "tes",
      Area.tag
    ];

    return BottomNavigationBar(
      currentIndex: _currentIndex,
      items: const <BottomNavigationBarItem> [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_filled),
          label: 'Home',
          backgroundColor: Colors.red
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home_filled),
          label: 'My NPL',
          backgroundColor: Colors.red
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home_filled),
          label: 'Lelang',
          backgroundColor: Colors.red
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.drive_eta),
          label: 'Daftar Barang',
          backgroundColor: Colors.red
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home_filled),
          label: 'Titip Jual',
          backgroundColor: Colors.red,     
        )
      ],
      selectedItemColor: Colors.red.shade900,
      onTap: (index) {
        // setState() {
          _currentIndex = index;
        // }

        Navigator.of(context).pushReplacementNamed(_pageList[index]);
      },
    );
  }
}