import 'package:flutter/material.dart';
import 'package:route_app/layout/widgets/fields/search_text_field.dart';
import 'package:route_app/layout/constants/colors.dart' as colors;

/// Search widget for routes
class RouteSearch extends StatefulWidget {
  /// default constructor
  const RouteSearch(
      {Key key, @required this.startController, @required this.endController})
      : super(key: key);

  /// Text controller to get start location
  final TextEditingController startController;

  /// Text controller to get end location
  final TextEditingController endController;

  @override
  _RouteSearchState createState() => _RouteSearchState();
}

class _RouteSearchState extends State<RouteSearch> with
    SingleTickerProviderStateMixin {

  AnimationController _controller;
  Animation<double> _opacityAnimation;
  final FocusNode _node = FocusNode();

  void onFocusChange() {
    if (_node.hasFocus) {
      _controller.forward();
    }
  }

  @override
  void initState() {
    super.initState();
    _node.addListener(onFocusChange);
    _controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
            parent: _controller,
            curve: Interval(0, 0.8, curve: Curves.fastOutSlowIn)))
      ..addListener(() {
        setState(() {

        });
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _node.removeListener(onFocusChange);
    _node.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 30),
        child: Align(
            alignment: Alignment.topCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Visibility(
                  visible: true,
                  child: Opacity(
                    opacity: _opacityAnimation.value,
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 30, left: 15,
                                                           right: 15),
                        child: SizedBox(
                          height: 40,
                          width: 40,
                          child: FloatingActionButton(
                            backgroundColor: colors.SearchBackground,
                            onPressed: () => _controller.reverse(),
                            child: const Icon(Icons.arrow_back_ios, size: 25),
                            ),
                          ),
                        ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 30),
                  child: Column(
                    children: <Widget>[
                      SearchTextField(
                        textController: widget.startController,
                        hint: 'Where to?',
                        icon: Icons.search,
                        animationController: _controller,
                        node: _node,
                      ),
                      SearchTextField(
                        textController: widget.startController,
                        hint: 'Where to?',
                        icon: Icons.search,
                        animationController: _controller,
                      ),
                      SizedBox(
                        height: 40,
                        width: 40,
                        child: FloatingActionButton(
                          backgroundColor: colors.SearchBackground,
                          onPressed: () => _controller.reverse(),
                          child: const Icon(Icons.arrow_back_ios, size: 25),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            )));
  }
}
