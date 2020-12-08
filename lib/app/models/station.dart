class Station {
  Station({
    this.name,
    this.alias = "",
    this.subscribedTopics,
    this.rssi,
    List<double> listRSSI,
    List<double> listHistograma,
    List<double> listHistograma100,
    this.quality,
    this.voltage,
    this.scan,
  }) {
    this.listRSSI = listRSSI ?? [];
  }

  String name;
  String alias;
  List<String> subscribedTopics;
  double rssi;
  List<double> listRSSI;
  List<double> listHistograma = new List(4);
  List<double> listHistograma100 = new List(100);

  double quality;
  double voltage;
  Scan scan;

  factory Station.fromJson(Map<String, dynamic> json) => Station(
        name: json['name'] ?? null,
        subscribedTopics:
            List<String>.from(json["subscribedTopics"].map((x) => x)),
        rssi: json["rssi"]?.toDouble(),
        quality: json["quality"]?.toDouble(),
        voltage: json["voltage"]?.toDouble(),
        scan: Scan.fromJson(json["scan"]),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "subscribedTopics": List<dynamic>.from(subscribedTopics.map((x) => x)),
        "rssi": rssi,
        "quality": quality,
        "voltage": voltage,
        "scan": scan == null ? Scan().toJson() : scan.toJson(),
      };
}

class Scan {
  Scan({
    this.label,
    this.mac,
    this.voltage,
    this.ssid,
    this.rssi,
    this.phyMode,
    this.localIp,
    this.subnetMask,
    this.gatewayIp,
    List<Rede> rede,
  }) {
    this.rede = rede ?? [];
  }

  String label;
  String mac;
  String voltage;
  String ssid;
  String rssi;
  String phyMode;
  String localIp;
  String subnetMask;
  String gatewayIp;
  List<Rede> rede;

  factory Scan.fromJson(Map<String, dynamic> json) => Scan(
        label: json["label"],
        mac: json["mac"],
        voltage: json["voltage"],
        ssid: json["ssid"],
        rssi: json["rssi"],
        phyMode: json["phy_mode"],
        localIp: json["localIP"],
        subnetMask: json["subnetMask"],
        gatewayIp: json["gatewayIP"],
        rede: List<Rede>.from(json["rede"].map((x) => Rede.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "label": label,
        "mac": mac,
        "voltage": voltage,
        "ssid": ssid,
        "rssi": rssi,
        "phy_mode": phyMode,
        "localIP": localIp,
        "subnetMask": subnetMask,
        "gatewayIP": gatewayIp,
        "rede": List<dynamic>.from(rede.map((x) => x.toJson())),
      };
}

class Rede {
  Rede({
    this.ssid,
    this.rssi,
    this.authmode,
    this.bssid,
    this.channel,
    this.isHidden,
  });

  String ssid;
  double rssi;
  String authmode;
  String bssid;
  double channel;
  double isHidden;

  factory Rede.fromJson(Map<String, dynamic> json) => Rede(
        ssid: json["ssid"],
        rssi: json["rssi"].toDouble(),
        authmode: json["authmode"],
        bssid: json["bssid"],
        channel: json["channel"].toDouble(),
        isHidden: json["is_hidden"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "ssid": ssid,
        "rssi": rssi,
        "authmode": authmode,
        "bssid": bssid,
        "channel": channel,
        "is_hidden": isHidden,
      };
}
