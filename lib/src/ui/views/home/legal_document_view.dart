import 'package:flutter/material.dart';
import 'package:the_eap_app/src/ui/shared/widgets/widgets.dart';

/// Renders a legal document's full text in-app, so Terms & Conditions and
/// Privacy Policy are accurate even before the matching pages are live on
/// theeapapp.co.za.
class LegalDocumentView extends StatelessWidget {
  final String title;
  final String lastUpdated;
  final String body;

  const LegalDocumentView({
    Key? key,
    required this.title,
    required this.lastUpdated,
    required this.body,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(title: title, showBackButton: true),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                lastUpdated,
                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
              ),
              SizedBox(height: 16),
              Text(
                body,
                style: TextStyle(fontSize: 15, height: 1.5, color: Colors.black87),
              ),
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
