import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:route_app/core/models/user_model.dart';
import 'package:route_app/core/services/interfaces/API/user.dart';
import 'package:route_app/layout/widgets/buttons/button.dart';
import 'package:route_app/locator.dart';
import 'package:route_app/layout/widgets/notifications.dart' as notifications;

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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('''User: ${snapshot.data.email}'''),
                        Button(
                          text: 'test',
                          onPressed: () {
                            notifications.message(context, 'Hej');
                          },
                        )
                      ],
                    ),
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
