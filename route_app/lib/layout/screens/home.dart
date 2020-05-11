import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:route_app/core/models/directions_model.dart';
import 'package:route_app/core/models/user_model.dart';
import 'package:route_app/core/services/interfaces/API/user.dart';
import 'package:route_app/core/services/interfaces/gmaps.dart';
import 'package:route_app/layout/widgets/buttons/button.dart';
import 'package:route_app/layout/widgets/buttons/custom_button.dart';
import 'package:route_app/layout/widgets/fields/custom_text_field.dart';
import 'package:route_app/layout/widgets/route_search.dart';
import 'package:route_app/layout/constants/colors.dart' as colors;
import 'package:route_app/core/services/background_geolocator.dart';
import 'package:route_app/locator.dart';
import 'package:route_app/layout/widgets/dialogs/logout.dart';
import 'package:route_app/core/providers/location_provider.dart';
import 'package:route_app/layout/constants/validators.dart' as validators;
import 'package:route_app/core/providers/form_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:route_app/layout/widgets/notifications.dart' as notifications;
import 'package:flutter/foundation.dart';

/// Home screen with map
class HomeScreen extends StatefulWidget {
  ///key is required, otherwise map crashes on hot reload
  HomeScreen() : super(key: UniqueKey());

  final GoogleMapsAPI _gMapsService = locator.get<GoogleMapsAPI>();
  final LocationProvider _locationModel = LocationProvider();
  final UserAPI _userService = locator.get<UserAPI>();
  final GlobalKey<ScaffoldState> _endDrawerKey = GlobalKey();

  /// Start the background geolocator when the HomeScreen is initialized.
  final BackgroundGeolocator _bgGeolocator = BackgroundGeolocator();

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GoogleMapController _controller;
  final TextEditingController _startController = TextEditingController();
  final TextEditingController _endController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
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

