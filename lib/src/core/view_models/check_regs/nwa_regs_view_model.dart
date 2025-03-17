import 'package:stacked/stacked.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:the_eap_app/src/core/models/nwa_reg.dart';
import 'package:the_eap_app/src/core/services/data/nwa_reg_service.dart';
import 'package:the_eap_app/src/locator.dart';

class NWARegsViewModel extends StreamViewModel<List<NWAReg>> {
  final NWARegService _nwaRegService = locator<NWARegService>();
  List<NWAReg> _allRegs = [];
  String _searchQuery = '';

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
    super.onData(data);
    if (data != null) {
      _allRegs = data;
    }
  }

  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<void> downloadWULAGuide() async {
    const url = 'https://example.com/wula-guide.pdf';
    try {
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      }
    } catch (e) {
      print('Error downloading WULA guide: $e');
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
