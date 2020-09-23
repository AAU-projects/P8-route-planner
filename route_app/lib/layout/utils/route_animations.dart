import 'package:flutter/material.dart';

/// Custom route to use with the navigator
///
/// Slides the given screen in from the right side
class SlideFromRightRoute extends PageRouteBuilder<dynamic> {
  /// Constructor for the custom route
  SlideFromRightRoute({this.widget})
    : super(pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return widget;
      }, 
      transitionsBuilder: (BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
      });

  /// The screen to use with the animation
  final Widget widget;
}

/// Custom route to use with the navigator
///
/// Slides the given screen in from the left side
class SlideFromLeftRoute extends PageRouteBuilder<dynamic> {
  /// Constructor for the custom route
  SlideFromLeftRoute({this.widget})
    : super(pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return widget;
      }, 
      transitionsBuilder: (BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(-1.0, 0.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
      });

  /// The screen to use with the animation
  final Widget widget;
}
