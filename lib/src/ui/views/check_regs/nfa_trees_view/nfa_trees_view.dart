import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:stacked/stacked.dart';
import 'package:the_eap_app/src/core/view_models/view_models.dart';
import 'package:the_eap_app/src/ui/shared/widgets/widgets.dart';

class NFATreesView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NFATreesViewModel>.reactive(
      viewModelBuilder: () => NFATreesViewModel(),
      builder: (context, model, child) => Scaffold(
        appBar: DefaultAppBar(
          title: 'Check NFA Trees',
          backgroundColor: Color(0xffE3BD36),
          showBackButton: true,
        ),
        backgroundColor: Colors.white,
        body: BackgroundContainer(
          background: 'background-3',
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  SizedBox(height: 16),
                  SearchInput(
                    hintText: 'Search trees...',
                    onChanged: model.onSearchQueryChanged,
                  ),
                  SizedBox(height: 16),
                  Expanded(
                    child: model.isBusy
                        ? Center(child: LoadingIndicator())
                        : model.nfaTrees.isEmpty
                            ? EmptyState(
                                icon: IconsaxPlusLinear.search_normal,
                                message: 'No trees found',
                              )
                            : ListView.builder(
                                itemCount: model.nfaTrees.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final tree = model.nfaTrees[index];
                                  return InkWell(
                                    onTap: () =>
                                        model.openTreeLink(tree.linkUrl),
                                    child: Container(
                                      margin: EdgeInsets.only(bottom: 16),
                                      padding: EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.05),
                                            blurRadius: 8,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            tree.botanicalName,
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            'Common name: ${tree.commonName}',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          if (tree
                                              .otherCommonName.isNotEmpty) ...[
                                            SizedBox(height: 4),
                                            Text(
                                              'Also known as: ${tree.otherCommonName}',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey[700],
                                              ),
                                            ),
                                          ],
                                          SizedBox(height: 8),
                                          Text(
                                            'Tree number: ${tree.nationalTreeNumber}',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[600],
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
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
