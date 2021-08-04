import 'package:flutter/material.dart';
// import 'package:obi_mobile/libraries/search.dart';

class SearchBar {
  BuildContext _context;
  bool _useNotification, _useSearch;
  // List _searchSource;
  Icon _searchIcon = Icon(Icons.search);

  SearchBar(BuildContext context, bool useSearch, bool useNotification) {
    this._context = context;
    this._useNotification = useNotification;
    this._useSearch = useSearch;
    // this._searchSource = searchSource;
  }

  List<Widget> build() {
    List<Widget> _widgets = [];
    if (this._useSearch == true) {
      _widgets.addAll([
        IconButton(
          icon: this._searchIcon, 
          onPressed: () {
            // showSearch(context: this._context, delegate: Search(this._searchSource));
            if (this._searchIcon.icon == Icons.search) {
              this._searchIcon = Icon(Icons.close);
              return TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Search..'
                ),
              );
            }
            else {
              this._searchIcon = Icon(Icons.search);
              return false;
            }
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