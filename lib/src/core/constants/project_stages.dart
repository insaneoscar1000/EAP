/// The 10 stages of the EIA process a project can be in, supplied by the
/// client for the Project Status tracker feature. Shared by the stage
/// picker and the info modal on the create/edit project form.
class ProjectStageInfo {
  final int number;
  final String name;
  final String description;

  const ProjectStageInfo({
    required this.number,
    required this.name,
    required this.description,
  });

  String get label => 'Stage $number: $name';
}

class ProjectStages {
  static const List<ProjectStageInfo> all = <ProjectStageInfo>[
    ProjectStageInfo(
      number: 1,
      name: 'Set up',
      description:
          'Determine legal requirements, appointment of EAPs, Specialists, define scope, obtain all project info.',
    ),
    ProjectStageInfo(
      number: 2,
      name: 'Application Drafted',
      description:
          'Complete application forms, gather supporting information and specialist requirements, prepare documents for submission.',
    ),
    ProjectStageInfo(
      number: 3,
      name: 'Reporting',
      description:
          'Complete environmental assessment, specialist studies, engineering inputs, impact assessments and mitigation measures.',
    ),
    ProjectStageInfo(
      number: 4,
      name: 'Public Participation',
      description:
          'Undertake public participation where required, advertising, site notices, record comments & responses.',
    ),
    ProjectStageInfo(
      number: 5,
      name: 'Application Submitted',
      description:
          'Submit the application to the relevant authority and receive acknowledgement/reference number where applicable.',
    ),
    ProjectStageInfo(
      number: 6,
      name: 'Final Submission',
      description:
          'Submit the final reports and supporting documents after incorporating comments and completing outstanding requirements.',
    ),
    ProjectStageInfo(
      number: 7,
      name: 'Authority Review',
      description:
          'Authority evaluates the application, including requests for additional information or amendments if required.',
    ),
    ProjectStageInfo(
      number: 8,
      name: 'Decision Issued',
      description:
          'Environmental Authorisation, License, Registration or other official decision issued.',
    ),
    ProjectStageInfo(
      number: 9,
      name: 'Appeal / Acceptance',
      description:
          'Appeal period, acceptance of conditions, financial provisions or other post-decision administrative actions where applicable.',
    ),
    ProjectStageInfo(
      number: 10,
      name: 'Implementation & Compliance',
      description:
          'Implement license/authorisation conditions, EMPr, monitoring, auditing and ongoing compliance.',
    ),
  ];

  static ProjectStageInfo? byNumber(int? number) {
    if (number == null) return null;
    for (final ProjectStageInfo stage in all) {
      if (stage.number == number) return stage;
    }
    return null;
  }
}
