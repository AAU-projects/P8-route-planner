import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:route_app/core/models/user_model.dart';
import 'package:route_app/core/services/interfaces/API/user.dart';
import 'package:route_app/locator.dart';

/// Initial screen to choose between the screens: login and register
class TestScreen extends StatelessWidget {
  final UserAPI _userAPI = locator.get<UserAPI>();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/mapBG.png'), fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: FutureBuilder<User>(
              future: _userAPI.activeUser,
              builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
                if (snapshot.hasData) {
                  return Center(
                    child: Text('''User: ${snapshot.data.email}'''),
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              }),
        ),
      ),
    );
  }
}
