import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationService {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  Future<String?> getToken() async {
    // Web push is not set up (no service worker / VAPID key), and iPhone Safari
    // does not support it outside an installed Home Screen app.
    if (kIsWeb) return '';
    try {
      if (Platform.isIOS) {
        // Check if running on simulator
        if (await _isSimulator()) {
          return ''; // Return empty string for simulator
        }
      }
      return await messaging.getToken();
    } catch (e) {
      // If there's an error getting the token (like on simulator), return empty string
      return '';
    }
  }

  Future<bool> _isSimulator() async {
    if (Platform.isIOS) {
      return !await _isiOSDevice();
    }
    return false;
  }

  Future<bool> _isiOSDevice() async {
    // These paths only exist on real devices
    return await Directory('/private/var/mobile/Library/AddressBook').exists();
  }

  Future<void> requestNotificationPermissions() async {
    if (kIsWeb) return;
    try {
      await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
    } catch (_) {
      // Never let a notification problem block app start-up.
    }
  }
}
