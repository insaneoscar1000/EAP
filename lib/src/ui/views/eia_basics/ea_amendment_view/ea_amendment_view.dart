import 'package:flutter/material.dart';
import 'package:the_eap_app/src/core/models/process_step.dart';
import 'package:the_eap_app/src/ui/shared/widgets/widgets.dart';

class EAAmendmentView extends StatelessWidget {
  final List<ProcessStep> processSteps = [
    ProcessStep(
      title: 'EAP Appointment',
      content: 'The applicant appoints a registered EAP (Contract signed & upfront payment made if required)',
      color: Color(0xFFBFB5A4),
    ),
    ProcessStep(
      title: 'Amendment Type',
      content: 'Determine if a Part 1 (non-substantive) or Part 2 (substantive) amendment is required',
      color: Color(0xFF8B8378),
    ),
    ProcessStep(
      title: 'Amendment Application',
      content: 'Submit amendment application with motivation and supporting documents',
      color: Color(0xFFBFB5A4),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(
        title: 'EA Amendment',
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
