import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
