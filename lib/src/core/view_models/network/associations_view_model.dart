import 'package:stacked/stacked.dart';
import 'package:the_eap_app/src/core/models/association.dart';
import 'package:the_eap_app/src/core/services/services.dart';
import 'package:the_eap_app/src/locator.dart';
import 'package:url_launcher/url_launcher.dart';

class AssociationsViewModel extends BaseViewModel {
  final AssociationService _associationService = locator<AssociationService>();
  List<Association> _allAssociations = [];
  List<Association> _filteredAssociations = [];
  List<Association> get associations => _filteredAssociations;

  Future<void> init() async {
    setBusy(true);
    try {
      _allAssociations = await _associationService.getAssociations();
      _filteredAssociations = List.from(_allAssociations);
      notifyListeners();
    } catch (e) {
      setError(e);
    } finally {
      setBusy(false);
    }
  }

  void search(String query) {
    if (query.isEmpty) {
      _filteredAssociations = List.from(_allAssociations);
    } else {
      _filteredAssociations = _allAssociations
          .where((association) => association.title
              .toLowerCase()
              .contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  Future<void> launchAssociationUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
