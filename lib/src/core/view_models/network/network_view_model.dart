import 'package:stacked/stacked.dart';
import 'package:the_eap_app/src/locator.dart';
import 'package:the_eap_app/src/core/constants/constants.dart';
import 'package:the_eap_app/src/core/services/services.dart';

class NetworkViewModel extends BaseViewModel {
  final NavigationService _navigationService = locator<NavigationService>();

  void navigateToContacts() {
    _navigationService.navigateTo(RoutePaths.networkContacts);
  }

  void navigateToFindTeam() {
    _navigationService.navigateTo(RoutePaths.adverts);
  }

  void navigateToEvents() {
    _navigationService.navigateTo(RoutePaths.events);
  }

  void navigateToAssociations() {
    _navigationService.navigateTo(RoutePaths.networkAssociations);
  }
}
