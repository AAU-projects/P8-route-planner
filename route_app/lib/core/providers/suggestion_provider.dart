import 'package:flutter/material.dart';
import 'package:route_app/core/services/interfaces/gsuggestions.dart';
import 'package:route_app/locator.dart';

///
class SuggestionProvider extends ChangeNotifier {
  /// Class Constructor
  SuggestionProvider();

  final GoogleAutocompleteAPI _googleAutocompleteAPI =
      locator.get<GoogleAutocompleteAPI>();

  /// List containing suggestions from API call
  List<String> suggestionList = <String>[];

  /// Get suggestions from search
  void getSuggestions(String input) {
    _googleAutocompleteAPI.getSuggestions(input).then((List<String> result) {
      suggestionList = result;
      notifyListeners();
    });
  }
}
