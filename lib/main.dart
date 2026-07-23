import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:the_eap_app/firebase_options.dart';
import 'package:the_eap_app/src/app.dart';
import 'package:the_eap_app/src/locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Clean web URLs: `/home` instead of `/#/home`. No-op on mobile.
  usePathUrlStrategy();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  setupLocator();

  runApp(App());
}
