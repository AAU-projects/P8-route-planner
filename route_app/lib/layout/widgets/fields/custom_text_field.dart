import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../constants/colors.dart' as color;

/// DOCUMENT THIS
class CustomTextField extends StatefulWidget {

   /// Textfield constructor
  CustomTextField({
    Key key, 
    @required this.hint, 
    this.helper,
    this.icon,
    this.errorText,
    this.validator
  }) : super(key: key);

  /// The hint text to display in the textfield
  final String hint;
  
  /// DOCUMENT THIS
  final String helper;

  /// The suffix icon to display
  final IconData icon;

  /// The text to diplay on errors
  final String errorText;

  /// The validator to use for input validation
  final Function validator;

  String _input;

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

/// Custom text field with specific color coding depending on the input
class _CustomTextFieldState extends State<CustomTextField> {
  bool _valid = true;
  bool _lastFocus = false;
  bool _completed = false;
  final FocusNode _node = FocusNode();

  @override
  void initState() {
    super.initState();
    _node.addListener(onFocusChange);
  }

  void onFocusChange() {
    if (_lastFocus != _node.hasFocus) {
      if (_lastFocus && !_node.hasFocus) {
        _valid = widget.validator(widget._input);
      }
      setState(() { _lastFocus = _node.hasFocus; });
    }
  }

  void validateInput(String input) {
    setState(() { 
      _valid = widget.validator(input); 
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.icon != null? _iconField() : _field();
  }

  Widget _iconField() {
    return SizedBox(
      height: 100.0,
      width: 250.0,
      child: TextField(
        focusNode: _node,
        onChanged: (String value) {widget._input = value;},
        style: TextStyle( color: Colors.white, fontSize: 13),
        decoration: InputDecoration(
          enabled: true,
          filled: true,
          fillColor: color.TextFieldBG,
          helperText: widget.helper,
          hintText: widget.hint,
          errorText: _valid? null : widget.errorText,
          errorStyle: TextStyle(color: color.ErrorColor, fontSize: 10),
          suffixIcon: Icon(
            widget.icon, 
            color: _completed
            ? color.CorrectColor 
            : _valid
              ? color.NeturalGrey
              : color.ErrorColor
          ),
          hintStyle: TextStyle(color: color.NeturalGrey, fontSize: 13),
          helperStyle: TextStyle(color: color.NeturalGrey, fontSize: 10),
          focusedBorder: UnderlineInputBorder(
            borderSide: _completed
              ? BorderSide(color: color.CorrectColor) 
              : BorderSide(color: Colors.white)
          ),
        ),
      ),
    );
  }

  Widget _field() {
    return SizedBox(
      height: 55.0,
      width: 250.0,
      child: TextField(
        onSubmitted: (String value) {validateInput(value);},
        decoration: InputDecoration(
          enabled: true,
          filled: true,
          fillColor: color.TextFieldBG,
          helperText: 'NO ICON',
          hintText: widget.hint,
          errorText: 'Hej'
        ),
      ),
    );
  }
  
}
