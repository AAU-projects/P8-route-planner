import 'package:geolocator/geolocator.dart';
import 'package:route_app/core/models/response_model.dart';
import 'package:route_app/core/models/suggestion_result_model.dart';
import 'package:route_app/core/services/interfaces/gsuggestions.dart';
import 'package:route_app/core/services/interfaces/web.dart';
import 'package:route_app/locator.dart';
import 'package:uuid/uuid.dart';

/// Google Autocomplete Serive
class GoogleAutocompleteService implements GoogleAutocompleteAPI {
  /// Class constructor
  GoogleAutocompleteService(this._apiKey, {Web webService}) {
    _webService = webService ??
        locator.get<Web>(
            param1:
                'https://maps.googleapis.com/maps/api/place/autocomplete/json?');
    _curSessionToken = _uuid.v4();
  }

  final String _apiKey;
  Web _webService;
  String _curSessionToken;
  final Uuid _uuid = Uuid();

  @override
  Future<List<SuggestionResult>> getSuggestions(
      String input, Position currentPos) {
    if (input.isEmpty) {
      _curSessionToken = _uuid.v4();
      return Future<List<SuggestionResult>>.value(<SuggestionResult>[]);
    }

    final String params = 'input=' +
        input +
        '&key=' +
        _apiKey +
        '&sessiontoken=' +
        _curSessionToken +
        '&origin=' +
        currentPos.latitude.toString() +
        ',' +
        currentPos.longitude.toString();

    return _webService.get(params).then((Response response) {
      final List<SuggestionResult> resultList = <SuggestionResult>[];
      for (dynamic item in response.json['predictions']) {
        resultList.add(
            SuggestionResult(item['distance_meters'], item['description']));
      }
      return resultList;
    });
  }
}
