import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:the_eap_app/src/core/view_models/view_models.dart';
import 'package:the_eap_app/src/ui/shared/widgets/widgets.dart';

class NetworkView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NetworkViewModel>.reactive(
      viewModelBuilder: () => NetworkViewModel(),
      builder: (BuildContext context, NetworkViewModel model, Widget? child) =>
          Scaffold(
        appBar: DefaultAppBar(
          title: 'Network',
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
                  SizedBox(height: 16),
                  MenuItem(
                    title: 'My Contacts',
                    subtitle: 'My EAP phone book for essential contacts',
                    icon: IconsaxPlusLinear.call,
                    onTap: () => model.navigateToContacts(),
                  ),
                  MenuItem(
                    title: 'Find My Team',
                    subtitle: 'EAPs, ECOs & Social Classifieds',
                    icon: IconsaxPlusLinear.people,
                    onTap: () => model.navigateToFindTeam(),
                  ),
                  MenuItem(
                    title: 'EAP Events',
                    subtitle: 'Upcoming courses, conferences',
                    icon: IconsaxPlusLinear.calendar,
                    onTap: () => model.navigateToEvents(),
                  ),
                  MenuItem(
                    title: 'Prof. Associations',
                    subtitle: 'Clubs for clever people',
                    icon: IconsaxPlusLinear.profile_2user,
                    onTap: () => model.navigateToAssociations(),
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
