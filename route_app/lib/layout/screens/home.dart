import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:route_app/core/models/directions_model.dart';
import 'package:route_app/core/models/user_model.dart';
import 'package:route_app/core/services/interfaces/API/user.dart';
import 'package:route_app/core/services/interfaces/gmaps.dart';
import 'package:route_app/layout/widgets/buttons/custom_button.dart';
import 'package:route_app/layout/widgets/fields/custom_text_field.dart';
import 'package:route_app/layout/widgets/fields/radio_group.dart';
import 'package:route_app/layout/widgets/route_search.dart';
import 'package:route_app/layout/constants/colors.dart' as colors;
import 'package:route_app/core/services/background_geolocator.dart';
import 'package:route_app/locator.dart';
import 'package:route_app/layout/widgets/dialogs/logout.dart';
import 'package:route_app/core/providers/location_provider.dart';
import 'package:route_app/layout/constants/validators.dart' as validators;
import 'package:route_app/core/providers/form_provider.dart';

/// Home screen with map
class HomeScreen extends StatefulWidget {
  ///key is required, otherwise map crashes on hot reload
  HomeScreen() : super(key: UniqueKey());

  final GoogleMapsAPI _gMapsService = locator.get<GoogleMapsAPI>();
  final LocationProvider _locationModel = LocationProvider();
  final UserAPI _userService = locator.get<UserAPI>();
  final GlobalKey<ScaffoldState> _endDrawerKey = GlobalKey();

  /// Start the background geolocator when the HomeScreen is initialized.
  final BackgroundGeolocator bgGeolocator = BackgroundGeolocator();

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GoogleMapController _controller;
  final TextEditingController _startController = TextEditingController();
  final TextEditingController _endController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _kmlController = TextEditingController();
  final TextEditingController _fuelTypeController = TextEditingController();
  final Set<Polyline> _polyline = <Polyline>{};
  final Set<Marker> _markers = <Marker>{};
  Directions driveDirections;
  Directions bicyclingDirections;
  Directions transitDirections;
  LatLng startpoint;
  bool _replaceMyLocation = true;
  bool co2EmissionEnabled = false;
  bool priceEnabled = false;
  bool timeEnabled = false;
  User _loggedInUser;

