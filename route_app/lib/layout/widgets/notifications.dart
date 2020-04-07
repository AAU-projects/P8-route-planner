import 'package:flutter/material.dart';
import 'package:route_app/layout/constants/colors.dart' as colors;

void _displayNotification(BuildContext context, Widget snackbar) {
  removeNotification(context);
  _getScaffold(context).showSnackBar(snackbar);
}

ScaffoldState _getScaffold(BuildContext context) {
  return Scaffold.of(context);
}

/// Remove the active notification
void removeNotification(BuildContext context) {
  _getScaffold(context).removeCurrentSnackBar();
}

Widget _closeSnackBar(BuildContext context) {
  return SnackBarAction(
    label: 'Close',
    textColor: colors.Text,
    onPressed: () {
      removeNotification(context);
    },
  );
}

Widget _snackbar(BuildContext context, String message, Color color,
    {Duration time}) {
  return SnackBar(
      duration: time != null ? time : const Duration(seconds: 4),
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
      action: _closeSnackBar(context),
      content: Row(
        children: <Widget>[
          Text(
            message,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ));
}

/// Display a success notification
void success(BuildContext context, String message, {Duration time}) {
  _displayNotification(
      context, _snackbar(context, message, colors.CorrectColor));
}

/// Display a Error notification
void error(BuildContext context, String message, {Duration time}) {
  _displayNotification(context, _snackbar(context, message, colors.ErrorColor));
}

/// Display a notification
void message(BuildContext context, String message, {Duration time}) {
  _displayNotification(
      context, _snackbar(context, message, colors.NeturalGrey));
}
