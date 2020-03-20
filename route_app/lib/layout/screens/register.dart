import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:route_app/layout/widgets/loading_snackbar.dart';
import 'package:route_app/locator.dart';
import 'package:route_app/core/models/user_model.dart';
import 'package:route_app/core/providers/form_provider.dart';
import 'package:route_app/core/services/interfaces/API/auth.dart';
import 'package:route_app/layout/screens/arguments/confirm_arguments.dart';
import 'package:route_app/layout/screens/welcome.dart';
import 'package:route_app/layout/utils/route_animations.dart';
import 'package:route_app/layout/widgets/buttons/custom_button.dart';
import 'package:route_app/layout/widgets/fields/custom_text_field.dart';
import 'package:route_app/layout/constants/colors.dart' as color;
import 'package:route_app/layout/constants/validators.dart' as validators;
import 'package:route_app/layout/widgets/notifications.dart' as notifications;

/// Documentation
class RegisterScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _licenseController = TextEditingController();

  final AuthAPI _authAPI = locator.get<AuthAPI>();

  void _onPressRegister(BuildContext context) {
    showLoadingSnackbar(context, 'Registering',
        time: const Duration(seconds: 10));

    _authAPI
        .register(_emailController.text, licensePlate: _licenseController.text)
        .then((User user) {
      notifications.removeNotification(context);
      _authAPI.sendPin(_emailController.text).then((bool value) {
        if (value) {
          Navigator.pushNamed(context, '/login/confirm',
              arguments:
                  ConfirmScreenArguments(_emailController.text, 'REGISTER'));
          notifications.removeNotification(context);
        } else {
          notifications.error(
              context, 'Could not login, please try again later');
        }
      });
    }).catchError((Object error) {
      notifications.error(context, error);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color.Background,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
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
                                height: constraints.maxHeight / 6,
                                child: const Text('REGISTER',
                                    style: TextStyle(
                                        fontSize: 35.0, color: color.Text))),
                            CustomTextField(
                                hint: 'Enter email',
                                icon: Icons.mail,
                                helper: 'Email',
                                validator: validators.email,
                                errorText: 'Invalid email',
                                controller: _emailController,
                                provider: formProvider),
                            CustomTextField(
                              hint: 'Enter license plate',
                              icon: Icons.directions_car,
                              helper: 'License plate',
                              validator: validators.licensePlate,
                              errorText: 'Invalid license plate',
                              controller: _licenseController,
                              provider: formProvider,
                              isOptional: true,
                            ),
                            CustomButton(
                                onPressed: () {
                                  _onPressRegister(context);
                                },
                                buttonText: 'Register',
                                provider: formProvider),
                            GestureDetector(
                              onTap: () {
                                Navigator.push<dynamic>(
                                    context,
                                    SlideFromLeftRoute(
                                        widget: WelcomeScreen()));
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
