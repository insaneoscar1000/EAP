import 'package:stacked/stacked.dart';
import 'package:the_eap_app/src/core/models/models.dart';
import 'package:the_eap_app/src/core/services/services.dart';
import 'package:the_eap_app/src/locator.dart';

class NEMAQActivitiesViewModel extends StreamViewModel<List<NEMAQActivity>> {
  final NEMService _nemService = locator<NEMService>();
  String _searchQuery = '';

  List<NEMAQActivity> get activities {
    final List<NEMAQActivity> all = data ?? <NEMAQActivity>[];
    if (_searchQuery.isEmpty) return all;
    final String query = _searchQuery.toLowerCase();
    return all.where((NEMAQActivity a) {
      return a.category.toLowerCase().contains(query) ||
          a.categoryDescription.toLowerCase().contains(query) ||
          a.subcategory.toLowerCase().contains(query) ||
          a.subcategoryDescription.toLowerCase().contains(query) ||
          a.application.toLowerCase().contains(query);
    }).toList();
  }

  @override
  Stream<List<NEMAQActivity>> get stream => _nemService.getAQActivities();

  void onSearchQueryChanged(String query) {
    _searchQuery = query.trim();
    notifyListeners();
  }
}
