import 'package:flutter/material.dart';

import '/pages/home.dart';

Widget _buildMenuItem(
    BuildContext context, Widget title, String routeName, String currentRoute) {
  final isSelected = routeName == currentRoute;

  return ListTile(
    title: title,
    selected: isSelected,
    onTap: () {
      if (isSelected) {
        Navigator.pop(context);
      } else {
        Navigator.pushReplacementNamed(context, routeName);
      }
    },
  );
}

Drawer buildDrawer(BuildContext context, String currentRoute) {
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        DrawerHeader(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.topRight,
                  colors: <Color>[Colors.blueAccent, Colors.blue])),
          child: SizedBox(
            width: double.infinity,
            height: 200.0,
            child: Column(
              children: const <Widget>[
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
          title: Text('Информация берется из Портала информирования пассажиров о движении наземного пассажирского транспорта'),
          onTap: () {},
        ),
        Column(children: const <Widget>[
          Text('https://mu-kgt.ru'),
        ]),
        const Divider(height: 500,),
        Column(children: const <Widget>[
          Text('© А.Ю. Лопарев, 2023'),
          Text('alexloparev@mai.ru'),
        ]),
      ],
    ),

  );
}
