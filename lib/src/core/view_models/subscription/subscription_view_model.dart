import 'dart:async';

import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:the_eap_app/src/core/services/services.dart';
import 'package:the_eap_app/src/locator.dart';
import 'package:url_launcher/url_launcher.dart';

class SubscriptionViewModel extends BaseViewModel {
  final SubscriptionService _subscriptionService =
      locator<SubscriptionService>();
  final NavigationService _navigationService = locator<NavigationService>();

  StreamSubscription<CustomerInfo>? _customerInfoSubscription;

  bool _isPremium = false;
  bool get isPremium => _isPremium;

  Package? _monthlyPackage;
  Package? get monthlyPackage => _monthlyPackage;

  String? _priceString;
  String? get priceString => _priceString;

  DateTime? _expirationDate;
  DateTime? get expirationDate => _expirationDate;

  bool _willRenew = false;
  bool get willRenew => _willRenew;

  bool _isPurchasing = false;
  bool get isPurchasing => _isPurchasing;

  bool _isRestoring = false;
  bool get isRestoring => _isRestoring;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> initialize() async {
    setBusy(true);

    try {
      // Check current subscription status
      _isPremium = await _subscriptionService.isPremium();
      _expirationDate = _subscriptionService.getExpirationDate();
      _willRenew = _subscriptionService.willRenew;

      // Get available package
      _monthlyPackage = await _subscriptionService.getMonthlyPackage();
      if (_monthlyPackage != null) {
        _priceString = _monthlyPackage!.storeProduct.priceString;
      }

      // Listen for subscription changes
      _customerInfoSubscription = _subscriptionService.customerInfoStream
          .listen((CustomerInfo customerInfo) {
        _isPremium = customerInfo.entitlements.active
            .containsKey(SubscriptionService.entitlementId);
        _expirationDate = _subscriptionService.getExpirationDate();
        _willRenew = _subscriptionService.willRenew;
        notifyListeners();
      });
    } catch (e) {
      _errorMessage = 'Failed to load subscription info: $e';
      debugPrint(_errorMessage);
    }

    setBusy(false);
  }

  Future<bool> purchaseSubscription() async {
    if (_monthlyPackage == null) {
      _errorMessage = 'No subscription package available';
      notifyListeners();
      return false;
    }

    _isPurchasing = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final bool success =
          await _subscriptionService.purchasePackage(_monthlyPackage!);

      if (success) {
        _isPremium = true;
        _expirationDate = _subscriptionService.getExpirationDate();
        _willRenew = _subscriptionService.willRenew;
      }

      _isPurchasing = false;
      notifyListeners();
      return success;
    } catch (e) {
      _errorMessage = 'Purchase failed: $e';
      _isPurchasing = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> restorePurchases() async {
    _isRestoring = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final bool success = await _subscriptionService.restorePurchases();

      if (success) {
        _isPremium = true;
        _expirationDate = _subscriptionService.getExpirationDate();
        _willRenew = _subscriptionService.willRenew;
      } else {
        _errorMessage = 'No active subscriptions found to restore';
      }

      _isRestoring = false;
      notifyListeners();
      return success;
    } catch (e) {
      _errorMessage = 'Restore failed: $e';
      _isRestoring = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> openManageSubscription() async {
    final String? url = await _subscriptionService.getManagementUrl();
    if (url != null) {
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        debugPrint('Could not launch management URL: $url');
      }
    } else {
      debugPrint('No management URL available');
    }
  }

  void goBack() {
    _navigationService.pop();
  }

  @override
  void dispose() {
    _customerInfoSubscription?.cancel();
    super.dispose();
  }
}
