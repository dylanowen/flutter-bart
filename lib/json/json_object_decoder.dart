import 'package:flutter_bart/json/json_decoder.dart';
import 'package:flutter_bart/json/parse_exception.dart';
import 'package:flutter_bart/json/value_type.dart';

typedef S MapConstructor<S>(Map<Symbol, dynamic> map);

class JsonObjectDecoder<S> extends JsonValueDecoder<Map<String, dynamic>, S> {

  final Map<Symbol, JsonEntryDecoder> _decoders;
  final MapConstructor<S> _constructor;
  final List<JsonObjectDecoder> _inherited;

  final Map<String, Symbol> _symbolMap;

  JsonObjectDecoder(Map<Symbol, JsonEntryDecoder> _decoders,
      this._constructor,
      ObjectType<S> valueType,
      [List<JsonObjectDecoder> _inherited]):
        this._decoders = _decoders,
        this._symbolMap = _decoders.map((key, decoder) => new MapEntry(decoder.key, key)),
        this._inherited = _inherited ?? [],
        super(valueType);

  Map<Symbol, dynamic> decodeToMap(Map<String, dynamic> input, List<String> stack) {
    if (input == null) {
      throw new ParseException('Unexpected null input for object', stack);
    }

    final Map<String, dynamic> cleanCopy = new Map.from(input)
    // remove every null value and unmatched key
      ..removeWhere((key, value) => value == null || !_symbolMap.containsKey(key));

    final Map<Symbol, dynamic> results = {};

    // add all our parent's results
    _inherited.forEach((parent) => results.addAll(parent.decodeToMap(input, stack)));

    final Map<Symbol, dynamic> thisResultMap = cleanCopy
        .map((key, value) {
          final Symbol symbol = _symbolMap[key];
          final JsonEntryDecoder entryDecoder = _decoders[symbol];
          final JsonValueDecoder decoder = entryDecoder.decoder;
          assert(symbol != null && entryDecoder != null);

          final List<String> newStack = new List.from(stack)..add('.$key');

          decoder.validateInput(value, newStack);

          try {
            return new MapEntry(symbol, decoder.decode(value, newStack));
          } on ParseException catch(e) {
            throw e;
          } catch (e) {
            throw new ParseException('Failed to parse object', stack, e);
          }
        });

    results.addAll(thisResultMap);

    return results;
  }

  @override
  S decode(Map<String, dynamic> input, List<String> stack) {
    final Map<Symbol, dynamic> results = decodeToMap(input, stack);

    try {
      return _constructor(results);
    } catch (e) {
      throw new ParseException('Failed to build object with ${_constructor.toString}', stack, e);
    }
  }
}