import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class SubscriptionService {
  // RevenueCat Test Store API key (works for both platforms during testing)
  // TODO: Replace with production API keys when ready
  static const String _iosApiKey = 'test_rYwKiIqBYQKqZmTrgEysAmfrEto';
  static const String _androidApiKey = 'test_rYwKiIqBYQKqZmTrgEysAmfrEto';

  // Entitlement ID - this should match what you set up in RevenueCat dashboard
  static const String entitlementId = 'premium';

  // Product ID for monthly subscription
  static const String monthlyProductId = 'com.theeap.app.premium.monthly';

  bool _isInitialized = false;
  CustomerInfo? _customerInfo;
  final StreamController<CustomerInfo> _customerInfoController =
      StreamController<CustomerInfo>.broadcast();

  Stream<CustomerInfo> get customerInfoStream => _customerInfoController.stream;
  CustomerInfo? get customerInfo => _customerInfo;

  /// Initialize RevenueCat SDK
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      final configuration = PurchasesConfiguration(
        Platform.isIOS ? _iosApiKey : _androidApiKey,
      );

      await Purchases.configure(configuration);
      _isInitialized = true;

      // Listen for customer info updates
      Purchases.addCustomerInfoUpdateListener((customerInfo) {
        _customerInfo = customerInfo;
        _customerInfoController.add(customerInfo);
      });

      // Get initial customer info
      _customerInfo = await Purchases.getCustomerInfo();
      debugPrint('RevenueCat initialized successfully');
    } catch (e) {
      debugPrint('Error initializing RevenueCat: $e');
      rethrow;
    }
  }

  /// Login user to RevenueCat (call after Firebase auth)
  Future<void> login(String userId) async {
    try {
      final result = await Purchases.logIn(userId);
      _customerInfo = result.customerInfo;
      _customerInfoController.add(result.customerInfo);
      debugPrint('RevenueCat user logged in: $userId');
    } catch (e) {
      debugPrint('Error logging in to RevenueCat: $e');
      rethrow;
    }
  }

  /// Logout user from RevenueCat
  Future<void> logout() async {
    try {
      _customerInfo = await Purchases.logOut();
      debugPrint('RevenueCat user logged out');
    } catch (e) {
      debugPrint('Error logging out from RevenueCat: $e');
      rethrow;
    }
  }

  /// Check if user has active premium subscription
  Future<bool> isPremium() async {
    try {
      final customerInfo = await Purchases.getCustomerInfo();
      _customerInfo = customerInfo;

      debugPrint('RevenueCat Customer ID: ${customerInfo.originalAppUserId}');
      debugPrint(
          'RevenueCat Active Entitlements: ${customerInfo.entitlements.active.keys.toList()}');
      debugPrint(
          'RevenueCat All Entitlements: ${customerInfo.entitlements.all.keys.toList()}');

      final hasPremium =
          customerInfo.entitlements.active.containsKey(entitlementId);
      debugPrint('Has premium entitlement "$entitlementId": $hasPremium');

      return hasPremium;
    } catch (e) {
      debugPrint('Error checking premium status: $e');
      return false;
    }
  }

  /// Get current subscription status synchronously (from cache)
  bool get isPremiumCached {
    return _customerInfo?.entitlements.active.containsKey(entitlementId) ??
        false;
  }

  /// Get available offerings (subscription packages)
  Future<Offerings?> getOfferings() async {
    try {
      final offerings = await Purchases.getOfferings();
      return offerings;
    } catch (e) {
      debugPrint('Error getting offerings: $e');
      return null;
    }
  }

  /// Get the monthly subscription package
  Future<Package?> getMonthlyPackage() async {
    try {
      final offerings = await getOfferings();
      if (offerings?.current != null) {
        // Try to get monthly package from current offering
        return offerings!.current!.monthly;
      }
      return null;
    } catch (e) {
      debugPrint('Error getting monthly package: $e');
      return null;
    }
  }

  /// Purchase a subscription package
  Future<bool> purchasePackage(Package package) async {
    try {
      final customerInfo = await Purchases.purchasePackage(package);
      _customerInfo = customerInfo;
      _customerInfoController.add(customerInfo);

      // Check if purchase was successful
      if (customerInfo.entitlements.active.containsKey(entitlementId)) {
        debugPrint('Purchase successful!');
        return true;
      }
      return false;
    } on PurchasesErrorCode catch (e) {
      debugPrint('Purchase error: $e');
      if (e == PurchasesErrorCode.purchaseCancelledError) {
        debugPrint('User cancelled purchase');
      }
      return false;
    } catch (e) {
      debugPrint('Error purchasing package: $e');
      return false;
    }
  }

  /// Restore previous purchases
  Future<bool> restorePurchases() async {
    try {
      final customerInfo = await Purchases.restorePurchases();
      _customerInfo = customerInfo;
      _customerInfoController.add(customerInfo);

      if (customerInfo.entitlements.active.containsKey(entitlementId)) {
        debugPrint('Restore successful - premium access restored');
        return true;
      }
      debugPrint('Restore completed - no active subscriptions found');
      return false;
    } catch (e) {
      debugPrint('Error restoring purchases: $e');
      return false;
    }
  }

  /// Get subscription expiration date
  DateTime? getExpirationDate() {
    final entitlement = _customerInfo?.entitlements.active[entitlementId];
    if (entitlement?.expirationDate != null) {
      return DateTime.parse(entitlement!.expirationDate!);
    }
    return null;
  }

  /// Check if subscription will renew
  bool get willRenew {
    final entitlement = _customerInfo?.entitlements.active[entitlementId];
    return entitlement?.willRenew ?? false;
  }

  /// Get management URL for subscription
  Future<String?> getManagementUrl() async {
    try {
      final customerInfo = await Purchases.getCustomerInfo();
      return customerInfo.managementURL;
    } catch (e) {
      debugPrint('Error getting management URL: $e');
      return null;
    }
  }

  void dispose() {
    _customerInfoController.close();
  }
}
