import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wifiscan/app/controllers/mqtt_controller.dart';
import 'package:wifiscan/app/models/station.dart';
import 'package:wifiscan/app/ui/bar_chart/bar_chart_composer.dart';
import 'package:wifiscan/app/ui/bar_chart/bar_chart_composer3.dart';
import 'package:wifiscan/app/ui/line_chart/line_chart_composer.dart';
import 'package:wifiscan/app/ui/pages/server/widgets/my_form_field.dart';

class StationCard extends StatelessWidget {
  final formKeyAlias = GlobalKey<FormState>();
  MqttController _mqtt;
  final Station station;

  StationCard({@required this.station});

  @override
  Widget build(BuildContext context) {
    _mqtt = Get.put(MqttController());

    return Container(
      margin: EdgeInsets.only(bottom: 3, left: 5, right: 5, top: 5),
      padding: EdgeInsets.only(bottom: 8, left: 5, right: 5, top: 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ExpansionTile(
        trailing: Icon(FontAwesomeIcons.angleDown),
        tilePadding: EdgeInsets.symmetric(vertical: 0),
        title: _header(),
        children: [_body()],
      ),
    );
  }

  Widget _header() {
    return Container(
      // largura do Container
      width: double.infinity,
      margin: const EdgeInsets.only(right: 0),
      // color: Colors.blue[50],
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.all(0),
            //color: Colors.blue[50],
            child: Padding(
              padding: EdgeInsets.all(0),
              child: Row(
                children: [
                  Container(
                      margin: EdgeInsets.all(8),
                      //color: Colors.red[50],
                      child: Icon(
                        Icons.wifi,
                        color: station.rssi == null
                            ? Colors.black
                            : station.rssi < -71.0
                                ? Colors.red[700]
                                : station.rssi < -61.0
                                    ? Colors.yellow
                                    : station.rssi < -51.0
                                        ? Colors.blue[800]
                                        : Colors.green[800],
                      )),
                  Expanded(
                      child: Container(
                    margin: EdgeInsets.all(0),
                    //color: Colors.pink[50],
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  FlatButton(
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    minWidth: 0,
                                    height: 35,
                                    padding: EdgeInsets.zero,
                                    onLongPress: (){
                                      getDialog();
                                    },
                                    child: Text(
                                      station.name ?? "",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Obx(() => Text(
                                        '[${RxString(station.alias)}]',
                                        style: TextStyle(
                                          color: Colors.grey[800],
                                          fontSize: 10,
                                        ),
                                      )),
                                ],
                              ),
                            ),
                            Text(
                              station.rssi == null
                                  ? ""
                                  : "${station.rssi.round()} dBm",
                              style: TextStyle(
                                color: Colors.grey[800],
                                fontSize: 12,
                              ),
                            ),
                            SizedBox(width: 10),
                            Text(
                              station.quality == null
                                  ? ""
                                  : "${station.quality.round()}%",
                              style: TextStyle(
                                color: Colors.grey[800],
                                fontSize: 12,
                              ),
                            )
                          ],
                        ),
                        //SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              station.scan?.localIp == null
                                  ? ""
                                  : "${station.scan.localIp}",
                              style: TextStyle(
                                color: Colors.grey[800],
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              station.voltage == null
                                  ? ""
                                  : "${station.voltage}V",
                              style: TextStyle(
                                color: Colors.grey[800],
                                fontSize: 12,
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 5),
                      ],
                    ),
                  ))
                ],
              ),
            ),
          ),
          Container(
              child: Obx(
            () => _mqtt.histograma
                ? BarChartComposer3(station: station)
                : LineChartComposer(station: station),
          )),
        ],
      ),
    );
  }

  Widget _body() {
    return station.scan.rede.length == 0
        ? Container()
        : Container(
            margin: EdgeInsets.only(bottom: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Color(0xff4fc3f7)),
            ),
            child: Table(
              columnWidths: {
                0: FlexColumnWidth(3),
                1: FlexColumnWidth(2),
                2: FlexColumnWidth(1),
                3: FlexColumnWidth(1),
              },
              //border: TableBorder.all(),
              border: TableBorder.symmetric(),
              children: List.generate(
                station.scan.rede.length + 1,
                (index) {
                  if (index == 0)
                    return TableRow(
                        decoration: BoxDecoration(
                          color: const Color(0xff02d39a),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(9),
                              topRight: Radius.circular(9)),
                          border: new Border.all(
                            color: Color(0xff02d39a),
                            width: 1.0,
                          ),
                        ),
                        children: [
                          _headerTableText("SSID"),
                          _headerTableText("Segurança"),
                          _headerTableText("Canal"),
                          _headerTableText("RSSI"),
                        ]);

                  Rede rede = station.scan.rede[index - 1];
                  return TableRow(children: [
                    _bodyTableText(rede.ssid),
                    _bodyTableText(rede.authmode),
                    _bodyTableText("${rede.channel.round()}"),
                    _bodyTableText("${rede.rssi.round()}"),
                  ]);
                },
              ),
            ),
          );
  }

  Widget _headerTableText(String text) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Center(
          child: AutoSizeText(
            text,
            maxLines: 2,
            maxFontSize: 12,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );

  Widget _bodyTableText(String text) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Center(
          child: AutoSizeText(
            text,
            maxLines: 2,
            maxFontSize: 10,
            minFontSize: 8,
          ),
        ),
      );

  void getDialog() {
    Get.defaultDialog(
      title: "Local da Estação",
      titleStyle: TextStyle(fontSize: 14, color: Colors.blue),
      //middleText: "Por favor! Adicione a descrição do local.",
      //middleTextStyle: TextStyle(fontSize: 12),
      //backgroundColor: Colors.lightBlueAccent,
      radius: 10,
      content: Container(
        margin: EdgeInsets.all(5),
        //color: Colors.pink[50],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Por favor! Adicione a descrição da área.",
              style: TextStyle(fontSize: 12, color: Colors.blue),
            ),
            TextField(
              autofocus: true,
              decoration: InputDecoration(labelText: ""),
              style: TextStyle(color: Colors.blue),
              keyboardType: TextInputType.text,
              onChanged: (text) {
                station.alias = text;
              },
            )
          ],
        ),
      ),
      textCancel: "Cancelar",
      textConfirm: "Confirmar",
      confirmTextColor: Colors.white,
      onCancel: () {
        Get.back();
      },
      onConfirm: () {
        Get.back();
      },
      barrierDismissible: false,
    );
  }
}
