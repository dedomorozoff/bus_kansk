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
    print("init");
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
                y = y + 0.001;
                Navigator.pushReplacementNamed(context, HomePage.route);
                print(y);
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

  Future<String> getLats() {
    String url = 'http://api.kansk-tc.ru/albums/';
    List data;
    //закачиваем json
    Future<void> makeRequest() async {
      var response = await http
          .get(Uri.parse(url), headers: {"Accept": "application/json"});
      var extractdata = json.decode(response.body);
      data = extractdata;
    }
    //TODO Разобраться с запросом
    //return makeRequest();
  }