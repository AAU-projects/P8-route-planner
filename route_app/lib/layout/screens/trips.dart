import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:route_app/core/models/trip.dart';
import 'package:route_app/core/services/interfaces/API/trips.dart';
import 'package:route_app/layout/constants/colors.dart' as color;
import 'package:route_app/layout/widgets/dialogs/edit_trip.dart';
import 'package:intl/intl.dart';
import 'package:route_app/locator.dart';
import 'package:route_app/layout/widgets/notifications.dart' as notifications;

///
class TripsScreen extends StatefulWidget {
  @override
  _TripsScreenState createState() => _TripsScreenState();
}

class _TripsScreenState extends State<TripsScreen> {
  final TripsAPI _trips = locator.get<TripsAPI>();

  @override
  void initState() {
    _trips.getTrips().then((List<Trip> res) {
      _tripList.addAll(res);
      setState(() {});
    });
    super.initState();
  }

  // Remove and use backend instead
  final List<Trip> _tripList = <Trip>[];

  @override
  Widget build(BuildContext context) {
    //_trips.getTrips().then((List<Trip> value) => _tripList = value);

    return Scaffold(
      backgroundColor: color.Background,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          buildTitleContainer(context),
          buildListView(),
        ],
      ),
    );
  }

  Widget buildListView() {
    if (_tripList.isEmpty) {
      return Container(
        alignment: Alignment.center,
        child: const Text('No trips found',
            style: TextStyle(fontSize: 25.0, color: color.Text)),
      );
    }
    return Expanded(
      child: ListView.builder(
          itemBuilder: (BuildContext context, int index) =>
              _makeCard(context, index),
          itemCount: _tripList.length,
          scrollDirection: Axis.vertical,
          shrinkWrap: true),
    );
  }

  Padding buildTitleContainer(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 50),
            child: Container(
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: color.Text,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
          Container(
              alignment: Alignment.bottomCenter,
              child: const Text('Your recent trips',
                  style: TextStyle(fontSize: 30, color: color.Text)))
        ],
      ),
    );
  }

  GestureDetector _makeCard(BuildContext context, int index) {
    final Trip item = _tripList[index];
    return GestureDetector(
      onTap: () {
          editTripDialog(context, item).then((bool updated) {
            if (updated != null) {
              notifications.success(context, 'Trip updated');
              setState(() { });
            }
        });
      },
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
    final String dateString = formatter.format(item.date);

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
