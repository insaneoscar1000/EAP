import 'package:flutter/material.dart';
import 'package:the_eap_app/src/core/view_models/projects/create_project_view_model.dart';
import 'step_base.dart';

class Step1ProjectOverview extends StepBase {
  const Step1ProjectOverview({Key? key, required CreateProjectViewModel model})
      : super(key: key, model: model);

  @override
  Widget buildStep(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Project Overview',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 24),
        
        // Project Title
        buildFormField(
          label: 'Project Title',
          hintText: 'Start typing...',
          onChanged: (value) => model.projectTitle = value,
          initialValue: model.projectTitle,
        ),
        SizedBox(height: 16),
        
        // Project Code
        buildFormField(
          label: 'Project Code',
          hintText: 'Start typing...',
          onChanged: (value) => model.projectCode = value,
          initialValue: model.projectCode,
        ),
        SizedBox(height: 16),
        
        // Department Reference Number
        buildFormField(
          label: 'Department Reference Number #',
          hintText: 'Start typing...',
          onChanged: (value) => model.departmentReferenceNumber = value,
          initialValue: model.departmentReferenceNumber,
        ),
        SizedBox(height: 16),
        
        // Property Name/Address/Farm No.
        buildFormField(
          label: 'Property Name/Address/Farm No.',
          hintText: 'Start typing...',
          onChanged: (value) => model.propertyNameAddressFarmNo = value,
          initialValue: model.propertyNameAddressFarmNo,
        ),
        SizedBox(height: 24),
      ],
    );
  }
}
