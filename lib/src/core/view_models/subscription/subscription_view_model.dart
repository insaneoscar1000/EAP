import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:stacked/stacked.dart';
import 'package:the_eap_app/src/core/constants/constants.dart';
import 'package:the_eap_app/src/core/services/services.dart';
import 'package:the_eap_app/src/locator.dart';

/// Subscription view model.
///
/// Mobile (iOS/Android): read-only. Shows current entitlement only.
/// Web: also exposes [startCheckout] so users can subscribe via PayStack.
class SubscriptionViewModel extends BaseViewModel {
  final SubscriptionService _subscriptionService =
      locator<SubscriptionService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final PaymentService _paymentService = locator<PaymentService>();

  StreamSubscription<Map<String, dynamic>?>? _subscriptionStreamSub;

  bool _isStartingCheckout = false;
  bool get isStartingCheckout => _isStartingCheckout;

  bool _isCancelling = false;
  bool get isCancelling => _isCancelling;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool get isPremium => _subscriptionService.isPremiumCached;
  bool get isInTrial => _subscriptionService.isInTrialCached;
  DateTime? get trialEndsAt => _subscriptionService.trialEndsAt;
  DateTime? get expirationDate => _subscriptionService.expirationDate;
  String get status => _subscriptionService.status;

  Future<void> initialize() async {
    setBusy(true);
    await _subscriptionService.isPremium();
    _subscriptionStreamSub =
        _subscriptionService.subscriptionStream.listen((_) {
      notifyListeners();
    });
    setBusy(false);
  }

  /// Web only — launches PayStack hosted checkout for the monthly plan.
  Future<void> startCheckout() async {
    _errorMessage = null;
    _isStartingCheckout = true;
    notifyListeners();
    try {
      final String? email = FirebaseAuth.instance.currentUser?.email;
      if (email == null) {
        _errorMessage = 'You must be logged in to subscribe.';
        return;
      }
      final bool launched = await _paymentService.startSubscription(
        planCode: PaystackConstants.monthlyPlanCode,
        email: email,
      );
      if (!launched) {
        _errorMessage = 'Could not start checkout. Please try again.';
      }
    } catch (e) {
      _errorMessage = 'Checkout failed: $e';
    } finally {
      _isStartingCheckout = false;
      notifyListeners();
    }
  }

  /// Cancels the user's active subscription. Renewals stop; access
  /// continues until the current period ends.
  Future<bool> cancelSubscription() async {
    _errorMessage = null;
    _isCancelling = true;
    notifyListeners();
    try {
      final bool success = await _paymentService.cancelSubscription();
      if (!success) {
        _errorMessage = 'Could not cancel subscription. Please try again.';
      }
      return success;
    } finally {
      _isCancelling = false;
      notifyListeners();
    }
  }

  void goBack() {
    _navigationService.pop();
  }

  @override
  void dispose() {
    _subscriptionStreamSub?.cancel();
    super.dispose();
  }
}
