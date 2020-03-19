import 'package:flutter_bart/json/json_decoder.dart';
import 'package:flutter_bart/json/parse_exception.dart';
import 'package:flutter_bart/json/value_type.dart';

typedef D ParserFunction<E, D>(E input);

class SimpleValueDecoder<E, D> extends JsonValueDecoder<E, D> {
  final ParserFunction<E, D> parser;

  const SimpleValueDecoder(this.parser, ValueType<E, D> valueType) : super(valueType);

  @override
  D decode(E input, List<String> path) {
    try {
      return parser(input);
    }
    catch (e, s) {
      throw new ParseException('Failed to parse', path, e, s);
    }
  }
}

class UnitValueDecoder<T> extends SimpleValueDecoder<T, T> {
  const UnitValueDecoder(ValueType<T, T> valueType) : super(
    UnitValueDecoder.parse,
    valueType,
  );

  static T parse<T>(T input) => input;
}

class SimpleToStringDecoder<E> extends SimpleValueDecoder<E, String> {

  const SimpleToStringDecoder(ValueType<E, String> valueType) : super(
    SimpleToStringDecoder.parse,
    valueType,
  );

  static String parse<T>(T input) => input.toString();
}


class IntToDoubleDecoder extends SimpleValueDecoder<int, double> {

  const IntToDoubleDecoder() : super(
    IntToDoubleDecoder.parse,
    ValueType.intToDouble,
  );

  static double parse(int input) => input.toDouble();
}

class IntToBoolDecoder extends SimpleValueDecoder<int, bool> {

  const IntToBoolDecoder() : super(
    IntToBoolDecoder.parse,
    ValueType.intToBool,
  );

  static bool parse(int input) => input != 0;
}


class DoubleToIntDecoder extends SimpleValueDecoder<double, int> {

  const DoubleToIntDecoder() : super(
    DoubleToIntDecoder.parse,
    ValueType.doubleToInt,
  );

  static int parse(double input) => input.round();
}

class DoubleToBoolDecoder extends SimpleValueDecoder<double, bool> {

  const DoubleToBoolDecoder() : super(
    DoubleToBoolDecoder.parse,
    ValueType.doubleToBool,
  );

  static bool parse(double input) => input != 0.0;
}


class StringToIntDecoder extends SimpleValueDecoder<String, int> {

  const StringToIntDecoder() : super(
    StringToIntDecoder.parse,
    ValueType.stringToInt,
  );

  static int parse(String input) => int.parse(input);
}

class StringToDoubleDecoder extends SimpleValueDecoder<String, double> {

  const StringToDoubleDecoder() : super(
    StringToDoubleDecoder.parse,
    ValueType.stringToDouble,
  );

  static double parse(String input) => double.parse(input);
}

class StringToBoolDecoder extends SimpleValueDecoder<String, bool> {

  const StringToBoolDecoder() : super(
    StringToBoolDecoder.parse,
    ValueType.stringToBool,
  );

  static bool parse(String input) {
    final String lowerCase = input.toLowerCase();

    return lowerCase == 'true' || lowerCase == 'yes' || lowerCase == '0';
  }
}

class BoolToIntDecoder extends SimpleValueDecoder<bool, int> {

  const BoolToIntDecoder() : super(
    BoolToIntDecoder.parse,
    ValueType.boolToInt,
  );

  static int parse(bool input) => (input) ? 1 : 0;
}

class BoolToDoubleDecoder extends SimpleValueDecoder<bool, double> {

  const BoolToDoubleDecoder() : super(
    BoolToDoubleDecoder.parse,
    ValueType.boolToDouble,
  );

  static double parse(bool input) => (input) ? 1.0 : 0.0;
}

// some dummy values to match with
const int _intTest = 0;
const double _doubleTest = 0.0;
const String _strTest = '';
const bool _boolTest = false;

typedef bool _TypeTest(dynamic input);

class JsonSimpleDecoder {

  JsonSimpleDecoder._noImpl();

  static JsonValueDecoder get<E, D>(ValueType<E, D> valueType) {
    final Symbol tType = _getType(valueType.isIn);
    final Symbol sType = _getType(valueType.isOut);

    if (tType == sType) {
      return new UnitValueDecoder(valueType);
    }
    if (sType == #string) {
      return new SimpleToStringDecoder<E>(valueType as ValueType<E, String>);
    }

    if (tType == #int) {
      if (sType == #double) {
        return new IntToDoubleDecoder();
      }
      else if (sType == #bool) {
        return new IntToBoolDecoder();
      }
    }
    else if (tType == #double) {
      if (sType == #int) {
        return new DoubleToIntDecoder();
      }
      else if (sType == #bool) {
        return new DoubleToBoolDecoder();
      }
    }
    else if (tType == #string) {
      if (sType == #int) {
        return new StringToIntDecoder();
      }
      else if (sType == #double) {
        return new StringToDoubleDecoder();
      }
      else if (sType == #bool) {
        return new StringToBoolDecoder();
      }
    }
    else if (tType == #bool) {
      if (sType == #int) {
        return new BoolToIntDecoder();
      }
      else if (sType == #double) {
        return new BoolToDoubleDecoder();
      }
    }

    throw 'Invalid types for simple json decoder';
  }

  static Symbol _getType(_TypeTest tester) {
    return tester(_intTest) ? #int :
    tester(_doubleTest) ? #double :
    tester(_strTest) ? #string :
    tester(_boolTest) ? #bool : #none;
  }
}