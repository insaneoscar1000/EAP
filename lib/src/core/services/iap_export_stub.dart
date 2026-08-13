import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

/// Mobile/desktop: write the export to a temp file and hand it to the
/// platform share sheet. `path_provider` has no web implementation, so
/// this file is never selected on web — see `iap_export_web.dart`.
Future<void> saveIAPExportFile(String content, String filename) async {
  final directory = await getTemporaryDirectory();
  final file = File('${directory.path}/$filename');
  await file.writeAsString(content);
  await Share.shareXFiles([XFile(file.path)], text: 'I&AP Database Export');
}
