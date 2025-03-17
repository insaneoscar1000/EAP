import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:stacked/stacked.dart';
import 'package:the_eap_app/src/core/view_models/view_models.dart';
import 'package:the_eap_app/src/ui/shared/widgets/widgets.dart';

class LawHubsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LawHubsViewModel>.reactive(
      viewModelBuilder: () => LawHubsViewModel(),
      builder: (context, model, child) => Scaffold(
        appBar: DefaultAppBar(
          title: 'Law Hubs',
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
                    hintText: 'Search...',
                    onChanged: model.onSearchQueryChanged,
                  ),
                  SizedBox(height: 16),
                  Expanded(
                    child: model.isBusy
                        ? Center(child: LoadingIndicator())
                        : model.lawHubs.isEmpty
                            ? EmptyState(
                                icon: IconsaxPlusLinear.document,
                                message: 'No law hubs found',
                                subMessage: 'Try adjusting your search',
                              )
                            : ListView.builder(
                                itemCount: model.lawHubs.length,
                                itemBuilder: (context, index) {
                                  final lawHub = model.lawHubs[index];

                                  return Container(
                                    margin: EdgeInsets.only(bottom: 16),
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
                                    child: ListTile(
                                      onTap: () =>
                                          model.openLawHubFile(lawHub.fileUrl),
                                      contentPadding: EdgeInsets.all(16),
                                      title: Text(
                                        lawHub.title,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      subtitle: Text(
                                        lawHub.description,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      trailing: IconButton(
                                        icon: Icon(
                                          IconsaxPlusLinear.document_download,
                                          size: 30,
                                          color: Theme.of(context).splashColor,
                                        ),
                                        onPressed: () =>
                                            model.downloadLawHubFile(
                                          lawHub.fileUrl,
                                          lawHub.title,
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
