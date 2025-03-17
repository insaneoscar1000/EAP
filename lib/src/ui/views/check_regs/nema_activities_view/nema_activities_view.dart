import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:stacked/stacked.dart';
import 'package:the_eap_app/src/core/constants/route_constants.dart';
import 'package:the_eap_app/src/core/view_models/view_models.dart';
import 'package:the_eap_app/src/ui/shared/widgets/widgets.dart';

class NEMAActivitiesView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NEMAActivitiesViewModel>.reactive(
      viewModelBuilder: () => NEMAActivitiesViewModel(),
      builder: (context, model, child) => Scaffold(
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
                children: [
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
                                itemBuilder: (context, index) {
                                  final activity = model.nemaActivities[index];
                                  return InkWell(
                                      onTap: () {
                                        Navigator.pushNamed(
                                          context,
                                          RoutePaths.nemaActivityDetails,
                                          arguments: activity,
                                        );
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(bottom: 16),
                                        padding: EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black
                                                  .withOpacity(0.05),
                                              blurRadius: 8,
                                              offset: Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  activity.legislation,
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w600,
                                                    color: Color(0xFF60788E),
                                                  ),
                                                ),
                                                Spacer(),
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 6,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: Color(0xFF60788E)
                                                        .withOpacity(0.1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  child: Text(
                                                    activity.activityNumber
                                                        .toString(),
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Color(0xFF60788E),
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 12),
                                            Text(
                                              activity.selectedListActivity,
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black87,
                                              ),
                                            ),
                                            SizedBox(height: 12),
                                            Text(
                                              'Authorization: ${activity.authorizationProcess}',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey[700],
                                              ),
                                            ),
                                            if (activity
                                                .exclusions.isNotEmpty) ...[
                                              SizedBox(height: 12),
                                              Text(
                                                'Exclusions:',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.grey[800],
                                                ),
                                              ),
                                              SizedBox(height: 4),
                                              Text(
                                                activity.exclusions,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey[700],
                                                ),
                                              ),
                                            ],
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
      ),
    );
  }
}
