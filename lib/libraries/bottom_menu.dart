import 'package:flutter/material.dart';
import 'package:obi_mobile/pages/area.dart';
import 'package:obi_mobile/pages/home.dart';
import 'package:obi_mobile/pages/buy_npl.dart';
import 'package:obi_mobile/pages/room.dart';
import 'package:obi_mobile/pages/auction_unit.dart';

class BottomMenu {
  BottomNavigationBar initialize(BuildContext context, page) {
    int _currentIndex = 0;
    List _pageList = [
      Home.tag,
      BuyNpl.tag,
      Room.tag,
      AuctionUnit.tag,
      Area.tag
    ];
    if (page != null) {
      _currentIndex = _pageList.indexOf(page);
    }
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      items: const <BottomNavigationBarItem> [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_filled),
          label: 'Home',
          backgroundColor: Colors.red,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.copy_rounded),
          label: 'Beli NPL',
          backgroundColor: Colors.red
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.apps),
          label: 'Lelang',
          backgroundColor: Colors.red
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.drive_eta),
          label: 'Daftar Barang',
          backgroundColor: Colors.red
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bus_alert),
          label: 'Titip Jual',
          backgroundColor: Colors.red,     
        )
      ],
      selectedItemColor: Colors.grey,
      onTap: (index) {
        Navigator.of(context).pushReplacementNamed(_pageList[index]);
      },
    );
  }
}