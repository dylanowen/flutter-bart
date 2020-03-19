import 'dart:convert';

import 'package:flutter_bart/json/json_list_decoder.dart';
import 'package:flutter_bart/json/json_object_decoder.dart';
import 'package:flutter_bart/json/json_simple_decoder.dart';
import 'package:flutter_bart/json/parse_exception.dart';
import 'package:flutter_bart/json/value_type.dart';

class JsonEntryDecoder<E, D> {
  final String key;
  final JsonValueDecoder<E, D> decoder;

  JsonEntryDecoder(this.key, this.decoder);
}

abstract class JsonValueDecoder<E, D> extends Converter<E, D> {

  final ValueType<E, D> entryType;

  const JsonValueDecoder(this.entryType);

  D decode(E input, List<String> stack);

  @override
  D convert(E input) => decode(input, const ['root']);

  void validateInput(dynamic input, List<String> path) {
    if (!entryType.isIn(input)) {
      final Type inputType = input.runtimeType;

      throw new ParseException('Unexpected type $inputType for ${input.toString()}', path);
    }
  }
}

abstract class TypedDecoder {

  TypedDecoder._singleton();

  static JsonEntryDecoder<E, D> simple<E, D>(String key, ValueType<E, D> valueType, [ParserFunction<E, D> decoder]) {
    if (decoder != null) {
      return new JsonEntryDecoder(key, new SimpleValueDecoder(decoder, valueType));
    }
    else {
      return new JsonEntryDecoder(key, simpleValue<E, D>(valueType));
    }
  }

  static JsonEntryDecoder<Map<String, dynamic>, D> object<D>(String key, JsonObjectDecoder<D> decoder) {
    return new JsonEntryDecoder(key, decoder);
  }

  static JsonEntryDecoder<List<dynamic>, List<D>> list<D>(String key, JsonValueDecoder<dynamic, D> decoder) {
    return new JsonEntryDecoder(key, listValue<D>(decoder));
  }


  static JsonEntryDecoder<int, int> intToInt(String key) {
    return TypedDecoder.simple(key, ValueType.intToInt);
  }

  static JsonEntryDecoder<int, double> intToDouble(String key) {
    return TypedDecoder.simple(key, ValueType.intToDouble);
  }

  static JsonEntryDecoder<int, String> intToString(String key) {
    return TypedDecoder.simple(key, ValueType.intToString);
  }

  static JsonEntryDecoder<int, bool> intToBool(String key) {
    return TypedDecoder.simple(key, ValueType.intToBool);
  }


  static JsonEntryDecoder<double, int> doubleToInt(String key) {
    return TypedDecoder.simple(key, ValueType.doubleToInt);
  }

  static JsonEntryDecoder<double, double> doubleToDouble(String key) {
    return TypedDecoder.simple(key, ValueType.doubleToDouble);
  }

  static JsonEntryDecoder<double, String> doubleToString(String key) {
    return TypedDecoder.simple(key, ValueType.doubleToString);
  }

  static JsonEntryDecoder<double, bool> doubleToBool(String key) {
    return TypedDecoder.simple(key, ValueType.doubleToBool);
  }


  static JsonEntryDecoder<String, int> stringToInt(String key) {
    return TypedDecoder.simple(key, ValueType.stringToInt);
  }

  static JsonEntryDecoder<String, double> stringToDouble(String key) {
    return TypedDecoder.simple(key, ValueType.stringToDouble);
  }

  static JsonEntryDecoder<String, String> stringToString(String key) {
    return TypedDecoder.simple(key, ValueType.stringToString);
  }

  static JsonEntryDecoder<String, bool> stringToBool(String key) {
    return TypedDecoder.simple(key, ValueType.stringToBool);
  }


  static JsonEntryDecoder<bool, int> boolToInt(String key) {
    return TypedDecoder.simple(key, ValueType.boolToInt);
  }

  static JsonEntryDecoder<bool, double> boolToDouble(String key) {
    return TypedDecoder.simple(key, ValueType.boolToDouble);
  }

  static JsonEntryDecoder<bool, String> boolToString(String key) {
    return TypedDecoder.simple(key, ValueType.boolToString);
  }

  static JsonEntryDecoder<bool, bool> boolToBool(String key) {
    return TypedDecoder.simple(key, ValueType.boolToBool);
  }


  static JsonValueDecoder<E, D> simpleValue<E, D>(ValueType<E, D> valueType) {
    return JsonSimpleDecoder.get<E, D>(valueType);
  }

  static JsonObjectDecoder<D> objectValue<D>(Map<Symbol, JsonEntryDecoder> _decoders,
      MapConstructor<D> constructor,
      ObjectType<D> valueType,
      [List<JsonObjectDecoder> _inherited]) {
    return new JsonObjectDecoder<D>(_decoders, constructor, valueType, _inherited);
  }

  static JsonListDecoder<D> listValue<D>(JsonValueDecoder<dynamic, D> decoder) {
    return new JsonListDecoder<D>(decoder);
  }
}
