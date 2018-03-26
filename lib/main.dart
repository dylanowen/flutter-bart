import 'package:flutter/material.dart';
import 'package:flutter_bart/pages/favorites/favorites_page.dart';
import 'package:flutter_bart/pages/map_page.dart';
import 'package:flutter_bart/pages/settings_page.dart';
import 'package:flutter_bart/pages/departures/departures_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bart/utils/logging.dart';
import 'package:logging/logging.dart';

void main() => runApp(new App());

class App extends StatelessWidget {

  App() {
    Logging.init(level: Level.ALL);
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'test',
      home: new MainNavigation(),
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}

class MainNavigation extends StatefulWidget {
  @override
  _NavigationState createState() => new _NavigationState();
}

class _PageNavigation {
  final BottomNavigationBarItem navigationItem;
  final Widget page;

  const _PageNavigation({
    @required this.navigationItem,
    @required this.page,
  })
      : assert(navigationItem != null),
        assert(page != null);
}

class _NavigationState extends State<MainNavigation> {
  static const String test = '';

  int _currentIndex = 0;
  static List<_PageNavigation> _navigationItems = <_PageNavigation>[
    const _PageNavigation(
      navigationItem: const BottomNavigationBarItem(
        icon: const Icon(Icons.star),
        title: const Text('Favorites'),
        backgroundColor: Colors.deepOrange,
      ),
      page: const FavoritesPage(),
    ),
    new _PageNavigation(
      navigationItem: const BottomNavigationBarItem(
        icon: const Icon(Icons.train),
        title: const Text('Routes'),
        backgroundColor: Colors.blue,
      ),
      page: new DeparturesPage(),
    ),
    const _PageNavigation(
      navigationItem: const BottomNavigationBarItem(
        icon: const Icon(Icons.map),
        title: const Text('Map'),
        backgroundColor: Colors.green,
      ),
      page: const MapPage(),
    ),
    const _PageNavigation(
      navigationItem: const BottomNavigationBarItem(
        icon: const Icon(Icons.settings),
        title: const Text('Settings'),
        backgroundColor: Colors.grey,
      ),
      page: const SettingsPage(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final BottomNavigationBar bottomNavigationBar = new BottomNavigationBar(
      items: _navigationItems
          .map(
              (_PageNavigation navigationItem) => navigationItem.navigationItem)
          .toList(),
      currentIndex: _currentIndex,
      //type: _type,
      onTap: (int index) {
        setState(() {
          //_navigationViews[_currentIndex].controller.reverse();
          _currentIndex = index;
          //_navigationViews[_currentIndex].controller.forward();
        });
      },
    );

    return new Scaffold(
        body: _navigationItems[_currentIndex].page,
        bottomNavigationBar: bottomNavigationBar);
  }
}
