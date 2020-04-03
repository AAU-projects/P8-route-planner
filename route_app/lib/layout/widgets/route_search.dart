import 'package:flutter/material.dart';
import 'package:flutter_sequence_animation/flutter_sequence_animation.dart';
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

class _RouteSearchState extends State<RouteSearch>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  SequenceAnimation sequenceAnimation;
  Animation<double> _inputAnimation;
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

    sequenceAnimation = SequenceAnimationBuilder()
        .addAnimatable(
            animatable: Tween<bool>(begin: false, end: true),
            from: const Duration(milliseconds: 0),
            to: const Duration(milliseconds: 1),
            tag: 'visibility')
        .addAnimatable(
            animatable: Tween<double>(begin: 0, end: 1),
            from: const Duration(milliseconds: 1),
            to: const Duration(milliseconds: 501),
            tag: 'opacity',
            curve: Interval(0, 0.8, curve: Curves.fastOutSlowIn))
        .animate(_controller);

    _inputAnimation = Tween<double>(begin: 350, end: 300).animate(
        CurvedAnimation(
            parent: _controller,
            curve: Interval(0, 0.8, curve: Curves.fastOutSlowIn)));
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
            child: AnimatedBuilder(
              animation: _controller,
              builder: (BuildContext context, Widget child) {
                return Stack(
                  children: <Widget>[
                    Opacity(
                      opacity: sequenceAnimation['opacity'].value,
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 30, left: 15, right: 15),
                          child: SizedBox(
                            height: 40,
                            width: 40,
                            child: Visibility(
                              visible: sequenceAnimation['visibility'].value,
                              child: FloatingActionButton(
                                backgroundColor: colors.SearchBackground,
                                onPressed: () => _controller.reverse(),
                                child:
                                    const Icon(Icons.arrow_back_ios, size: 25),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 30),
                          child: Column(
                            children: <Widget>[
                              SearchTextField(
                                textController: widget.startController,
                                hint: 'Where to?',
                                icon: Icons.search,
                                animationController: _controller,
                                animation: _inputAnimation,
                                node: _node,
                              ),
                              Opacity(
                                opacity: sequenceAnimation['opacity'].value,
                                child: Visibility(
                                  visible:
                                      sequenceAnimation['visibility'].value,
                                  child: SearchTextField(
                                    textController: widget.endController,
                                    hint: 'Where to?',
                                    icon: Icons.search,
                                    animationController: _controller,
                                    animation: _inputAnimation,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            )));
  }
}