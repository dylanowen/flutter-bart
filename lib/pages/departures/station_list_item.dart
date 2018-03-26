import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bart/bart/station.dart';
import 'package:flutter_bart/pages/departures/station_departures_page.dart';
import 'package:flutter_bart/utils/logging.dart';
import 'package:logging/logging.dart';

Logger _log = Logging.build(StationListItem);

class StationListItem extends StatefulWidget {

  final Station station;

  StationListItem({this.station}) :
        super(key: new ValueKey(station.abbreviation));

  @override
  _StationState createState() {
    return new _StationState();
  }

}

class _StationState extends State<StationListItem> {

  _StationState();

  @override
  Widget build(BuildContext context) {
    final Widget page = new StationDeparturesPage(station: widget.station);

    return new ListTile(
      title: new Text(widget.station.name),
      onTap: () => Navigator.of(context).push(new PageRouteBuilder(
          pageBuilder: (BuildContext context, _, __) {
            return page;
          },
          transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
            return new FadeTransition(
              opacity: animation,
              child: child,
            );
          }
      )),
    );
  }
}