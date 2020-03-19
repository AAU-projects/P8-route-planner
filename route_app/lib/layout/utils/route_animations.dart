import 'package:flutter/material.dart';

///
class SlideFromRightRoute extends PageRouteBuilder<dynamic> {
  ///
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

  ///
  final Widget widget;
}

///
class SlideFromLeftRoute extends PageRouteBuilder<dynamic> {
  ///
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

  ///
  final Widget widget;
}