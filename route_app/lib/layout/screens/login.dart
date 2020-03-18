import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:route_app/layout/screens/welcome.dart';
import 'package:route_app/layout/utils/routeAnimations.dart';
import '../../core/providers/form_provider.dart';
import '../constants/colors.dart' as color;
import '../constants/validators.dart' as validators;
import '../widgets/fields/custom_text_field.dart';
import '../widgets/buttons/custom_button.dart';

/// Documentation
class LoginScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();

  void _onPressedLogin(BuildContext context) {
    print('Login pressed');
    Navigator.pushNamed(
      context, 
      '/login/confirm',
      // Pass input email to confirm screen
      arguments: _emailController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color.Background,
      body: Center(
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
                              child: const Text('LOGIN',
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
                          CustomButton(
                              onPressed: () {_onPressedLogin(context);},
                              buttonText: 'Login',
                              provider: formProvider),
                          GestureDetector(
                            onTap: () {
                              Navigator.push<dynamic>(
                                context, 
                                SlideFromLeftRoute(widget: WelcomeScreen()));
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
    );
  }
}
