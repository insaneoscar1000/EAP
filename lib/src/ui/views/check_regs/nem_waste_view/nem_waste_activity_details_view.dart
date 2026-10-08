import 'package:flutter/material.dart';
import 'package:the_eap_app/src/core/models/models.dart';
import 'package:the_eap_app/src/ui/shared/widgets/widgets.dart';

class NEMWasteActivityDetailsView extends StatelessWidget {
  final NEMWasteActivity activity;

  const NEMWasteActivityDetailsView({Key? key, required this.activity})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Color titleColor = Color(0xFFB85C1A);
    return Scaffold(
      appBar: DefaultAppBar(
        title: 'Waste Management Activities',
        showBackButton: true,
        backgroundColor: Color(0xFFC97B63),
      ),
      backgroundColor: Colors.white,
      body: BackgroundContainer(
        background: 'background-3',
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  NEMInfoField(
                    title: 'Waste Category',
                    content: activity.wasteCategory,
                    titleColor: titleColor,
                  ),
                  NEMInfoField(
                    title: 'Application Process',
                    content: activity.applicationProcess,
                    titleColor: titleColor,
                  ),
                  NEMInfoField(
                    title: 'Activity Type',
                    content: activity.activityType,
                    titleColor: titleColor,
                  ),
                  NEMInfoField(
                    title: 'GNR Section',
                    content: activity.gnrSection,
                    titleColor: titleColor,
                  ),
                  NEMInfoField(
                    title: 'Selected Activity',
                    content: activity.activity,
                    titleColor: titleColor,
                  ),
                  NEMInfoField(
                    title: 'Exclusions',
                    content: activity.exclusions,
                    titleColor: titleColor,
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
