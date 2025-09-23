import 'package:flutter/material.dart';
import 'package:the_eap_app/src/ui/shared/widgets/widgets.dart';
import 'package:the_eap_app/src/ui/views/eia_basics/basic_assessment_view/_info_block.dart';

class Section24GView extends StatelessWidget {
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
                SelectableText(
                    'The period from 15 December to 5 January to be excluded from all time periods given in this summary.',
                    style: TextStyle(fontWeight: FontWeight.bold),
                    toolbarOptions: ToolbarOptions(
                      copy: true, 
                      selectAll: true
                    )),
                SizedBox(height: 10),
                ProcessAccordion(
                    title: 'Non-Compliance Issued',
                    backgroundColor: Color(0xFF0F6358),
                    content:
                        'Environmental Affairs issues a Non-Compliance letter (in terms of Section 31L of NEMA) to a landowner/individual/company representative .'),
                ProcessAccordion(
                    title: 'EAP Appointment',
                    content:
                        'The applicant appoints a registered EAP (Contract signed & upfront payment made if required).'),
                ProcessAccordion(
                    title: 'Contact Authority',
                    backgroundColor: Color(0xFF7E8C76),
                    content:
                        'EAP makes contact with the relevant department that issued the Non-Compliance Letter to notify them of an upcoming Section 24G application.\nConfirm PPP requirements or exemptions.'),
                ProcessAccordion(
                    title: 'Site Visit',
                    content:
                        'EAP goes to site to assess activities.\nInclude PPP if required.'),
                ProcessAccordion(
                    title: 'Public Participation',
                    backgroundColor: Color(0xFFC97C5D),
                    content:
                        'Newspaper advert published (notify public of Section 24 G Application, review period & EAP contact info). \nSite notices placed on site (if not already)\nNotification letters & BIDs sent out\nOn-going liaison with I&APs (Comments received & responses given by EAP recorded)\nMeeting held if necessary (register taken & minutes compiled for Section 24 G Report)'),
                ProcessAccordion(
                    title: 'Application Form Completion',
                    backgroundColor: Color(0xFF7E8C76),
                    content:
                        'EAP completes the relevant application form (depending on province), including project details (applicant, environment, impacts, site photos). If required, a Specialist may be appointed to provide input. \nApplicant and EAP to sign declarations. '),
                ProcessAccordion(
                    title: 'Application Form Submission',
                    backgroundColor: Color(0xFF7E8C76),
                    content:
                        'Application form submitted (application fee paid)'),
                InfoBlock(
                    text:
                        'Environmental Affairs will provide details of a fine (required to be paid within 30 days).\n Upon payment of the fine, a decision regarding the application will be released.')
              ],
            ),
          ),
        ),
      ),
    );
  }
}
