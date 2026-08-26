import 'package:stacked/stacked.dart';
import 'package:the_eap_app/src/core/constants/constants.dart';
import 'package:the_eap_app/src/core/services/services.dart';
import 'package:the_eap_app/src/locator.dart';

class HomeViewModel extends BaseViewModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final DialogService _dialogService = locator<DialogService>();
  final StorageService _storageService = locator<StorageService>();
  final SubscriptionService _subscriptionService =
      locator<SubscriptionService>();

  Future<void> initialize() async {
    await _checkTrialReminders();
  }

  Future<void> navigateToNetwork() async {
    await _navigationService.navigateTo(RoutePaths.network);
  }

  Future<void> navigateToEIABasics() async {
    await _navigationService.navigateTo(RoutePaths.eiaBasics);
  }

  Future<void> navigateToCheckRegs() async {
    await _navigationService.navigateTo(RoutePaths.checkRegs);
  }

  /// Shows a one-time in-app nudge at three points during the 7-day free
  /// trial. Real "drip campaign" emails aren't available yet — the
  /// Firestore "Trigger Email" extension isn't installed and there's no
  /// SMTP credential configured — so this is a client-side stand-in until
  /// that's set up.
  Future<void> _checkTrialReminders() async {
    if (!_subscriptionService.isInTrialCached) {
      return;
    }
    final DateTime? trialEndsAt = _subscriptionService.trialEndsAt;
    if (trialEndsAt == null) {
      return;
    }

    final int daysLeft =
        trialEndsAt.difference(DateTime.now()).inDays.clamp(0, 7);

    if (daysLeft <= 1) {
      await _showTrialReminderOnce(
        key: StorageConstants.trialReminderDay6Shown,
        title: 'Your Free Trial Ends Tomorrow',
        description:
            'Your 7-day free trial ends tomorrow. Upgrade now to keep full '
            'access to your Projects, Planning and the Check REG\'s '
            'database.',
        showUpgradeCta: true,
      );
    } else if (daysLeft <= 4) {
      await _showTrialReminderOnce(
        key: StorageConstants.trialReminderDay3Shown,
        title: 'Have You Tried These Yet?',
        description: "Don't miss Planning for tracking your project "
            'deadlines, or Network to find and connect with other EAPs.',
      );
    } else if (daysLeft <= 6) {
      await _showTrialReminderOnce(
        key: StorageConstants.trialReminderDay1Shown,
        title: 'Welcome to The EAP App!',
        description: "Get started with Check REG's to look up regulations, "
            'Planning to track deadlines, and Network to build your '
            'contacts.',
      );
    }
  }

  Future<void> _showTrialReminderOnce({
    required String key,
    required String title,
    required String description,
    bool showUpgradeCta = false,
  }) async {
    final String? shown = await _storageService.getString(key);
    if (shown == 'true') {
      return;
    }
    await _storageService.setString(key, 'true');

    if (showUpgradeCta) {
      final DialogResponse? result =
          await _dialogService.showConfirmationDialog(
        title: title,
        description: description,
        confirmationTitle: 'Upgrade Now',
        cancelTitle: 'Later',
      );
      if (result?.confirmed ?? false) {
        await _navigationService.navigateTo(RoutePaths.subscription);
      }
    } else {
      await _dialogService.showDialog(title: title, description: description);
    }
  }
}
