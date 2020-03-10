import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../constants/colors.dart' as color;

/// Documentation
class RegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    child: const Text('Register Screen',
                        style: TextStyle(fontSize: 35.0, color: color.Text))),
              ],
            );
          },
        ),
      ),
    );
  }
}
