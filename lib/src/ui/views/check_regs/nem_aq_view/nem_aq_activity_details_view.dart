import 'package:flutter/material.dart';
import 'package:the_eap_app/src/core/models/models.dart';
import 'package:the_eap_app/src/ui/shared/widgets/widgets.dart';

class NEMAQActivityDetailsView extends StatelessWidget {
  final NEMAQActivity activity;

  const NEMAQActivityDetailsView({Key? key, required this.activity})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Color teal = Color(0xFF00979B);
    return Scaffold(
      appBar: DefaultAppBar(
        title: 'NEM:AQA Listed Activity',
        showBackButton: true,
        backgroundColor: teal,
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
                  Center(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 16),
                      child: Text(
                        'GNR 893 of 22 November 2013',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: teal),
                      ),
                    ),
                  ),
                  NEMInfoField(
                    title: 'Category',
                    content: activity.category,
                    titleColor: teal,
                  ),
                  NEMInfoField(
                    title: 'Category Description',
                    content: activity.categoryDescription,
                    titleColor: teal,
                  ),
                  NEMInfoField(
                    title: 'Subcategory',
                    content: activity.subcategory,
                    titleColor: teal,
                  ),
                  NEMInfoField(
                    title: 'Subcategory Description',
                    content: activity.subcategoryDescription,
                    titleColor: teal,
                  ),
                  NEMInfoField(
                    title: 'Application',
                    content: activity.application,
                    titleColor: teal,
                  ),
                  Center(
                    child: Text(
                      'Check GNR 893 (22 Nov 2013) for substances, plant status & emission concentrations along with special arrangements for this activity.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: teal,
                          height: 1.4),
                    ),
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
