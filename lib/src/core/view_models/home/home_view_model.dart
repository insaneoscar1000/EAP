import 'package:stacked/stacked.dart';
import 'package:the_eap_app/src/core/constants/constants.dart';
import 'package:the_eap_app/src/core/services/services.dart';
import 'package:the_eap_app/src/locator.dart';

class HomeViewModel extends BaseViewModel {
  final NavigationService _navigationService = locator<NavigationService>();

  Future<void> navigateToNetwork() async {
    await _navigationService.navigateTo(RoutePaths.network);
  }

  Future<void> navigateToEIABasics() async {
    await _navigationService.navigateTo(RoutePaths.eiaBasics);
  }

  Future<void> navigateToCheckRegs() async {
    await _navigationService.navigateTo(RoutePaths.checkRegs);
  }
}
