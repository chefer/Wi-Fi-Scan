import 'package:get/get.dart';
import 'package:wifiscan/app/controllers/preference_controller.dart';
import 'package:wifiscan/app/models/server.dart';

class ServerController extends GetxController {
  var server = Server();

  void setIp(String ip) {
    if (ip.isNotEmpty) server.ip = ip;
  }

  void setPort(int port) {
    if (port > 0) server.port = port;
  }

  void setStationsNumber(int number) {
    if (number > 0) server.stationsNumber = number;
  }

  void save() {
    PreferenceController.setServer(server);
  }
}
