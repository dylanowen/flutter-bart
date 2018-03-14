import 'package:flutter/material.dart';
import 'package:flutter_bart/bart/bart_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bart/config.dart';

import 'dart:async';

class DeparturesPage extends StatefulWidget {

  const DeparturesPage();

  @override
  _DeparturesState createState() {
    final _DeparturesState state = new _DeparturesState();
    state.refreshStations();

    return state;
  }

}

class _DeparturesState extends State<DeparturesPage> {

  final BartClient client = new BartClient();

  final Future<SharedPreferences> preferences = SharedPreferences.getInstance();

  List<String> _stations = new List<String>();

  _DeparturesState() {
    /*
    preferences.then((prefs) => {
      prefs.getStringList('')
    });
    _stations.addAll(iterable)
    */
  }



  @override
  Widget build(BuildContext context) {
    //Navigator.of(context).push(new PopupRoute())

    return new Center(
      // Center is a layout widget. It takes a single child and positions it
      // in the middle of the parent.
      child: new ListView(
        children: _stations.map((station) {
          return new Text(station);
        }).toList(),
      ),
    );
  }

  void refreshStations() async {
    List<String> stations = await client.getStations();

    setState(() {
      _stations.addAll(stations);
    });
  }
}