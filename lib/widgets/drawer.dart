import 'package:flutter/material.dart';

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
          title: const Text(
              'Информация берется из Портала информирования пассажиров о движении наземного пассажирского транспорта'),
          onTap: () {},
        ),
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
