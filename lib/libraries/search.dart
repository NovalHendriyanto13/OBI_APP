import 'package:flutter/material.dart';

class Search extends SearchDelegate {
  String selectedResult;
  final List source;
  
  Search(this.source);

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget> [
      IconButton(
        icon: const Icon(Icons.close), 
        onPressed: () {
          query = '';
        }
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back), 
      onPressed: () {
        Navigator.pop(context);
      }
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container(
      child: Center(
        child: Text(selectedResult),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List result = [];
    query.isNotEmpty
      ? result = this.source
      : result.addAll(this.source.where((element) => element.contains(query)));

    return ListView.builder(
      itemCount: result.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('filtered')
        );
      }
    );
  }
}