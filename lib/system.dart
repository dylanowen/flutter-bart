import 'dart:async';

import 'package:flutter_bart/config.dart';


class RuntimeSystem {

  static final RuntimeSystem _singleton = new RuntimeSystem._withDefaults();

  final Future<Config> config;

  RuntimeSystem._withDefaults():
      this.config = Config.get();

  static RuntimeSystem get() {
    return RuntimeSystem._singleton;
  }
}