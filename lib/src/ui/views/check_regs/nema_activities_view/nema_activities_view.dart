import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:stacked/stacked.dart';
import 'package:the_eap_app/src/core/constants/route_constants.dart';
import 'package:the_eap_app/src/core/models/nema_activity.dart';
import 'package:the_eap_app/src/core/view_models/view_models.dart';
import 'package:the_eap_app/src/ui/shared/widgets/widgets.dart';

class NEMAActivitiesView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NEMAActivitiesViewModel>.reactive(
      viewModelBuilder: () => NEMAActivitiesViewModel(),
      builder: (BuildContext context, NEMAActivitiesViewModel model,
              Widget? child) =>
          Scaffold(
        appBar: DefaultAppBar(
          title: 'NEMA Activities',
          showBackButton: true,
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
                  SearchInput(
                    hintText: 'Search activities...',
                    onChanged: model.onSearchQueryChanged,
                  ),
                  SizedBox(height: 16),
                  Expanded(
                    child: model.isBusy
                        ? Center(child: LoadingIndicator())
                        : model.nemaActivities.isEmpty
                            ? EmptyState(
                                icon: IconsaxPlusLinear.clipboard,
                                message: 'No activities found',
                                subMessage: 'Try adjusting your search',
                              )
                            : ListView.builder(
                                itemCount: model.nemaActivities.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final NEMAActivity activity =
                                      model.nemaActivities[index];
                                  return Container(
                                    margin: EdgeInsets.only(bottom: 16),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: <BoxShadow>[
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.05),
                                          blurRadius: 8,
                                          offset: Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: ListTile(
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 12,
                                      ),
                                      title: Text(
                                        activity.selectedListActivity,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      trailing: Icon(
                                        IconsaxPlusLinear.arrow_right,
                                        color: Color(0xFF60788E),
                                        size: 24,
                                      ),
                                      onTap: () {
                                        Navigator.pushNamed(
                                          context,
                                          RoutePaths.nemaActivityDetails,
                                          arguments: activity,
                                        );
                                      },
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
