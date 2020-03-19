/// Capture the stack trace of the source when rethrowing an exception
abstract class WrappedException implements Exception {

  final StackTrace stackTrace;

  const WrappedException(this.stackTrace);
}