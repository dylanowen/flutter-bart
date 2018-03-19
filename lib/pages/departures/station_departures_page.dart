import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bart/bart/bart_client.dart';
import 'package:flutter_bart/bart/station.dart';
import 'package:flutter_bart/bart/station_departures.dart';
import 'package:flutter_bart/system.dart';

class StationDeparturesPage extends StatefulWidget {
  final BartClient client;
  final Station station;

  StationDeparturesPage({this.station, RuntimeSystem system})
      : this.client = new BartClient((system ?? RuntimeSystem.get()).config),
        super(key: new LabeledGlobalKey(station.abbreviation));

  @override
  _StationDepartureState createState() {
    final _StationDepartureState state = new _StationDepartureState();
    //state.refreshStations();

    return state;
  }
}

class _StationDepartureState extends State<StationDeparturesPage> {
  Timer timer;
  List<Departure> _departures;

  void _refresh() {
    widget.client.getDepartures(widget.station).then((StationDepartures stationDepartures) {
      if (mounted) {
        setState(() {
          _departures = stationDepartures.departures;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();

    // do an initial call
    _refresh();

    // start our timer
    timer = new Timer.periodic(new Duration(seconds: 10), (Timer _) => _refresh());
  }

  @override
  void dispose() {
    // cancel our timer
    timer.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String str = '';
    _departures?.forEach((Departure departure) {
      str += departure.destination + '\n';
      str += departure.estimates.map((Estimate estimate) {
        return estimate.minutes;
      }).join(' ') + '\n';
    });

    return new Scaffold(
        appBar: new AppBar(title: new Text(widget.station.name)),
        body: new Center(
          child: new Text(widget.station.abbreviation + ": " + widget.station.name + '\n' + str),
        ));
  }
}
