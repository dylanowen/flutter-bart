import 'package:flutter/foundation.dart';
import 'package:flutter_bart/bart/station.dart';
import 'package:flutter_bart/json/json_decoder.dart';
import 'package:flutter_bart/json/json_object_decoder.dart';
import 'package:flutter_bart/json/json_simple_decoder.dart';
import 'package:flutter_bart/json/value_type.dart';
import 'package:flutter_bart/json/parse_exception.dart';
import 'package:flutter_bart/utils/logging.dart';
import 'package:logging/logging.dart';

@immutable
class StationDepartures extends Station {

  static JsonObjectDecoder<StationDepartures> decoder = TypedDecoder.objectValue<StationDepartures>({
    #etd: TypedDecoder.list('etd', Departure.decoder),
  }, StationDepartures.fromMap, const ObjectType<StationDepartures>(), [Station.decoder]);

  final List<Departure> departures;

  const StationDepartures(String abbreviation,
      String name,
      this.departures) : super(abbreviation, name);

  static StationDepartures fromMap(Map<Symbol, dynamic> map) {
    return new StationDepartures(
      map[#abbr],
      map[#name],
      map[#etd],
    );
  }
}

@immutable
class Departure {

  static JsonObjectDecoder<Departure> decoder = TypedDecoder.objectValue<Departure>({
    #destination: TypedDecoder.stringToString('destination'),
    #abbreviation: TypedDecoder.stringToString('abbreviation'),
    #limited: TypedDecoder.stringToBool('limited'),
    #estimate: TypedDecoder.list('estimate', Estimate.decoder),
  }, Departure.fromMap, const ObjectType<Departure>(), [Station.decoder]);

  final String destination;
  final String abbreviation;
  final bool limited;
  final List<Estimate> estimates;

  const Departure(this.destination, this.abbreviation, this.limited,
      this.estimates);

  static Departure fromMap(Map<Symbol, dynamic> map) {
    return new Departure(
      map[#destination],
      map[#abbreviation],
      map[#limited],
      map[#estimate],
    );
  }
}

@immutable
class Estimate {

  static Logger log = Logging.build(Estimate);

  static JsonObjectDecoder<Estimate> decoder = TypedDecoder.objectValue<Estimate>({
    #minutes: TypedDecoder.simple<String, int>('minutes', ValueType.stringToInt, (String input) {
      return (input.toLowerCase() == 'leaving') ? 0 : StringToIntDecoder.parse(input);
    }),
    #platform: TypedDecoder.stringToInt('platform'),
    #direction: TypedDecoder.stringToString('direction'),
    #length: TypedDecoder.stringToInt('length'),
    #color: TypedDecoder.stringToString('color'),
    #hexColor: TypedDecoder.simple('hexcolor', ValueType.stringToInt, (str) {
      final String color = "FF" + str.substring(1);

      try {
        return int.parse(color, radix: 16);
      } on FormatException catch(e) {
        log.warning('Failed to parse "$color" to int', e);
        // fall back to missing graphics pink for our color
        return 0xFFEB40F7;
      }
    }),
    #bikeFlag: TypedDecoder.stringToBool('bikeFlag'),
    #delay: TypedDecoder.stringToInt('delay'),
  }, Estimate.fromMap, const ObjectType<Estimate>());

  final int minutes;
  final int platform;
  final String direction;
  final int length;
  final String color;
  final int hexColor;
  final bool bikeFlag;
  final int delay;

  const Estimate(this.minutes,
      this.platform,
      this.direction,
      this.length,
      this.color,
      this.hexColor,
      this.bikeFlag,
      this.delay);

  static Estimate fromMap(Map<Symbol, dynamic> map) {
    return new Estimate(
      map[#minutes],
      map[#platform],
      map[#direction],
      map[#length],
      map[#color],
      map[#hexColor],
      map[#bikeflag],
      map[#delay],
    );
  }
}