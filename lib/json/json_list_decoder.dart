import 'package:flutter_bart/json/json_decoder.dart';
import 'package:flutter_bart/json/parse_exception.dart';
import 'package:flutter_bart/json/value_type.dart';


class JsonListDecoder<S> extends JsonValueDecoder<List<dynamic>, List<S>> {

  JsonValueDecoder<dynamic, S> _decoder;

  JsonListDecoder(this._decoder): super(new ListType<S>());

  @override
  List<S> decode(List<dynamic> inputList, List<String> path) {
    final List<S> result = [];

    for (int i = 0; i < inputList.length; i++) {
      final dynamic input = inputList[i];
      final List<String> newPath = new List.from(path)..add('[$i]');

      _decoder.validateInput(input, newPath);

      try {
        result.add(_decoder.decode(input, newPath));
      } on ParseException catch(e) {
        throw e;
      } catch (e) {
        throw new ParseException('Failed to parse list', newPath, e);
      }
    }

    return result;
  }
}
