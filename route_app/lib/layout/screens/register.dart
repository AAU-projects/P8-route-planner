import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:route_app/layout/widgets/fields/radio_group.dart';
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

/// Screen to register the user
// ignore: must_be_immutable
class RegisterScreen extends StatefulWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _kmlController = TextEditingController();
  final TextEditingController _fuelTypeController = TextEditingController();
  final AuthAPI _authAPI = locator.get<AuthAPI>();
  bool _expanded = false;
  bool _disabled = false;

  void _onPressRegister(BuildContext context) {
    _disabled = true;
    showLoadingSnackbar(context, 'Registering',
        time: const Duration(seconds: 10));

    if (!_expanded) {
      _kmlController.text = '0';
      _fuelTypeController.text = null;
    }
    _authAPI
        .register(_emailController.text,
            kml: _kmlController.text.isEmpty
                ? 0
                : double.parse(_kmlController.text),
            fuelType: _fuelTypeController.text)
        .then((User user) {
      _authAPI.sendPin(_emailController.text).then((bool value) {
        if (value) {
          Navigator.pushNamed(context, '/login/confirm',
              arguments:
                  ConfirmScreenArguments(_emailController.text, 'register'));
          notifications.removeNotification(context);
        } else {
          notifications.error(
              context, 'Could not login, please try again later');
        }
      _disabled = false;

      });
    }).catchError((Object error) {
      _disabled = false;
      notifications.error(context, error.toString());
    });
    
  }

  @override
  RegisterScreenWidget createState() => RegisterScreenWidget();
}

/// State of registerScreen
class RegisterScreenWidget extends State<RegisterScreen>
    with TickerProviderStateMixin {
  /// controller for expanding kml / petrol window
  AnimationController expandController;

  /// expanding animation
  Animation<double> animation;

  @override
  void initState() {
    super.initState();
    prepareAnimations();
  }

  ///Setting up the animation
  void prepareAnimations() {
    expandController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    animation = CurvedAnimation(
      parent: expandController,
      curve: Curves.fastOutSlowIn,
    );
  }

  void _onCheckboxClick(bool value) {
    setState(() {
      widget._expanded = value;
      if (value) {
        expandController.forward();
      } else {
        expandController.reverse();
      }
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
                                child: const Text('Register',
                                    style: TextStyle(
                                        fontSize: 30.0, color: color.Text))),
                            CustomTextField(
                                iconKey: const Key('emailIcon'),
                                key: const Key('emailField'),
                                hint: 'Enter email',
                                icon: Icons.mail,
                                helper: 'Email',
                                validator: validators.email,
                                errorText: 'Invalid email',
                                controller: widget._emailController,
                                provider: formProvider),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                const Text('Do you have a car?',
                                    style: TextStyle(
                                        fontSize: 12.0,
                                        color: color.NeturalGrey)),
                                Checkbox(
                                    value: widget._expanded,
                                    onChanged: _onCheckboxClick,
                                    key: const Key('doYouHaveCarCheckbox'))
                              ],
                            ),
                            SizeTransition(
                              axisAlignment: 1.0,
                              sizeFactor: animation,
                              child: Container(
                                  height: 150,
                                  child: Column(
                                    children: <Widget>[
                                      CustomTextField(
                                        key: const Key('fuelConsumptionField'),
                                        hint: '(Optional)',
                                        icon: Icons.local_gas_station,
                                        helper:
                                            'Enter fuel consumption in km/l. E.g. 16.5',
                                        validator: validators.kml,
                                        errorText: 'Invalid fuel consumption',
                                        controller: widget._kmlController,
                                        provider: formProvider,
                                        isOptional: true,
                                        keyboardType: TextInputType.number,
                                      ),
                                      RadioGroup(
                                          controller:
                                              widget._fuelTypeController),
                                    ],
                                  )),
                            ),
                            CustomButton(
                                key: const Key('RegisterKey'),
                                onPressed: () {
                                  if (!widget._disabled) {
                                    widget._onPressRegister(context);
                                  }
                                },
                                buttonText: 'Register',
                                provider: formProvider),
                            GestureDetector(
                              key: const Key('cancelButton'),
                              onTap: () {
                                Navigator.push<dynamic>(
                                    context,
                                    SlideFromLeftRoute(
                                        widget: const WelcomeScreen()));
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
