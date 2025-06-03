import 'package:flutter/material.dart';
import 'package:the_eap_app/src/core/constants/route_constants.dart';
import 'package:the_eap_app/src/ui/shared/widgets/widgets.dart';

class CheckRegsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(
        title: 'Check the REGS',
        showBackButton: true,
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
                  title: 'NEMA Listing Notices',
                  subtitle: 'Do I need an EIA?',
                  borderColor: Theme.of(context).primaryColor,
                  onTap: () {
                    Navigator.pushNamed(context, RoutePaths.nemaActivities);
                  },
                ),
                SizedBox(height: 12),
                MenuItem(
                  title: 'NWA Water Uses',
                  subtitle: 'Do I need a WULA?',
                  borderColor: Color(0xff60788E),
                  onTap: () {
                    Navigator.pushNamed(context, RoutePaths.waterUses);
                  },
                ),
                SizedBox(height: 12),
                MenuItem(
                  title: 'NFA Protected Trees',
                  subtitle: 'Can I chop down this tree?',
                  borderColor: Color(0xFFFAB941),
                  onTap: () {
                    Navigator.pushNamed(context, RoutePaths.nfaTrees);
                  },
                ),
                SizedBox(height: 12),
                MenuItem(
                  title: 'NEM: Air Quality',
                  subtitle: 'Coming soon',
                  borderColor: Theme.of(context).primaryColor.withOpacity(0.7),
                  enabled: false,
                  onTap: () {
                    // Disabled
                  },
                ),
                SizedBox(height: 12),
                MenuItem(
                  title: 'NEM: Waste',
                  subtitle: 'Coming soon',
                  borderColor: Color(0xFFD1D1D1),
                  enabled: false,
                  onTap: () {
                    // Disabled
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
