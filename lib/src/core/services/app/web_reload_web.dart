import 'dart:js_interop';
import 'package:web/web.dart' as web;

/// Drops the Flutter service worker (and its cached app shell) then reloads, so the browser
/// pulls the freshly deployed bundle instead of the cached old one.
Future<void> reloadWebApp() async {
  try {
    final JSArray<web.ServiceWorkerRegistration> regs =
        await web.window.navigator.serviceWorker.getRegistrations().toDart;
    for (final web.ServiceWorkerRegistration reg in regs.toDart) {
      await reg.unregister().toDart;
    }
  } catch (_) {
    // Fall through to a plain reload.
  }
  web.window.location.reload();
}
