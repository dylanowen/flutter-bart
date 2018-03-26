import 'dart:convert';

import 'package:flutter_bart/json/json_list_decoder.dart';
import 'package:flutter_bart/json/json_object_decoder.dart';
import 'package:flutter_bart/json/json_simple_decoder.dart';
import 'package:flutter_bart/json/parse_exception.dart';
import 'package:flutter_bart/json/value_type.dart';

class JsonEntryDecoder<T, S> {
  final String key;
  final JsonValueDecoder<T, S> decoder;

  JsonEntryDecoder(this.key, this.decoder);
}

abstract class JsonValueDecoder<T, S> extends Converter<T, S> {

  final ValueType<T, S> entryType;

  const JsonValueDecoder(this.entryType);

  S decode(T input, List<String> stack);

  @override
  S convert(T input) => decode(input, const ['root']);

  void validateInput(dynamic input, List<String> stack) {
    if (!entryType.isIn(input)) {
      final Type inputType = input.runtimeType;

      throw new ParseException('Unexpected type $inputType for ${input.toString()}', stack);
    }
  }
}

abstract class TypedDecoder {

  static JsonEntryDecoder<T, S> simple<T, S>(String key, ValueType<T, S> valueType, [ParserFunction<T, S> decoder]) {
    if (decoder != null) {
      return new JsonEntryDecoder(key, new SimpleValueDecoder(decoder, valueType));
    }
    else {
      return new JsonEntryDecoder(key, simpleValue<T, S>(valueType));
    }
  }

  static JsonEntryDecoder<Map<String, dynamic>, S> object<S>(String key, JsonObjectDecoder<S> decoder) {
    return new JsonEntryDecoder(key, decoder);
  }

  static JsonEntryDecoder<List<dynamic>, List<S>> list<S>(String key, JsonValueDecoder<dynamic, S> decoder) {
    return new JsonEntryDecoder(key, listValue<S>(decoder));
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


  static JsonValueDecoder<T, S> simpleValue<T, S>(ValueType<T, S> valueType) {
    return JsonSimpleDecoder.get<T, S>(valueType);
  }

  static JsonObjectDecoder<S> objectValue<S>(Map<Symbol, JsonEntryDecoder> _decoders,
      MapConstructor<S> constructor,
      ObjectType<S> valueType,
      [List<JsonObjectDecoder> _inherited]) {
    return new JsonObjectDecoder<S>(_decoders, constructor, valueType, _inherited);
  }

  static JsonListDecoder<S> listValue<S>(JsonValueDecoder<dynamic, S> decoder) {
    return new JsonListDecoder<S>(decoder);
  }
}
