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
          title: 'NFA Protected Trees (GNR 650 of 29 Aug 2014)',
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
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(bottom: 16),
                    padding: EdgeInsets.symmetric(vertical: 14, horizontal: 18),
                    decoration: BoxDecoration(
                      color: Color(0xFFF4F4F4),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Color(0xFFE0E0E0)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'English Common Name (National Tree Number)',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            height: 1.5,
                          ),
                        ),
                        Text(
                          'Botanical/Latin Name',
                          style: TextStyle(
                            fontSize: 15,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Other names: Afrikaans (A) Northern Sotho (NS) Southern Sotho (SA) Tswana (T) Venda (V) Xhosa (X) Zulu (Z)',
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  SearchInput(
                    hintText: 'Search trees...',
                    onChanged: model.onSearchQueryChanged,
                    borderColor: Color(0xffE3BD36),
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
                                            tree.commonName,
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            tree.botanicalName,
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          if (tree
                                              .otherCommonName.isNotEmpty) ...[
                                            SizedBox(height: 4),
                                            Text(
                                              '${tree.otherCommonName}',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey[700],
                                              ),
                                            ),
                                          ],
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
