
class ParseException implements Exception {
  final String message;
  final List<String> stack;
  final dynamic cause;

  ParseException(this.message, this.stack, [this.cause]);

  @override
  String toString() {
    return '$message\n${this.stack.join('')}\n${cause?.toString() ?? ''}';
  }
}