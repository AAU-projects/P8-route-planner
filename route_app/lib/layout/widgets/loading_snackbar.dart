import 'package:flutter/material.dart';

/// Display a snack bar with loading spinner
void showLoadingSnackbar(BuildContext context, String message,
    {Duration time}) {
  Scaffold.of(context).showSnackBar(SnackBar(
      duration: time != null ? time : const Duration(seconds: 4),
      content: Row(
        children: <Widget>[
          const CircularProgressIndicator(),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(message),
          )
        ],
      )));
}