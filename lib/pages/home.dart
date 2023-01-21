import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import '/widgets/drawer.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import '/config.dart';

String sid = '';

class HomePage extends StatefulWidget {
  static const String route = '/';

  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final MapController _mapController = MapController();
  var markers = <Marker>[];

  @override
  void initState() {
    print("Reloading");
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
                setState(() {
                  getInfo();
                });
              },
              child: const Text('Обновить'),
            ),
            Flexible(
              child: FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  center: LatLng(centerLat, centerLong),
                  zoom: centerZoom,
                  onMapReady: () {
                    print("Map ready");
                  },
                  keepAlive: true,
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
    int noArrays = (busIds.length / 3).ceil();
    getSsid().then((sidFrom) {
      sid = sidFrom;
      // print(sid);

      for (int i = 0; i < noArrays; i++) {
        int noElements =
            i == noArrays - 1 ? (3 - (noArrays * 3 - busIds.length)) : (3);
        List partBuses = busIds.sublist(i * 3, (i * 3) + noElements);

        getBuses(sid, partBuses).then((dataBus) {
          for (var bus in dataBus) {
            markers.add(Marker(
                width: 50,
                height: 50,
                point: LatLng(
                    double.parse(bus["u_lat"]), double.parse(bus["u_long"])),
                builder: (ctx) => SizedBox.fromSize(
                    size: Size(80, 80), // button width and height
                    child: Stack(children: <Widget>[
                      Container(
                        padding: const EdgeInsets.only(left: 20),
                        width: 10,
                        height: 10,
                        color: Colors.red,
                      ),
                      ClipOval(
                        child: Material(
                          color: Colors.orange, // button color
                          child: InkWell(
                            splashColor: Colors.green, // splash color
                            onTap: () {}, // button pressed
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(bus["mr_num"]),
                                Icon(Icons.directions_bus_filled)
                                // text
                              ],
                            ),
                          ),
                        ),
                      ),
                    ]))));
            //
          }
        });
      }
    });

  }

  Future<String> getSsid() async {
    markers.clear();
    // print("getting sid");
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

  Future<List> getBuses(sid, busIds) async {
    // print("getting buses");

    // markers.clear();
    String url = 'https://mu-kgt.ru/regions/api/rpc.php';
    String body =
        '{"jsonrpc":"2.0","method":"getUnits","params":{"sid":"$sid","marshList":$busIds},"id":1}';
    // print(body);
    final response = await http.post(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: body);
    var data = json.decode(response.body);
    // print(data);
    return data["result"];
  }
}
