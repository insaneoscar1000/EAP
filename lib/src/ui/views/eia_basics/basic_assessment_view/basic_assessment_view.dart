import 'package:flutter/material.dart';
import 'package:the_eap_app/src/core/models/process_step.dart';
import 'package:the_eap_app/src/ui/shared/widgets/widgets.dart';

class BasicAssessmentView extends StatelessWidget {
  final List<ProcessStep> processSteps = [
    ProcessStep(
      title: 'EAP Appointment',
      content:
          'The applicant appoints a registered EAP (Contract signed & upfront payment made if required)',
      color: Color(0xFFBFB5A4),
    ),
    ProcessStep(
      title: 'Screening & Pre-Application',
      content:
          'Screen the project against NEMA Listed Activities to determine if an environmental authorization is required',
      color: Color(0xFF8B8378),
    ),
    ProcessStep(
      title: 'Application Form',
      content:
          'Submit the application form to the competent authority and receive a reference number',
      color: Color(0xFFBFB5A4),
    ),
    ProcessStep(
      title: 'Draft BAR',
      content:
          'Prepare the draft Basic Assessment Report including all specialist studies and the EMPr',
      color: Color(0xFF8B8378),
    ),
    ProcessStep(
      title: 'Public Participation',
      content:
          'Conduct the public participation process including site notices, newspaper adverts, and notifications',
      color: Color(0xFFBFB5A4),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(
        title: 'Basic Assessment',
        showBackButton: true,
      ),
      backgroundColor: Colors.white,
      body: BackgroundContainer(
        background: 'background-3',
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 24),
                ...processSteps
                    .map((step) => Padding(
                          padding: EdgeInsets.only(bottom: 16),
                          child: ProcessAccordion(
                            title: step.title,
                            content: step.content,
                            backgroundColor: step.color,
                          ),
                        ))
                    .toList(),
                SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
