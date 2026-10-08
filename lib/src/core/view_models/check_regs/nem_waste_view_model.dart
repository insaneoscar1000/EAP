import 'package:stacked/stacked.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:the_eap_app/src/core/models/models.dart';
import 'package:the_eap_app/src/core/services/services.dart';
import 'package:the_eap_app/src/locator.dart';

/// Landing screen of NEM: Waste (Category C norms list with PDF downloads).
class NEMWasteViewModel extends StreamViewModel<List<NEMWasteNorm>> {
  final NEMService _nemService = locator<NEMService>();

  List<NEMWasteNorm> get norms => data ?? <NEMWasteNorm>[];

  @override
  Stream<List<NEMWasteNorm>> get stream => _nemService.getWasteNorms();

  Future<void> openNorm(NEMWasteNorm norm) async {
    if (norm.pdfUrl.isEmpty) return;
    try {
      final Uri uri = Uri.parse(norm.pdfUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      }
    } catch (e) {
      print('Error opening norm PDF: $e');
    }
  }
}
