import 'package:flutter/material.dart';
import 'package:the_eap_app/src/core/view_models/projects/create_project_view_model.dart';
import 'step_base.dart';

class Step9Notes extends StepBase {
  const Step9Notes({Key? key, required CreateProjectViewModel model})
      : super(key: key, model: model);

  @override
  Widget buildStep(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Notes',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 24),
        
        // Project Notes
        buildFormField(
          label: 'Project Notes',
          hintText: 'Add any additional notes about the project...',
          onChanged: (value) => model.notes = value,
          initialValue: model.notes,
          maxLines: 8,
        ),
        SizedBox(height: 24),
        
        // Completion message
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.green.shade200,
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Almost Done!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade800,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'You have completed all the steps for creating your project. Click "Save & Continue" to finalize your project.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.green.shade800,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 24),
      ],
    );
  }
}
