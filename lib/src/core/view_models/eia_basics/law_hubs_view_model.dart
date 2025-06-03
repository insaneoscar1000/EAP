import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:stacked/stacked.dart';
import 'package:the_eap_app/src/core/models/models.dart';
import 'package:the_eap_app/src/core/services/services.dart';
import 'package:the_eap_app/src/locator.dart';

import 'package:url_launcher/url_launcher_string.dart';

class LawHubsViewModel extends StreamViewModel<List<LawHub>> {
  final _lawHubService = locator<LawHubService>();
  String _searchQuery = '';
  List<LawHub> _allLawHubs = [];

  List<LawHub> get lawHubs {
    List<LawHub> listToSort;
    if (_searchQuery.isEmpty) {
      listToSort = (data ?? []).toList();
    } else {
      final query = _searchQuery.toLowerCase();
      listToSort = _allLawHubs.where((lawHub) {
        return lawHub.title.toLowerCase().contains(query) ||
            lawHub.description.toLowerCase().contains(query);
      }).toList();
    }
    listToSort
        .sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
    return listToSort;
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
    if (await canLaunchUrlString(fileUrl)) {
      await launchUrlString(fileUrl);
    } else {
      showSimpleNotification(
        const Text('Could not open file.'),
        background: Colors.red,
        duration: const Duration(seconds: 3),
      );
    }
  }
}
