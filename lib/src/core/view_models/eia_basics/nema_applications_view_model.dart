import 'package:stacked/stacked.dart';
import 'package:the_eap_app/src/core/services/services.dart';
import 'package:the_eap_app/src/core/constants/constants.dart';
import 'package:the_eap_app/src/locator.dart';

class NEMAApplicationsViewModel extends BaseViewModel {
  final NavigationService _navigationService = locator<NavigationService>();

  Future<void> navigateToBasicAssessment() async {
    await _navigationService.navigateTo(RoutePaths.basicAssessment);
  }

  Future<void> navigateToScopingEIR() async {
    await _navigationService.navigateTo(RoutePaths.scopingEIR);
  }

  Future<void> navigateToSection24G() async {
    await _navigationService.navigateTo(RoutePaths.section24G);
  }

  Future<void> navigateToEAAmendment() async {
    await _navigationService.navigateTo(RoutePaths.eaAmendment);
  }
}
