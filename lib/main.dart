import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:the_eap_app/firebase_options.dart';
import 'package:the_eap_app/src/app.dart';
import 'package:the_eap_app/src/locator.dart';
import 'package:the_eap_app/src/core/constants/constants.dart';
import 'package:the_eap_app/src/core/services/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Clean web URLs: `/home` instead of `/#/home`. No-op on mobile.
  usePathUrlStrategy();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  setupLocator();

  // Warm the subscription cache before the Navigator resolves its first
  // route. A deep-linked page load -- a bookmark, a browser refresh while
  // sitting on a non-root path, or (critically) PayStack's checkout
  // redirect back to a URL like /events/return -- never builds SplashView
  // at all: Flutter calls onGenerateRoute directly for the requested path,
  // bypassing `home` entirely. Relying on Splash alone to bind() the
  // subscription left the router's premium gate reading a permanently-empty
  // cache on every such load, bouncing genuinely-subscribed users straight
  // to the paywall with no way back (this is what happened right after a
  // successful event/advert payment).
  final storageService = locator<StorageService>();
  final userId = await storageService.getString(StorageConstants.userId);
  if (userId != null && userId.isNotEmpty) {
    await locator<SubscriptionService>().bind(userId);
  }

  runApp(App());
}
