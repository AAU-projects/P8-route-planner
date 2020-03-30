import 'package:flutter/material.dart';
import 'package:route_app/layout/constants/colors.dart' as color;

class RadioGroup extends StatefulWidget {
  RadioGroup({@required this.controller});

  final TextEditingController controller;

  @override
  RadioGroupWidget createState() => RadioGroupWidget();
}

class RadioGroupWidget extends State<RadioGroup> {
  /// Default Radio Button Item
  String _radioItem = 'Petrol';

  void _handleRadioValueChange(String value) {
    setState(() {
      _radioItem = value;
      widget.controller.text = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
      Radio<String>(
        value: 'Petrol',
        groupValue: _radioItem,
        onChanged: _handleRadioValueChange,
        activeColor: color.CorrectColor,
      ),
      const Text(
        'Petrol',
        style: TextStyle(fontSize: 12.0, color: color.NeturalGrey),
      ),
      Radio<String>(
        value: 'Diesel',
        groupValue: _radioItem,
        onChanged: _handleRadioValueChange,
        activeColor: color.CorrectColor,
      ),
      const Text(
        'Diesel',
        style: TextStyle(fontSize: 12.0, color: color.NeturalGrey),
      ),
      Radio<String>(
        value: 'Electric',
        groupValue: _radioItem,
        onChanged: _handleRadioValueChange,
        activeColor: color.CorrectColor,
      ),
      const Text(
        'Electric',
        style: TextStyle(fontSize: 12.0, color: color.NeturalGrey),
      ),
    ]);
  }
}
