import 'package:stacked/stacked.dart';
import 'package:the_eap_app/src/core/models/models.dart';
import 'package:the_eap_app/src/core/services/services.dart';
import 'package:the_eap_app/src/locator.dart';

class NEMWasteActivitiesViewModel
    extends StreamViewModel<List<NEMWasteActivity>> {
  final NEMService _nemService = locator<NEMService>();
  String _searchQuery = '';

  List<NEMWasteActivity> get activities {
    final List<NEMWasteActivity> all = data ?? <NEMWasteActivity>[];
    if (_searchQuery.isEmpty) return all;
    final String query = _searchQuery.toLowerCase();
    return all.where((NEMWasteActivity a) {
      return a.wasteCategory.toLowerCase().contains(query) ||
          a.applicationProcess.toLowerCase().contains(query) ||
          a.activityType.toLowerCase().contains(query) ||
          a.gnrSection.toLowerCase().contains(query) ||
          a.activity.toLowerCase().contains(query) ||
          a.exclusions.toLowerCase().contains(query);
    }).toList();
  }

  @override
  Stream<List<NEMWasteActivity>> get stream => _nemService.getWasteActivities();

  void onSearchQueryChanged(String query) {
    _searchQuery = query.trim();
    notifyListeners();
  }
}
