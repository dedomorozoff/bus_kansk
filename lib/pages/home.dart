import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:smart_timer/smart_timer.dart';
import '/widgets/drawer.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import '/config.dart';
import 'package:location/location.dart';
import 'dart:math' as math; // import this

String sid = '';
var markers = <Marker>[];
var markersTest = <Marker>[];
late Timer timer;

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
    if (kDebugMode) {
      print("Reloading");
    }
    getInfo();
    SmartTimer(
      duration: const Duration(seconds: 10),
      onTick: () => getInfo(),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print("Building map");
    }
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
                  if (kDebugMode) {
                    print("Map ready");
                  }
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
                padding: const EdgeInsets.only(left: 30),
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
      if (kDebugMode) {
        print(sid);
      }

      for (int i = 0; i < noArrays; i++) {
        int noElements =
            i == noArrays - 1 ? (3 - (noArrays * 3 - busIds.length)) : (3);
        List partBuses = busIds.sublist(i * 3, (i * 3) + noElements);

        getBuses(sid, partBuses).then((dataBus) {
          for (var bus in dataBus) {
            Widget busImage = double.parse(bus["u_course"]) < 180
                ? (Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationX(math.pi),
                    child: Container(
                        padding: const EdgeInsets.only(top: 0.0, left: 0.0),
                        child: Transform.rotate(
                          angle: double.parse(
                            bus["u_course"],
                          ),
                          child: const SizedBox(
                            width: 40.0,
                            height: 40.0,
                            child: Stack(
                                textDirection: TextDirection.ltr,
                                alignment: AlignmentDirectional.center,
                                children: <Widget>[
                              Image(
                                image: AssetImage(
                                  "assets/images/marker.png",
                                ),
                              ),
                              SizedBox(
                                width: 25.0,
                                height: 25.0,
                                child: Image(
                                  image: AssetImage(
                                    "assets/images/red-circle.png",
                                  ),
                                ),
                              ),
                            ]),
                          ),
                        ))))
                : (Container(
                    padding: const EdgeInsets.only(top: 0.0, left: 0.0),
                    child: Transform.rotate(
                      angle: double.parse(
                        bus["u_course"],
                      ),
                      child: const SizedBox(
                        width: 40.0,
                        height: 40.0,
                        child: Stack(
                            textDirection: TextDirection.ltr,
                            alignment: AlignmentDirectional.center,
                            children: <Widget>[
                          Image(
                            image: AssetImage(
                              "assets/images/marker.png",
                            ),
                          ),
                          SizedBox(
                            width: 25.0,
                            height: 25.0,
                            child: Image(
                              image: AssetImage(
                                "assets/images/red-circle.png",
                              ),
                            ),
                          ),
                        ]),
                      ),
                    )));
            markers.add(Marker(
              width: 50,
              height: 50,
              point: LatLng(
                  double.parse(bus["u_lat"]), double.parse(bus["u_long"])),
              builder: (ctx) => SizedBox.fromSize(
                  size: const Size(50, 50), // button width and height
                  child: Stack(
                      textDirection: TextDirection.ltr,
                      alignment: AlignmentDirectional.center,
                      children: <Widget>[
                        SizedBox(
                          width: 40,
                          height: 40,
                          child: InkWell(
                            // splashColor: Colors.green, // splash color
                            onTap: () {}, // button pressed
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                // Text(bus["mr_num"]),
                                busImage,
                                // text
                              ],
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(
                              top: 0, bottom: 0, left: 0, right: 0),
                          alignment: Alignment.center,
                          width: 25,
                          height: 25,
                          child: FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: Text(
                                bus["mr_num"],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ])),
            ));
            setState(() {});

            //
          }
        });
      }
      if (kDebugMode) {
        print(markers);
      }
    });
  }

  Future<String> getSsid() async {
    markers.clear();
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
  State<CurrentLocation> createState() => _CurrentLocationState();
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
