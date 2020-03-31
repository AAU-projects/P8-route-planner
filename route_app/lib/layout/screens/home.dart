import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:route_app/core/models/directions_model.dart';
import 'package:route_app/core/services/gmaps_service.dart';
import 'package:route_app/core/services/interfaces/gmaps.dart';
import 'package:route_app/layout/widgets/route_search.dart';
import 'package:route_app/layout/constants/colors.dart' as colors;
import 'package:route_app/locator.dart';

import '../../core/providers/location_provider.dart';

/// Home screen with map
class HomeScreen extends StatefulWidget {
  ///key is required, otherwise map crashes on hot reload
  HomeScreen() : super(key: UniqueKey());
  final GoogleMapsService _gMapsService = locator.get<GoogleMapsAPI>();
  final LocationProvider _locationModel =
      LocationProvider(noInitialization: true);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GoogleMapController _controller;
  final TextEditingController _startController = TextEditingController();
  final TextEditingController _endController = TextEditingController();
  final Set<Polyline> _polyline = <Polyline>{};
  final Set<Marker> _markers = <Marker>{};
  LatLng startpoint;

  @override
  void initState() {
    super.initState();
    _startController.addListener(_updateSearchFieldsText);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onStartSubmit(String input) {}

  Future<bool> _onEndSubmit(String input) async {
    if (input.isEmpty) {
      return false;
    }

    String startLoc;

    if (_startController.text == 'My Location') {
      await widget._locationModel.updateCurrentLocation();
      await widget._locationModel
          .updateAddressFromPosition(widget._locationModel.currentLocationObj);
      startLoc = widget._locationModel.positionAddress;
      startpoint = LatLng(widget._locationModel.currentLocationObj.latitude,
          widget._locationModel.currentLocationObj.longitude);
    } else {
      startLoc = _startController.text;
    }

    final Directions dir = await widget._gMapsService
        .getDirections(origin: startLoc, destination: input);

    if (dir.status == 'ZERO_RESULTS') {
      return false;
    }

    startpoint ??=
        LatLng(dir.startLocation.latitude, dir.startLocation.longtitude);
    final LatLng endpoint =
        LatLng(dir.endLocation.latitude, dir.endLocation.longtitude);
    final List<LatLng> pointslist = <LatLng>[startpoint, endpoint];

    setState(() {
      _markers
          .add(Marker(position: startpoint, markerId: MarkerId('startmarker')));
      _markers.add(Marker(position: endpoint, markerId: MarkerId('endmarker')));
      _polyline.add(Polyline(
          points: pointslist,
          polylineId: PolylineId('main'),
          geodesic: true,
          color: Colors.pink));
    });

    return true;
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

  void _updateSearchFieldsText() {
    if (_startController.text == '') {
      _startController.text = 'My Location';
    }
  }

  void _centerMap(Position location) {
    if (location != null) {
      _controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          bearing: 0,
          target: LatLng(location.latitude, location.longitude),
          zoom: 14.0,
        ),
      ));
    }
  }

  CameraPosition _initialPosition(Position location) {
    return const CameraPosition(
      bearing: 0,
      target: LatLng(0, 0),
      zoom: 14.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LocationProvider>(
      create: (_) => LocationProvider(),
      child: Consumer<LocationProvider>(builder: (BuildContext context,
          LocationProvider _locationModel, Widget child) {
        _centerMap(_locationModel.currentLocationObj);
        return Scaffold(
            body: Stack(
          children: <Widget>[
            GoogleMap(
              polylines: _polyline,
              markers: _markers,
              mapType: MapType.normal,
              initialCameraPosition:
                  _initialPosition(_locationModel.currentLocationObj),
              onMapCreated: onMapCreate,
              myLocationButtonEnabled: false,
              myLocationEnabled: true,
              compassEnabled: false,
              onTap: (_) {
                FocusScope.of(context).requestFocus(FocusNode());
              },
            ),
            GestureDetector(
              child: RouteSearch(
                startController: _startController,
                endController: _endController,
                startSubmitFunc: _onStartSubmit,
                endSubmitFunc: _onEndSubmit,
              ),
            ),
            _buildSearchField(_locationModel)
          ],
        ));
      }),
    );
  }

  Padding _buildSearchField(LocationProvider locationModel) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Align(
        alignment: Alignment.bottomRight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            _buildMenuButton(),
            _buildLocationButton(locationModel)
          ],
        ),
      ),
    );
  }

  Padding _buildLocationButton(LocationProvider locationModel) {
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
