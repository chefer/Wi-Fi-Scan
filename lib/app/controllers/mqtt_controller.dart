import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:uuid/uuid.dart';
import 'package:wifiscan/app/controllers/preference_controller.dart';
import 'package:wifiscan/app/models/server.dart';
import 'package:wifiscan/app/models/station.dart';

class MqttController extends GetxController {
  MqttServerClient _client;
  StreamSubscription _subscription;

  bool _autoReconnect = true;
  var _connected = false.obs;
  var _loading = false.obs;
  var _stations = RxList<Station>();
  var _histograma = false.obs;
  var uuid = Uuid();

  bool get isConnected => _connected();

  bool get loading => _loading();

  bool get autoReconnect => _autoReconnect;

  List<Station> get stations => _stations;

  bool get histograma => _histograma();


  void onHistograma(bool hist) {
    _histograma(hist);
  }

  Future<void> startConnection({@required Server server}) async {
    if (isConnected || loading) return;

    _loading(true);

    try {
      await _connect(server: server);
    } catch (e) {
      await closeConnection();
      Get.snackbar(
        "Erro",
        "Não foi possível conectar.",
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 3),
      );
      return;
    }

    _createStations(server.stationsNumber);
    _listenMqttServer();
    PreferenceController.setServer(server);
    _loading(false);
  }

  Future<void> closeConnection() async {
    if (_client == null && _subscription == null && !_connected()) return;
    _autoReconnect = false;
    _loading(true);
    await _disconnect();
    _loading(false);
  }

  Future<void> _connect({@required Server server}) async {
    try {
      MqttConnectMessage connMess = MqttConnectMessage()
          //id diferente para permitir mais de um app ao mesmo tempo no MQTT
          .withClientIdentifier('smartphone_${uuid.v1()}')
          .startClean()
          .keepAliveFor(30)
          .withWillQos(MqttQos.atMostOnce);

      _client = MqttServerClient(server.ip, '');
      _client.port = server.port;
      _client.keepAlivePeriod = 30;
      _client.onConnected = _onConnected;
      _client.onDisconnected = () => _onDisconnect(server);
      _client.connectionMessage = connMess;

      await _client.connect();
      //print('conectado!');
    } catch (e) {
      throw ("_connect error");
    }
  }

  Future<void> _disconnect() async {
    try {
      await _subscription?.cancel();
      _subscription = null;
    } catch (e) {
      print("_subscription.cancel() error ${e.toString()}");
    }

    try {
      _client?.disconnect();
      _client = null;
    } catch (e) {
      print("_client.disconnect() ${e.toString()}");
    }
  }

  void _listenMqttServer() {
    try {
      _subscription = _client.updates.listen(_onMessage);
    } catch (e) {
      if (isConnected) closeConnection();
    }
  }

  void _onMessage(event) {
    MqttPublishMessage payload = event[0].payload as MqttPublishMessage;
    var topic = "${event[0].topic}";
    var msg = MqttPublishPayload.bytesToStringAsString(payload.payload.message);

    // match da estação e tópico
    for (int i = 0; i < stations.length; i++) {
      Station s = stations[i];
      if (s.subscribedTopics.contains(topic)) {
        if (topic.toString().contains("RSSI")) {
          s.rssi = double.parse(msg);
          if (s.listRSSI.length >= 100) {
            s.listRSSI.removeAt(0);
          }
          // RANGE LIMITE (-30 to -100) PARA O GRÁFICO
          if (s.rssi > -30) {
            s.listRSSI.add(-30);
          } else if (s.rssi < -100) {
            s.listRSSI.add(-100);
          } else {
            s.listRSSI.add(s.rssi);
          }
          //100 COLUNAS DO HISTOGRAMA
          for (int i = 0; i < s.listHistograma100.length; i++)
            if (s.listHistograma100[i].isEqual(null))
              s.listHistograma100[i] = 0;

          //while (s.listHistograma100[(s.rssi.abs()).toInt()] != (s.rssi.abs()).toInt()) {
          // ignore: unrelated_type_equality_checks
          while (s.listHistograma100 != (s.rssi.abs()).toInt()) {
            s.listHistograma100[(s.rssi.abs()).toInt()]++;
            //print('| coluna = ${(s.rssi.abs()).toInt()} | valor = ${s.listHistograma100[(s.rssi.abs()).toInt()]}');
            break;
          }

          /*//4 COLUNAS DO HISTOGRAMA
          for (int i = 0; i < s.listHistograma.length; i++)
            if (s.listHistograma[i].isEqual(null))
              s.listHistograma[i] = 0;

          if (s.rssi <= -1 && s.rssi >= -50) {
            s.listHistograma[0]++;
            print("COLUNA 0 = ${s.rssi}");
          } else if (s.rssi <= -51 && s.rssi >= -60) {
            s.listHistograma[1]++;
            print("COLUNA 1 = ${s.rssi}");
          } else if (s.rssi <= -61 && s.rssi >= -70) {
            s.listHistograma[2]++;
            print("COLUNA 2 = ${s.rssi}");
          } else if (s.rssi <= -71 && s.rssi >= -100) {
            s.listHistograma[3]++;
            print("COLUNA 3 = ${s.rssi}");
          }*/

        } else if (topic.toString().contains("quality"))
          s.quality = double.parse(msg);
        else if (topic.toString().contains("voltage"))
          s.voltage = double.parse(msg);
        else if (topic.toString().contains("JSON_SCAN_NETWORK"))
          s.scan = Scan.fromJson(json.decode(msg));
        _stations[i] = s;

        PreferenceController.setStations(stations);
        break;
      }
    }
  }

  Future<void> _createStations(int stationsNumber) async {
    _stations.clear();

    List<Station> aux = await PreferenceController.getStations();
    if (aux != null && aux?.length == stationsNumber)
      _stations.addAll(aux);
    else {
      aux = [];
      for (int i = 1; i <= stationsNumber; i++) {
        String number = i < 10 ? "0$i" : "$i";
        String name = "/ESP-01/$number/";

        Station auxStation =
            Station(scan: Scan(rede: []), subscribedTopics: []);
        auxStation.name = name;
        auxStation.subscribedTopics.add(name + "RSSI/");
        auxStation.subscribedTopics.add(name + "quality/");
        auxStation.subscribedTopics.add(name + "voltage/");
        auxStation.subscribedTopics.add(name + "JSON_SCAN_NETWORK/");
        aux.add(auxStation);
      }
      _stations.addAll(aux);
    }
    PreferenceController.setStations(stations);

    for (Station s in stations)
      s.subscribedTopics.forEach((topic) => _subscribeToTopic(topic));
  }

  void _subscribeToTopic(String topic) {
    if (isConnected) _client.subscribe(topic, MqttQos.exactlyOnce);
  }

  void _onConnected() {
    _connected(true);
    _autoReconnect = true;
  }

  void _onDisconnect(Server server) {
    _connected(false);
    if (_autoReconnect) {
      _autoReconnect = false;
      startConnection(server: server);
    }
  }

  @override
  void dispose() {
    closeConnection();
    super.dispose();
  }
}
