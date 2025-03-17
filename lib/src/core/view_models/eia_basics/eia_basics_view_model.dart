import 'package:stacked/stacked.dart';
import 'package:the_eap_app/src/core/constants/route_constants.dart';
import 'package:the_eap_app/src/core/services/services.dart';
import 'package:the_eap_app/src/locator.dart';

class EIABasicsViewModel extends BaseViewModel {
  final NavigationService _navigationService = locator<NavigationService>();

  Future<void> navigateToNemaApplications() async {
    await _navigationService.navigateTo(RoutePaths.nemaApplications);
  }

  Future<void> navigateToLawHub() async {
    await _navigationService.navigateTo(RoutePaths.lawHubs);
  }

  Future<void> navigateToAcronyms() async {
    await _navigationService.navigateTo(RoutePaths.acronyms);
  }

  Future<void> navigateToDefinitions() async {
    await _navigationService.navigateTo(RoutePaths.definitions);
  }

  Future<void> navigateToLawHubs() async {
    await _navigationService.navigateTo(RoutePaths.lawHubs);
  }
}