  void onSaveClick() {
    if (_emailController.text.isNotEmpty) {
      _loggedInUser.email = _emailController.text;

      widget._userService.updateUser(_loggedInUser.id, _loggedInUser).then((_) {
        setState(() {
          _emailController.text = _loggedInUser.email;
        });
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _startController.addListener(_updateSearchFieldsText);
    widget._userService.activeUser.then((User loggedInUser) {
      _loggedInUser = loggedInUser;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onBackButtonPress() {
    _replaceMyLocation = true;
    setState(() {
      _polyline.clear();
      _markers.clear();
    });
  }

  Polyline _makePolyLine(Directions dir, String id, Color color) {
    return Polyline(
        polylineId: PolylineId(id),
        points: dir.polylinePoints,
        geodesic: true,
        color: color,
        width: 6);
  }

  void _onStartSubmit(String input) {
    if (_endController.text.isNotEmpty) {
      _onEndSubmit(_endController.text);
    }
  }

  Future<void> _onEndSubmit(String input) async {
    if (input.isEmpty) {
      return;
    }

    final String startLoc = await getStartLocation();

    if (!(await getPolylines(startLoc, input))) {
      return;
    }

    final LatLng endpoint = LatLng(driveDirections.endLocation.latitude,
        driveDirections.endLocation.longtitude);

    final Set<Polyline> polylineList = <Polyline>{
      _makePolyLine(driveDirections, 'driving', Colors.redAccent),
      _makePolyLine(bicyclingDirections, 'bicycling', Colors.green),
      _makePolyLine(transitDirections, 'transit', Colors.orangeAccent)
    };

    setState(() {
      _markers.add(Marker(
        position: endpoint,
        markerId: MarkerId('endmarker'),
      ));
      _polyline.addAll(polylineList);
    });
  }

  Future<String> getStartLocation() async {
    String startLoc;
    if (_startController.text == 'My Location') {
      await widget._locationModel.updateCurrentLocation();

      startLoc = widget._locationModel.currentLocationObj.latitude.toString() +
          ' ' +
          widget._locationModel.currentLocationObj.longitude.toString();
    } else {
      startLoc = _startController.text;
    }
    return startLoc;
  }

  Future<bool> getPolylines(String startLoc, String input) async {
    driveDirections = await widget._gMapsService
        .getDirections(origin: startLoc, destination: input);

    bicyclingDirections = await widget._gMapsService.getDirections(
        origin: startLoc, destination: input, travelMode: 'bicycling');

    transitDirections = await widget._gMapsService.getDirections(
        origin: startLoc, destination: input, travelMode: 'transit');

    return !(driveDirections.status == 'ZERO_RESULTS' &&
        bicyclingDirections.status == 'ZERO_RESULTS' &&
        transitDirections.status == 'ZERO_RESULTS');
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
    if (_replaceMyLocation && _startController.text == '') {
      _startController.text = 'My Location';
      _replaceMyLocation = false;
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

  Card _makeDirectionCard(Directions dir, IconData icon, Color iconColor) {
    return Card(
        color: colors.CardBackground,
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text('Fastest Route\n',
                        style: TextStyle(color: Colors.white, fontSize: 18)),
                    Text(
                        (dir.duration / 60).round().toString() +
                            ' minutes,   ' +
                            (dir.distance / 1000).toStringAsFixed(1) +
                            ' km,   x g CO2',
                        style: const TextStyle(color: Colors.white))
                  ]),
            ),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                RawMaterialButton(
                  onPressed: () {},
                  child: Icon(
                    icon,
                    color: Colors.white,
                  ),
                  shape: const CircleBorder(),
                  elevation: 2.0,
                  fillColor: iconColor,
                  padding: const EdgeInsets.all(2.0),
                ),
              ],
            ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () => showLogoutDialog(context),
        child: ChangeNotifierProvider<LocationProvider>(
          create: (_) => LocationProvider(),
          child: Consumer<LocationProvider>(builder: (BuildContext context,
              LocationProvider _locationModel, Widget child) {
            _centerMap(_locationModel.currentLocationObj);
            return Scaffold(
                body: _buildMainBody(_locationModel, context),
                bottomSheet: _buildBottomSheet(),
                floatingActionButton: _floatingButtonsContainer(_locationModel),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.endDocked);
          }),
        ));
  }

  Scaffold _buildMainBody(
      LocationProvider _locationModel, BuildContext context) {
    return Scaffold(
      key: widget._endDrawerKey,
      endDrawer: _createDrawer(),
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
            zoomControlsEnabled: false,
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
              backButtonFunc: _onBackButtonPress,
            ),
          ),
        ],
      ),
    );
  }

  Widget _createDrawer() {
    return Drawer(
        child: Container(
      color: colors.Background,
      child: ListView(
        padding: const EdgeInsets.only(top: 20),
        children: <Widget>[
          _suggestionsTitle(),
          _noSuggestionsTile(),
          _profileSettings()
        ],
      ),
    ));
  }

  Widget _profileSettings() {
    return Padding(
      padding: const EdgeInsets.only(left: 35),
      child: Column(
        children: <Widget>[
          _settingsTitle(),
          _settingsForm(),
        ],
      ),
    );
  }

