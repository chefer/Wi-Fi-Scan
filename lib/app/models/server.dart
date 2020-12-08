class Server {
  Server({
    this.ip = "",
    this.port,
    this.stationsNumber,
  });

  String ip;
  int port;
  int stationsNumber;

  factory Server.fromJson(Map<dynamic, dynamic> json) => Server(
        ip: json["ip"],
        port: json["port"],
        stationsNumber: json["stationsNumber"],
      );

  Map<String, dynamic> toJson() => {
        "ip": ip,
        "port": port,
        "stationsNumber": stationsNumber,
      };
}
