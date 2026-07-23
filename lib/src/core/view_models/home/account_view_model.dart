import 'package:firebase_auth/firebase_auth.dart';
import 'package:stacked/stacked.dart';
import 'package:the_eap_app/src/locator.dart';
import 'package:the_eap_app/src/core/models/models.dart';
import 'package:the_eap_app/src/core/services/services.dart';
import 'package:the_eap_app/src/core/constants/constants.dart';

class AccountViewModel extends BaseViewModel {
  final AuthService _authService = locator<AuthService>();
  final UserService _userService = locator<UserService>();
  final StorageService _storageService = locator<StorageService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final SubscriptionService _subscriptionService =
      locator<SubscriptionService>();

  Stream<UserRecord>? _userStream;
  Stream<UserRecord>? get userStream => _userStream;

  Future<void> init() async {
    setBusy(true);
    String? userId = await _storageService.getString(StorageConstants.userId);
    if (userId != null) {
      _userStream = _userService.getUserStream(userId);
    }
    setBusy(false);
  }

  Future<void> logout() async {
    setBusy(true);
    await _authService.signOut();

    await _subscriptionService.unbind();

    await _storageService.clearAll();
    _navigationService.navigateToReplacement(RoutePaths.welcome);
    setBusy(false);
  }

  Future<void> deleteAccount() async {
    try {
      setBusy(true);

      final User? currentUser = await _authService.getCurrentUser();
      if (currentUser == null) throw Exception('No user logged in');

      await _userService.deleteUser(currentUser.uid);

      await _authService.deleteCurrentUser();

      await _storageService.clearAll();

      _navigationService.navigateToReplacement(RoutePaths.welcome);
    } catch (e) {
      setError(e.toString());
    } finally {
      setBusy(false);
    }
  }
}
