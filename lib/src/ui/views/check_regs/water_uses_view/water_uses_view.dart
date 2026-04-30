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
              children: <Widget>[
                SizedBox(height: 24),
                MenuItem(
                  title: 'Check REGs For NWA Water Use',
                  borderColor: Color(0xff60788E),
                  onTap: () {
                    Navigator.pushNamed(context, RoutePaths.nwaRegs);
                  },
                ),
                SizedBox(height: 32),
                SelectableText(
                  'NWA Section 21 Water Uses',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  toolbarOptions: ToolbarOptions(copy: true, selectAll: true),
                ),
                SizedBox(height: 24),
                SelectableText(
                  'a) taking water from a water resource',
                  style: TextStyle(fontSize: 16, height: 1.5),
                  toolbarOptions: ToolbarOptions(copy: true, selectAll: true),
                ),
                SizedBox(height: 16),
                SelectableText(
                  'b) storing water',
                  style: TextStyle(fontSize: 16, height: 1.5),
                  toolbarOptions: ToolbarOptions(copy: true, selectAll: true),
                ),
                SizedBox(height: 16),
                SelectableText(
                  'c) impeding or diverting the flow of water in a watercourse',
                  style: TextStyle(fontSize: 16, height: 1.5),
                  toolbarOptions: ToolbarOptions(copy: true, selectAll: true),
                ),
                SizedBox(height: 16),
                SelectableText(
                  'd) engaging in a stream flow reduction activity contemplated in section 36 (The following are stream flow reduction activities…)',
                  style: TextStyle(fontSize: 16, height: 1.5),
                  toolbarOptions: ToolbarOptions(copy: true, selectAll: true),
                ),
                SizedBox(height: 16),
                SelectableText(
                  'e) engaging in a controlled activity identified as such in section 37( 1 ) or declared under section 38(1)\n\n- irrigation of any land with waste or water containing waste generated through any industrial activity or by a waterwork;\n- an activity aimed at the modification of atmospheric precipitation;\n- power generation activity which alters the flow regime of a water resource;\n- intentional recharging of an aquifer with any waste or water containing waste',
                  style: TextStyle(fontSize: 16, height: 1.5),
                  toolbarOptions: ToolbarOptions(copy: true, selectAll: true),
                ),
                SizedBox(height: 16),
                SelectableText(
                  'f) discharging waste or water containing waste into a water resource through a pipe, canal. sewer. sea outfall or other conduit:',
                  style: TextStyle(fontSize: 16, height: 1.5),
                  toolbarOptions: ToolbarOptions(copy: true, selectAll: true),
                ),
                SizedBox(height: 16),
                SelectableText(
                  'g) disposing of waste in a manner which may detrimentally impact on a water resource;',
                  style: TextStyle(fontSize: 16, height: 1.5),
                  toolbarOptions: ToolbarOptions(copy: true, selectAll: true),
                ),
                SizedBox(height: 16),
                SelectableText(
                  'h) disposing in any manner of water which contains waste from, or which has been heated in any industrial or power generation process;',
                  style: TextStyle(fontSize: 16, height: 1.5),
                  toolbarOptions: ToolbarOptions(copy: true, selectAll: true),
                ),
                SizedBox(height: 16),
                SelectableText(
                  'i) altering the bed, banks, course or characteristics of a watercourse:',
                  style: TextStyle(fontSize: 16, height: 1.5),
                  toolbarOptions: ToolbarOptions(copy: true, selectAll: true),
                ),
                SizedBox(height: 16),
                SelectableText(
                  'j) removing, discharging or disposing of water found underground if it is necessary for the efficient continuation of an activity for the safety of people: and',
                  style: TextStyle(fontSize: 16, height: 1.5),
                  toolbarOptions: ToolbarOptions(copy: true, selectAll: true),
                ),
                SizedBox(height: 16),
                SelectableText(
                  'k) using water for recreational purposes',
                  style: TextStyle(fontSize: 16, height: 1.5),
                  toolbarOptions: ToolbarOptions(copy: true, selectAll: true),
                ),
                SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
