import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:route_app/core/enums/Transport_Types.dart';
import 'package:route_app/core/models/trip.dart';
import 'package:route_app/core/services/interfaces/API/trips.dart';
import 'package:route_app/layout/constants/colors.dart' as color;
import 'package:route_app/locator.dart';

/// Transport Icon
Icon buildTransportIcon(Trip item, {double size = 24}) {
  if (item.transport == Transport.WALK) {
    return Icon(
      Icons.directions_walk,
      color: color.Text,
      size: size,
    );
  } else if (item.transport == Transport.BIKE) {
    return Icon(
      Icons.directions_bike,
      color: color.Text,
      size: size,
    );
  } else if (item.transport == Transport.CAR) {
    return Icon(
      Icons.directions_car,
      color: color.Text,
      size: size,
    );
  } else if (item.transport == Transport.PUBLIC) {
    return Icon(
      Icons.directions_bus,
      color: color.Text,
      size: size,
    );
  }
  return Icon(Icons.help_outline, color: color.Text);
}

/// Displays logout confirmation message
Future<bool> editTripDialog(BuildContext context, Trip trip) {
  final TripsAPI _trips = locator.get<TripsAPI>();
  final DateFormat formatter = DateFormat('H:m dd/MM-yyyy');
  final String dateString = formatter.format(trip.date);

  return showDialog<bool>(
    context: context,
    builder: (BuildContext context) => Dialog(
      backgroundColor: color.CardBackground,
      child: Container(
        alignment: Alignment.topCenter,
        height: 300,
        decoration: BoxDecoration(
            color: color.CardBackground,
            borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Text(
                  'Edit your trip at ' + dateString,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18.0,
                      color: color.Text,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Text(
                'Predicted means of transport',
                style: TextStyle(
                    fontSize: 18.0,
                    color: color.Text,
                    fontWeight: FontWeight.normal),
              ),
              const SizedBox(
                height: 5,
              ),
              buildTransportIcon(trip, size: 36.0),
              const SizedBox(
                height: 25,
              ),
              Text(
                'Select correct means of transport',
                style: TextStyle(
                    fontSize: 18.0,
                    color: color.Text,
                    fontWeight: FontWeight.normal),
              ),
              const SizedBox(
                height: 10,
              ),
              _buildTransportButtons(context, _trips, trip)
            ],
          ),
        ),
      ),
    ),
  );
}

Widget _buildTransportButtons(BuildContext context, TripsAPI api, Trip trip) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: <Widget>[
      if (trip.transport != Transport.WALK)
        buildTransportButton(
            context, Icons.directions_walk, api, trip),
      if (trip.transport != Transport.BIKE)
        buildTransportButton(
            context, Icons.directions_bike, api, trip),
      if (trip.transport != Transport.CAR)
        buildTransportButton(
            context, Icons.directions_car, api, trip),
      if (trip.transport != Transport.PUBLIC)
        buildTransportButton(
            context, Icons.directions_bus, api, trip),
    ],
  );
}

/// Build the icon button for transport
Widget buildTransportButton(
    BuildContext context, IconData icon, TripsAPI api, Trip trip) {
  return GestureDetector(
    onTap: () {
      trip.transport = getTransportFromIcon(icon);
      api.updateTrip(trip);
      Navigator.pop(context, true);
    },
    child: Container(
      decoration: BoxDecoration(
          color: color.ButtonBackground,
          borderRadius: BorderRadius.circular(10.0)),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Icon(
          icon,
          color: color.Text,
          size: 36,
        ),
      ),
    ),
  );
}

/// Convert icon to transportation
Transport getTransportFromIcon(IconData icon) {
  final Map<IconData, Transport> lookup = <IconData, Transport>{
    Icons.directions_walk: Transport.WALK,
    Icons.directions_bike: Transport.BIKE,
    Icons.directions_car: Transport.CAR,
    Icons.directions_bus: Transport.PUBLIC
  };

  return lookup[icon];
}
