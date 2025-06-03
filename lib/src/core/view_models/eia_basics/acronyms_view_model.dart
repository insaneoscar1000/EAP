import 'package:stacked/stacked.dart';
import 'package:the_eap_app/src/core/models/acronym.dart';
import 'package:the_eap_app/src/core/services/services.dart';
import 'package:the_eap_app/src/locator.dart';

class AcronymsViewModel extends StreamViewModel<List<Acronym>> {
  final AcronymService _acronymService = locator<AcronymService>();
  List<Acronym> _allAcronyms = [];
  String _searchQuery = '';

  List<Acronym> get acronyms {
    List<Acronym> listToSort;
    if (_searchQuery.isEmpty) {
      listToSort = (data ?? []).toList();
    } else {
      final query = _searchQuery.toLowerCase();
      listToSort = _allAcronyms.where((acronym) {
        return acronym.title.toLowerCase().contains(query) ||
            acronym.meaning.toLowerCase().contains(query);
      }).toList();
    }
    listToSort
        .sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
    return listToSort;
  }

  @override
  Stream<List<Acronym>> get stream => _acronymService.getAcronyms();

  @override
  void onData(List<Acronym>? data) {
    if (data != null) {
      _allAcronyms = data;
    }
    super.onData(data);
  }

  void onSearchQueryChanged(String query) {
    _searchQuery = query;
    notifyListeners();
  }
}
