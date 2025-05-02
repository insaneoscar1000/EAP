import 'package:flutter/material.dart';
import 'package:the_eap_app/src/core/view_models/projects/create_project_view_model.dart';
import 'step_base.dart';

class Step4ProjectDescription extends StepBase {
  const Step4ProjectDescription({Key? key, required CreateProjectViewModel model})
      : super(key: key, model: model);

  @override
  Widget buildStep(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Project Description',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 24),
        
        // Application Type
        buildFormField(
          label: 'Application Type',
          hintText: 'Start typing...',
          onChanged: (value) => model.applicationType = value,
          initialValue: model.applicationType,
        ),
        SizedBox(height: 16),
        
        // Project Description
        buildFormField(
          label: 'Project Description',
          hintText: 'Start typing...',
          onChanged: (value) => model.projectDescription = value,
          initialValue: model.projectDescription,
          maxLines: 5,
        ),
        SizedBox(height: 24),
      ],
    );
  }
}
