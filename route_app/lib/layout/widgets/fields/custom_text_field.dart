import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:route_app/core/providers/form_provider.dart';
import '../../constants/colors.dart' as color;

/// Custom text field matching the app's design guidelines.
/// 
/// Can have optional icon
/// Have Accept and Error states based on the provided validator (optional)
class CustomTextField extends StatefulWidget {

   /// Textfield constructor
  const CustomTextField({
    Key key, 
    @required this.hint, 
    @required this.controller,
    this.helper,
    this.icon,
    this.errorText,
    this.validator,
    this.provider
  }) : super(key: key);

  /// The hint text to display in the textfield
  final String hint;
  
  /// Helper text to display under textfield
  final String helper;

  /// The suffix icon to display
  final IconData icon;

  /// The text to diplay on errors
  final String errorText;

  /// The validator to use for input validation
  final Function validator;

  /// Text controler to retrive the input of the textfield
  final TextEditingController controller;

  ///
  final FormProvider provider;

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

/// Custom text field with specific color coding depending on the input
class _CustomTextFieldState extends State<CustomTextField> {
  // Boolean to check if the input is valid (checked using the validator)
  bool _valid = true;
  // Boolean to check if input is valid and the user has removed focus
  bool _completed = false;
  bool _lastFocus = false;
  String _input;
  final FocusNode _node = FocusNode();

  @override
  void initState() {
    super.initState();
    widget.provider.register(widget.hint, false);
    _node.addListener(onFocusChange);
  }

  @override
  void dispose() {
    _node.removeListener(onFocusChange);
    _node.dispose();
    super.dispose();
  }

  // Validates the input of the textfield if the focus changes
  void onFocusChange() {
    if (_lastFocus != _node.hasFocus) {
      if (_lastFocus && !_node.hasFocus) {
        if (_input != null) {
          validateInput(_input);
        }
      }
      setState(() { 
        _lastFocus = _node.hasFocus;
      });
    }
  }

  // Validate the input using the given validator
  void validateInput(String input) {
    setState(() { 
      _valid = widget.validator(input); 

      if (_input != null) {
        if (_input.isNotEmpty) {
          _completed = _valid;
          widget.provider.changeStatus(widget.hint, _valid);
        }
        else {
          _completed = false;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return _field();
  }

  Widget _field() {
    return SizedBox(
      height: 85.0,
      width: 250.0,
      child: TextField(
        controller: widget.controller,
        focusNode: _node,
        onChanged: (String value) {_input = value;},
        textAlignVertical: TextAlignVertical.center,
        style: TextStyle( color: Colors.white, fontSize: 13),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(20.0),
          enabled: true,
          filled: true,
          fillColor: color.TextFieldBG,
          helperText: widget.helper,
          hintText: widget.hint,
          errorText: _valid? null : widget.errorText,
          errorStyle: TextStyle(color: color.ErrorColor, fontSize: 10),
          suffixIcon: widget.icon != null
            ? Icon(
                widget.icon, 
                size: 20.0,
                color: _completed
                ? color.CorrectColor 
                : _valid
                  ? color.NeturalGrey
                  : color.ErrorColor
            )
            : null,
          hintStyle: TextStyle(color: color.NeturalGrey, fontSize: 13),
          helperStyle: TextStyle(color: color.NeturalGrey, fontSize: 10),
          focusedBorder: UnderlineInputBorder(
            borderSide: _completed
              ? BorderSide(color: color.CorrectColor) 
              : BorderSide(color: Colors.white)
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: _completed
              ? BorderSide(color: color.CorrectColor) 
              : BorderSide(color: color.NeturalGrey)
          ),
        ),
      ),
    );
  }
  
}
