import 'package:logging/logging.dart';
import 'dart:math';


abstract class Logging {

  static int _maxAlignment = 0;

  Logging._singleton();

  static Logger build(Type t) {
    return buildNamed(t.toString());
  }

  static Logger buildNamed(String name) {
    _updateAlignment(name);

    return new Logger(name);
  }

  static void init({Level level = Level.WARNING}) {
    Logger.root.level = level;

    Logger.root.onRecord.listen((LogRecord record) {
      String message = '${record.loggerName} [${record.level.name}]';

      // make the length align nicely
      while (message.length <= _maxAlignment) {
        message += ' ';
      }

      message += ' ' + record.message;

      if (record.error != null) {
        message += ' : ' + record.error;
      }

      if (record.stackTrace != null) {
        message += '\n' + record.stackTrace.toString();
      }

      print(message);
    });
  }

  static StackTrace getStackTrace() {
    try {
      throw new Exception("");
    } catch (e, s) {
      return s;
    }
  }

  static _updateAlignment(String name) {
    final int alignment = name.length
        + 2 + 2 // add for our spaces and brackets
        + Level.LEVELS.map((l) => l.name.length).fold(0, max);

    _maxAlignment = max(alignment, _maxAlignment);
  }
}