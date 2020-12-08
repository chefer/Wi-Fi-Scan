import 'package:shared_preferences/shared_preferences.dart';
import 'package:wifiscan/app/models/server.dart';
import 'package:wifiscan/app/models/station.dart';
import 'dart:convert';

// salva os dados no smartphone.
class PreferenceController {
  static const SERVER_KEY = "server";
  static const STATIONS_KEY = "stations";

  static Future<void> setServer(Server server) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(SERVER_KEY, json.encode(server.toJson()));
  }

  static Future<Server> getServer() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String prefValue = prefs.getString(SERVER_KEY);
    if (prefValue == null) return null;

    return Server.fromJson(json.decode(prefValue));
  }

  static Future<void> setStations(List<Station> stations) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String prefValue = json.encode(_toJson(stations));
    await prefs.setString(STATIONS_KEY, prefValue);
  }

  static Future<List<Station>> getStations() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String prefValue = prefs.getString(STATIONS_KEY);
    if (prefValue == null) return null;

    return _fromJson(json.decode(prefValue));
  }

  static List<Station> _fromJson(Map<String, dynamic> json) =>
      List<Station>.from(json["stations"].map((x) => Station.fromJson(x)));

  static Map<String, dynamic> _toJson(List<Station> stations) => {
        "stations": List<dynamic>.from(stations.map((x) => x.toJson())),
      };
}
