import 'dart:convert';

import 'package:flutter_bart/json/json_simple_decoder.dart';
import 'package:flutter_bart/json/value_type.dart';

class JsonEntryEncoder<D, E> {
  final String key;
  final JsonValueEncoder<D, E> encoder;

  JsonEntryEncoder(this.key, this.encoder);
}

abstract class JsonValueEncoder<D, E> extends Converter<D, E> {

  final ValueType<D, E> entryType;

  const JsonValueEncoder(this.entryType);

  E encode(D input);

  @override
  E convert(D input) => encode(input);
}

abstract class TypedEncoder {

  TypedEncoder._singleton();

  static JsonEntryEncoder<D, E> simple<D, E>(String key, ValueType<D, E> valueType, [ParserFunction<D, E> decoder]) {
    if (decoder != null) {
      return new JsonEntryEncoder(key, new SimpleValueDecoder(decoder, valueType));
    }
    else {
      return new JsonEntryEncoder(key, simpleValue<D, E>(valueType));
    }
  }

  static JsonEntryEncoder<Map<String, dynamic>, e> object<E>(String key, JsonObjectEncoder<E> decoder) {
    return new JsonEntryEncoder(key, decoder);
  }

  static JsonEntryEncoder<List<dynamic>, List<E>> list<E>(String key, JsonValueEncoder<dynamic, D> decoder) {
    return new JsonEntryEncoder(key, listValue<E>(decoder));
  }


  static JsonEntryEncoder<int, int> intToInt(String key) {
    return TypedEncoder.simple(key, ValueType.intToInt);
  }

  static JsonEntryEncoder<int, double> intToDouble(String key) {
    return TypedEncoder.simple(key, ValueType.intToDouble);
  }

  static JsonEntryEncoder<int, String> intToString(String key) {
    return TypedEncoder.simple(key, ValueType.intToString);
  }

  static JsonEntryEncoder<int, bool> intToBool(String key) {
    return TypedEncoder.simple(key, ValueType.intToBool);
  }


  static JsonEntryEncoder<double, int> doubleToInt(String key) {
    return TypedEncoder.simple(key, ValueType.doubleToInt);
  }

  static JsonEntryEncoder<double, double> doubleToDouble(String key) {
    return TypedEncoder.simple(key, ValueType.doubleToDouble);
  }

  static JsonEntryEncoder<double, String> doubleToString(String key) {
    return TypedEncoder.simple(key, ValueType.doubleToString);
  }

  static JsonEntryEncoder<double, bool> doubleToBool(String key) {
    return TypedEncoder.simple(key, ValueType.doubleToBool);
  }


  static JsonEntryEncoder<String, int> stringToInt(String key) {
    return TypedEncoder.simple(key, ValueType.stringToInt);
  }

  static JsonEntryEncoder<String, double> stringToDouble(String key) {
    return TypedEncoder.simple(key, ValueType.stringToDouble);
  }

  static JsonEntryEncoder<String, String> stringToString(String key) {
    return TypedEncoder.simple(key, ValueType.stringToString);
  }

  static JsonEntryEncoder<String, bool> stringToBool(String key) {
    return TypedEncoder.simple(key, ValueType.stringToBool);
  }


  static JsonEntryEncoder<bool, int> boolToInt(String key) {
    return TypedEncoder.simple(key, ValueType.boolToInt);
  }

  static JsonEntryEncoder<bool, double> boolToDouble(String key) {
    return TypedEncoder.simple(key, ValueType.boolToDouble);
  }

  static JsonEntryEncoder<bool, String> boolToString(String key) {
    return TypedEncoder.simple(key, ValueType.boolToString);
  }

  static JsonEntryEncoder<bool, bool> boolToBool(String key) {
    return TypedEncoder.simple(key, ValueType.boolToBool);
  }


  static JsonValueEncoder<D, E> simpleValue<D, E>(ValueType<D, E> valueType) {
    return JsonSimpleDecoder.get<D, E>(valueType);
  }

  static JsonObjectDecoder<E> objectValue<E>(Map<Symbol, JsonEntryEncoder> _decoders,
      MapConstructor<E> constructor,
      ObjectType<E> valueType,
      [List<JsonObjectDecoder> _inherited]) {
    return new JsonObjectDecoder<E>(_decoders, constructor, valueType, _inherited);
  }

  static JsonListDecoder<E> listValue<E>(JsonValueEncoder<dynamic, D> decoder) {
    return new JsonListDecoder<E>(decoder);
  }
}