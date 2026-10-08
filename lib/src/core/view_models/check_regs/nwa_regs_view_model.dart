import 'package:stacked/stacked.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:the_eap_app/src/core/models/nwa_reg.dart';
import 'package:the_eap_app/src/core/services/data/nwa_reg_service.dart';
import 'package:the_eap_app/src/locator.dart';

class NWARegsViewModel extends StreamViewModel<List<NWAReg>> {
  final NWARegService _nwaRegService = locator<NWARegService>();
  List<NWAReg> _allRegs = [];
  String _searchQuery = '';

  // Defaults, overridden by the app-settings/wula-guide doc (editable in the admin portal).
  static const String _defaultWulaSubtitle =
      'Procedural Requirements (GNR 267 of 24 March 2017)';
  static const String _defaultWulaUrl =
      'https://firebasestorage.googleapis.com/v0/b/the-eap-app.firebasestorage.app/o/system%2FWULA_Procedural_Requirements_GNR267_of_24_March_2017.pdf?alt=media&token=5acbaf8b-3e3a-45b0-b0d1-0039870a1e8b';
  String wulaSubtitle = _defaultWulaSubtitle;
  String _wulaUrl = _defaultWulaUrl;

  @override
  void initialise() {
    super.initialise();
    _loadWulaGuide();
  }

  Future<void> _loadWulaGuide() async {
    try {
      final Map<String, dynamic>? data = await _nwaRegService.getWulaGuide();
      if (data == null) return;
      final String subtitle = (data['subtitle'] ?? '').toString().trim();
      final String url = (data['pdfUrl'] ?? '').toString().trim();
      if (subtitle.isNotEmpty) wulaSubtitle = subtitle;
      if (url.isNotEmpty) _wulaUrl = url;
      notifyListeners();
    } catch (e) {
      print('Error loading WULA guide settings: $e');
    }
  }

  List<NWAReg> get nwaRegs {
    if (_searchQuery.isEmpty) return data ?? [];
    return _allRegs.where((reg) {
      final query = _searchQuery.toLowerCase();
      return reg.section.toLowerCase().contains(query) ||
          reg.regulation.toLowerCase().contains(query);
    }).toList();
  }

  @override
  Stream<List<NWAReg>> get stream {
    print('Getting NWA regs stream');
    return _nwaRegService.getNWARegs();
  }

  @override
  void onError(error) {
    print('Error in NWARegsViewModel: $error');
    super.onError(error);
  }

  @override
  void onData(List<NWAReg>? data) {
    print('Received data: ${data?.length} regs');
    if (data != null) {
      // Sort the data alphabetically by section name
      data.sort((a, b) => a.section.toLowerCase().compareTo(b.section.toLowerCase()));
      _allRegs = data;
    }
    super.onData(data);
  }

  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<void> downloadWULAGuide() async {
    final String url = _wulaUrl;
    try {
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      }
    } catch (e) {
      print('Error downloading WULA guide: $e');
    }
  }
  
  Future<void> openGeneralAuthorizations() async {
    const url = 'https://firebasestorage.googleapis.com/v0/b/eap-dev-f55c4.firebasestorage.app/o/system%2FGA_Section%2021%20e_f_%20g_h_j_%20GNR665%20of%206%20Secpt%202013.pdf?alt=media&token=03fec32c-a37b-49c9-822b-a405985a5aef';
    try {
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      }
    } catch (e) {
      print('Error opening General Authorizations: $e');
    }
  }
  
  Future<void> openWaterUses() async {
    const url = 'https://firebasestorage.googleapis.com/v0/b/eap-dev-f55c4.firebasestorage.app/o/system%2FGA_Section%2021%20c%20%26%20i_GNR%204167%20of%208%20December%202023.pdf?alt=media&token=9b6d548b-4c8b-4197-b746-75e4535a83f4';
    try {
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      }
    } catch (e) {
      print('Error opening Water Uses: $e');
    }
  }
  
  Future<void> openTakingStoringWater() async {
    const url = 'https://firebasestorage.googleapis.com/v0/b/eap-dev-f55c4.firebasestorage.app/o/system%2FGA_Section%2021%20a%20%26%20b_GNR538%20of%202%20Sept%202016.pdf?alt=media&token=ee031b15-ed48-41f8-96c4-dd52ea3e2510';
    try {
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      }
    } catch (e) {
      print('Error opening Taking & Storing Of Water: $e');
    }
  }

  Future<void> openRegulationLink(String? url) async {
    if (url == null || url.isEmpty) return;

    try {
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      }
    } catch (e) {
      print('Error opening regulation link: $e');
    }
  }
}
