import 'package:flutter/material.dart';
import 'package:flutter_bart/bart/bart_client.dart';
import 'package:flutter_bart/bart/station.dart';
import 'package:flutter_bart/pages/departures/station_list_item.dart';
import 'package:flutter_bart/system.dart';
import 'package:flutter_bart/utils/preference.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:async';

class DeparturesPage extends StatefulWidget {
  final BartClient client;

  DeparturesPage({RuntimeSystem system})
      : client = new BartClient((system ?? RuntimeSystem.get()).config);

  @override
  _DeparturesState createState() {
    final _DeparturesState state = new _DeparturesState();
    state.refreshStations();

    return state;
  }
}

class _DeparturesState extends State<DeparturesPage> {
  static PreferenceList<Station> cachedStations =
      new PreferenceList('bart.cached-stations', Station.codec);

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

  void _favoriteUpdated(String abbreviation) {}

  @override
  Widget build(BuildContext context) {
    //Navigator.of(context).push(new PopupRoute())

    return new Navigator(
      initialRoute: '/',
      onGenerateRoute: (RouteSettings settings) {
        return new PageRouteBuilder(pageBuilder: (BuildContext context, _, __) {
          return new ListView(
            children: _stations
                .map((Station station) => new StationListItem(station: station))
                .toList(),
          );
        });
      },
    );
  }

  void refreshStations() async {
    List<Station> stations = await widget.client.getStations();

    setState(() {
      _stations.addAll(stations);
    });

    cachedStations.set(stations);
  }
}
