import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_bart/json/json_decoder.dart';
import 'package:flutter_bart/json/json_object_decoder.dart';
import 'package:flutter_bart/utils/simple_codec.dart';
import 'package:flutter_bart/json/value_type.dart';

@immutable
class Station {

  static const Map<Symbol, String> JsonKeys = const {
    #abbr: 'abbr',
    #name: 'name',
  };

  static Map<Symbol, MapperGet> getters = {
    #abbr: (s) => s.abbreviation,
    #name: (s) => s.name,
  };

  static JsonObjectDecoder<Station> decoder = TypedDecoder.objectValue<Station>({
    #abbr: TypedDecoder.stringToString('abbr'),
    #name: TypedDecoder.stringToString('name'),
  }, Station.fromMap, const ObjectType<Station>());

  static SimpleCodec<Station> codec = new SimpleCodec(JsonKeys, getters, Station.fromMap);

  final String name;
  final String abbreviation;

  const Station(this.abbreviation, this.name);

  static Station fromMap(Map<Symbol, dynamic> map) {
    return new Station(map[#abbr], map[#name]);
  }
}

@immutable
class StationDetail extends Station {

  static JsonObjectDecoder<StationDetail> decoder = TypedDecoder.objectValue<Station>({
    #latitude: TypedDecoder.stringToDouble('latitude'),
    #longitude: TypedDecoder.stringToDouble('longitude'),
  }, Station.fromMap, const ObjectType<StationDetail>(), [Station.decoder]);

  final double latitude;
  final double longitude;

  const StationDetail(String abbreviation, String name, this.latitude, this.longitude): super(abbreviation, name);

  static StationDetail fromMap(Map<Symbol, dynamic> map) {
    return new StationDetail(
        map[#abbr],
        map[#name],
        double.parse(map[#latitude]),
        double.parse(map[#longitude]),
    );
  }
}