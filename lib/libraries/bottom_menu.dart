import 'package:flutter/material.dart';

class BottomMenu {
  BottomNavigationBar initialize() {
    return BottomNavigationBar(
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
          backgroundColor: Colors.red
        )
      ],
      selectedItemColor: Colors.red.shade900,
    );
  }
}