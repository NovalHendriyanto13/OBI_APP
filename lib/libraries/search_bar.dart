import 'package:flutter/material.dart';

class SearchBar {
  BuildContext _context;
  bool _useNotification, _useSearch;
  
  SearchBar(BuildContext context, bool useSearch, bool useNotification) {
    this._context = context;
    this._useNotification = useNotification;
    this._useSearch = useSearch;
  }

  List<Widget> build() {
    List<Widget> _widgets = [];
    if (this._useSearch == true) {
      _widgets.addAll([
        IconButton(
          icon: const Icon(Icons.search), 
          onPressed: ()=>{

          })
      ]);
    }
    if (this._useNotification == true) {
      _widgets.addAll([
        new IconButton(
          icon: const Icon(Icons.notifications), 
          onPressed: () {

          })
      ]);
    }
    return _widgets;
  }

}