import 'package:flutter/material.dart';
import 'package:obi_mobile/libraries/drawer_menu.dart';
import 'package:obi_mobile/libraries/bottom_menu.dart';
import 'package:obi_mobile/libraries/session.dart';

class Home extends StatefulWidget {
  static String tag = 'home-page';
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  DrawerMenu _drawerMenu = new DrawerMenu();
  BottomMenu _bottomMenu = new BottomMenu();
  Session _session = new Session();
  String _token;

  List<String> images = [  
    "https://static.javatpoint.com/tutorial/flutter/images/flutter-logo.png",  
    "https://static.javatpoint.com/tutorial/flutter/images/flutter-logo.png",  
    "https://static.javatpoint.com/tutorial/flutter/images/flutter-logo.png",  
    "https://static.javatpoint.com/tutorial/flutter/images/flutter-logo.png"  
  ];  
  
  // @override
  void initState() {
    super.initState();

    _getSession();
  }

  _getSession() async {
    final token = await _session.getString('token');
    setState(() {
      _token = token;
    });
  }

  
  @override
  Widget build(BuildContext context) {
    Drawer _menu = _drawerMenu.initialize(context, Home.tag);
    BottomNavigationBar _bottomNav = _bottomMenu.initialize();

    Widget _schedule = Container(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 4.0,
              mainAxisSpacing: 4.0
            ), 
            itemBuilder: (BuildContext context, int index) {
              return Image.network(images[index]);
            },
            itemCount: images.length,
          )
    );

    Widget _filterItems = Container(
      padding: const EdgeInsets.all(16),
      child: Card(
        elevation: 50,
        shadowColor: Colors.grey.shade400,
        child: SizedBox(
          width: 300,
          height: 500,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text('test'),
                Text('data')
              ],
            ),
          ),
        ),
      ),
    );
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        backgroundColor: Colors.red,
      ),
      drawer: _menu,
      bottomNavigationBar: _bottomNav,
      body: Center(
        child: ListView(
          children: <Widget>[
            _schedule,
            _filterItems
          ],
        ),
      ),      
    );
  }

}