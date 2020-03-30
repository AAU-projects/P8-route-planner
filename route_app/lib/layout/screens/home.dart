import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:route_app/layout/widgets/route_search.dart';
import 'package:route_app/layout/constants/colors.dart' as colors;

import '../../core/providers/location_provider.dart';

/// Home screen with map
class HomeScreen extends StatefulWidget {
  ///key is required, otherwise map crashes on hot reload
  HomeScreen() : super(key: UniqueKey());

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GoogleMapController _controller;
  final TextEditingController _startController = TextEditingController();
  final TextEditingController _endController = TextEditingController();

  final CameraPosition _currentPos = const CameraPosition(
    target: LatLng(56.0333, 8.85),
    zoom: 14,
  );

  @override
  void dispose() {
    super.dispose();
  }

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

  void _centerMap(Position location) {
    _controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        bearing: 0,
        target: LatLng(location.latitude, location.longitude),
        zoom: 14.0,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LocationProvider>(
      create: (_) => LocationProvider(),
      child: Scaffold(
          body: Stack(
        children: <Widget>[
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _currentPos,
            onMapCreated: onMapCreate,
            // circles: circles,
            myLocationButtonEnabled: false,
            myLocationEnabled: true,
            compassEnabled: false,
            onTap: (_) {
              FocusScope.of(context).requestFocus(FocusNode());
            },
          ),
          RouteSearch(
            startController: _startController,
            endController: _endController,
          ),
          _buildSearchField()
        ],
      )),
    );
  }

  Padding _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Align(
        alignment: Alignment.bottomRight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[_buildMenuButton(), _buildLocationButton()],
        ),
      ),
    );
  }

  Consumer<LocationProvider> _buildLocationButton() {
    return Consumer<LocationProvider>(
      builder:
          (BuildContext context, LocationProvider locationModel, Widget child) {
        return Padding(
          padding: const EdgeInsets.only(top: 10),
          child: SizedBox(
            height: 40,
            width: 40,
            child: FloatingActionButton(
              backgroundColor: colors.SearchBackground,
              onPressed: () => _centerMap(locationModel.currentLocationObj),
              child: const Icon(Icons.near_me, size: 25),
            ),
          ),
        );
      },
    );
  }

  SizedBox _buildMenuButton() {
    return SizedBox(
      height: 40,
      width: 40,
      child: FloatingActionButton(
        backgroundColor: colors.SearchBackground,
        onPressed: () => print('bob'),
        child: const Icon(Icons.menu, size: 25),
      ),
    );
  }
}
