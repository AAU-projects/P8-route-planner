import 'package:flutter/material.dart';

/// Form validation provider
class FormProvider with ChangeNotifier {

  final Map<String, bool> _fields = <String, bool>{};

  /// Is the form valid, have all the registered fields returned true
  bool get accept => _fields.values.every((bool value) => value);

  /// Register a required field
  void register(String name, bool value) {
    if (_fields.containsKey(name)) {
      throw Exception('name already exists! To change value use changeStatus');
    } else {
      _fields[name] = value;
    }
  }

  /// Change the status of a field
  void changeStatus(String name, bool value) {
    if (_fields.containsKey(name)) {
      _fields.update(name, (bool old) => value);
      notifyListeners();
    } else {
      throw Exception('name dont exists! Register the field first!');
    }
  }
}
