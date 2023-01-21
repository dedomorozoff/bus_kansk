import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import '/widgets/drawer.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import '/config.dart';

var markers = <Marker>[];
String sid = '';

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
    print("Reloading");
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
                Navigator.pushReplacementNamed(context, HomePage.route);
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
    print("geting info");
    int noArrays = (busIds.length / 3).ceil();
    getSsid().then((sidFrom) {
      sid = sidFrom;
      print(sid);
    });

    for (int i = 0; i < noArrays; i++) {
      int noElements =
          i == noArrays - 1 ? (3 - (noArrays * 3 - busIds.length)) : (3);
      List partBuses = busIds.sublist(i * 3, (i * 3) + noElements);

      getBuses(sid, partBuses).then((dataBus) {
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
    }
  }

  Future<List> getBuses(sid, busIds) async {
    // markers.clear();
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
    print(data);
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
    // print(data["result"]["sid"]);
    return data["result"]["sid"];
  }
}
