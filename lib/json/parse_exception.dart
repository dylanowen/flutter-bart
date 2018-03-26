
class ParseException implements Exception {
  final String message;
  final List<String> path;
  final Object cause;

  ParseException(this.message, this.path, [this.cause]);

  @override
  String toString() {
    return '$message\n${this.path.join('')}\n${cause?.toString() ?? ''}';
  }
}