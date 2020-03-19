import 'package:flutter_bart/json/json_encoder.dart';
import 'package:flutter_bart/json/serialization_exception.dart';
import 'package:flutter_bart/json/value_type.dart';

typedef E GetterFunction<D, E>(D input);

class SimpleValueEncoder<D, E> extends JsonValueEncoder<D, E> {
  final GetterFunction<D, E> getter;

  const SimpleValueEncoder(this.getter, ValueType<D, E> valueType) : super(valueType);

  @override
  E encode(D input) {
    try {
      return getter(input);
    }
    catch (e, s) {
      throw new SerializationException('Failed to serialize', e, s);
    }
  }
}