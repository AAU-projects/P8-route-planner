import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:route_app/core/providers/location_provider.dart';
import 'package:route_app/layout/screens/login.dart';
import 'package:route_app/layout/screens/register.dart';
import 'package:route_app/layout/utils/route_animations.dart';
import 'package:route_app/layout/widgets/buttons/button.dart';
import 'package:route_app/layout/constants/colors.dart' as colors;
import 'package:route_app/layout/constants/text_styles.dart' as text_styles;

/// Initial screen to choose between the screens: login and register
class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LocationProvider>(
      create: (_) => LocationProvider(),
      child: Consumer<LocationProvider>(
        builder: (BuildContext context, LocationProvider locationModel,
            Widget child) {
          return Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/mapBG.png'),
                    fit: BoxFit.cover)),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Center(
                child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    return Column(
                      children: <Widget>[
                        Container(
                            alignment: Alignment.center,
                            height: constraints.maxHeight / 2,
                            width: MediaQuery.of(context).size.width / 2,
                            child: const Text('Welcome to "App Name"',
                                style: TextStyle(
                                    fontSize: 35.0, color: colors.Text))),
                        Container(
                          alignment: Alignment.center,
                          height: constraints.maxHeight / 2,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 50),
                            child: _buildButtons(context, locationModel),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildButtons(BuildContext context, LocationProvider locationModel) {
    return FutureBuilder<bool>(
        future: locationModel.permission,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData && snapshot.data) {
            return Column(
              children: <Widget>[
                Button(
                    text: 'Register',
                    onPressed: () {
                      Navigator.push<dynamic>(context,
                          SlideFromRightRoute(widget: RegisterScreen()));
                    },
                    key: const Key('RegisterButton')),
                const SizedBox(height: 25),
                Button(
                    text: 'Login',
                    onPressed: () {
                      Navigator.push<dynamic>(
                          context, SlideFromRightRoute(widget: LoginScreen()));
                    },
                    key: const Key('LoginButton')),
              ],
            );
          } else {
            return Column(
              children: const <Widget>[
                Card(
                  color: colors.Background,
                  child: Padding(
                    padding: EdgeInsets.all(30.0),
                    child: Text(
                      'Please enable permission for location in settings',
                      style: text_styles.NormalStyle,
                    ),
                  ),
                )
              ],
            );
          }
        });
  }
}
