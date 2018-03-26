import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bart/bart/bart_client.dart';
import 'package:flutter_bart/bart/station.dart';
import 'package:flutter_bart/bart/station_departures.dart';
import 'package:flutter_bart/system.dart';
import 'package:flutter_bart/utils/logging.dart';
import 'package:logging/logging.dart';

Logger log = Logging.build(StationDeparturesPage);

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

class _DepartureListItem extends StatelessWidget {

  Departure departure;

  _DepartureListItem({this.departure});

  @override
  Widget build(BuildContext context) {
    return new ListTile(
      title: new Text(
        this.departure.abbreviation + ": " + this.departure.destination,
        style: new TextStyle(
          decorationColor: new Color(0)
        )
      ),
      subtitle: new Row(
        children: this.departure.estimates.map((Estimate e) {
          return new Text(
              e.minutes.toString() + " ",
              style: new TextStyle(color: new Color(e.hexColor))
          );
        }).toList(),
      ),
    );
  }
}

class _StationDepartureState extends State<StationDeparturesPage> {

  Timer timer;
  List<Departure> _departures;

  void _refresh() {
    log.info('Refreshing for ${widget.station.abbreviation}');

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
    Widget body;
    if (_departures != null) {
      body = new ListView(
        children: _departures
            .map((Departure departure) => new _DepartureListItem(departure: departure))
            .toList(),
      );
    }
    else {
      body = new Center(
        child: new Icon(Icons.file_download)
      );
    }

    return new Scaffold(
        appBar: new AppBar(title: new Text(widget.station.name)),
        body: body,
    );
  }
}
