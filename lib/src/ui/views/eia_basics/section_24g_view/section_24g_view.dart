import 'package:flutter/material.dart';
import 'package:the_eap_app/src/core/models/process_step.dart';
import 'package:the_eap_app/src/ui/shared/widgets/widgets.dart';

class Section24GView extends StatelessWidget {
  final List<ProcessStep> processSteps = [
    ProcessStep(
      title: 'EAP Appointment',
      content: 'The applicant appoints a registered EAP (Contract signed & upfront payment made if required)',
      color: Color(0xFFBFB5A4),
    ),
    ProcessStep(
      title: 'Initial Site Assessment',
      content: 'Assess the site and determine the extent of unlawful commencement or continuation',
      color: Color(0xFF8B8378),
    ),
    ProcessStep(
      title: 'Fine Calculation',
      content: 'Calculate the administrative fine based on the assessment findings',
      color: Color(0xFFBFB5A4),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(
        title: 'Section 24 G',
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
                ...processSteps.map((step) => Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: ProcessAccordion(
                    title: step.title,
                    content: step.content,
                    backgroundColor: step.color,
                  ),
                )).toList(),
                SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
