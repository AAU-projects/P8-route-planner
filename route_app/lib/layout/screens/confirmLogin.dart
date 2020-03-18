import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import '../../core/providers/form_provider.dart';
import '../constants/colors.dart' as color;
import '../constants/validators.dart' as validators;
import '../widgets/fields/custom_text_field.dart';
import '../widgets/buttons/custom_button.dart';

/// Documentation
class ConfirmLoginScreen extends StatelessWidget {
  final TextEditingController _pinController = TextEditingController();

  void _onPressedConfirm() {
    print('Confirm pressed');
  }

  @override
  Widget build(BuildContext context) {
    final String email = ModalRoute.of(context).settings.arguments.toString();

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
                              height: constraints.maxHeight / 12,
                              child: const Text('CONFIRM LOGIN',
                                  style: TextStyle(
                                      fontSize: 35.0, color: color.Text))),
                          Container(
                              alignment: Alignment.center,
                              height: constraints.maxHeight / 6,
                              width: constraints.maxWidth / 2,
                              child: Text('''Please enter the 4-digit code sent to $email''',
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
    );
  }
}
