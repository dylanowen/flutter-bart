class ValueType<In, Out> {

  const ValueType();

  bool isIn(dynamic toTest) {
    return toTest is In;
  }

  bool isOut(dynamic toTest) {
    return toTest is Out;
  }

  static const ValueType<int, int> intToInt = const UnitType<int>();
  static const ValueType<int, double> intToDouble = const ValueType<int, double>();
  static const ValueType<int, String> intToString = const ValueType<int, String>();
  static const ValueType<int, bool> intToBool = const ValueType<int, bool>();

  static const ValueType<double, int> doubleToInt = const ValueType<double, int>();
  static const ValueType<double, double> doubleToDouble = const UnitType<double>();
  static const ValueType<double, String> doubleToString = const ValueType<double, String>();
  static const ValueType<double, bool> doubleToBool = const ValueType<double, bool>();

  static const ValueType<String, int> stringToInt = const ValueType<String, int>();
  static const ValueType<String, double> stringToDouble = const ValueType<String, double>();
  static const ValueType<String, String> stringToString = const UnitType<String>();
  static const ValueType<String, bool> stringToBool = const ValueType<String, bool>();

  static const ValueType<bool, int> boolToInt = const ValueType<bool, int>();
  static const ValueType<bool, double> boolToDouble = const ValueType<bool, double>();
  static const ValueType<bool, String> boolToString = const ValueType<bool, String>();
  static const ValueType<bool, bool> boolToBool = const UnitType<bool>();
}

class UnitType<T> extends ValueType<T, T> {
  const UnitType();
}

class ObjectType<Out> extends ValueType<Map<String, dynamic>, Out> {
  const ObjectType();
}

class ListType<Out> extends ValueType<List<dynamic>, List<Out>> {
  const ListType();
}