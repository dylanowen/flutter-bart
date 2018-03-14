import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:flutter_bart/pages/map_page.dart';
import 'package:flutter_bart/pages/settings_page.dart';
import 'package:flutter_bart/pages/departures_page.dart';
import 'package:flutter/foundation.dart';

void main() => runApp(new App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'test',
      home: new MainNavigation(),
      theme: new ThemeData(
        primarySwatch: Colors.deepOrange,
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
      :
        assert(navigationItem != null),
        assert(page != null);
}

class _NavigationState extends State<MainNavigation> {

  static const String test = '';

  int _currentIndex = 0;
  static const List<_PageNavigation> _navigationItems = const <_PageNavigation>[
    const _PageNavigation(
      navigationItem: const BottomNavigationBarItem(
        icon: const Icon(Icons.train),
        title: const Text('Routes'),
      ),
      page: const DeparturesPage(),
    ),
    const _PageNavigation(
      navigationItem: const BottomNavigationBarItem(
        icon: const Icon(Icons.map),
        title: const Text('Map'),
      ),
      page: const MapPage(),
    ),
    const _PageNavigation(
      navigationItem: const BottomNavigationBarItem(
        icon: const Icon(Icons.settings),
        title: const Text('Settings'),
      ),
      page: const SettingsPage(),
    ),
  ];

  @override
  void initState() {
    super.initState();
    /*
    for (NavigationIconView view in _navigationViews)
      view.controller.addListener(_rebuild);

    _navigationViews[_currentIndex].controller.value = 1.0;
    */
  }

  /*
  @override
  void dispose() {
    for (_NavigationItem view in _navigationViews)
      view.controller.dispose();
    super.dispose();
  }


  Widget _buildTransitionsStack() {
    final List<FadeTransition> transitions = <FadeTransition>[];

    for (NavigationIconView view in _navigationViews)
      transitions.add(view.transition(_type, context));

    // We want to have the newly animating (fading in) views on top.
    transitions.sort((FadeTransition a, FadeTransition b) {
      final Animation<double> aAnimation = a.opacity;
      final Animation<double> bAnimation = b.opacity;
      final double aValue = aAnimation.value;
      final double bValue = bAnimation.value;
      return aValue.compareTo(bValue);
    });

    return new Stack(children: transitions);
  }
  */

  @override
  Widget build(BuildContext context) {
    final BottomNavigationBar bottomNavigationBar = new BottomNavigationBar(
      items: _navigationItems
          .map((_PageNavigation navigationItem) =>
      navigationItem.navigationItem)
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
        bottomNavigationBar: bottomNavigationBar
    );

    /*
    return new Scaffold(
      appBar: new AppBar(
        title: const Text('Bottom navigation'),
        actions: <Widget>[
          new PopupMenuButton<BottomNavigationBarType>(
            onSelected: (BottomNavigationBarType value) {
              setState(() {
                _type = value;
              });
            },
            itemBuilder: (BuildContext context) =>
            <PopupMenuItem<BottomNavigationBarType>>[
              const PopupMenuItem<BottomNavigationBarType>(
                value: BottomNavigationBarType.fixed,
                child: const Text('Fixed'),
              ),
              const PopupMenuItem<BottomNavigationBarType>(
                value: BottomNavigationBarType.shifting,
                child: const Text('Shifting'),
              )
            ],
          )
        ],
      ),
      body: new Center(
          child: _buildTransitionsStack()
      ),
      bottomNavigationBar: botNavBar,
    );
    */
  }

}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.green,
      ),
      home: new MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String _info = "";

  void _incrementCounter() async {
    Uri uri = Uri.parse(
        'http://api.bart.gov/api/etd.aspx?cmd=etd&orig=12th&key=ZS4R-PRDK-98LT-DWE9&json=y');
    var httpClient = new HttpClient();

    String result;
    try {
      var request = await httpClient.getUrl(uri);
      var response = await request.close();
      if (response.statusCode == HttpStatus.OK) {
        var json = await response.transform(UTF8.decoder).join();
        var data = JSON.decode(json);
        result = data['root']['date'];
      } else {
        result =
        'Error getting IP address:\nHttp status ${response.statusCode}';
      }
    } catch (exception) {
      result = 'Failed getting IP address';
    }

    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
      this._info = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return new Scaffold(
      appBar: new AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: new Text(widget.title),
      ),
      body: new Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: new Column(
          // Column is also layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug paint" (press "p" in the console where you ran
          // "flutter run", or select "Toggle Debug Paint" from the Flutter tool
          // window in IntelliJ) to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text(
              _info,
            ),
            new Text(
              'You have pushed the button this many times:',
            ),
            new Text(
              '$_counter',
              style: Theme
                  .of(context)
                  .textTheme
                  .display1,
            ),
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
