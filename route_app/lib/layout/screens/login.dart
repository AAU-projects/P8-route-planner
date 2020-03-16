import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../constants/colors.dart' as color;
import '../widgets/fields/custom_text_field.dart';
import '../constants/validators.dart' as validators;

/// Documentation
class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color.Background,
      body: Center(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Column(
              children: <Widget>[
                Container(
                    alignment: Alignment.center,
                    height: constraints.maxHeight / 2,
                    width: MediaQuery.of(context).size.width / 2,
                    child: const Text('Login Screen',
                        style: TextStyle(fontSize: 35.0, color: color.Text))
                ),
                CustomTextField(
                  hint: 'Enter email',
                  icon: Icons.mail,
                  helper: 'Email',
                  validator: validators.email,
                  errorText: 'Jeg er en fejlbesked',
                ),
                CustomTextField(
                  hint: 'Enter license plate',
                  icon: Icons.directions_car,
                  helper: 'License plate'
                  //errorText: 'Jeg er en fejlbesked',
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
