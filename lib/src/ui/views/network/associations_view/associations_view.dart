import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:stacked/stacked.dart';
import 'package:the_eap_app/src/core/view_models/view_models.dart';
import 'package:the_eap_app/src/ui/shared/widgets/widgets.dart';

class AssociationsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AssociationsViewModel>.reactive(
      viewModelBuilder: () => AssociationsViewModel(),
      onViewModelReady: (AssociationsViewModel model) => model.init(),
      builder:
          (BuildContext context, AssociationsViewModel model, Widget? child) =>
              Scaffold(
        appBar: DefaultAppBar(
          title: 'Prof. Associations',
        ),
        backgroundColor: Colors.white,
        body: BackgroundContainer(
          background: 'background-3',
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Voluntary Associations recognized by SACNASP in\nterms of the Natural Scientific Professions Act (No\n27 of 2003).',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).primaryColorDark,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Ngamanye amagama: The clubs you receive CPD\npoints for joining.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).primaryColorDark,
                    ),
                  ),
                  SizedBox(height: 24),
                  SearchInput(
                    onChanged: model.search,
                    hintText: 'Search...',
                  ),
                  SizedBox(height: 24),
                  Expanded(
                    child: model.isBusy
                        ? Center(child: LoadingIndicator())
                        : model.associations.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      IconsaxPlusLinear.search_normal,
                                      size: 48,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(height: 16),
                                    Text(
                                      'No associations found',
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
                                itemCount: model.associations.length,
                                itemBuilder: (context, index) {
                                  final association = model.associations[index];
                                  return InkWell(
                                    onTap: () =>
                                        model.launchAssociationUrl(association.url),
                                    child: Container(
                                      margin: EdgeInsets.only(bottom: 16),
                                      padding: EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
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
                                          Text(
                                            association.title,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            association.description,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey,
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
