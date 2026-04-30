import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:the_eap_app/src/app.dart';
import 'package:the_eap_app/src/locator.dart';
import 'package:the_eap_app/src/core/services/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setupLocator();

  // Initialize RevenueCat
  try {
    await locator<SubscriptionService>().initialize();
  } catch (e) {
    debugPrint('Failed to initialize RevenueCat: $e');
  }

  runApp(App());
}
