import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:route_app/core/providers/form_provider.dart';
import 'package:route_app/layout/constants/colors.dart' as color;

/// Custom button matching the app's design guidelines
///
/// Has two states: invalid and valid, based on the state of
/// the CustomTextField's which are linked
class CustomButton extends StatefulWidget {
  /// CustomButton constructor
  const CustomButton(
      {Key key,
      @required this.onPressed,
      @required this.buttonText,
      @required this.provider})
      : super(key: key);

  /// The function to call when this button is pressed
  final GestureTapCallback onPressed;

  /// The text to show on the button
  final String buttonText;

  /// The FormProvider used to link the button with the textfields
  final FormProvider provider;

  @override
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return _button();
  }

  Widget _button() {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: SizedBox(
          height: 40.0,
          width: 150.0,
          child: RawMaterialButton(
              onPressed: widget.provider.accept ? widget.onPressed : null,
              fillColor: widget.provider.accept
                  ? color.CorrectColor
                  : color.CustomButtonInactive,
              splashColor: Colors.white,
              child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        widget.buttonText,
                        style: TextStyle(
                            color: widget.provider.accept
                                ? Colors.white
                                : color.NeturalGrey,
                            fontSize: 14),
                      )
                    ],
                  )))),
    );
  }
}
