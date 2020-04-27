import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:route_app/core/enums/Transport_Types.dart';
import 'package:route_app/core/models/trip.dart';
import 'package:route_app/layout/constants/colors.dart' as color;
import 'package:route_app/core/services/interfaces/API/trips.dart';
import 'package:route_app/locator.dart';

///
class TripsScreen extends StatefulWidget {
  @override
  _TripsScreenState createState() => _TripsScreenState();
}

class _TripsScreenState extends State<TripsScreen> {
  //final TripsAPI _trips = locator.get<TripsAPI>();

  final List<Trip> _tripList = <Trip>[
    Trip(
      startDestination: 'Nordkraft',
      endDestination: 'Cassiopeia',
      transport: Transport.CAR,
      tripDuration: 22,
      tripPosition: <Position>[],
    ),
    Trip(
      startDestination: 'Ikea',
      endDestination: 'Aalborg C',
      transport: Transport.PUBLIC,
      tripDuration: 37,
      tripPosition: <Position>[],
    ),
    Trip(
      startDestination: 'Herningvej 140',
      endDestination: 'Alexs lejlighed',
      transport: Transport.BIKE,
      tripDuration: 12,
      tripPosition: <Position>[],
    )
  ];

  @override
  Widget build(BuildContext context) {
    //_trips.getTrips().then((List<Trip> value) => _tripList = value);

    return Container(
      child: ListView.builder(
          itemBuilder: (BuildContext context, int index) =>
              _makeCard(context, index),
          itemCount: _tripList.length,
          scrollDirection: Axis.vertical,
          shrinkWrap: true),
    );
  }

  Card _makeCard(BuildContext context, int index) {
    final Trip item = _tripList[index];
    return Card(
      elevation: 8.0,
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(
            color: color.CardBackground,
            borderRadius: BorderRadius.circular(10)),
        child: _buildMenu(context, index, item),
      ),
    );
  }

  ListTile _buildMenu(BuildContext context, int index, Trip item) {
    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      leading: Container(
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
                'From: ' + item.startDestination,
                style:
                    TextStyle(color: color.Text, fontWeight: FontWeight.bold),
              ),
              Text(
                'To: ' + item.endDestination,
                style:
                    TextStyle(color: color.Text, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Icon(Icons.directions_car, color: color.Text),
        ],
      ),
    );
  }
}
