import 'package:web/web.dart' as web;

/// Navigates the current browser tab to [url] — no new tab, no popup.
/// Equivalent to setting `window.location.href = url` from JS.
void navigateSameTab(String url) {
  web.window.location.assign(url);
}
