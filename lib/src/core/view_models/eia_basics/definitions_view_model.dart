import 'package:stacked/stacked.dart';
import 'package:the_eap_app/src/core/models/models.dart';
import 'package:the_eap_app/src/core/services/services.dart';
import 'package:the_eap_app/src/locator.dart';

class DefinitionsViewModel extends StreamViewModel<List<Definition>> {
  final _definitionService = locator<DefinitionService>();
  String _searchQuery = '';
  List<Definition> _allDefinitions = [];

  List<Definition> get definitions {
    if (_searchQuery.isEmpty) return data ?? [];
    return _allDefinitions.where((definition) {
      final query = _searchQuery.toLowerCase();
      return definition.title.toLowerCase().contains(query) ||
          definition.meaning.toLowerCase().contains(query);
    }).toList();
  }

  @override
  Stream<List<Definition>> get stream => _definitionService.getDefinitions();

  @override
  void onData(List<Definition>? data) {
    if (data != null) {
      _allDefinitions = data;
    }
    super.onData(data);
  }

  void onSearchQueryChanged(String value) {
    _searchQuery = value;
    notifyListeners();
  }
}
