import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:stacked/stacked.dart';
import 'package:the_eap_app/src/core/constants/route_constants.dart';
import 'package:the_eap_app/src/core/models/models.dart';
import 'package:the_eap_app/src/core/view_models/view_models.dart';
import 'package:the_eap_app/src/ui/shared/widgets/widgets.dart';

/// Landing screen of NEM: Waste. Categories A/B/C are headings only (not
/// buttons); the "Check" button opens the activity list.
class NEMWasteView extends StatelessWidget {
  static const Color terracotta = Color(0xFFC97B63);
  static const Color beige = Color(0xFF9C8B6E);
  static const Color sage = Color(0xFF6E7C62);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NEMWasteViewModel>.reactive(
      viewModelBuilder: () => NEMWasteViewModel(),
      builder: (BuildContext context, NEMWasteViewModel model, Widget? child) =>
          Scaffold(
        appBar: DefaultAppBar(
          title: 'NEM: Waste Activities',
          showBackButton: true,
          backgroundColor: terracotta,
        ),
        backgroundColor: Colors.white,
        body: BackgroundContainer(
          background: 'background-3',
          child: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Expanded(
                          child: _categoryBox(
                            'Category A',
                            'Basic Assessment (BA)',
                            beige,
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: _categoryBox(
                            'Category B',
                            'Scoping & EIR (S&EIR)',
                            terracotta,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 12),
                  _normsBox(context, model),
                  SizedBox(height: 24),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: terracotta,
                        foregroundColor: Colors.white,
                        padding:
                            EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () => Navigator.pushNamed(
                          context, RoutePaths.nemWasteActivities),
                      child: Text(
                        'Check NEM: Waste Activities  >',
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () => Navigator.pushNamed(
                          context, RoutePaths.nemWasteUnclassified),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Flexible(
                              child: Text(
                                'Wastes that do NOT require\nClassification or Assessment',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.info, color: Color(0xFF8A4B14)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _categoryBox(String title, String subtitle, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 1.5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: color),
          ),
          SizedBox(height: 6),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _normsBox(BuildContext context, NEMWasteViewModel model) {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
      decoration: BoxDecoration(
        color: sage.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: sage, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Center(
            child: Text(
              'Category C',
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold, color: sage),
            ),
          ),
          SizedBox(height: 6),
          Center(
            child: Text(
              'Norms & Standards (N&S) Registration',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, color: Colors.black87),
            ),
          ),
          SizedBox(height: 8),
          if (model.isBusy)
            Padding(
              padding: EdgeInsets.all(12),
              child: Center(child: LoadingIndicator()),
            )
          else
            ...model.norms.map((NEMWasteNorm norm) => InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: norm.pdfUrl.isEmpty ? null : () => model.openNorm(norm),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 6, right: 10),
                          child: Icon(Icons.circle, size: 6, color: sage),
                        ),
                        Expanded(
                          child: Text(
                            norm.title,
                            style: TextStyle(
                                fontSize: 14, color: Colors.black87, height: 1.3),
                          ),
                        ),
                        if (norm.pdfUrl.isNotEmpty) ...<Widget>[
                          SizedBox(width: 8),
                          Icon(IconsaxPlusLinear.document_download,
                              size: 22, color: sage),
                        ],
                      ],
                    ),
                  ),
                )),
        ],
      ),
    );
  }
}
