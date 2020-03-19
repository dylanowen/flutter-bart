import 'package:flutter_bart/utils/wrapped_exception.dart';


class ParseException extends WrappedException {
  final String message;
  final List<String> path;
  final Object cause;

  ParseException(this.message, this.path, [this.cause, StackTrace stackTrace]): super(stackTrace);

  @override
  String toString() {
    final String causeMessage = (cause != null) ? ' : ' + cause.toString() : '';

    return '$message at ${this.path.join('')}$causeMessage';
  }
}