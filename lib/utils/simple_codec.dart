import 'dart:convert';

typedef dynamic MapperGet<S>(S s);
typedef S MapperConstructor<S>(Map<Symbol, dynamic> map);

class SimpleEncoder<S> extends Converter<S, Object> {
  final Map<Symbol, String> jsonKeys;
  final Map<Symbol, MapperGet> getters;

  const SimpleEncoder(this.jsonKeys, this.getters);

  @override
  dynamic convert(S input) {
    final Iterable<MapEntry<String, dynamic>> entries = getters.entries.map((
        entry) {
      return new MapEntry(jsonKeys[entry.key], entry.value(input));
    });

    return new Map.fromEntries(entries);
  }
}

class SimpleDecoder<S> extends Converter<Object, S> {
  final Map<String, Symbol> jsonKeys;
  final MapperConstructor<S> constructor;

  SimpleDecoder(Map<Symbol, String> jsonKeys, this.constructor):
      // flip our keys
      this.jsonKeys = new Map.fromEntries(jsonKeys.entries.map((entry) =>
        new MapEntry(entry.value, entry.key)
      ));

  @override
  S convert(dynamic input) {
    final Iterable<MapEntry<Symbol, dynamic>> filteredEntries =
    input.entries
        .where((entry) => jsonKeys.containsKey(entry.key))
        .map((entry) => new MapEntry(jsonKeys[entry.key], entry.value));

    return constructor(new Map.fromEntries(filteredEntries));
  }
}

class SimpleCodec<S> extends Codec<S, Object> {

  //final Map<Symbol, String> jsonKeys;
  final Converter<S, Object> encoder;
  final Converter<Object, S> decoder;

  SimpleCodec(
      Map<Symbol, String> jsonKeys,
      Map<Symbol, MapperGet> getters,
      MapperConstructor<S> constructor
    ):
        encoder = new SimpleEncoder(jsonKeys, getters),
        decoder = new SimpleDecoder(jsonKeys, constructor);
}