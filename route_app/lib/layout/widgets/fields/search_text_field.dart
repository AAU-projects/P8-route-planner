import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:route_app/core/models/suggestion_result_model.dart';
import 'package:route_app/core/providers/location_provider.dart';

import 'package:route_app/core/services/interfaces/gsuggestions.dart';
import 'package:route_app/layout/constants/colors.dart' as colors;
import 'package:route_app/locator.dart';

/// Custom text field used for location search in the app
class SearchTextField extends StatefulWidget {
  /// Default constructor
  const SearchTextField(
      {Key key,
      @required this.hint,
      @required this.textController,
      @required this.animationController,
      @required this.icon,
      @required this.onFocusChange,
      this.animation,
      this.onSubmitFunc})
      : super(key: key);

  /// Animation controller
  final AnimationController animationController;

  /// Animation for input
  final Animation<double> animation;

  /// The hint text to display in the textfield
  final String hint;

  /// Function to run when the focus of the field changes
  final Function onFocusChange;

  /// The suffix icon to display
  final IconData icon;

  /// Text controller to retrieve the input of the textfield
  final TextEditingController textController;

  /// The callback function which executes when submitting text
  final Function onSubmitFunc;

  @override
  _SearchTextFieldState createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<SearchTextField> {
  AutoCompleteTextField<SuggestionResult> _textField;

  final List<SuggestionResult> _suggestionList = <SuggestionResult>[];

  final GoogleAutocompleteAPI _googleAutocompleteAPI =
      locator.get<GoogleAutocompleteAPI>();

  final LocationProvider _locationModel = LocationProvider();

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: widget.animationController, builder: _buildAnimation);
  }

  Widget _buildAnimation(BuildContext context, Widget child) {
    return SizedBox(
      height: 50,
      width: widget.animation.value,
      child: _buildAutoCompTextfield(),
    );
  }

  AutoCompleteTextField<SuggestionResult> _buildAutoCompTextfield() {
    _textField = AutoCompleteTextField<SuggestionResult>(
      key: GlobalKey(),
      suggestions: _suggestionList,
      clearOnSubmit: false,
      textChanged: (_) => _updateSuggestionList(),
      onFocusChanged: widget.onFocusChange,
      textSubmitted: widget.onSubmitFunc,
      controller: widget.textController,
      style: const TextStyle(color: Colors.white, fontSize: 13),
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(10),
          enabled: true,
          filled: true,
          hintText: widget.hint,
          hintStyle: const TextStyle(color: colors.Text, fontSize: 13),
          fillColor: colors.SearchBackground,
          border: const OutlineInputBorder(
              borderSide: BorderSide(color: colors.SearchBackground),
              borderRadius: BorderRadius.all(Radius.circular(5.0))),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: colors.SearchBackground)),
          prefixIcon: Icon(widget.icon, size: 20, color: Colors.white)),
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
        widget.textController.text = suggestion.location;
        widget.onSubmitFunc(widget.textController.text);
      },
    );
    return _textField;
  }

  void _updateSuggestionList() {
    _googleAutocompleteAPI
        .getSuggestions(
            widget.textController.text, _locationModel.currentLocationObj)
        .then((List<SuggestionResult> resultList) {
      _suggestionList.clear();
      resultList.forEach((SuggestionResult res) {
        _suggestionList.add(res);
        print(res.location);
      });
      _textField.updateSuggestions(_suggestionList);
    });
  }

  Widget _row(SuggestionResult suggestion) {
    return Container(
      color: colors.SearchBackground,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            width: 225,
            child: Text(
              suggestion.location,
              style: const TextStyle(fontSize: 12.0, color: colors.Text),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            (suggestion.distance / 1000).toStringAsFixed(1) + ' Km',
            style: const TextStyle(fontSize: 10.0, color: colors.Text),
          ),
        ],
      ),
    );
  }
}
