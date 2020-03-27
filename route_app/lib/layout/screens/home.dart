import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:route_app/layout/widgets/fields/custom_text_field.dart';
import 'package:route_app/layout/widgets/fields/search_text_field.dart';
import 'package:route_app/layout/constants/colors.dart' as colors;

/// Home screen with map
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GoogleMapController _controller;
  final TextEditingController _startController = TextEditingController();

  final CameraPosition _currentPos = const CameraPosition(
    target: LatLng(56.0333, 8.85),
    zoom: 14,
  );

  void onMapCreate(GoogleMapController controller) {
    rootBundle
        .loadString('assets/mapstyles/dark_map.json')
        .then((String value) {
      controller.setMapStyle(value);
      setState(() {
        _controller = controller;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _currentPos,
            onMapCreated: onMapCreate),
        Padding(
          padding: const EdgeInsets.only(top: 30),
          child: Align(
            alignment: Alignment.topCenter,
            child: SearchTextField(
              controller: _startController,
              hint: 'Where to?',
              icon: Icons.search,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Align(
            alignment: Alignment.bottomRight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                SizedBox(
                  height: 40,
                  width: 40,
                  child: FloatingActionButton(
                    backgroundColor: colors.SearchBackground,
                    onPressed: () => print('bob'),
                    child: const Icon(Icons.menu, size: 25),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: SizedBox(
                    height: 40,
                    width: 40,
                    child: FloatingActionButton(
                      backgroundColor: colors.SearchBackground,
                      onPressed: () => print('bob'),
                      child: const Icon(Icons.near_me, size: 25),
                      ),
                    ),
                )
              ],
            ),
          ),
        )
      ],
    ));
  }
}
