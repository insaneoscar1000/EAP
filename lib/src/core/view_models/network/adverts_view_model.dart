import 'package:stacked/stacked.dart';
import 'package:the_eap_app/src/core/models/models.dart';
import 'package:the_eap_app/src/core/services/services.dart';
import 'package:the_eap_app/src/core/services/data/user_service.dart';
import 'package:the_eap_app/src/locator.dart';

class AdvertsViewModel extends StreamViewModel<List<Advert>> {
  final _advertService = locator<AdvertService>();
  final _userService = locator<UserService>();
  final _subscriptionService = locator<SubscriptionService>();
  String _searchQuery = '';
  int _userCount = 0;
  bool _isPremium = false;

  int get userCount => _userCount;
  bool get isPremium => _isPremium;

  String get searchQuery => _searchQuery;

  @override
  Stream<List<Advert>> get stream => _advertService.adverts;

  @override
  Future<void> initialise() async {
    super.initialise();
    await _fetchUserCount();
    await _checkSubscriptionStatus();
  }

  Future<void> _fetchUserCount() async {
    _userCount = await _userService.getUserCount();
    notifyListeners();
  }

  Future<void> _checkSubscriptionStatus() async {
    _isPremium = await _subscriptionService.isPremium();
    notifyListeners();
  }

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
