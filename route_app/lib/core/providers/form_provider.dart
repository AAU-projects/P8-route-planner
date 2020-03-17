import 'package:flutter/material.dart';

///
class FormProvider with ChangeNotifier {

  Map<String, bool> _fields = <String, bool>{};
  bool _accept = false;

  /// 
  bool get accept => _accept;

  /// 
  void register(String name, bool value) {
    if (_fields.containsKey(name)) {
      throw Exception('name already exists! To change value use changeStatus');
    } else {
      _fields[name] = value;
    }
  }

  ///
  void changeStatus(String name, bool value) {
    if (_fields.containsKey(name)) {
      _fields.update(name, (bool value) => value);
      _accept = _updateAccept();
      print(_accept.toString());
      print(_fields);
      notifyListeners();
      print(name + ' : ' + value.toString());
    } else {
      throw Exception('name dont exists! Register the field first!');
    }
  }

  bool _updateAccept() {
    for (bool value in _fields.values) {
      if (!value) {
        return false;
      }
    }
    return true;
  }
}