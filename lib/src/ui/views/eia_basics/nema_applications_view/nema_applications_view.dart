import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:the_eap_app/src/core/view_models/view_models.dart';
import 'package:the_eap_app/src/ui/shared/widgets/widgets.dart';

class NEMAApplicationsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NEMAApplicationsViewModel>.reactive(
      viewModelBuilder: () => NEMAApplicationsViewModel(),
      builder: (BuildContext context, NEMAApplicationsViewModel model,
              Widget? child) =>
          Scaffold(
        appBar: DefaultAppBar(
          title: 'NEMA Applications',
          showBackButton: true,
        ),
        backgroundColor: Colors.white,
        body: BackgroundContainer(
          background: 'background-3',
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 24),
                  MenuItem(
                    title: 'Basic Assessment',
                    icon: IconsaxPlusLinear.document_text,
                    onTap: () => model.navigateToBasicAssessment(),
                  ),
                  MenuItem(
                    title: 'Scoping & EIR',
                    icon: IconsaxPlusLinear.document_text,
                    onTap: () => model.navigateToScopingEIR(),
                  ),
                  MenuItem(
                    title: 'Section 24 G',
                    icon: IconsaxPlusLinear.document_text,
                    onTap: () => model.navigateToSection24G(),
                  ),
                  MenuItem(
                    title: 'EA Amendment',
                    icon: IconsaxPlusLinear.document_text,
                    onTap: () => model.navigateToEAAmendment(),
                  ),
                  SizedBox(height: 24),
                  Text(
                    'New EIA applications to be submitted electronically through the National Environmental Authorisation System (NEAS)',
                    style: TextStyle(fontSize: 16, height: 1.5),
                  ),
                  SizedBox(height: 16),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                        padding:
                            EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () => launchUrl(
                        Uri.parse('https://neas.environment.gov.za/dea_neas/'),
                        mode: LaunchMode.externalApplication,
                      ),
                      child: Text(
                        'Go to the NEAS',
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
