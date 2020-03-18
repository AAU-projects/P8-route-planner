import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import '../../core/providers/form_provider.dart';
import '../constants/colors.dart' as color;
import '../constants/validators.dart' as validators;
import '../widgets/fields/custom_text_field.dart';
import '../widgets/buttons/custom_button.dart';

/// Documentation
class LoginScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _licenseController = TextEditingController();

  ///
  void test() {
    print('Test');
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
                              height: constraints.maxHeight / 2,
                              width: MediaQuery.of(context).size.width / 2,
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
                          CustomTextField(
                              hint: 'Enter license plate',
                              icon: Icons.directions_car,
                              helper: 'License plate',
                              validator: validators.licensePlate,
                              errorText: 'Invalid license plate',
                              controller: _licenseController,
                              provider: formProvider),
                          CustomButton(
                            onPressed: test,
                            buttonText: 'Test knap',
                            provider: formProvider)
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
