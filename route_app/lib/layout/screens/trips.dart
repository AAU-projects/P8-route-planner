import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:route_app/core/enums/Transport_Types.dart';
import 'package:route_app/core/models/trip.dart';
import 'package:route_app/layout/constants/colors.dart' as color;
import 'package:route_app/core/services/interfaces/API/trips.dart';
import 'package:route_app/layout/widgets/dialogs/edit_trip.dart';
import 'package:route_app/locator.dart';
import 'package:intl/intl.dart';

///
class TripsScreen extends StatefulWidget {
  @override
  _TripsScreenState createState() => _TripsScreenState();
}

class _TripsScreenState extends State<TripsScreen> {
  //final TripsAPI _trips = locator.get<TripsAPI>();

  // Remove and use backend instead
  final List<Trip> _tripList = <Trip>[
    Trip(
      startDestination: 'Nordkraft',
      endDestination: 'Cassiopeia',
      transport: Transport.BIKE,
      tripDuration: 22,
      tripPosition: <Position>[Position(timestamp: DateTime.now())],
    ),
    Trip(
      startDestination: 'Ikea',
      endDestination: 'Aalborg C',
      transport: Transport.CAR,
      tripDuration: 37,
      tripPosition: <Position>[Position(timestamp: DateTime.now())],
    ),
    Trip(
      startDestination: 'Ikea',
      endDestination: 'Aalborg C',
      transport: Transport.PUBLIC,
      tripDuration: 37,
      tripPosition: <Position>[Position(timestamp: DateTime.now())],
    ),
    Trip(
      startDestination: 'Ikea',
      endDestination: 'Aalborg C',
      transport: Transport.WALK,
      tripDuration: 37,
      tripPosition: <Position>[Position(timestamp: DateTime.now())],
    ),
    Trip(
      startDestination: 'Ikea',
      endDestination: 'Aalborg C',
      transport: Transport.PUBLIC,
      tripDuration: 37,
      tripPosition: <Position>[Position(timestamp: DateTime.now())],
    ),
    Trip(
      startDestination: 'Ikea',
      endDestination: 'Aalborg C',
      transport: Transport.PUBLIC,
      tripDuration: 37,
      tripPosition: <Position>[Position(timestamp: DateTime.now())],
    ),
    Trip(
      startDestination: 'Ikea',
      endDestination: 'Aalborg C',
      transport: Transport.PUBLIC,
      tripDuration: 37,
      tripPosition: <Position>[Position(timestamp: DateTime.now())],
    ),
    Trip(
      startDestination: 'Ikea',
      endDestination: 'Aalborg C',
      transport: Transport.PUBLIC,
      tripDuration: 37,
      tripPosition: <Position>[Position(timestamp: DateTime.now())],
    ),
    Trip(
      startDestination: 'Ikea',
      endDestination: 'Aalborg C',
      transport: Transport.CAR,
      tripDuration: 37,
      tripPosition: <Position>[Position(timestamp: DateTime.now())],
    ),
    Trip(
      startDestination: 'Ikea',
      endDestination: 'Aalborg C',
      transport: Transport.WALK,
      tripDuration: 37,
      tripPosition: <Position>[Position(timestamp: DateTime.now())],
    ),
    Trip(
      startDestination: 'Herningvej 140',
      endDestination: 'Alexs lejlighed',
      transport: Transport.BIKE,
      tripDuration: 12,
      tripPosition: <Position>[Position(timestamp: DateTime.now())],
    )
  ];

  @override
  Widget build(BuildContext context) {
    //_trips.getTrips().then((List<Trip> value) => _tripList = value);

    return Scaffold(
      backgroundColor: color.Background,
      body: Column(
        children: <Widget>[
          buildTitleContainer(context),
          buildListView(),
        ],
      ),
    );
  }

  Expanded buildListView() {
    return Expanded(
      child: ListView.builder(
          itemBuilder: (BuildContext context, int index) =>
              _makeCard(context, index),
          itemCount: _tripList.length,
          scrollDirection: Axis.vertical,
          shrinkWrap: true),
    );
  }

  Container buildTitleContainer(BuildContext context) {
    return Container(
        alignment: Alignment.bottomCenter,
        height: 100,
        width: MediaQuery.of(context).size.width / 1.5,
        child: const Text('Your recent trips',
            style: TextStyle(fontSize: 35.0, color: color.Text)));
  }

  GestureDetector _makeCard(BuildContext context, int index) {
    final Trip item = _tripList[index];
    return GestureDetector(
      onTap: () => editTripDialog(context, item),
      child: Card(
        color: Colors.transparent,
        elevation: 8.0,
        margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        child: Container(
          decoration: BoxDecoration(
              color: color.CardBackground,
              borderRadius: BorderRadius.circular(10)),
          child: _buildMenu(context, index, item),
        ),
      ),
    );
  }

  ListTile _buildMenu(BuildContext context, int index, Trip item) {
    final DateFormat formatter = DateFormat('H:m dd/MM-yyyy');
    final String dateString = formatter.format(item.tripPosition[0].timestamp);

    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      leading: Container(
        height: 35,
        padding: const EdgeInsets.only(right: 12.0),
        decoration: const BoxDecoration(
          border: Border(
            right: BorderSide(width: 1.0, color: color.Text),
          ),
        ),
        child: Icon(
          Icons.location_on,
          color: Colors.redAccent,
        ),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Date: ' + dateString,
                style: TextStyle(
                    fontSize: 14,
                    color: color.Text,
                    fontWeight: FontWeight.normal),
              ),
              Text(
                'From: ' + item.startDestination,
                style:
                    TextStyle(color: color.Text, fontWeight: FontWeight.bold),
              ),
              Text(
                'To: ' + item.endDestination,
                style:
                    TextStyle(color: color.Text, fontWeight: FontWeight.bold),
              ),
              Text(
                'Duration: ' + item.tripDuration.toString() + ' minutes',
                style:
                    TextStyle(color: color.Text, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          buildTransportIcon(item),
        ],
      ),
    );
  }
}
