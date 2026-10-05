import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:the_eap_app/src/core/constants/paystack_constants.dart';
import 'package:the_eap_app/src/core/services/app/web_reload_stub.dart'
    if (dart.library.js_interop) 'package:the_eap_app/src/core/services/app/web_reload_web.dart';

/// Checks the published version (the `version.json` Flutter writes on every web build, plus the
/// optional `update.json` for forced updates) against the running build and, when the running
/// copy is behind, shows an "update available" dialog. Android uses the APK download link; the
/// web version reloads itself. Any failure (offline, bad JSON) is swallowed so launch never breaks.
class UpdateService {
  /// Overridable only for local testing (`--dart-define=UPDATE_BASE_URL=...`); production uses the live host.
  static const String updateBaseUrl = String.fromEnvironment('UPDATE_BASE_URL',
      defaultValue: PaystackConstants.webBaseUrl);
  static const String _apkUrl =
      '${updateBaseUrl}/downloads/EAPApp-release.apk';

  bool _checked = false;

  Future<void> checkForUpdate(BuildContext context) async {
    if (_checked) return;
    if (!kIsWeb && defaultTargetPlatform != TargetPlatform.android) return;
    _checked = true;

    try {
      final int installed =
          int.parse((await PackageInfo.fromPlatform()).buildNumber);

      final String stamp = DateTime.now().millisecondsSinceEpoch.toString();
      final Dio dio = Dio(BaseOptions(
        connectTimeout: const Duration(seconds: 8),
        receiveTimeout: const Duration(seconds: 8),
        responseType: ResponseType.json,
      ));
      const String base = updateBaseUrl;
      final Response<dynamic> versionRes =
          await dio.get<dynamic>('$base/version.json?t=$stamp');
      final int latest = int.parse('${_asMap(versionRes.data)['build_number']}');
      if (latest <= installed) return;

      int minimum = 0;
      try {
        final Response<dynamic> updateRes =
            await dio.get<dynamic>('$base/update.json?t=$stamp');
        minimum = int.tryParse(
                '${_asMap(updateRes.data)['min_build_number'] ?? 0}') ??
            0;
      } catch (_) {
        // update.json is optional; no file means a normal, dismissible update.
      }

      if (!context.mounted) return;
      await _showDialog(context, forced: installed < minimum);
    } catch (e) {
      debugPrint('Update check skipped: $e');
    }
  }

  Map<String, dynamic> _asMap(dynamic data) {
    if (data is Map) return Map<String, dynamic>.from(data);
    return Map<String, dynamic>.from(
        (jsonDecode(data as String)) as Map);
  }

  /// Downloads the APK inside the app and hands it to Android's installer (same one-tap flow as
  /// the GardenTeam app). Android always asks the user to confirm an install outside Play.
  Future<void> _downloadAndInstall(void Function(double?) onProgress) async {
    final Directory dir = await getTemporaryDirectory();
    final String path = '${dir.path}/eap-update.apk';
    await Dio().download(
      _apkUrl,
      path,
      onReceiveProgress: (int received, int total) {
        if (total > 0) onProgress(received / total);
      },
    );
    await OpenFilex.open(path);
  }

  Future<void> _showDialog(BuildContext context, {required bool forced}) {
    bool busy = false;
    double? progress;
    String? error;
    return showDialog<void>(
      context: context,
      barrierDismissible: !forced,
      builder: (BuildContext ctx) {
        return PopScope(
          canPop: !forced,
          child: StatefulBuilder(
            builder: (BuildContext ctx, StateSetter setState) => AlertDialog(
              title: const Text('A new version is available'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(kIsWeb
                      ? 'A newer version of The EAP App has been released. Refresh to load it.'
                      : 'A newer version of The EAP App is ready. Tap Update to download and install it; it keeps all your data.'),
                  if (busy) ...<Widget>[
                    const SizedBox(height: 16),
                    LinearProgressIndicator(value: progress),
                  ],
                  if (error != null) ...<Widget>[
                    const SizedBox(height: 12),
                    Text(error!, style: const TextStyle(color: Colors.red)),
                  ],
                ],
              ),
              actions: <Widget>[
                if (!forced && !busy)
                  TextButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    child: const Text('Later'),
                  ),
                TextButton(
                  onPressed: busy
                      ? null
                      : () async {
                          if (kIsWeb) {
                            await reloadWebApp();
                            return;
                          }
                          setState(() {
                            busy = true;
                            error = null;
                          });
                          try {
                            await _downloadAndInstall(
                                (double? p) => setState(() => progress = p));
                            if (!forced && ctx.mounted) Navigator.of(ctx).pop();
                          } catch (e) {
                            setState(() {
                              busy = false;
                              error = 'Download failed. Check your connection and try again.';
                            });
                          }
                        },
                  child: Text(kIsWeb ? 'Refresh' : 'Update'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
