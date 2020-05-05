import 'package:flutter/material.dart';
import 'package:route_app/core/enums/Transport_Types.dart';
import 'package:route_app/core/models/trip.dart';
import 'package:route_app/layout/constants/colors.dart' as color;

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
                  'Edit your trip from ' +
                      trip.startDestination +
                      ' to ' +
                      trip.endDestination,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  buildTransportButton(Icons.directions_walk),
                  buildTransportButton(Icons.directions_bike),
                  buildTransportButton(Icons.directions_car),
                  buildTransportButton(Icons.directions_bus),
                ],
              )
            ],
          ),
        ),
      ),
    ),
  );
}

Container buildTransportButton(IconData icon) {
  return Container(
    decoration: BoxDecoration(
        color: color.ButtonBackground,
        borderRadius: BorderRadius.circular(10.0)),
    child: Padding(
      padding: EdgeInsets.all(5.0),
      child: Icon(
        icon,
        color: color.Text,
        size: 36,
      ),
    ),
  );
}
