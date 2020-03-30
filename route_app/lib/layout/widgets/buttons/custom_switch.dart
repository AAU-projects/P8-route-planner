import 'package:flutter/material.dart';

class CustomSwitch extends StatefulWidget {
  CustomSwitch({
    Key key,
    @required this.linkedValue,
  }) : super(key: key);

  bool linkedValue;

  @override
  CustomSwitchWidget createState() => CustomSwitchWidget();
}

class CustomSwitchWidget extends State<CustomSwitch>{

  void _handleOnChange(bool value) {
    setState(() {
      widget.linkedValue = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      value: widget.linkedValue, 
      onChanged: _handleOnChange
    );
  }
}