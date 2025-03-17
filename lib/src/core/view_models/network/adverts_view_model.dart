import 'package:stacked/stacked.dart';
import 'package:the_eap_app/src/core/models/models.dart';
import 'package:the_eap_app/src/core/services/services.dart';
import 'package:the_eap_app/src/locator.dart';

class AdvertsViewModel extends StreamViewModel<List<Advert>> {
  final _advertService = locator<AdvertService>();
  String _searchQuery = '';

  String get searchQuery => _searchQuery;

  @override
  Stream<List<Advert>> get stream => _advertService.adverts;

  List<Advert> get adverts {
    final allAdverts = data ?? [];
    if (_searchQuery.isEmpty) return allAdverts;

    return allAdverts.where((advert) {
      final query = _searchQuery.toLowerCase();
      return advert.title.toLowerCase().contains(query) ||
          advert.company.toLowerCase().contains(query) ||
          advert.role.toLowerCase().contains(query) ||
          advert.location.toLowerCase().contains(query) ||
          advert.services.toLowerCase().contains(query) ||
          advert.contact.name.toLowerCase().contains(query);
    }).toList();
  }

  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }
}
