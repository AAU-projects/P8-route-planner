import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:route_app/core/models/suggestion_result_model.dart';
import 'package:route_app/core/providers/location_provider.dart';

import 'package:route_app/core/services/interfaces/gsuggestions.dart';
import 'package:route_app/layout/constants/colors.dart' as colors;
import 'package:route_app/locator.dart';

/// Custom text field used for location search in the app
class SearchTextField extends StatelessWidget {
  /// Default constructor
  SearchTextField(
      {Key key,
      @required this.hint,
      @required this.textController,
      @required this.animationController,
      @required this.icon,
      this.node,
      this.animation,
      this.onSumbitFunc})
      : super(key: key);

  /// Animation controller
  final AnimationController animationController;

  /// Animation for input
  final Animation<double> animation;

  /// The hint text to display in the textfield
  final String hint;

  /// The focusnode to control focus
  final FocusNode node;

  /// The suffix icon to display
  final IconData icon;

  /// Text controller to retrieve the input of the textfield
  final TextEditingController textController;

  /// The callback function which executes when submitting text
  final Function onSumbitFunc;

  ///
  AutoCompleteTextField<SuggestionResult> textField;

  /// Suggestion list
  final List<SuggestionResult> suggestionList = <SuggestionResult>[];

  ///
  final GoogleAutocompleteAPI googleAutocompleteAPI =
      locator.get<GoogleAutocompleteAPI>();

  final LocationProvider _locationModel = LocationProvider();

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: animationController, builder: _buildAnimation);
  }

  Widget _buildAnimation(BuildContext context, Widget child) {
    return SizedBox(
      height: 50,
      width: animation.value,
      child: _buildAutoCompTextfield(),
    );
  }

/*
  TextField _buildTextField(SuggestionProvider suggestionProvider,
      {bool hasDropDown = false}) {
    return TextField(
      onChanged: (_) => suggestionProvider.getSuggestions(textController.text),
      focusNode: node,
      onSubmitted: onSumbitFunc,
      controller: textController,
      textAlignVertical: TextAlignVertical.center,
      style: const TextStyle(color: Colors.white, fontSize: 13),
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(10),
          enabled: true,
          filled: true,
          hintText: hint,
          hintStyle: const TextStyle(color: colors.Text, fontSize: 13),
          fillColor: colors.SearchBackground,
          border: const OutlineInputBorder(
              borderSide: BorderSide(color: colors.SearchBackground),
              borderRadius: BorderRadius.all(Radius.circular(5.0))),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: colors.SearchBackground)),
          prefixIcon: Icon(icon, size: 20, color: Colors.white)),
    );
  }
*/

  AutoCompleteTextField<SuggestionResult> _buildAutoCompTextfield() {
    textField = AutoCompleteTextField<SuggestionResult>(
      key: GlobalKey(),
      suggestions: suggestionList,
      clearOnSubmit: false,
      textChanged: (_) => _updateSuggestionList(),
      focusNode: node,
      textSubmitted: onSumbitFunc,
      controller: textController,
      style: const TextStyle(color: Colors.white, fontSize: 13),
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(10),
          enabled: true,
          filled: true,
          hintText: hint,
          hintStyle: const TextStyle(color: colors.Text, fontSize: 13),
          fillColor: colors.SearchBackground,
          border: const OutlineInputBorder(
              borderSide: BorderSide(color: colors.SearchBackground),
              borderRadius: BorderRadius.all(Radius.circular(5.0))),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: colors.SearchBackground)),
          prefixIcon: Icon(icon, size: 20, color: Colors.white)),
      itemBuilder: (BuildContext context, SuggestionResult suggestion) {
        return _row(suggestion);
      },
      itemFilter: (SuggestionResult suggestion, String query) {
        return suggestion.location
            .toLowerCase()
            .startsWith(query.toLowerCase());
      },
      itemSorter: (SuggestionResult a, SuggestionResult b) {
        return a.distance.compareTo(b.distance);
      },
      itemSubmitted: (SuggestionResult suggestion) {
        textController.text = suggestion.location;
      },
    );
    return textField;
  }

  void _updateSuggestionList() {
    googleAutocompleteAPI
        .getSuggestions(textController.text, _locationModel.currentLocationObj)
        .then((List<SuggestionResult> resultList) {
      suggestionList.clear();
      resultList.forEach((SuggestionResult res) {
        suggestionList.add(res);
        print(res.location);
      });
      textField.updateSuggestions(suggestionList);
    });
  }

  Widget _row(SuggestionResult suggestion) {
    return Container(
      color: colors.SearchBackground,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            suggestion.location,
            style: const TextStyle(fontSize: 16.0, color: colors.Text),
          ),
          const SizedBox(
            width: 10.0,
          ),
          Text(
            suggestion.distance.toString(),
            style: const TextStyle(fontSize: 10.0, color: colors.Text),
          ),
        ],
      ),
    );
  }
}
