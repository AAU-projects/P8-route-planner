import 'package:flutter/material.dart';
import 'package:route_app/layout/constants/colors.dart' as colors;

/// Custom text field used for location search in the app
class SearchTextField extends StatelessWidget {
  /// Default constructor
  const SearchTextField(
      {Key key,
      @required this.hint,
      @required this.textController,
      @required this.animationController,
      @required this.icon,
      this.node, this.animation})
        :
        super(key: key);

  /// Animation controller
  final AnimationController animationController;

    /// Animation for input
  final Animation<double> animation;

  /// The hint text to display in the textfield
  final String hint;

  /// The focusnode to control focus
  final FocusNode node;

  /// The suffix icon to display
  final IconData icon;

  /// Text controller to retrieve the input of the textfield
  final TextEditingController textController;



  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: animationController, builder: _buildAnimation);
  }

  Widget _buildAnimation(BuildContext context, Widget child) {
    return SizedBox(
      height: 50,
      width: animation.value,
      child: TextField(
        focusNode: node,
        controller: textController,
        textAlignVertical: TextAlignVertical.center,
        style: const TextStyle(color: Colors.white, fontSize: 13),
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(10),
            enabled: true,
            filled: true,
            hintText: hint,
            hintStyle: const TextStyle(color: colors.Text, fontSize: 13),
            fillColor: colors.SearchBackground,
            border: const OutlineInputBorder(
                borderSide: BorderSide(color: colors.SearchBackground),
                borderRadius: BorderRadius.all(Radius.circular(5.0))),
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: colors.SearchBackground)),
            prefixIcon: Icon(icon, size: 20, color: Colors.white)),
      ),
    );
  }
}