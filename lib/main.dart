import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:the_eap_app/src/app.dart';
import 'package:the_eap_app/src/locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setupLocator();
  runApp(App());
}
