import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

/// Mobile/desktop: write the text to a temp file and open the share sheet.
Future<void> saveTextExportFile(
    String content, String filename, String shareText) async {
  final directory = await getTemporaryDirectory();
  final file = File('${directory.path}/$filename');
  await file.writeAsString(content);
  await Share.shareXFiles([XFile(file.path)], text: shareText);
}
