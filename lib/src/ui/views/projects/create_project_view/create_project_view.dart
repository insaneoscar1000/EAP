import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
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
                // Progress indicator
                _buildProgressIndicator(context, model),
                
                // Form content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: _buildFormContent(context, model),
                  ),
                ),
                
                // Save & Continue button
                _buildSaveButton(context, model),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildProgressIndicator(BuildContext context, CreateProjectViewModel model) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Step ${model.currentStep} of ${model.totalSteps}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              Text(
                '${model.progress.toInt()}%',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: model.progress / 100,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).primaryColor,
            ),
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    );
  }
  
  Widget _buildFormContent(BuildContext context, CreateProjectViewModel model) {
    // Show different form content based on the current step
    switch (model.currentStep) {
      case 1:
        return Step1ProjectOverview(model: model);
      case 2:
        return Step2LocationDetails(model: model);
      case 3:
        return Step3ApplicantLandowner(model: model);
      case 4:
        return Step4ProjectDescription(model: model);
      case 5:
        return Step5EnvironmentalDetails(model: model);
      case 6:
        return Step6EiaTeam(model: model);
      case 7:
        return Step7PublicReview(model: model);
      case 8:
        return Step8SubmissionContacts(model: model);
      case 9:
        return Step9Notes(model: model);
      default:
        return Step1ProjectOverview(model: model);
    }
  }
  
  Widget _buildSaveButton(BuildContext context, CreateProjectViewModel model) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          child: Row(
            children: [
              // Back button (only show if not on first step)
              if (model.currentStep > 1)
                Expanded(
                  flex: 1,
                  child: OutlinedButton(
                    onPressed: model.isBusy ? null : () => model.navigateBack(),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Theme.of(context).primaryColor,
                      side: BorderSide(color: Theme.of(context).primaryColor),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Back',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              
              // Add spacing between buttons if back button is shown
              if (model.currentStep > 1) const SizedBox(width: 16),
              
              // Save & Continue button (or Finish on last step)
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: model.canContinue ? () => model.saveAndContinue() : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: model.currentStep == model.totalSteps 
                        ? Colors.green 
                        : Theme.of(context).primaryColor,
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
                          model.currentStep == model.totalSteps ? 'Finish' : 'Save & Continue',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
