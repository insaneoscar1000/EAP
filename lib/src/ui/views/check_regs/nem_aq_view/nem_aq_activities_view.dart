import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:stacked/stacked.dart';
import 'package:the_eap_app/src/core/constants/route_constants.dart';
import 'package:the_eap_app/src/core/models/models.dart';
import 'package:the_eap_app/src/core/view_models/view_models.dart';
import 'package:the_eap_app/src/ui/shared/widgets/widgets.dart';

class NEMAQActivitiesView extends StatelessWidget {
  static const Color teal = Color(0xFF00979B);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NEMAQActivitiesViewModel>.reactive(
      viewModelBuilder: () => NEMAQActivitiesViewModel(),
      builder: (BuildContext context, NEMAQActivitiesViewModel model,
              Widget? child) =>
          Scaffold(
        appBar: DefaultAppBar(
          title: 'NEM: AQA Activities',
          showBackButton: true,
          backgroundColor: teal,
        ),
        backgroundColor: Colors.white,
        body: BackgroundContainer(
          background: 'background-3',
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: <Widget>[
                  SizedBox(height: 8),
                  SearchInput(
                    hintText: 'Search...',
                    onChanged: model.onSearchQueryChanged,
                  ),
                  SizedBox(height: 16),
                  Expanded(
                    child: model.isBusy
                        ? Center(child: LoadingIndicator())
                        : model.activities.isEmpty
                            ? EmptyState(
                                icon: IconsaxPlusLinear.clipboard,
                                message: 'No activities found',
                                subMessage: 'Try adjusting your search',
                              )
                            : ListView.builder(
                                itemCount: model.activities.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final NEMAQActivity activity =
                                      model.activities[index];
                                  final String sub = activity
                                              .categoryDescription ==
                                          activity.subcategory
                                      ? activity.category
                                      : '${activity.category} · ${activity.categoryDescription}';
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
                                        activity.subcategory,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: teal,
                                        ),
                                      ),
                                      subtitle: Padding(
                                        padding: EdgeInsets.only(top: 4),
                                        child: Text(
                                          sub,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ),
                                      trailing: Icon(
                                        IconsaxPlusLinear.arrow_right,
                                        color: teal,
                                        size: 24,
                                      ),
                                      onTap: () {
                                        Navigator.pushNamed(
                                          context,
                                          RoutePaths.nemAqActivityDetails,
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
