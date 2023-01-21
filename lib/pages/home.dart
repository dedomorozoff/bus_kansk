import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import '/widgets/drawer.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import '/config.dart';

var markers = <Marker>[];

class HomePage extends StatefulWidget {
  static const String route = '/';

  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  @override
  void initState() {
    getInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Главная')),
      drawer: buildDrawer(context, HomePage.route),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            MaterialButton(
              onPressed: () {
                // y = y + 0.001;
                Navigator.pushReplacementNamed(context, HomePage.route);
                getInfo();
              },
              child: const Text('Обновить'),
            ),
            Flexible(
              child: FlutterMap(
                options: MapOptions(
                  center: LatLng(centerLat, centerLong),
                  zoom: centerZoom,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'dev.fleaflet.flutter_map.example',
                  ),
                  MarkerLayer(markers: markers),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void getInfo() {
    getSsid().then((sidFrom) {
      getBuses(sidFrom, busIds).then((dataBus) {
        for (var bus in dataBus) {
          markers.add(Marker(
            width: 80,
            height: 80,
            point:
                LatLng(double.parse(bus["u_lat"]), double.parse(bus["u_long"])),
            builder: (ctx) => const Icon(Icons.bus_alert_sharp),
          ));
          print(bus["mr_num"]);
        }
      });
    });
  }

  Future<List> getBuses(sid, busIds) async {
    String url = 'https://mu-kgt.ru/regions/api/rpc.php';
    String body =
        '{"jsonrpc":"2.0","method":"getUnits","params":{"sid":"$sid","marshList":$busIds},"id":1}';
    print(body);
    final response = await http.post(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: body);
    var data = json.decode(response.body);
    return data["result"];
  }

  Future<String> getSsid() async {
    String url = 'https://mu-kgt.ru/regions/api/rpc.php';
    String body =
        '{"jsonrpc":"2.0","method":"startSession","params":{},"id":1}';
    final response = await http.post(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: body);
    var data = json.decode(response.body);
    return data["result"]["sid"];
  }
}
