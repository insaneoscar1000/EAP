import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:stacked/stacked.dart';
import 'package:the_eap_app/src/core/constants/route_constants.dart';
import 'package:the_eap_app/src/core/models/models.dart';
import 'package:the_eap_app/src/core/view_models/view_models.dart';
import 'package:the_eap_app/src/ui/shared/widgets/widgets.dart';

class NEMWasteActivitiesView extends StatelessWidget {
  static const Color terracotta = Color(0xFFC97B63);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NEMWasteActivitiesViewModel>.reactive(
      viewModelBuilder: () => NEMWasteActivitiesViewModel(),
      builder: (BuildContext context, NEMWasteActivitiesViewModel model,
              Widget? child) =>
          Scaffold(
        appBar: DefaultAppBar(
          title: 'NEM: Waste Activities',
          showBackButton: true,
          backgroundColor: terracotta,
        ),
        backgroundColor: Colors.white,
        body: BackgroundContainer(
          background: 'background-3',
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Color(0xFFF9DCC9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Waste Management Activities that have, or are likely to have, a detrimental effect on the Environment\n(GNR 921 of 29 Nov 2013)',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 14, color: Colors.black87, height: 1.3),
                    ),
                  ),
                  SizedBox(height: 16),
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
                                  final NEMWasteActivity activity =
                                      model.activities[index];
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
                                      title: Padding(
                                        padding: EdgeInsets.only(bottom: 6),
                                        child: Text(
                                          <String>[
                                            activity.wasteCategory,
                                            activity.applicationProcess,
                                            if (activity.gnrSection.isNotEmpty)
                                              activity.gnrSection,
                                          ].join(' · '),
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: terracotta,
                                          ),
                                        ),
                                      ),
                                      subtitle: Text(
                                        activity.activity,
                                        maxLines: 4,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      trailing: Icon(
                                        IconsaxPlusLinear.arrow_right,
                                        color: terracotta,
                                        size: 24,
                                      ),
                                      onTap: () {
                                        Navigator.pushNamed(
                                          context,
                                          RoutePaths.nemWasteActivityDetails,
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
