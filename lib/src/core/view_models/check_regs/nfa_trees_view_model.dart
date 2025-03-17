import 'package:stacked/stacked.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:the_eap_app/src/core/models/models.dart';
import 'package:the_eap_app/src/core/services/services.dart';
import 'package:the_eap_app/src/locator.dart';

class NFATreesViewModel extends StreamViewModel<List<NFATree>> {
  final NFATreeService _nfaTreeService = locator<NFATreeService>();
  List<NFATree> _allTrees = [];
  String _searchQuery = '';

  List<NFATree> get nfaTrees {
    if (_searchQuery.isEmpty) return data ?? [];
    return _allTrees.where((tree) {
      final query = _searchQuery.toLowerCase();
      return tree.botanicalName.toLowerCase().contains(query) ||
          tree.commonName.toLowerCase().contains(query) ||
          tree.otherCommonName.toLowerCase().contains(query) ||
          tree.nationalTreeNumber.toString().contains(query);
    }).toList();
  }

  @override
  Stream<List<NFATree>> get stream => _nfaTreeService.getNFATrees();

  @override
  void onData(List<NFATree>? data) {
    super.onData(data);
    if (data != null) {
      _allTrees = data;
    }
  }

  void onSearchQueryChanged(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<void> openTreeLink(String? url) async {
    if (url == null || url.isEmpty) return;

    try {
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      }
    } catch (e) {
      print('Error opening tree link: $e');
    }
  }
}
