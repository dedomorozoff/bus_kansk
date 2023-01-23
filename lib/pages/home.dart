import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import '/widgets/drawer.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import '/config.dart';
import 'package:location/location.dart';

String sid = '';
var markers = <Marker>[];
var markersTest = <Marker>[];

class HomePage extends StatefulWidget {
  static const String route = '/';

  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final MapController _mapController = MapController();

  @override
  void initState() {
    print("Reloading");
    getInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("Building map");
    return Scaffold(
      appBar: AppBar(title: const Text('Автобусы Канска')),
      drawer: buildDrawer(context, HomePage.route),
      body: Padding(
        padding: const EdgeInsets.all(5),
        child: Column(children: [
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
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'dev.fleaflet.flutter_map.example',
                ),
                MarkerLayer(markers: markers),
              ],
            ),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            MaterialButton(
              onPressed: () {
                getInfo();
                _mapController.move(LatLng(centerLat, centerLong), 15);
              },
              child: const Text('Центр города'),
            ),
            MaterialButton(
              onPressed: () {
                getInfo();
              },
              child: const Text('Обновить'),
            ),
            Padding(
                padding: EdgeInsets.only(left: 30),
                child: CurrentLocation(mapController: _mapController))
          ])
        ]),
      ),
    );
  }

  getInfo() {
    int noArrays = (busIds.length / 3).ceil();
    getSsid().then((sidFrom) {
      sid = sidFrom;
      print(sid);

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
            setState(() {});

            //
          }
        });
      }
      print(markers);
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

class CurrentLocation extends StatefulWidget {
  const CurrentLocation({
    Key? key,
    required this.mapController,
  }) : super(key: key);

  final MapController mapController;

  @override
  _CurrentLocationState createState() => _CurrentLocationState();
}

class _CurrentLocationState extends State<CurrentLocation> {
  int _eventKey = 0;

  IconData icon = Icons.gps_not_fixed;
  late final StreamSubscription<MapEvent> mapEventSubscription;

  @override
  void initState() {
    super.initState();
    mapEventSubscription =
        widget.mapController.mapEventStream.listen(onMapEvent);
  }

  @override
  void dispose() {
    mapEventSubscription.cancel();
    super.dispose();
  }

  void setIcon(IconData newIcon) {
    if (newIcon != icon && mounted) {
      setState(() {
        icon = newIcon;
      });
    }
  }

  void onMapEvent(MapEvent mapEvent) {
    if (mapEvent is MapEventMove && mapEvent.id != _eventKey.toString()) {
      setIcon(Icons.gps_not_fixed);
    }
  }

  void _moveToCurrent() async {
    _eventKey++;
    final location = Location();

    try {
      final currentLocation = await location.getLocation();
      final moved = widget.mapController.move(
        LatLng(currentLocation.latitude!, currentLocation.longitude!),
        15,
        id: _eventKey.toString(),
      );

      setIcon(moved ? Icons.gps_fixed : Icons.gps_not_fixed);
    } catch (e) {
      setIcon(Icons.gps_off);
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon),
      onPressed: _moveToCurrent,
    );
  }
}
