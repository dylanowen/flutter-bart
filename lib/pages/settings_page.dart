import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {

  const SettingsPage();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new Center(
      // Center is a layout widget. It takes a single child and positions it
      // in the middle of the parent.
      child: new Column(

        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Text(
            'I am a settings:',
          ),
        ],
      ),
    );
  }
}