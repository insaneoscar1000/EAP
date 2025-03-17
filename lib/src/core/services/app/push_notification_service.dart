import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationService {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  Future<String?> getToken() async {
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
    await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }
}
