import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bart/bart/station.dart';

class StationDeparturesPage extends StatefulWidget {

  final Station station;

  StationDeparturesPage({this.station}) :
        super(key: new LabeledGlobalKey(station.abbreviation));

  @override
  _StationDepartureState createState() {
    final _StationDepartureState state = new _StationDepartureState(station);
    //state.refreshStations();

    return state;
  }

}

class _StationDepartureState extends State<StationDeparturesPage> {

  final Station station;

  _StationDepartureState(this.station);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(station.name)
      ),
      body: new Center(
        child: new Text(station.abbreviation + ": " + station.name),
      )
    );
  }
}