import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:the_eap_app/src/core/models/models.dart';
import 'package:the_eap_app/src/core/view_models/projects/iap_database_view_model.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:the_eap_app/src/ui/shared/widgets/widgets.dart';
import 'package:the_eap_app/src/ui/views/projects/iap_database_view/iap_details_view.dart';

class IAPDatabaseView extends StatelessWidget {
  final String projectId;

  const IAPDatabaseView({Key? key, required this.projectId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<IAPDatabaseViewModel>.reactive(
      onViewModelReady: (model) {
        print('IAPDatabaseView.onViewModelReady with projectId: $projectId');
        model.setProjectId(projectId);
        // We don't need to call refreshData here as setProjectId already initializes the stream
      },
      viewModelBuilder: () => IAPDatabaseViewModel(),
      builder: (context, model, child) => Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            'I&AP Database',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.chevron_left,
                size: 34, color: Theme.of(context).primaryColorLight),
            onPressed: () => model.navigateBack(),
          ),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: BackgroundContainer(
          background: 'background-1',
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16),
                _buildAddButton(context, model),
                SizedBox(height: 16),
                Expanded(
                  child: model.isBusy
                      ? Center(child: LoadingIndicator())
                      : RefreshIndicator(
                          onRefresh: () async {
                            // Force a refresh of the data
                            print('Manual refresh triggered');
                            await model.refreshData();
                          },
                          child: _buildIAPList(context, model),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAddButton(BuildContext context, IAPDatabaseViewModel model) {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => model.navigateToAddIAP(),
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              IconsaxPlusLinear.message_add_1,
              color: Colors.white,
            ),
            SizedBox(width: 10),
            Text(
              'New',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIAPList(BuildContext context, IAPDatabaseViewModel model) {
    if (model.filteredIAPs.isEmpty) {
      return Center(
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
              'No I&APs found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: model.filteredIAPs.length,
      itemBuilder: (context, index) {
        final iap = model.filteredIAPs[index];
        return _buildIAPCard(context, model, iap);
      },
    );
  }

  Widget _buildIAPCard(
      BuildContext context, IAPDatabaseViewModel model, IAP iap) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => IAPDetailsView(
              initialIAP: iap,
              projectId: projectId,
              projectName: model.projectName,
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[200],
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              iap.name,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              iap.organization ?? 'No organization',
              style: TextStyle(
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
