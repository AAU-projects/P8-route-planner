import 'package:flutter/material.dart';
import 'package:route_app/layout/constants/colors.dart' as colors;

/// Custom text field used for location search in the app
class SearchTextField extends StatefulWidget {
  /// Default constructor
  const SearchTextField(
      {Key key,
      @required this.hint,
      @required this.controller,
      @required this.icon})
      : super(key: key);

  @override
  _SearchTextFieldState createState() => _SearchTextFieldState();

  /// The hint text to display in the textfield
  final String hint;

  /// The suffix icon to display
  final IconData icon;

  /// Text controller to retrieve the input of the textfield
  final TextEditingController controller;
}

class _SearchTextFieldState extends State<SearchTextField> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: 350,
      child: TextField(
        controller: widget.controller,
        textAlignVertical: TextAlignVertical.center,
        style: const TextStyle(color: Colors.white, fontSize: 13),
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(10),
            enabled: true,
            filled: true,
            hintText: widget.hint,
            hintStyle: const TextStyle(color: colors.Text, fontSize: 13),
            fillColor: colors.SearchBackground,
            border: OutlineInputBorder(
                borderSide: BorderSide(color: colors.SearchBackground),
                borderRadius: const BorderRadius.all(Radius.circular(5.0))),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: colors.SearchBackground)),
            prefixIcon: Icon(widget.icon, size: 20, color: Colors.white)
            ),
      ),
    );
  }
}
