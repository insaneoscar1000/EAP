import 'package:stacked/stacked.dart';
import 'package:the_eap_app/src/core/models/models.dart';
import 'package:the_eap_app/src/core/services/services.dart';
import 'package:the_eap_app/src/locator.dart';

class NEMAActivitiesViewModel extends StreamViewModel<List<NEMAActivity>> {
  final NEMAActivityService _nemaActivityService = locator<NEMAActivityService>();
  List<NEMAActivity> _allActivities = [];
  String _searchQuery = '';

  List<NEMAActivity> get nemaActivities {
    if (_searchQuery.isEmpty) return data ?? [];
    return _allActivities.where((activity) {
      final query = _searchQuery.toLowerCase();
      return activity.legislation.toLowerCase().contains(query) ||
          activity.activityNumber.toString().contains(query) ||
          activity.authorizationProcess.toLowerCase().contains(query) ||
          activity.selectedListActivity.toLowerCase().contains(query) ||
          activity.exclusions.toLowerCase().contains(query);
    }).toList();
  }

  @override
  Stream<List<NEMAActivity>> get stream => _nemaActivityService.getNEMAActivities();

  @override
  void onData(List<NEMAActivity>? data) {
    super.onData(data);
    if (data != null) {
      _allActivities = data;
    }
  }

  void onSearchQueryChanged(String query) {
    _searchQuery = query;
    notifyListeners();
  }
}
