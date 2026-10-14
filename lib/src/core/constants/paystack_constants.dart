/// PayStack configuration.
///
/// The secret key is NEVER stored in this client. All transaction
/// initialization and webhook verification happens server-side in
/// Firebase Cloud Functions (see `functions/src/index.ts`).
///
/// The public key here is safe to ship; it only authorizes
/// client-side checkout flows.
class PaystackConstants {
  /// PayStack public key (live).
  static const String publicKey =
      'pk_live_dae4055188f08de1e4ad5a9300f616d6d38e3c23';

  /// ISO currency code used for all transactions.
  /// Likely 'ZAR' for South Africa. PayStack also supports NGN, GHS, USD, KES.
  static const String currency = 'ZAR';

  /// Subscription plan codes from the PayStack dashboard.
  static const String monthlyPlanCode = 'PLN_r7o0pauedfbhzhd';

  /// Public URL of the web app — used as the callback / return URL
  /// after PayStack checkout completes. Firebase Hosting auto-provisions
  /// `https://<project-id>.web.app` until a custom domain is connected.
  static const String webBaseUrl = 'https://the-eap-app.web.app';
}
