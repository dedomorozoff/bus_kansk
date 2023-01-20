import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import '/widgets/drawer.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

double y = 56.2041;

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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final markers = <Marker>[
      Marker(
        width: 80,
        height: 80,
        point: LatLng(y, 95.7197),
        builder: (ctx) => const Icon(Icons.bus_alert_sharp),
      ),
    ];
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
                getSsid().then((sidFrom) {
                  print(sidFrom);
                });
              },
              child: const Text('Обновить'),
            ),
            Flexible(
              child: FlutterMap(
                options: MapOptions(
                  center: LatLng(56.2041, 95.7197),
                  zoom: 15,
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

  Future<List> getBuses() async {
    String url = 'https://mu-kgt.ru/regions/api/rpc.php';
    List data;
    var response =
        await http.get(Uri.parse(url), headers: {"Accept": "application/json"});
    var extractData = json.decode(response.body);
    data = extractData;
    return data;
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