  Widget _settingsForm() {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return ChangeNotifierProvider<FormProvider>(
          create: (_) => FormProvider(),
          child: Consumer<FormProvider>(builder:
              (BuildContext context, FormProvider formProvider, Widget child) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
              child: Column(
                children: <Widget>[
                  CustomTextField(
                      iconKey: const Key('emailIcon'),
                      key: const Key('emailField'),
                      hint: _loggedInUser.email,
                      icon: Icons.mail,
                      helper: 'Change email',
                      validator: validators.email,
                      errorText: 'Invalid email',
                      controller: _emailController,
                      provider: formProvider),
//                                    CustomTextField(
//                                      key: const Key('fuelConsumptionField'),
//                                      hint: 'Unknown',
//                                      icon: Icons.local_gas_station,
//                                      helper: 'Change fuel consumption',
//                                      validator: validators.kml,
//                                      errorText: 'Invalid fuel consumption',
//                                      controller: _kmlController,
//                                      provider: formProvider,
//                                      isOptional: true,
//                                      keyboardType: TextInputType.number,
//                                    ),
//                                    RadioGroup(controller: _fuelTypeController),
                  CustomButton(
                      key: const Key('SaveChanges'),
                      onPressed: () => onSaveClick(),
                      buttonText: 'Save',
                      provider: formProvider),
                ],
              ),
            );
          }));
    });
  }

  Widget _settingsTitle() {
    return Row(children: <Widget>[
      Padding(
        padding: const EdgeInsets.only(right: 8),
        child: Icon(
          Icons.portrait,
          color: colors.Text,
        ),
      ),
      const Text(
        'Profile Settings',
        style: TextStyle(color: colors.Text),
      )
    ]);
  }

  Widget _noSuggestionsTile() {
    return const Padding(
      padding: EdgeInsets.only(top: 20),
      child: ListTile(
        title: Text(
          'Settings',
          style: TextStyle(fontSize: 25, color: colors.Text),
        ),
        trailing: Icon(
          Icons.settings,
          color: colors.Text,
        ),
      ),
    );
  }

  Widget _suggestionsTitle() {
    return const Padding(
      padding: EdgeInsets.only(left: 35),
      child: Text(
        'No route suggestions at this moment.',
        style: TextStyle(color: colors.Text),
      ),
    );
  }

  DraggableScrollableSheet _buildBottomSheet() {
    return DraggableScrollableSheet(
      initialChildSize: 0.1,
      maxChildSize: 0.4,
      minChildSize: 0.1,
      expand: false,
      builder: (BuildContext context, ScrollController scrollController) {
        return _polyline.isEmpty
            ? Container()
            : Container(
                key: const Key('BottomSheetContainer'),
                decoration: const BoxDecoration(
                    color: colors.SearchBackground,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0))),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 14.0, left: 4.0, right: 4.0),
                    child: Column(
                      children: <Widget>[
                        if (driveDirections != null)
                          _makeDirectionCard(driveDirections,
                              Icons.directions_car, Colors.redAccent),
                        if (bicyclingDirections != null)
                          _makeDirectionCard(bicyclingDirections,
                              Icons.directions_bike, Colors.green),
                        if (transitDirections != null)
                          _makeDirectionCard(transitDirections,
                              Icons.directions_bus, Colors.orangeAccent)
                      ],
                    ),
                  ),
                ),
              );
      },
    );
  }

  Stack _floatingButtonsContainer(LocationProvider locationModel) {
    return Stack(children: <Widget>[
      _buildMenuButton(),
      _buildLocationButton(locationModel)
    ]);
  }

  Padding _buildLocationButton(LocationProvider locationModel) {
    return Padding(
      padding: const EdgeInsets.only(top: 50.0),
      child: SizedBox(
        height: 40,
        width: 40,
        child: FloatingActionButton(
          heroTag: 'near_me',
          backgroundColor: colors.SearchBackground,
          onPressed: () => _centerMap(locationModel.currentLocationObj),
          child: const Icon(Icons.near_me, size: 25, color: colors.Text),
        ),
      ),
    );
  }

  Padding _buildMenuButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 150),
      child: SizedBox(
        height: 40,
        width: 40,
        child: FloatingActionButton(
          heroTag: 'menu',
          backgroundColor: colors.SearchBackground,
          onPressed: () {
            if (widget._endDrawerKey.currentState.isEndDrawerOpen) {
              widget._endDrawerKey.currentState.openDrawer();
            } else {
              widget._endDrawerKey.currentState.openEndDrawer();
            }
          },
          child: const Icon(Icons.menu, size: 25, color: colors.Text),
        ),
      ),
    );
  }
}
