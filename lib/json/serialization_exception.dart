import 'package:flutter_bart/utils/wrapped_exception.dart';

class SerializationException extends WrappedException {
  final String message;
  final Object cause;

  SerializationException(this.message, [this.cause, StackTrace stackTrace]): super(stackTrace);

  @override
  String toString() {
    final String causeMessage = (cause != null) ? ' : ' + cause.toString() : '';

    return '$message$causeMessage';
  }
}