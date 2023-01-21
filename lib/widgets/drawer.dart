import 'package:flutter/material.dart';

import '/pages/animated_map_controller.dart';
import '/pages/circle.dart';
import '/pages/custom_crs/custom_crs.dart';
import '/pages/epsg3413_crs.dart';
import '/pages/epsg4326_crs.dart';
import '/pages/esri.dart';
import '/pages/fallback_url_network_page.dart';
import '/pages/fallback_url_offline_page.dart';
import '/pages/home.dart';
import '/pages/interactive_test_page.dart';
import '/pages/latlng_to_screen_point.dart';
import '/pages/live_location.dart';
import '/pages/many_markers.dart';
import '/pages/map_controller.dart';
import '/pages/map_inside_listview.dart';
import '/pages/marker_anchor.dart';
import '/pages/marker_rotate.dart';
import '/pages/max_bounds.dart';
import '/pages/moving_markers.dart';
import '/pages/network_tile_provider.dart';
import '/pages/offline_map.dart';
import '/pages/on_tap.dart';
import '/pages/overlay_image.dart';
import '/pages/plugin_scalebar.dart';
import '/pages/plugin_zoombuttons.dart';
import '/pages/point_to_latlng.dart';
import '/pages/polygon.dart';
import '/pages/polyline.dart';
import '/pages/reset_tile_layer.dart';
import '/pages/sliding_map.dart';
import '/pages/stateful_markers.dart';
import '/pages/tap_to_add.dart';
import '/pages/tile_builder_example.dart';
import '/pages/tile_loading_error_handle.dart';
import '/pages/widgets.dart';
import '/pages/wms_tile_layer.dart';

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
      children: <Widget>[

      ],
    ),
  );
}
