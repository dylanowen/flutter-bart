import 'dart:convert';

class UnitConverter<S> extends Converter<S, S> {

  const UnitConverter();

  @override
  S convert(S input) => input;
}

class UnitCodec<S> extends Codec<S, S> {
  final Converter<S, S> converter;

  const UnitCodec() :
        converter = const UnitConverter();

  @override
  Converter<S, S> get encoder => converter;

  @override
  Converter<S, S> get decoder => converter;
}