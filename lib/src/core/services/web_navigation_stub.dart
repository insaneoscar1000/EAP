/// Stub for non-web platforms. Never called because PayStack flows
/// are blocked by the `kIsWeb` gate before reaching this code.
void navigateSameTab(String url) {
  throw UnsupportedError('navigateSameTab is web-only.');
}
