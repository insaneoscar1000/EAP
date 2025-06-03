import 'package:flutter/material.dart';

import 'package:the_eap_app/src/ui/shared/widgets/widgets.dart';
import 'package:the_eap_app/src/ui/views/eia_basics/basic_assessment_view/_info_block.dart';

class BasicAssessmentView extends StatelessWidget {
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
                Text(
                    'Consult Appendix 1 of GNR326 EIA Regulations (7 April 2017) '),
                SizedBox(height: 10),
                Text(
                  'The period from 15 December to 5 January to be excluded from all time periods given in this summary.',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor),
                ),
                SizedBox(height: 10),
                // Step 1: EAP Appointment
                ProcessAccordion(
                  title: 'EAP Appointment',
                  content:
                      'The applicant appoints a registered EAP (Contract signed & upfront payment made if required).',
                  backgroundColor: Color(0xFFBFB5A4),
                ),
                // Step 2: Project Initiation
                ProcessAccordion(
                  title: 'Project Initiation',
                  content:
                      '•EAP gathers info (project description, design drawings, plans, maps etc.). \n•National web-based Environmental Screening Tool Report completed. \n•Specialists appointed. \n•Relevant Environmental Affairs office contacted & informed of new application. Pre-application meeting date & time secured (online, in office or on site). \n•Pre-application meeting form completed (if required) & submitted to the case officer ahead of meeting. \n•‘KEY’ stakeholders contacted (Local Municipality, other Departments)',
                  backgroundColor: Color(0xFFD9A48E),
                ),
                Text(
                  'Minutes must be submitted to Environmental Affairs within 5 days of the meeting for signing. ',
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
                SizedBox(height: 10),
                Text(
                  'Pre-application meeting & Site visit are sometimes done together.',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor),
                ),
                SizedBox(height: 10),
                ProcessAccordion(
                    title: 'Pre-Application Meeting',
                    backgroundColor: Color(0xFF0F6358),
                    content:
                        '•The EAP provides a summary of the upcoming assessment with the case officer & plan of study (including PPP) discussed. \n•Minutes taken & signatures obtained from all present. \n•The EAP checks submission requirements with the case office (where to send application, number of hard copies of DBAR etc.)'),
                ProcessAccordion(
                  title: 'Site Visit',
                  backgroundColor: Color(0xFF0F6358),
                  content:
                      '•Site photos must be taken & the site assessed.\n•Site notice/s must be put up.\n•Notification letters must be delivered if relevant\n•Local people can be approached and informed about proposed activity/ies. Any comments must be recorded.',
                ),
                ProcessAccordion(
                  title: 'Draft BAR',
                  backgroundColor: Color(0xFF0F6358),
                  content:
                      '•EAP receives input from specialist/s (with signed declaration form)\n•Draft BAR & EMPr compiled (as per Appendix 1 of GNR326 Regulations, 7 April 2017)\n•Draft BAR to exclude I&AP personal info (as per POPIA, Act No. 14 of 2013)',
                ),
                ProcessAccordion(
                    title: 'Submission of application',
                    backgroundColor: Color(0xFF608E72),
                    content:
                        'Environmental Affairs is required to provide written acknowledgement of the application within 10 days of submission. \n\nFrom the date of the ‘application acknowledgement letter’, the EAP must submit the FINAL BAR within 90 days.  \n\nSubmission of application, release of Draft BAR for review, and submission of Draft BAR are sometimes done together. \n\nEAP completes & submits relevant application form with appendices to Environmental Affairs.'),
                ProcessAccordion(
                    title: 'Release of Draft BAR for review',
                    backgroundColor: Color(0xFF608E72),
                    content:
                        '•Draft BAR released for public review (for minimum 30 days).\n•Copies (Hard and/or soft copies) to CA & key stakeholders for review.'),
                ProcessAccordion(
                    title: 'Submission of Draft BAR',
                    backgroundColor: Color(0xFF608E72),
                    content:
                        'EAP sends Draft BAR to Environmental Affairs (case officer).'),
                ProcessAccordion(
                    title: 'Public Participation',
                    backgroundColor: Color(0xFFD9A48E),
                    content:
                        '•Newspaper advert published (notifying public of BA, BAR review period & EAP contact info)\n•Site notices placed on site (if not already)\n•Notification letters & BIDs sent out\n•On-going liaison with I&APs (Comments received & responses given by EAP recorded)\n•Meeting held if necessary (register taken & minutes compiled for BAR)'),
                ProcessAccordion(
                    title: 'FINAL BAR Compilation',
                    backgroundColor: Color(0xFF0F6358),
                    content:
                        '•Draft BAR updated to include all PPP input.\n•EAP adds final recommendations.'),
                ProcessAccordion(
                    title: 'FINAL BAR Submission',
                    backgroundColor: Color(0xFF608E72),
                    content: 'Final BAR submitted to Environmental Affairs'),
                InfoBlock(
                    text:
                        'Environmental Affairs is required to provide written acknowledgement of the Final BAR submission within 10 days. A decision must be released within 107 days from the date of the acknowledgement letter.\n\nThe EAP must inform all registered I&APs of the decision issued by Environmental Affairs (Authorisation granted or refused), within 14 days of the decision being released. All I&APs must be informed of the appeals process (as per Draft National Appeal Regulations, 25 August 2023).\n\nAn appellant must submit an appeal within 20 days from the date that the decision is sent.  ')
              ],
            ),
          ),
        ),
      ),
    );
  }
}
