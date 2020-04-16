import 'package:route_app/core/models/response_model.dart';
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
  Future<List<String>> getSuggestions(String input) {
    if (input.isEmpty) {
      _curSessionToken = _uuid.v4();
      return Future<List<String>>.value(<String>[]);
    }

    final String params = 'input=' +
        input +
        '&key=' +
        _apiKey +
        '&sessiontoken=' +
        _curSessionToken;

    return _webService.get(params).then((Response response) {
      List<String> resultList;
      for (dynamic item in response.json['predictions']) {
        resultList.add(item['description']);
      }

      return resultList;
    });
  }
}
