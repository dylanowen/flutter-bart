import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bart/bart/station.dart';


class StationListItem extends StatefulWidget {

  final Station station;

  StationListItem({this.station}) :
        super(key: new ValueKey(station.abbreviation));

  @override
  _StationState createState() {
    return new _StationState(station);
  }

}

class _StationState extends State<StationListItem> {

  final Station station;

  _StationState(this.station);

  @override
  Widget build(BuildContext context) {
    return new ListTile(
        title: new Text(station.name)
    );
  }
}