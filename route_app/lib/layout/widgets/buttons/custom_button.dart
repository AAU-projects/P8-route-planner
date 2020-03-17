import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:route_app/core/providers/form_provider.dart';
import '../../constants/colors.dart' as color;

///
class CustomButton extends StatefulWidget {

  ///
  const CustomButton({
    Key key, 
    @required this.onPressed,
    @required this.buttonText,
    this.provider
  }) : super(key: key);

  ///
  final GestureTapCallback onPressed;

  ///
  final String buttonText;

  ///
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
    return SizedBox(
      height: 40.0,
      width: 150.0,
      child: RawMaterialButton(
        onPressed: widget.onPressed,
        fillColor: widget.provider.accept
          ? color.CorrectColor
          : color.ErrorColor,
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
                  color: color.NeturalGrey,
                  fontSize: 14
                ),
              )
            ],
          )
        )
      )
    );
  }

}