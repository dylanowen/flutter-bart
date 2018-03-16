import 'package:flutter_bart/utils/simple_codec.dart';


class Station {

  static const Map<Symbol, String> JsonKeys = const {
    #abbr: 'abbr',
    #name: 'name'
  };

  static SimpleCodec<Station> codec = new SimpleCodec(JsonKeys, {
    #abbr: (s) => s.abbreviation,
    #name: (s) => s.name,
  }, Station.fromMap);

  final String name;
  final String abbreviation;

  const Station(this.abbreviation, this.name);

  static Station fromMap(Map<Symbol, dynamic> map) {
    return new Station(map[#abbr], map[#name]);
  }
}


/*


class StationEncoder extends Converter<Station, Map<String, String>> {
  @override
  Map<String, String> convert(Station input) {
    return {
      _abbrKey: input.abbreviation,
      _nameKey: input.name,
    };
  }
}

class StationDecoder extends Converter<Map<String, String>, Station> {

  static const singleton = const StationDecoder();

  const StationDecoder();

  @override
  Station convert(Map<String, String> input) {
    return new Station(input[_abbrKey], input[_nameKey]);
  }
}*/