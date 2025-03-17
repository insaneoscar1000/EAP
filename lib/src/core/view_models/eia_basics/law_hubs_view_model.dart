import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:stacked/stacked.dart';
import 'package:the_eap_app/src/core/models/models.dart';
import 'package:the_eap_app/src/core/services/services.dart';
import 'package:the_eap_app/src/locator.dart';

class LawHubsViewModel extends StreamViewModel<List<LawHub>> {
  final _lawHubService = locator<LawHubService>();
  String _searchQuery = '';
  List<LawHub> _allLawHubs = [];

  List<LawHub> get lawHubs {
    if (_searchQuery.isEmpty) return data ?? [];
    return _allLawHubs.where((lawHub) {
      final query = _searchQuery.toLowerCase();
      return lawHub.title.toLowerCase().contains(query) ||
          lawHub.description.toLowerCase().contains(query);
    }).toList();
  }

  @override
  Stream<List<LawHub>> get stream => _lawHubService.getLawHubs();

  @override
  void onData(List<LawHub>? data) {
    if (data != null) {
      _allLawHubs = data;
    }
    super.onData(data);
  }

  void onSearchQueryChanged(String value) {
    _searchQuery = value;
    notifyListeners();
  }

  Future<void> openLawHubFile(String fileUrl) async {
    await _lawHubService.openLawHubFile(fileUrl);
  }

  Future<void> downloadLawHubFile(String fileUrl, String title) async {
    final fileName = title.replaceAll(' ', '_').toLowerCase() + '.pdf';

    final filePath = await _lawHubService.downloadFile(fileUrl, fileName);

    if (filePath != null) {
      showSimpleNotification(
        Text('$fileName downloaded successfully'),
        background: Colors.green,
        duration: const Duration(seconds: 3),
      );
    } else {
      showSimpleNotification(
        const Text('Failed to download file'),
        background: Colors.red,
        duration: const Duration(seconds: 3),
      );
    }
  }
}
