import 'dart:async';
import 'dart:convert';

import 'package:flutter_bart/utils/unit_codec.dart';
import 'package:shared_preferences/shared_preferences.dart';


abstract class _AbstractPreference<S, T> {
  static const Codec<String, String> unitStringCodec = const UnitCodec<String>();
  static Future<SharedPreferences> _preferences = SharedPreferences.getInstance();

  final String key;
  final Codec<S, String> codec;

  _AbstractPreference(String key, Codec<S, Object> codec):
        this.key = key,
        this.codec = codec.fuse<Object>(JSON);

  Future<T> call();

  Future<void> set(T input);
}

class Preference<S> extends _AbstractPreference<S, S> {
  Preference(String key, Codec<S, Object> codec): super(key, codec);

  @override
  Future<S> call() async {
    final SharedPreferences prefs = await _AbstractPreference._preferences;
    final String str = prefs.getString(key);

    return (str != null) ? codec.decode(str) : null;
  }

  @override
  Future<void> set(S input) {
    return _AbstractPreference._preferences.then((prefs) {
      final String value = codec.encode(input);

      prefs.setString(key, value);

      return null;
    });
  }
}

class PreferenceList<S> extends _AbstractPreference<S, List<S>> {

  PreferenceList(String key, Codec<S, Object> codec): super(key, codec);

  @override
  Future<List<S>> call() async {
    final SharedPreferences prefs = await _AbstractPreference._preferences;

    return prefs.getStringList(key)
      ?.map(codec.decode)
      ?.toList();
  }

  @override
  Future<void> set(List<S> input) {
    return _AbstractPreference._preferences.then((prefs) {
      final List<String> value = input.map(codec.encode);

      prefs.setStringList(key, value);

      return null;
    });
  }
}

class PreferenceString extends Preference<String> {
  PreferenceString(String key): super(key, _AbstractPreference.unitStringCodec);
}

class PreferenceStringList extends PreferenceList<String> {
  PreferenceStringList(String key): super(key, _AbstractPreference.unitStringCodec);
}