import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:wifiscan/app/controllers/mqtt_controller.dart';
import 'package:wifiscan/app/controllers/preference_controller.dart';
import 'package:wifiscan/app/controllers/server_controller.dart';
import 'package:wifiscan/app/routes/app_routes.dart';
import 'package:wifiscan/app/ui/pages/home/widgets/no_connection_widget.dart';
import 'package:wifiscan/app/ui/pages/home/widgets/station_card.dart';
import 'package:wifiscan/app/ui/widgets/loading_widget.dart';
//https://pub.dev/packages/screen

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  MqttController _mqtt;
  ServerController _server;
  bool isSwitched = false;
  bool _value03 = false;

  @override
  void initState() {
    // observador para conectar ao MQTT
    WidgetsBinding.instance.addObserver(this);
    super.initState();

    // orientação
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    _mqtt = Get.put(MqttController());
    _server = Get.put(ServerController());

    // último servidor válido.
    _connectFromPreferences();

    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        titleSpacing: 0.0,
        elevation: 5.0,
        backgroundColor: Colors.blue[900],
        title: Row(
          children: <Widget>[
            Container(
                margin: EdgeInsets.fromLTRB(10, 8, 10, 8),
                child: CircleAvatar(
                  child: Icon(
                    Icons.wifi,
                    color: Colors.redAccent,
                  ),
                ),
                decoration: new BoxDecoration(
                  border: new Border.all(
                    color: Colors.white,
                    width: 1.0,
                  ),
                  borderRadius: new BorderRadius.all(new Radius.circular(10.0)),
                )),
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
              child: RichText(
                text: TextSpan(
                    text: "Wi-Fi ",
                    style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                    children: [
                      TextSpan(
                          text: "Scan",
                          style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.red))
                    ]),
              )
              ,
            )
          ],
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10),
            child: Center(
                child:AdvancedSwitch(
                  activeColor: Colors.amber[700],
                  inactiveColor: Colors.green[700],
                  width: 50,
                  height: 20,
                  value: _value03,
                  inactiveChild: Icon(
                      Icons.bar_chart
                  ),
                  activeChild: Icon(
                      Icons.stacked_line_chart_sharp
                  ),
                  onChanged: (value) => setState(() {
                    _value03 = value;
                    _mqtt.onHistograma(_value03);
                  }),
                )
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    child: Text(
                      'MQTT',
                      style: TextStyle(fontSize: 12.0),
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Obx(() {
                        if (_mqtt.isConnected)
                          return Icon(
                            Icons.link,
                            color: Colors.green,
                          );
                        return Icon(
                          Icons.link_off,
                          color: Colors.red,
                        );
                      })
                    ],
                  ),
                ]),
          ),
          Obx(() {
            // Cria os botões de acordo com o estado de conexão atual.
            if (_mqtt.isConnected)
              return IconButton(
                icon: Icon(Icons.logout),
                onPressed: _mqtt.loading ? null : _mqtt.closeConnection,
              );
            return IconButton(
              icon: Icon(Icons.settings),
              onPressed:
              _mqtt.loading ? null : () => Get.toNamed(Routes.SERVER),
            );
          })
        ],
      ),
      body: Obx(() => Stack(
        children: [
          !_mqtt.loading && !_mqtt.isConnected
              ? NoConnectionWidget()
              : ListView.builder(
            itemCount: _mqtt.stations.length,
            itemBuilder: (context, index) =>
                StationCard(station: _mqtt.stations[index]),
          ),
          _mqtt.loading
              ? LoadingWidget(
            message: "Conectando ao Servidor.\nPor favor, aguarde.",
          )
              : const SizedBox()
        ],
      )),
    );
  }

  void _connectFromPreferences() {
    PreferenceController.getServer().then((value) {
      if (value != null) {
        _server.server = value;
        _mqtt.startConnection(server: value);
      } else
        Get.toNamed(Routes.SERVER);
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (_mqtt != null && _mqtt.autoReconnect) {
        _connectFromPreferences();
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _mqtt.closeConnection();
    super.dispose();
  }
}
