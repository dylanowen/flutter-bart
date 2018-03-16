import 'package:flutter/material.dart';
import 'package:flutter_bart/bart/bart_client.dart';
import 'package:flutter_bart/bart/station.dart';
import 'package:flutter_bart/pages/departures/station_list_item.dart';
import 'package:flutter_bart/utils/preference.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:async';

class DeparturesPage extends StatefulWidget {

  const DeparturesPage();

  @override
  _DeparturesState createState() {
    final _DeparturesState state = new _DeparturesState();
    //state.refreshStations();

    return state;
  }

}

class _DeparturesState extends State<DeparturesPage> {

  static PreferenceList<Station> cachedStations = new PreferenceList(
      'bart.cached-stations', Station.codec);
  static PreferenceList<String> favoriteStations = new PreferenceStringList(
      'bart.favorite-stations');

  final BartClient client = new BartClient();

  final Future<SharedPreferences> preferences = SharedPreferences.getInstance();

  List<Station> _stations = new List<Station>();

  _DeparturesState() {
    cachedStations().then((stations) {
      if (stations != null) {
        setState(() {
          _stations = stations;
        });
      }
    });
    //_stations.addAll(iterable)
  }

  void _favoriteUpdated(String abbreviation) {

  }

  @override
  Widget build(BuildContext context) {
    //Navigator.of(context).push(new PopupRoute())

    return new Center(
      // Center is a layout widget. It takes a single child and positions it
      // in the middle of the parent.
      child: new ListView(
        children: _stations
            .map((Station station) => new StationListItem(station: station))
            .toList(),
      ),
    );
  }

  void refreshStations() async {
    List<Station> stations = await client.getStations();

    setState(() {
      _stations.addAll(stations);
    });

    cachedStations.set(stations);
  }
}