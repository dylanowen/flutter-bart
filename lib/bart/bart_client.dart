import 'package:flutter_bart/bart/station.dart';
import 'package:flutter_bart/bart/station_departures.dart';
import 'package:flutter_bart/config.dart';
import 'dart:async';
import 'dart:io';
import 'dart:convert';

class ClientException implements Exception {

  final String message;

  ClientException(this.message);

  @override
  String toString() {
    return this.message;
  }
}

class BartClient {

  static const String _bartBaseUrl = 'http://api.bart.gov/api';

  Future<Config> _config = Config.get();
  HttpClient _client = new HttpClient();

  Future<List<Station>> getStations() async {
    final Uri uri = await _buildUri(
        path: '/stn.aspx',
        queryParms: { 'cmd': 'stns'}
    );
    final Map<String, dynamic> json = await _getCall(uri);
    List<Map<String, String>> stations = json['root']['stations']['station'];

    return stations.map(Station.codec.decoder.convert).toList();
  }

  Future<List<StationDepartures>> getDepartures(Station station) async {
    final Uri uri = await _buildUri(
        path: '/etd.aspx',
        queryParms: {
          'cmd': 'etd',
          'orig': station.abbreviation,
        }
    );

    final Map<String, dynamic> json = await _getCall(uri);
    List<Map<String, String>> stations = json['root']['station'];

    return stations.map(StationDepartures.decoder.convert).toList();
  }

  Future<Map<String, dynamic>> _getCall(Uri url) async {
    final HttpClientRequest request = await _client.getUrl(url);
    final HttpClientResponse response = await request.close();

    if (response.statusCode == HttpStatus.OK) {
      var json = await response.transform(UTF8.decoder).join();

      return JSON.decode(json);
    }
    else {
      throw new ClientException(
          'Unexpected response code: ${response.statusCode}');
    }
  }

  Future<Uri> _buildUri({
    String path,
    Map<String, String> queryParms = const {}
  }) async {
    final String apiKey = await _config.then((config) => config.bartApiKey);
    final Map<String, String> allQueryParms = {
      'key': apiKey,
      'json': 'y',
    };
    allQueryParms.addAll(queryParms);

    final String queryParmString = allQueryParms.entries.map((entry) {
      return "${entry.key}=${entry.value}";
    }).join('&');

    return Uri.parse("$_bartBaseUrl$path?$queryParmString");
  }
}