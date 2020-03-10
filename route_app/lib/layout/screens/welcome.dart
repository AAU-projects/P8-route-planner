import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:route_app/layout/widgets/button.dart';
import '../constants/colors.dart' as color;

/// Inital screen to choose between the screens: login and register
class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/mapBG.png'), fit: BoxFit.cover)),
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
                          style: TextStyle(fontSize: 35.0, color: color.Text))),
                  Container(
                    alignment: Alignment.center,
                    height: constraints.maxHeight / 2,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 50),
                      child: Column(
                        children: <Widget>[
                          Button(
                              text: 'Register',
                              onPressed: () {
                                Navigator.pushNamed(context, '/register');
                              },
                              key: const Key('RegisterButton')),
                          const SizedBox(height: 25),
                          Button(
                              text: 'Login',
                              onPressed: () {
                                Navigator.pushNamed(context, '/login');
                              },
                              key: const Key('LoginButton')),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
