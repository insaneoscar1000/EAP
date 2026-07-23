import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';

import 'web_navigation_stub.dart'
    if (dart.library.html) 'web_navigation_web.dart';

/// Initiates PayStack payments by asking a Cloud Function to create a
/// transaction (so the secret key never lives in the client) and then
/// launching PayStack's hosted checkout in the user's browser.
///
/// Used for one-off ad placement payments and (on the web build only)
/// for subscription purchases.
class PaymentService {
  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  /// Starts a one-off payment for an advert placement.
  ///
  /// Returns `true` if checkout was launched; the actual payment outcome
  /// is reflected asynchronously in Firestore by the PayStack webhook.
  Future<bool> startAdPayment({
    required String advertId,
    required double amount,
    required String email,
  }) async {
    return _initialize(
      callable: 'initializeAdPayment',
      payload: <String, dynamic>{
        'advertId': advertId,
        'amount': amount,
        'email': email,
      },
    );
  }

  /// Starts a one-off payment for an event listing.
  Future<bool> startEventPayment({
    required String eventId,
    required double amount,
    required String email,
  }) async {
    return _initialize(
      callable: 'initializeEventPayment',
      payload: <String, dynamic>{
        'eventId': eventId,
        'amount': amount,
        'email': email,
      },
    );
  }

  /// Starts a subscription checkout (web only — the mobile builds
  /// never call this).
  Future<bool> startSubscription({
    required String planCode,
    required String email,
  }) async {
    return _initialize(
      callable: 'initializeSubscription',
      payload: <String, dynamic>{
        'planCode': planCode,
        'email': email,
      },
    );
  }

  /// Cancels the current user's active subscription via PayStack.
  /// Renewals stop; the user keeps access until the current period ends.
  /// Returns `true` on success, `false` if the function errored.
  Future<bool> cancelSubscription() async {
    if (!_platformAllowed) {
      debugPrint('cancelSubscription blocked: web-only flow.');
      return false;
    }
    try {
      await _functions
          .httpsCallable('cancelSubscription')
          .call(<String, dynamic>{});
      return true;
    } catch (e) {
      debugPrint('cancelSubscription failed: $e');
      return false;
    }
  }

  /// Hard gate — PayStack flows only run on web. On iOS/Android we
  /// must not initiate any external purchase from inside the app
  /// (App Store anti-steering rule 3.1.3 and the equivalent Google
  /// Play policy). Callers should rely on this returning `false` and
  /// show a "this is web-only" message instead.
  bool get _platformAllowed => kIsWeb;

  Future<bool> _initialize({
    required String callable,
    required Map<String, dynamic> payload,
  }) async {
    if (!_platformAllowed) {
      debugPrint(
          '$callable blocked: payments are only available on the web build.');
      return false;
    }
    try {
      final HttpsCallableResult<dynamic> result =
          await _functions.httpsCallable(callable).call(payload);
      final Map<String, dynamic> data =
          Map<String, dynamic>.from(result.data as Map<dynamic, dynamic>);
      final String? authorizationUrl = data['authorizationUrl'] as String?;
      if (authorizationUrl == null) {
        debugPrint('$callable returned no authorizationUrl');
        return false;
      }
      // Navigate the current tab to PayStack — no new tab, no popup.
      // Using window.location.assign directly avoids url_launcher's
      // window.open path, which some browsers re-interpret as a popup
      // when called outside a synchronous click handler (i.e. after an
      // await for the cloud function). The post-payment redirect lands
      // back in this same tab.
      navigateSameTab(authorizationUrl);
      return true;
    } catch (e) {
      debugPrint('Payment init failed ($callable): $e');
      return false;
    }
  }
}
