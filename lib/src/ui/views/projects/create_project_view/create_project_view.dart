import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:the_eap_app/src/core/constants/project_stages.dart';
import 'package:the_eap_app/src/core/view_models/view_models.dart';
import 'package:the_eap_app/src/ui/shared/widgets/widgets.dart';
import 'steps/step1_project_overview.dart';
import 'steps/step2_location_details.dart';
import 'steps/step3_applicant_landowner.dart';
import 'steps/step4_project_description.dart';
import 'steps/step5_environmental_details.dart';
import 'steps/step6_eia_team.dart';
import 'steps/step7_public_review.dart';
import 'steps/step8_submission_contacts.dart';
import 'steps/step9_notes.dart';

class CreateProjectView extends StatelessWidget {
  final String? projectId;

  const CreateProjectView({Key? key, this.projectId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CreateProjectViewModel>.reactive(
      viewModelBuilder: () => CreateProjectViewModel(),
      onModelReady: (model) => model.initialize(projectId: projectId),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => model.navigateBack(),
          ),
          title: const Text(
            'New Project',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
        ),
        backgroundColor: Colors.white,
        body: BackgroundContainer(
          background: 'background-1',
          child: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: _buildFormContent(context, model),
                  ),
                ),
                _buildSaveButton(context, model),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormContent(BuildContext context, CreateProjectViewModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Step1ProjectOverview(model: model),
        const SizedBox(height: 8),
        _buildStagePicker(context, model),
        const Divider(height: 32),
        Step2LocationDetails(model: model),
        const Divider(height: 32),
        Step3ApplicantLandowner(model: model),
        const Divider(height: 32),
        Step4ProjectDescription(model: model),
        const Divider(height: 32),
        Step5EnvironmentalDetails(model: model),
        const Divider(height: 32),
        Step6EiaTeam(model: model),
        const Divider(height: 32),
        Step7PublicReview(model: model),
        const Divider(height: 32),
        Step8SubmissionContacts(model: model),
        const Divider(height: 32),
        Step9Notes(model: model),
      ],
    );
  }

  Widget _buildStagePicker(BuildContext context, CreateProjectViewModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Project Stage',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            IconButton(
              icon: Icon(Icons.info_outline, color: Colors.grey[600], size: 20),
              tooltip: 'What do the stages mean?',
              onPressed: () => _showStageInfoModal(context),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!, width: 1),
          ),
          child: DropdownButtonFormField<int>(
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
            hint: const Text('Not set'),
            value: model.projectStage,
            isExpanded: true,
            items: ProjectStages.all
                .map((stage) => DropdownMenuItem<int>(
                      value: stage.number,
                      child: Text(stage.label),
                    ))
                .toList(),
            onChanged: (value) => model.projectStage = value,
          ),
        ),
      ],
    );
  }

  void _showStageInfoModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.75,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Project Stages',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.separated(
                    itemCount: ProjectStages.all.length,
                    separatorBuilder: (context, index) =>
                        const Divider(height: 24),
                    itemBuilder: (context, index) {
                      final stage = ProjectStages.all[index];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            stage.label,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            stage.description,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                              height: 1.4,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSaveButton(BuildContext context, CreateProjectViewModel model) {
    final isEditing = projectId != null;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      child: ElevatedButton(
        onPressed: model.canSave ? () => model.saveProject() : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: model.isBusy
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 2,
                ),
              )
            : Text(
                isEditing ? 'Save Changes' : 'Create Project',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}
