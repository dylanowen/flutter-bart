import 'package:flutter_bart/bart/station.dart';
import 'package:flutter_bart/utils/simple_codec.dart';

const String _etdKey = 'etd';

class StationDepartures extends Station {

  static SimpleDecoder<StationDepartures> decoder = new SimpleDecoder({
    #etd: 'etd',
  }
    ..addAll(Station.JsonKeys), StationDepartures.fromMap);

  final List<Departure> departures;

  const StationDepartures(String abbreviation,
      String name,
      this.departures) : super(abbreviation, name);

  static StationDepartures fromMap(Map<Symbol, dynamic> map) {
    return new StationDepartures(
      map[#abbr],
      map[#name],
      (map[#etd] as List<dynamic>).map(Departure.decoder.convert).toList(),
    );
  }
}

class Departure {
  static SimpleDecoder<Departure> decoder = new SimpleDecoder({
    #destination: 'destination',
    #abbreviation: 'abbreviation',
    #limited: 'limited',
    #estimate: 'estimate',
  }, Departure.fromMap);

  final String destination;
  final String abbreviation;
  final int limited;
  final List<Estimate> estimates;

  const Departure(this.destination, this.abbreviation, this.limited,
      this.estimates);

  static Departure fromMap(Map<Symbol, dynamic> map) {
    return new Departure(
      map[#destination],
      map[#abbreviation],
      map[#limited],
      (map[#estimate] as List<dynamic>).map(Estimate.decoder.convert).toList(),
    );
  }
}

class Estimate {

  static SimpleDecoder<Estimate> decoder = new SimpleDecoder({
    #minutes: 'minutes',
    #platform: 'platform',
    #direction: 'direction',
    #length: 'length',
    #color: 'color',
    #hexColor: 'hexColor',
    #bikeFlag: 'bikeFlag',
    #delay: 'delay',
  }, Estimate.fromMap);

  final int minutes;
  final int platform;
  final String direction;
  final int length;
  final String color;
  final String hexColor;
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
      map[#bikeFlag],
      map[#delay],
    );
  }
}