import 'package:flutter/material.dart';
import 'package:route_app/core/services/interfaces/API/user.dart';
import 'package:route_app/locator.dart';

/// Displays logout confirmation message
Future<bool> showLogoutDialog(BuildContext context) {
    UserAPI service = locator.get<UserAPI>();

  return showDialog<bool>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: const Text('Confirm Logout'),
      content: const Text('Are you sure yoi want to logout?'),
      actions: <Widget>[
        FlatButton(
            onPressed: () {
              service.logout();
              Navigator.pop(context, true);
            },
            child: const Text('Yes')),
        FlatButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('No'))
      ],
    ),
  );
}
