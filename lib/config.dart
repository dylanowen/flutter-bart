import 'package:flutter/services.dart' show rootBundle;

import 'dart:convert';
import 'dart:async';

class Config {
  static final Future<Config> _singletonFuture = Config._load();

  final Map<String, dynamic> _json;

  Config._singleton(Map<String, dynamic> json) : this._json = json;

  String get bartApiKey {
    return _json['bart']['api-key'];
  }

  static Future<Config> get() {
    return _singletonFuture;
  }

  static Future<Config> _load() {
    return rootBundle.loadString("assets/config.json")
        .then((String configString) {
          Map<String, dynamic> json = JSON.decode(configString);

          return new Config._singleton(json);
        });
  }
}