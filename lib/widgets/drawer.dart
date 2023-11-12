import 'package:buskansk/pages/home.dart';
import 'package:flutter/material.dart';

import '../pages/schedule.dart';

Drawer buildDrawer(BuildContext context, String currentRoute) {
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        const DrawerHeader(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.topRight,
                  colors: <Color>[Colors.blueAccent, Colors.blue])),
          child: SizedBox(
            width: double.infinity,
            height: 200.0,
            child: Column(
              children: <Widget>[
                SizedBox(
                    width: 150.0,
                    height: 120.0,
                    child: Image(
                      image: AssetImage(
                        "assets/images/icon.png",
                      ),
                    )),
              ],
            ),
          ),
        ),
        ListTile(
            leading: const Icon(Icons.map),
            title: const Text("Карта автобусов"),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const HomePage()));
            }),
        ListTile(
            leading: const Icon(Icons.schedule),
            title: const Text("Раписание автобусов"),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Schedule()));
            }),
        const Divider(
          height: 300,
        ),
        const Padding(
            padding: EdgeInsets.only(left: 18),
            child: Text(
                'Информация берется из Портала информирования пассажиров о движении наземного пассажирского транспорта',
                style: TextStyle(
                    color: Colors.black54, fontWeight: FontWeight.bold))),

        const Column(children: <Widget>[
          Text('https://mu-kgt.ru'),
        ]),
        const Divider(
          height: 500,
        ),
        const Column(children: <Widget>[
          Text('https://github.com/dedomorozoff/bus_kansk'),
        ]),
      ],
    ),
  );
}
