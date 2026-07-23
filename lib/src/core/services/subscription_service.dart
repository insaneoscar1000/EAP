import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:the_eap_app/src/core/services/app/storage_service.dart';
import 'package:the_eap_app/src/core/constants/constants.dart';
import 'package:the_eap_app/src/locator.dart';

/// Subscription state for the current user.
///
/// Source of truth is Firestore: `users/{uid}.subscription`, written by
/// the PayStack webhook Cloud Function after a successful web purchase.
/// The mobile app is read-only — purchases happen exclusively on the
/// web build to comply with App Store / Play Store anti-steering rules.
class SubscriptionService {
  final StorageService _storageService = locator<StorageService>();

  /// Status values written by the webhook.
  static const String statusActive = 'active';
  static const String statusCancelled = 'cancelled';
  static const String statusExpired = 'expired';
  static const String statusNone = 'none';

  /// Length of the free trial granted to every new sign-up.
  static const Duration trialDuration = Duration(days: 30);

  Map<String, dynamic>? _subscription;
  Map<String, dynamic>? get subscription => _subscription;

  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>?
      _userDocSubscription;
  final StreamController<Map<String, dynamic>?> _controller =
      StreamController<Map<String, dynamic>?>.broadcast();
  Stream<Map<String, dynamic>?> get subscriptionStream => _controller.stream;

  /// Begin listening to the current user's subscription field.
  /// Called after sign-in / sign-up.
  Future<void> bind(String userId) async {
    await _userDocSubscription?.cancel();
    _userDocSubscription = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .snapshots()
        .listen((DocumentSnapshot<Map<String, dynamic>> snap) {
      final Map<String, dynamic>? data = snap.data();
      _subscription = data?['subscription'] as Map<String, dynamic>?;
      _controller.add(_subscription);
    }, onError: (Object e) {
      debugPrint('SubscriptionService stream error: $e');
    });
  }

  /// Stop listening. Called on logout.
  Future<void> unbind() async {
    await _userDocSubscription?.cancel();
    _userDocSubscription = null;
    _subscription = null;
    _controller.add(null);
  }

  /// One-shot fetch — useful for places that don't subscribe to the stream.
  Future<bool> isPremium() async {
    final String? userId =
        await _storageService.getString(StorageConstants.userId);
    if (userId == null) {
      return false;
    }
    try {
      final DocumentSnapshot<Map<String, dynamic>> doc = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(userId)
          .get();
      final Map<String, dynamic>? sub =
          doc.data()?['subscription'] as Map<String, dynamic>?;
      _subscription = sub;
      return _isActive(sub);
    } catch (e) {
      debugPrint('SubscriptionService.isPremium error: $e');
      return false;
    }
  }

  /// Cached premium check — uses last-known stream value, no network.
  bool get isPremiumCached => _isActive(_subscription);

  /// True if the user has either a paid subscription OR is still within
  /// the free trial window. This is the gate for "can access content".
  bool get hasAccessCached =>
      isPremiumCached || _isInTrial(_subscription);

  /// One-shot fetch of [hasAccessCached] — useful for places that don't
  /// subscribe to the stream.
  Future<bool> hasAccess() async {
    if (await isPremium()) {
      return true;
    }
    return _isInTrial(_subscription);
  }

  /// Date the free trial ends, if any.
  DateTime? get trialEndsAt {
    final Object? raw = _subscription?['trialEndsAt'];
    if (raw is Timestamp) {
      return raw.toDate();
    }
    if (raw is String) {
      return DateTime.tryParse(raw);
    }
    return null;
  }

  /// True if the user is currently inside their free trial window.
  bool get isInTrialCached => _isInTrial(_subscription);

  DateTime? get expirationDate {
    final Object? raw = _subscription?['currentPeriodEnd'];
    if (raw is Timestamp) {
      return raw.toDate();
    }
    if (raw is String) {
      return DateTime.tryParse(raw);
    }
    return null;
  }

  String get status =>
      (_subscription?['status'] as String?) ?? statusNone;

  bool _isInTrial(Map<String, dynamic>? sub) {
    if (sub == null) {
      return false;
    }
    final Object? raw = sub['trialEndsAt'];
    final DateTime? endsAt = raw is Timestamp
        ? raw.toDate()
        : (raw is String ? DateTime.tryParse(raw) : null);
    if (endsAt == null) {
      return false;
    }
    return endsAt.isAfter(DateTime.now());
  }

  bool _isActive(Map<String, dynamic>? sub) {
    if (sub == null) {
      return false;
    }
    if (sub['status'] != statusActive) {
      return false;
    }
    final DateTime? exp = (() {
      final Object? raw = sub['currentPeriodEnd'];
      if (raw is Timestamp) {
        return raw.toDate();
      }
      if (raw is String) {
        return DateTime.tryParse(raw);
      }
      return null;
    })();
    if (exp == null) {
      return true; // No expiry recorded — treat as active.
    }
    return exp.isAfter(DateTime.now());
  }

  void dispose() {
    _userDocSubscription?.cancel();
    _controller.close();
  }
}
