import 'dart:js_interop';

import 'package:web/web.dart' as web;

/// Web: there is no filesystem to write to, so trigger a normal browser
/// download instead — a Blob URL clicked via a throwaway anchor element.
Future<void> saveIAPExportFile(String content, String filename) async {
  final blob = web.Blob(
    [content.toJS].toJS,
    web.BlobPropertyBag(type: 'text/csv;charset=utf-8'),
  );
  final url = web.URL.createObjectURL(blob);

  final anchor = web.document.createElement('a') as web.HTMLAnchorElement;
  anchor.href = url;
  anchor.download = filename;
  web.document.body!.appendChild(anchor);
  anchor.click();
  anchor.remove();

  web.URL.revokeObjectURL(url);
}
