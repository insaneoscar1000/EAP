import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:stacked/stacked.dart';
import 'package:the_eap_app/src/core/view_models/view_models.dart';
import 'package:the_eap_app/src/ui/shared/widgets/widgets.dart';

class AcronymsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AcronymsViewModel>.reactive(
      viewModelBuilder: () => AcronymsViewModel(),
      builder: (context, model, child) => Scaffold(
        appBar: DefaultAppBar(
          title: 'Acronyms',
        ),
        backgroundColor: Colors.white,
        body: BackgroundContainer(
          background: 'background-2',
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16),
                SearchInput(
                  hintText: 'Search...',
                  onChanged: model.onSearchQueryChanged,
                ),
                SizedBox(height: 16),
                Expanded(
                  child: model.isBusy
                      ? Center(child: LoadingIndicator())
                      : model.acronyms.isEmpty
                          ? EmptyState(
                              icon: IconsaxPlusLinear.text,
                              message: 'No acronyms found',
                              subMessage: 'Try adjusting your search',
                            )
                          : ListView.builder(
                              itemCount: model.acronyms.length,
                              itemBuilder: (context, index) {
                                final acronym = model.acronyms[index];
                                return Container(
                                  margin: EdgeInsets.only(bottom: 16),
                                  padding: EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.1),
                                        spreadRadius: 1,
                                        blurRadius: 5,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SelectableText(
                                        acronym.title,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        toolbarOptions: ToolbarOptions(copy: true, selectAll: true),
                                      ),
                                      SizedBox(height: 4),
                                      SelectableText(
                                        acronym.meaning,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                        toolbarOptions: ToolbarOptions(copy: true, selectAll: true),
                                      ),
                                    ],
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
    );
  }
}
