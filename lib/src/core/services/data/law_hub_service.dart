import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:the_eap_app/src/core/constants/service_constants.dart';
import 'package:the_eap_app/src/core/models/models.dart';
import 'package:url_launcher/url_launcher.dart';

class LawHubService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<LawHub>> getLawHubs() {
    return _firestore
        .collection(ServiceConstants.lawHubs)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => LawHub.fromMap(doc.id, doc.data()))
            .toList());
  }

  Future<void> openLawHubFile(String fileUrl) async {
    final url = Uri.parse(fileUrl);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  Future<String?> downloadFile(String fileUrl, String fileName) async {
    try {
      final dio = Dio();
      final dir = await getApplicationDocumentsDirectory();
      final savePath = '${dir.path}/$fileName';

      await dio.download(
        fileUrl,
        savePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            // Calculate progress if needed
            final progress = (received / total * 100).toStringAsFixed(0);
            print('Download Progress: $progress%');
          }
        },
      );

      return savePath;
    } catch (e) {
      print('Error downloading file: $e');
      return null;
    }
  }
}