  void onSaveClick(BuildContext context) {
    if (_emailController.text.isNotEmpty) {
      _loggedInUser.email = _emailController.text;

      widget._userService.updateUser(_loggedInUser.id, _loggedInUser).then((_) {
        setState(() {
          widget._endDrawerKey.currentState.openDrawer();
          notifications.success(context, 'Email updated');
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
    widget._bgGeolocator.clearTimer();
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
    if (input.isEmpty || _startController.text.isEmpty) {
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

  Future<void> openMaps(Directions dir, BuildContext context) async {
    String url = 'https://www.google.com/maps/dir/?api=1&origin=' +
        dir.startLocation.latitude.toString() +
        ',' +
        dir.startLocation.longtitude.toString() +
        '&destination=' +
        dir.endLocation.latitude.toString() +
        ',' +
        dir.endLocation.longtitude.toString();

    if (dir.icon == Icons.directions_bus) {
      url += '&travelmode=transit';
    } else {
      url += '&waypoints=';

      for (int i = 0; i < dir.polylinePoints.length; i++) {
        url += dir.polylinePoints[i].latitude.toString();
        url += ',';
        url += dir.polylinePoints[i].longitude.toString();

        if (i != dir.polylinePoints.length - 1) {
          url += '|';
        }
      }

      url += '&travelmode=';

      if (dir.icon == Icons.directions_car) {
        url += 'driving';
      } else {
        url += 'bicycling';
      }
    }

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      notifications.error(context, 'Could not open Google Maps');
    }
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
    final User currentUser = widget._userService.getUserSynchronously();
    driveDirections = await widget._gMapsService
        .getDirections(origin: startLoc, destination: input);
    driveDirections.icon = Icons.directions_car;
    driveDirections.emission =
        currentUser.carEmission * (driveDirections.distance / 1000);
    driveDirections.price = driveDirections.distance / 1000 / 15 * 11;

    bicyclingDirections = await widget._gMapsService.getDirections(
        origin: startLoc, destination: input, travelMode: 'bicycling');
    bicyclingDirections.icon = Icons.directions_bike;
    bicyclingDirections.emission = 0.0;
    bicyclingDirections.price = 0.0;

    transitDirections = await widget._gMapsService.getDirections(
        origin: startLoc, destination: input, travelMode: 'transit');
    transitDirections.icon = Icons.directions_bus;
    transitDirections.emission = 75 * (transitDirections.distance / 1000);
    transitDirections.price = 22.0;

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

  GestureDetector _makeDirectionCard(Directions dir, Color iconColor,
      List<IconData> titleList, BuildContext context) {
    return GestureDetector(
      child: Card(
          color: colors.CardBackground,
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: directionCardText(dir, titleList)),
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  RawMaterialButton(
                    onPressed: () {},
                    child: Icon(
                      dir.icon,
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
          )),
      onTap: () => openMaps(dir, context),
    );
  }

  List<Widget> directionCardText(Directions dir, List<IconData> titleList) {
    String emissionString;

    if (dir.emission > 1000) {
      emissionString = (dir.emission / 1000).toStringAsFixed(1) + ' kg CO2';
    } else {
      emissionString = dir.emission.toStringAsFixed(1) + ' g CO2';
    }

    String titleText = '';

    if (dir.icon == titleList[0]) {
      titleText = 'Fastest';
    }
    if (dir.icon == titleList[1]) {
      titleText += titleText.isEmpty ? 'Environmental' : '/Environmental';
    }
    if (dir.icon == titleList[2]) {
      titleText += titleText.isEmpty ? 'Cheapest' : '/Cheapest';
    }

    titleText += titleText.isEmpty ? 'Route' : ' Route';

    return <Widget>[
      Text(titleText + '\n',
          style: const TextStyle(color: Colors.white, fontSize: 18)),
      Text(
          (dir.duration / 60).round().toString() +
              ' minutes,   ' +
              (dir.distance / 1000).toStringAsFixed(1) +
              ' km,   ' +
              emissionString +
              ',   ' +
              dir.price.toStringAsFixed(1) +
              ',-',
          style: const TextStyle(color: Colors.white))
    ];
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
                bottomSheet: _buildBottomSheet(context),
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
      endDrawer: _createDrawer(context),
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

  Widget _createDrawer(BuildContext context) {
    return Drawer(
        child: Container(
      color: colors.Background,
      child: ListView(
        padding: const EdgeInsets.only(top: 20),
        children: <Widget>[
          _noSuggestionsTile('Trips', Icons.place),
          _yourTrips(context),
          _noSuggestionsTile('Settings', Icons.settings),
          _profileSettings(context),
        ],
      ),
    ));
  }

  Padding _yourTrips(BuildContext context) {
    return Padding(
          padding: const EdgeInsets.fromLTRB(40, 5, 40, 5),
          child: RaisedButton(
              key: const Key('AccessTrips'),
              color: colors.SearchBackground,
              onPressed: () => Navigator.pushNamed(context, '/trips'),
              child: const Text('See your trips',
                  style: TextStyle(fontSize: 14, color: colors.Text))),
        );
  }

  Widget _profileSettings(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 35),
      child: Column(
        children: <Widget>[
          _settingsTitle(),
          _settingsForm(context),
          _gpsUploadButton(),
        ],
      ),
    );
  }

  Widget _gpsUploadButton() {
    // Only show the GPS upload button when running in debug
    if (kReleaseMode) {
       return Container();
    } else {
      return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: Button(
        text: 'Upload GPS logs',
        onPressed: () => widget._bgGeolocator.uploadLogs(),
      ));
    }
  }

  Widget _settingsForm(BuildContext context) {
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
                  CustomButton(
                      key: const Key('SaveChanges'),
                      onPressed: () => onSaveClick(context),
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

  Widget _noSuggestionsTile(String titleString, IconData inputIcon) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: ListTile(
        title: Text(
          titleString,
          style: const TextStyle(fontSize: 25, color: colors.Text),
        ),
        trailing: Icon(
          inputIcon,
          color: colors.Text,
        ),
      ),
    );
  }

  DraggableScrollableSheet _buildBottomSheet(BuildContext context) {
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
                      children: _makeBottomSheetChildren(context),
                    ),
                  ),
                ),
              );
      },
    );
  }

  List<Widget> _makeBottomSheetChildren(BuildContext context) {
    final List<IconData> titleList = _getDirectionCardTitles(
        <Directions>[driveDirections, bicyclingDirections, transitDirections]);
    return <Widget>[
      if (driveDirections != null)
        _makeDirectionCard(
            driveDirections, Colors.redAccent, titleList, context),
      if (bicyclingDirections != null)
        _makeDirectionCard(
            bicyclingDirections, Colors.green, titleList, context),
      if (transitDirections != null)
        _makeDirectionCard(
            transitDirections, Colors.orangeAccent, titleList, context)
    ];
  }

  List<IconData> _getDirectionCardTitles(List<Directions> directions) {
    // 0 = fastest, 1 = most environmental, 2 = cheapest
    final List<IconData> resList = <IconData>[null, null, null];
    double cheapest = double.maxFinite;
    int fastests = 2147483647;
    double environmental = double.maxFinite;

    for (Directions direction in directions) {
      if (direction == null) {
        continue;
      }
      if (direction.duration < fastests) {
        fastests = direction.duration;
        resList[0] = direction.icon;
      }
      if (direction.emission < environmental) {
        environmental = direction.emission;
        resList[1] = direction.icon;
      }
      if (direction.price < cheapest) {
        cheapest = direction.price;
        resList[2] = direction.icon;
      }
    }

    return resList;
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
          onPressed: () => <void>{
            locationModel.updateCurrentLocation(),
            _centerMap(locationModel.currentLocationObj)},
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
