import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:route_app/core/providers/form_provider.dart';
import 'package:route_app/core/services/interfaces/API/auth.dart';
import 'package:route_app/layout/screens/arguments/confirm_arguments.dart';
import 'package:route_app/layout/widgets/buttons/custom_button.dart';
import 'package:route_app/layout/widgets/fields/custom_text_field.dart';
import 'package:route_app/locator.dart';
import 'package:route_app/layout/constants/colors.dart' as color;
import 'package:route_app/layout/constants/validators.dart' as validators;

/// Documentation
class ConfirmLoginScreen extends StatelessWidget {
  final TextEditingController _pinController = TextEditingController();
  final AuthAPI _authAPI = locator.get<AuthAPI>();

  void _onPressedConfirm() {
    _authAPI.login(_pinController.text).then((_) {
      print('Loggedin');
    }).catchError((Object error) {
      print(error);
    });
  }

  @override
  Widget build(BuildContext context) {
    final ConfirmScreenArguments args =
        ModalRoute.of(context).settings.arguments;

    return Scaffold(
      backgroundColor: color.Background,
      body: GestureDetector(
        onTap: () {FocusScope.of(context).requestFocus(FocusNode());},
        child: Center(
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return ChangeNotifierProvider<FormProvider>(
                  create: (_) => FormProvider(),
                  child: Consumer<FormProvider>(builder: (BuildContext context,
                      FormProvider formProvider, Widget child) {
                    return Container(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                                alignment: Alignment.center,
                                height: constraints.maxHeight / 12,
                                child: Text('''CONFIRM ${args.type}''',
                                    style: const TextStyle(
                                        fontSize: 35.0, color: color.Text))),
                            Container(
                                alignment: Alignment.center,
                                height: constraints.maxHeight / 6,
                                width: constraints.maxWidth / 2,
                                child: Text('''Please enter the 4-digit code 
                                sent to ${args.email}''',
                                    style: const TextStyle(
                                        fontSize: 15.0,
                                        color: color.Text))),
                            CustomTextField(
                                hint: 'Enter PIN',
                                icon: Icons.lock,
                                helper: 'PIN',
                                validator: validators.pin,
                                errorText: 'Invalid pin',
                                controller: _pinController,
                                keyboardType: TextInputType.number,
                                provider: formProvider),
                            CustomButton(
                                onPressed: _onPressedConfirm,
                                buttonText: 'Confirm',
                                provider: formProvider),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, '/');
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                child: const Text('Cancel',
                                    style: TextStyle(
                                        fontSize: 10.0,
                                        color: color.NeturalGrey,
                                        decoration: TextDecoration.underline)),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }));
            },
          ),
        ),
      ),
    );
  }
}
