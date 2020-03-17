import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:route_app/core/providers/location_provider.dart';
import 'package:route_app/layout/widgets/button.dart';

/// Inital screen to choose between the screens: login and register
class LocationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LocationProvider>(
      create: (_) => LocationProvider(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Container(child: Consumer<LocationProvider>(builder:
              (BuildContext context, LocationProvider locationModel,
                  Widget child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(locationModel.addressPosition.toString(),
                    style: const TextStyle(fontSize: 20.0)),
                const SizedBox(height: 25.0),
                Button(
                    text: 'Update',
                    onPressed: () {
                      locationModel
                          .updatePositionFromAddress('selma lagerløfs vej');
                    })
              ],
            );
          })),
        ),
      ),
    );
  }
}
