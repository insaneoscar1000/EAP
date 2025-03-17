import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:the_eap_app/src/core/view_models/view_models.dart';
import 'package:the_eap_app/src/ui/shared/widgets/widgets.dart';

class EIABasicsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<EIABasicsViewModel>.reactive(
      viewModelBuilder: () => EIABasicsViewModel(),
      builder:
          (BuildContext context, EIABasicsViewModel model, Widget? child) =>
              Scaffold(
        appBar: DefaultAppBar(
          title: 'EIA Basics',
          showBackButton: false,
        ),
        backgroundColor: Colors.white,
        body: BackgroundContainer(
          background: 'background-1',
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 24),
                  MenuItem(
                    title: 'NEMA Applications',
                    icon: IconsaxPlusLinear.document_text,
                    onTap: () => model.navigateToNemaApplications(),
                  ),
                  MenuItem(
                    title: 'Law Hub',
                    icon: IconsaxPlusLinear.bank,
                    onTap: () => model.navigateToLawHub(),
                  ),
                  MenuItem(
                    title: 'Acronyms',
                    icon: IconsaxPlusLinear.info_circle,
                    onTap: () => model.navigateToAcronyms(),
                  ),
                  MenuItem(
                    title: 'Definitions',
                    icon: IconsaxPlusLinear.message_question,
                    onTap: () => model.navigateToDefinitions(),
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
