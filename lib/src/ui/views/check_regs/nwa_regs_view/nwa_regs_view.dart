import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:stacked/stacked.dart';
import 'package:the_eap_app/src/core/models/nwa_reg.dart';
import 'package:the_eap_app/src/core/view_models/check_regs/nwa_regs_view_model.dart';
import 'package:the_eap_app/src/ui/shared/widgets/widgets.dart';

class NWARegsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NWARegsViewModel>.reactive(
      viewModelBuilder: () => NWARegsViewModel(),
      builder: (BuildContext context, NWARegsViewModel model, Widget? child) =>
          Scaffold(
        appBar: DefaultAppBar(
          title: 'Check NWA REGs',
          showBackButton: true,
          backgroundColor: Color(0xff60788E),
        ),
        backgroundColor: Colors.white,
        body: BackgroundContainer(
          background: 'background-3',
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: <Widget>[
                  SizedBox(height: 16),
                  Expanded(
                    child: model.isBusy
                        ? Center(child: LoadingIndicator())
                        : model.nwaRegs.isEmpty
                            ? EmptyState(
                                icon: IconsaxPlusLinear.document,
                                message: 'No regulations found',
                                subMessage: 'Try adjusting your search',
                              )
                            : ListView.builder(
                                itemCount: model.nwaRegs.length +
                                    1, // +1 for the WULA guide
                                itemBuilder: (BuildContext context, int index) {
                                  // Resource cards (first 4 items)
                                  if (index == 0) {
                                    // First item is the WULA guide
                                    return Container(
                                      margin: EdgeInsets.only(bottom: 16),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: <BoxShadow>[
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.1),
                                            spreadRadius: 1,
                                            blurRadius: 5,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(12),
                                        onTap: () => model.downloadWULAGuide(),
                                        child: Padding(
                                          padding: EdgeInsets.all(16),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: <Widget>[
                                              // Title & subtitle
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: <Widget>[
                                                    SelectableText(
                                                      'How to do a WULA',
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                      toolbarOptions: ToolbarOptions(copy: true, selectAll: true),
                                                    ),
                                                    SizedBox(height: 4),
                                                    SelectableText(
                                                      'Procedural Requirements (GNR 3434 of 19 May 2023)',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.grey,
                                                      ),
                                                      toolbarOptions: ToolbarOptions(copy: true, selectAll: true),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(width: 12),
                                              // Trailing actions constrained
                                              SizedBox(
                                                width: 40,
                                                height: 40,
                                                child: IconButton(
                                                  padding: EdgeInsets.zero,
                                                  icon: Icon(
                                                    IconsaxPlusLinear.document_download,
                                                    size: 24,
                                                    color: Color(0xff60788E),
                                                  ),
                                                  onPressed: () => model.downloadWULAGuide(),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }

                                  // Regulations items
                                  final NWAReg reg = model.nwaRegs[index - 1];
                                  return Container(
                                    margin: EdgeInsets.only(bottom: 16),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: <BoxShadow>[
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.1),
                                          spreadRadius: 1,
                                          blurRadius: 5,
                                          offset: Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(12),
                                      onTap: () => model.openRegulationLink(reg.linkUrl),
                                      child: Padding(
                                        padding: EdgeInsets.all(16),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: <Widget>[
                                            // Title & subtitle
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  SelectableText(
                                                    reg.section,
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w500,
                                                      color: Color(0xff60788E),
                                                    ),
                                                    toolbarOptions: ToolbarOptions(copy: true, selectAll: true),
                                                  ),
                                                  SizedBox(height: 4),
                                                  SelectableText(
                                                    reg.regulation,
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.grey[800],
                                                    ),
                                                    toolbarOptions: ToolbarOptions(copy: true, selectAll: true),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(width: 12),
                                            // Trailing actions constrained
                                            if (reg.section.toLowerCase().startsWith('a)') ||
                                                reg.section.toLowerCase().startsWith('b)') ||
                                                reg.section.toLowerCase().startsWith('c)') ||
                                                reg.section.toLowerCase().startsWith('i)') ||
                                                reg.section.toLowerCase().startsWith('e)') ||
                                                reg.section.toLowerCase().startsWith('f)') ||
                                                reg.section.toLowerCase().startsWith('g)') ||
                                                reg.section.toLowerCase().startsWith('h)') ||
                                                reg.section.toLowerCase().startsWith('j)'))
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  SizedBox(
                                                    width: 40,
                                                    height: 40,
                                                    child: IconButton(
                                                      padding: EdgeInsets.zero,
                                                      icon: Icon(
                                                        IconsaxPlusLinear.document_download,
                                                        size: 24,
                                                        color: Color(0xff60788E),
                                                      ),
                                                      onPressed: () {
                                                        if (reg.section.toLowerCase().startsWith('a)') ||
                                                            reg.section.toLowerCase().startsWith('b)')) {
                                                          model.openTakingStoringWater();
                                                        } else if (reg.section.toLowerCase().startsWith('c)') ||
                                                            reg.section.toLowerCase().startsWith('i)')) {
                                                          model.openWaterUses();
                                                        } else if (reg.section.toLowerCase().startsWith('e)') ||
                                                            reg.section.toLowerCase().startsWith('f)') ||
                                                            reg.section.toLowerCase().startsWith('g)') ||
                                                            reg.section.toLowerCase().startsWith('h)') ||
                                                            reg.section.toLowerCase().startsWith('j)')) {
                                                          model.openGeneralAuthorizations();
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                  SizedBox(width: 8),
                                                  Icon(
                                                    IconsaxPlusLinear.arrow_right,
                                                    size: 24,
                                                    color: Color(0xff60788E),
                                                  ),
                                                ],
                                              )
                                            else
                                              Icon(
                                                IconsaxPlusLinear.arrow_right,
                                                size: 24,
                                                color: Color(0xff60788E),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
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
}
