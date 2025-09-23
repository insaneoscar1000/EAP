import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:the_eap_app/src/core/models/models.dart';
import 'package:the_eap_app/src/core/view_models/check_regs/nema_activity_details_view_model.dart';
import 'package:the_eap_app/src/ui/shared/widgets/widgets.dart';

class NEMAActivityDetailsView extends StatelessWidget {
  final NEMAActivity activity;

  const NEMAActivityDetailsView({Key? key, required this.activity})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NEMAActivityDetailsViewModel>.reactive(
      viewModelBuilder: () => NEMAActivityDetailsViewModel(),
      onModelReady: (model) => model.initialize(activity),
      builder: (context, model, child) => Scaffold(
        appBar: DefaultAppBar(
          title: 'Activity',
          showBackButton: true,
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
                  children: [
                    _buildSection(
                      'Relevant Legislation',
                      model.activity.legislation,
                    ),
                    SizedBox(height: 24),
                    _buildSection(
                      'Activity Number',
                      model.activity.activityNumber.toString(),
                    ),
                    SizedBox(height: 24),
                    _buildSection(
                      'Authorization Process',
                      model.activity.authorizationProcess,
                    ),
                    SizedBox(height: 24),
                    _buildSection(
                      'Selected Listed Activity',
                      model.activity.selectedListActivity,
                    ),
                    SizedBox(height: 24),
                    _buildSection(
                      'Exclusions',
                      model.activity.exclusions,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF0D723B),
          ),
        ),
        SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
          ),
          child: SelectableText(
            content,
            style: TextStyle(
              fontSize: 16,
              color: Colors.black87,
              height: 1.5,
            ),
            toolbarOptions: ToolbarOptions(copy: true, selectAll: true),
          ),
        ),
      ],
    );
  }
}
