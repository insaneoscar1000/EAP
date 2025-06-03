import 'package:flutter/material.dart';
import 'package:the_eap_app/src/ui/shared/widgets/widgets.dart';
import 'package:the_eap_app/src/ui/views/eia_basics/basic_assessment_view/_info_block.dart';

class EAAmendmentView extends StatelessWidget {
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
                Text(
                    'The period from 15 December to 5 January to be excluded from all time periods given in this summary.',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                ProcessAccordion(
                    title: 'Part 1 or Part 2 Amendment',
                    content:
                        'EAP determines whether an Environmental Authorisation requires a \nPart 1 Amendment: For minor changes (Change in land ownership or corrections to Environmental Authorisation) or a\nPart 2 Amendment: For significant changes in project scope, impacts identified or mitigation measures. In some cases one can confirm this with relevant Environmental Affairs office.'),
                ProcessAccordion(
                    title: 'EAP Appointment',
                    content:
                        'The applicant appoints a registered EAP (Contract signed & upfront payment made if required).'),
                Text(
                  'If Part 1:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                ProcessAccordion(
                    title: 'Contact Authority',
                    backgroundColor: Color(0xFF7E8C76),
                    content:
                        'EAP makes contact with the relevant department that issued the Environmental Authorisation to notify them of an upcoming amendment application.'),
                ProcessAccordion(
                    title: 'Application Form Completion',
                    backgroundColor: Color(0xFF7E8C76),
                    content:
                        'EAP completes the relevant application form (depending on province) '),
                ProcessAccordion(
                    title: 'Application Form Submission',
                    backgroundColor: Color(0xFF7E8C76),
                    content:
                        'Application form submitted (application fee paid)'),
                InfoBlock(
                    text:
                        'Environmental Affairs may request additional information within a particular time period (this request must accompany the acknowledgement of receipt of the application (and if such information is not submitted within such a period the application will be deemed to have lapsed).'),
                InfoBlock(
                    text:
                        'Environmental Affairs must provide a decision regarding the application within 30 days of acknowledging the receipt of the application (or of receipt of the additional information).'),
                Text(
                  'If Part 2:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                ProcessAccordion(
                    title: 'Contact Authority',
                    backgroundColor: Color(0xFF7E8C76),
                    content:
                        'EAP makes contact with the relevant department that issued the Environmental Authorisation to notify them of an upcoming amendment application. Check PPP measures are acceptable.'),
                ProcessAccordion(
                    title: 'Application Form Completion',
                    backgroundColor: Color(0xFF7E8C76),
                    content:
                        'EAP completes the relevant application form (depending on province)'),
                ProcessAccordion(
                    title: 'Compilation of Pt. 2 Amendment Report',
                    backgroundColor: Color(0xFF7E8C76),
                    content:
                        'EAP compiles an Amendment Report \n(as per Section 32 of GNR326 Regulations,\n7 April 2017)'),
                ProcessAccordion(
                    title: 'Application Form Submission',
                    backgroundColor: Color(0xFF7E8C76),
                    content:
                        'Application form submitted (application fee paid)'),
                InfoBlock(
                    text:
                        'From the date of the ‘application acknowledgement letter’, the EAP must submit a Part 2 Amendment Report within 90 days. '),
                ProcessAccordion(
                    title: 'Public Participation',
                    backgroundColor: Color(0xFFD9A48E),
                    content:
                        'PPP (as agreed to by Environmental Affairs) to bring the proposed change/s to the attention of potential and registered I&APs.'),
                InfoBlock(
                    text:
                        'If something comes up (new project info, PPP Comments etc.) and a second PPP is required (30 day review period), the EAP must provide notification in writing within 90 days from the date of the ‘application acknowledgement letter’, telling Environmental Affairs that the Amendment Report will be submitted in 140 days.'),
                ProcessAccordion(
                    title: 'Submission of  Part 2 Amendment Report',
                    backgroundColor: Color(0xFF7E8C76),
                    content:
                        'Part 2 Amendment Report submitted to Environmental Affairs\n(Including any comments made by I&APs during PPP)'),
                InfoBlock(
                    text:
                        'Environmental Affairs must within 107 days of receipt of the report contemplated in regulation 32, in writing, decide the application.')
              ],
            ),
          ),
        ),
      ),
    );
  }
}
