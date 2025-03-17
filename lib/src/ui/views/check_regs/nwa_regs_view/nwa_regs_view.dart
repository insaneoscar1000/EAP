import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:stacked/stacked.dart';
import 'package:the_eap_app/src/core/view_models/check_regs/nwa_regs_view_model.dart';
import 'package:the_eap_app/src/ui/shared/widgets/widgets.dart';

class NWARegsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NWARegsViewModel>.reactive(
        viewModelBuilder: () => NWARegsViewModel(),
        builder: (context, model, child) => Scaffold(
              appBar: DefaultAppBar(
                title: 'Check NWA REGs',
                showBackButton: true,
                backgroundColor: Color(0xFFCE8054),
              ),
              body: BackgroundContainer(
                background: 'background-3',
                child: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            onTap: () => model.downloadWULAGuide(),
                            contentPadding: EdgeInsets.all(16),
                            title: Text(
                              'How to do a WULA',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            subtitle: Text(
                              'Procedural steps',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                            trailing: IconButton(
                                icon: Icon(
                                  IconsaxPlusLinear.document_download,
                                  size: 30,
                                  color: Color(0xFFCE8054),
                                ),
                                onPressed: () => model.downloadWULAGuide()),
                          ),
                        ),
                        SizedBox(height: 16),
                        SearchInput(
                          hintText: 'Search regulations...',
                          onChanged: model.updateSearchQuery,
                        ),
                        SizedBox(height: 16),
                        Expanded(
                          child: model.isBusy
                              ? Center(child: LoadingIndicator())
                              : model.nwaRegs.isEmpty
                                  ? Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            IconsaxPlusLinear.search_normal,
                                            size: 48,
                                            color: Colors.grey,
                                          ),
                                          SizedBox(height: 16),
                                          Text(
                                            'No regulations found',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.grey[700],
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : ListView.builder(
                                      itemCount: model.nwaRegs.length,
                                      itemBuilder: (context, index) {
                                        final reg = model.nwaRegs[index];
                                        return Padding(
                                            padding:
                                                EdgeInsets.only(bottom: 16),
                                            child: InkWell(
                                              onTap: () =>
                                                  model.openRegulationLink(
                                                      reg.linkUrl),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    reg.section,
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Color(0xFFCE8054),
                                                    ),
                                                  ),
                                                  SizedBox(height: 8),
                                                  Text(
                                                    reg.regulation,
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      height: 1.5,
                                                      color: Colors.black87,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ));
                                      },
                                    ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ));
  }
}
