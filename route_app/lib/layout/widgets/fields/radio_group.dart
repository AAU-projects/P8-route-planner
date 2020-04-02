import 'package:flutter/material.dart';
import 'package:route_app/layout/constants/colors.dart' as color;

/// Group of radio buttons
class RadioGroup extends StatefulWidget {
  /// Radio group constructor
  const RadioGroup({@required this.controller});

  /// Output text for selection of buttons
  final TextEditingController controller;

  @override
  RadioGroupWidget createState() => RadioGroupWidget();
}

/// State of radio group
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
  void initState() {
    super.initState();
    widget.controller.text = _radioItem;
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
