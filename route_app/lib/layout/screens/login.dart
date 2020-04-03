import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:route_app/core/providers/form_provider.dart';
import 'package:route_app/core/services/interfaces/API/auth.dart';
import 'package:route_app/layout/screens/arguments/confirm_arguments.dart';
import 'package:route_app/layout/screens/welcome.dart';
import 'package:route_app/layout/utils/route_animations.dart';
import 'package:route_app/layout/widgets/buttons/custom_button.dart';
import 'package:route_app/layout/widgets/fields/custom_text_field.dart';
import 'package:route_app/locator.dart';
import 'package:route_app/layout/constants/colors.dart' as color;
import 'package:route_app/layout/constants/validators.dart' as validators;
import 'package:route_app/layout/widgets/notifications.dart' as notifications;
import 'package:route_app/layout/widgets/loading_snackbar.dart';

/// Screen to log in the user
class LoginScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final AuthAPI _auth = locator.get<AuthAPI>();

  void _onPressedLogin(BuildContext context) {
    showLoadingSnackbar(context, 'Requesting Pincode');
    _auth.sendPin(_emailController.text).then((bool value) {
      if (value) {
        Navigator.pushNamed(context, '/login/confirm',
            arguments: ConfirmScreenArguments(_emailController.text, 'login'));
        notifications.removeNotification(context);
      } else {
        notifications.error(context, 'Could not login, please try again later');
      }
    }).catchError((Object error) {
      print(error);
      notifications.error(context, 'Unexpected error!');
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
                                child: const Text('Login',
                                    style: TextStyle(
                                        fontSize: 30.0, color: color.Text))),
                            CustomTextField(
                                key: const Key('emailField'),
                                hint: 'Enter email',
                                icon: Icons.mail,
                                helper: 'Email',
                                validator: validators.email,
                                errorText: 'Invalid email',
                                controller: _emailController,
                                provider: formProvider),
                            CustomButton(
                                onPressed: () {
                                  _onPressedLogin(context);
                                },
                                buttonText: 'Login',
                                provider: formProvider),
                            GestureDetector(
                              key: const Key('cancelButton'),
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
