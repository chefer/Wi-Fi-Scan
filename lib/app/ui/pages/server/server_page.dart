import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:wifiscan/app/controllers/mqtt_controller.dart';
import 'package:wifiscan/app/controllers/server_controller.dart';
import 'package:wifiscan/app/ui/pages/server/widgets/my_form_field.dart';
import 'package:wifiscan/app/ui/widgets/loading_widget.dart';

class ServerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    MqttController mqtt = Get.find<MqttController>();
    ServerController server = Get.find<ServerController>();

    return Obx(() {
      if (mqtt.isConnected) {
        if (Get.isSnackbarOpen) Get.back();
        Get.back();
      }

      return Scaffold(
          appBar: AppBar(
            title: Text('Conf. do servidor MQTT'),
            actions: [
              IconButton(
                icon: Icon(Icons.check),
                onPressed: mqtt.loading
                    ? null
                    : () => mqtt.startConnection(server: server.server),
              )
            ],
          ),
          body: Stack(
            children: [
              ListView(
                children: [
                  Container(
                    margin: EdgeInsets.all(20),
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          MyFormField(
                            text: "Endereço do servidor",
                            hint: "Ex.: 192.168.0.11",
                            initialValue: server.server.ip,
                            keyboardType: TextInputType.number,
                            onChanged: server.setIp,
                            validator: _ipValidator,
                          ),
                          MyFormField(
                            text: "Porta",
                            hint: "Ex.: 1883",
                            initialValue: "${server.server.port ?? ''}",
                            keyboardType: TextInputType.number,
                            onChanged: (text) =>
                                server.setPort(int.parse(text)),
                            mask: MaskTextInputFormatter(
                              mask: '########',
                              filter: {"#": RegExp(r'[0-9]')},
                            ),
                            validator: (text) {
                              if (text.isEmpty)
                                return "Por favor, digite o número da porta";
                              return null;
                            },
                          ),
                          MyFormField(
                            text: "Número de estações",
                            hint: "Ex.: 4",
                            initialValue:
                                "${server.server.stationsNumber ?? ''}",
                            keyboardType: TextInputType.number,
                            onChanged: (text) =>
                                server.setStationsNumber(int.parse(text)),
                            mask: MaskTextInputFormatter(
                              mask: '########',
                              filter: {"#": RegExp(r'[0-9]')},
                            ),
                            validator: (text) {
                              if (text.isEmpty)
                                return "Por favor, digite o número de estações ativas";
                              return null;
                            },
                          ),
                          // SizedBox(height: 30),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              mqtt.loading
                  ? LoadingWidget(
                      message: "Conectando...\nPor favor, aguarde.",
                    )
                  : const SizedBox()
            ],
          ));
    });
  }

  /// validação do IP
  String _ipValidator(text) {
    if (text.isEmpty) return "Digite um endereço de IP válido";
    RegExp exp = RegExp(
      r"\b(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b",
    );
    if (exp.hasMatch(text)) return null;
    return "Endereço IP incorreto";
  }
}
