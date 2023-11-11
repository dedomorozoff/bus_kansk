import 'package:flutter/material.dart';
import 'package:buskansk/pages/home.dart';
import '/widgets/drawer.dart';


class Schedule extends StatelessWidget {
  const Schedule({super.key});


  @override

  Widget build(BuildContext context) {

    return Scaffold(
        drawer: buildDrawer(context, HomePage.route),
        appBar: AppBar(title: const Text('Расписание автобусов')),

        body: ListView(
          children: <Widget>[
            Divider(height: 25,color: Colors.white,),
            ListTile(
              leading: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {},
                child: Container(
                  width: 148,
                  height: 148,
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  alignment: Alignment.center,
                ),
              ),
              title: Text('2'),
              dense: false,
            ),
            Divider(height: 15,color: Colors.white,),


          ],
        )

    );

  }

}