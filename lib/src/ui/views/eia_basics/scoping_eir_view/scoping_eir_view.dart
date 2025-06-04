import 'package:flutter/material.dart';
import 'package:the_eap_app/src/ui/shared/widgets/widgets.dart';
import 'package:the_eap_app/src/ui/views/eia_basics/basic_assessment_view/_info_block.dart';

class ScopingEIRView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(
        title: 'Scoping & EIR',
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
                    'Consult Appendix 2 of GNR326 EIA Regulations (7 April 2017).',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                ProcessAccordion(
                    title: 'EAP Appointment',
                    content:
                        'The applicant appoints a registered EAP (Contract signed & upfront payment made if required).'),
                ProcessAccordion(
                    title: 'Contact Environmental Affairs',
                    backgroundColor: Color(0xFF7E8C76),
                    content:
                        'Contact local Environmental Affairs (pre-application chat).  '),
                Text(
                  'Scoping Phase',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                ProcessAccordion(
                    title: 'Site Visit & Gather Info',
                    backgroundColor: Color(0xFF0F6358),
                    content:
                        'Get site photos (put up site notices), notify neighbours, chat to locals.'),
                ProcessAccordion(
                    title: 'Draft Scoping Report',
                    backgroundColor: Color(0xFF0F6358),
                    content:
                        'Compile Draft Scoping Report. Include background, intended specialist studies, plan of study for the EIA.'),
                ProcessAccordion(
                    title: 'Public Participation Process (PPP)',
                    backgroundColor: Color(0xFFD9A48E),
                    content:
                        "Advertise Scoping & EIR Process and availability of the Draft Scoping Report for review (dates & how to access documents). Release the Draft Scoping Report for public review (30 days). Send copy of Draft Scoping Report to Environmental Affairs. *Remember - don't include 15 Dec to 5 Jan in timeframes. "),
                ProcessAccordion(
                    title: 'Application Form Submission',
                    backgroundColor: Color(0xFF7E8C76),
                    content:
                        'Compile and submit application form (specific to each province). EIA Online Screening Tool Report will go with your application.   Organise payment of R10  000 application fee (n/a if applicant is an Organ of State).'),
                InfoBlock(
                    text:
                        "TIME ALERT: Environmental Affairs is required to acknowledge your application within 10 days of submission. The date on the acknowledgement letter is your 'START DATE'. You have 44 days from then to submit your SCOPING REPORT (which has been out for public review for 30 days)."),
                ProcessAccordion(
                    title: 'Submit Scoping Report',
                    backgroundColor: Color(0xFF7E8C76),
                    content:
                        'Finalise your Scoping Report (include comments from the Public Review Period). Submit Scoping Report to the relevant office of Environmental Affairs.'),
                InfoBlock(
                    text:
                        'TIME ALERT: Environmental Affairs must tell you within 43 days whether you can proceed with the plan of study in the Scoping Report or not. From the date of their acceptance letter, you have 106 days to submit an Environmental Impact Assessment Report. '),
                Text(
                  'Environmental Impact Assessment Phase',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Consult Appendix 3 of GNR326 EIA Regulations (7 April 2017) ',
                ),
                SizedBox(height: 10),
                ProcessAccordion(
                    title: 'Draft Environmental Impact Report',
                    backgroundColor: Color(0xFF0F6358),
                    content:
                        'Once the CA has accepted the Scoping Report, prepare the Environmental Impact Report. Include all Specialist Reports, the EMPr etc.'),
                ProcessAccordion(
                    title: 'Public Participation Process (PPP)',
                    backgroundColor: Color(0xFFD9A48E),
                    content:
                        "Advertise availability of the Draft EIR for review (dates & how to access documents). Release the Draft EIR for public review (30 days). *Remember - don't include 15 Dec to 5 Jan in timeframes. "),
                ProcessAccordion(
                    title: 'Submit Environmental Impact Report',
                    backgroundColor: Color(0xFF7E8C76),
                    content:
                        'Submit EIR Report (including EMPr) to the relevant office of Environmental Affairs.'),
                InfoBlock(
                    text:
                        'TIME ALERT: Environmental Affairs is required to acknowledge your submission within 10 days (START DATE). Your application must either be granted or refused by Environmental Affairs within 107 days of that acknowledgement date.'),
                ProcessAccordion(
                    title: 'Notification Of Outcome (PPP)',
                    backgroundColor: Color(0xFFD9A48E),
                    content:
                        'Notify all stakeholders & I&APs of the decision released by Environmental Affairs (within 14 days of the release) & appeals process. ')
              ],
            ),
          ),
        ),
      ),
    );
  }
}
