import 'package:flutter/material.dart';
import 'package:flutter_sequence_animation/flutter_sequence_animation.dart';
import 'package:route_app/layout/widgets/fields/search_text_field.dart';
import 'package:route_app/layout/constants/colors.dart' as colors;

/// Search widget for routes
class RouteSearch extends StatefulWidget {
  /// default constructor
  const RouteSearch(
      {Key key,
      @required this.startController,
      @required this.endController,
      this.startSubmitFunc,
      this.endSubmitFunc,
      this.backButtonFunc})
      : super(key: key);

  /// Text controller to get start location
  final TextEditingController startController;

  /// Text controller to get end location
  final TextEditingController endController;

  /// Callback function for submitting text to the startController
  final Function startSubmitFunc;

  /// Callback function for submitting text to the endController
  final Function endSubmitFunc;

  /// Callback function for pressing the back button
  final Function backButtonFunc;

  @override
  _RouteSearchState createState() => _RouteSearchState();
}

class _RouteSearchState extends State<RouteSearch>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  SequenceAnimation sequenceAnimation;
  Animation<double> _inputAnimation;

  @override
  void initState() {
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

    super.initState();

  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
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
                                key: const Key('SearchBackButton'),
                                backgroundColor: colors.SearchBackground,
                                onPressed: () {
                                  _controller.reverse();
                                  widget.backButtonFunc();
                                },
                                child: const Icon(
                                  Icons.arrow_back_ios,
                                  size: 25,
                                  color: colors.Text,
                                ),
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
                                key: const Key('OriginTextField'),
                                textController: widget.startController,
                                hint: 'Where to?',
                                icon: Icons.search,
                                animationController: _controller,
                                animation: _inputAnimation,
                                onFocusChange: (bool hasFocus) {
                                  if (hasFocus) {
                                    _controller.forward();
                                  }
                                },
                                onSubmitFunc: widget.startSubmitFunc,
                              ),
                              Opacity(
                                opacity: sequenceAnimation['opacity'].value,
                                child: Visibility(
                                  visible:
                                      sequenceAnimation['visibility'].value,
                                  child: SearchTextField(
                                    key: const Key('DestinationTextField'),
                                    textController: widget.endController,
                                    hint: 'Where to?',
                                    icon: Icons.search,
                                    onFocusChange: (bool hasFocus) {},
                                    animationController: _controller,
                                    animation: _inputAnimation,
                                    onSubmitFunc: widget.endSubmitFunc,
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
