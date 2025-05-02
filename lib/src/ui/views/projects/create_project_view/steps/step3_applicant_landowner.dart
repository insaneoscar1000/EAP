import 'package:flutter/material.dart';
import 'package:the_eap_app/src/core/view_models/projects/create_project_view_model.dart';
import 'step_base.dart';

class Step3ApplicantLandowner extends StepBase {
  const Step3ApplicantLandowner({Key? key, required CreateProjectViewModel model})
      : super(key: key, model: model);

  @override
  Widget buildStep(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Applicant and Landowner Information',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 24),
        
        // Applicant Name
        buildFormField(
          label: 'Applicant Name',
          hintText: 'Start typing...',
          onChanged: (value) => model.applicantName = value,
          initialValue: model.applicantName,
        ),
        SizedBox(height: 16),
        
        // Applicant Details
        buildFormField(
          label: 'Applicant Details',
          hintText: 'Start typing...',
          onChanged: (value) => model.applicantDetails = value,
          initialValue: model.applicantDetails,
        ),
        SizedBox(height: 16),
        
        // Landowner
        buildFormField(
          label: 'Landowner',
          hintText: 'Start typing...',
          onChanged: (value) => model.landowner = value,
          initialValue: model.landowner,
        ),
        SizedBox(height: 16),
        
        // Landowner Details
        buildFormField(
          label: 'Landowner Details',
          hintText: 'Start typing...',
          onChanged: (value) => model.landownerDetails = value,
          initialValue: model.landownerDetails,
        ),
        SizedBox(height: 24),
      ],
    );
  }
}
