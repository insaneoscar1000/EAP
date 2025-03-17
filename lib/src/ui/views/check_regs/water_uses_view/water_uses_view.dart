import 'package:flutter/material.dart';
import 'package:the_eap_app/src/core/constants/route_constants.dart';
import 'package:the_eap_app/src/ui/shared/widgets/widgets.dart';

class WaterUsesView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(
        title: 'Check water uses',
        showBackButton: true,
        backgroundColor: Color(0xff60788E),
      ),
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
                  title: 'Check REGs For NWA Water Use',
                  onTap: () {
                    Navigator.pushNamed(context, RoutePaths.nwaRegs);
                  },
                ),
                SizedBox(height: 32),
                Text(
                  'NWA Section 21 Water Uses',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 24),
                Text(
                  'a) taking water from a water resource',
                  style: TextStyle(fontSize: 16, height: 1.5),
                ),
                SizedBox(height: 16),
                Text(
                  'b) storing water',
                  style: TextStyle(fontSize: 16, height: 1.5),
                ),
                SizedBox(height: 16),
                Text(
                  'c) impeding or diverting the flow of water in a watercourse',
                  style: TextStyle(fontSize: 16, height: 1.5),
                ),
                SizedBox(height: 16),
                Text(
                  'd) engaging in a stream flow reduction activity contemplated in Section 36 -(Use of land for afforestation established for commercial purposes, or an activity which has been declared as such under subsection 2 - by The Minister)',
                  style: TextStyle(fontSize: 16, height: 1.5),
                ),
                SizedBox(height: 16),
                Text(
                  'e) engaging in a controlled activity identified as such in Section 37(1)-(a) irrigation with waste or water containing waste generated through any industrial activity or by a waterwork; (b) an activity aimed at the modification of atmospheric precipitation; (c) power generation activity which alters the flow regime of a water resource; (d) intentional recharging of an aquifer with any waste or water containing waste or a controlled activity declared as such under Section 38(1) by The Minister)',
                  style: TextStyle(fontSize: 16, height: 1.5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
