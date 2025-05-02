import 'package:cloud_firestore/cloud_firestore.dart';

// Step 1 - Project Overview
class ProjectOverview {
  final String title;
  final String code;
  final String departmentReferenceNumber;
  final String propertyNameAddressFarmNo;

  ProjectOverview({
    required this.title,
    required this.code,
    required this.departmentReferenceNumber,
    required this.propertyNameAddressFarmNo,
  });

  factory ProjectOverview.fromMap(Map<String, dynamic> data) {
    return ProjectOverview(
      title: data['title'] ?? '',
      code: data['code'] ?? '',
      departmentReferenceNumber: data['departmentReferenceNumber'] ?? '',
      propertyNameAddressFarmNo: data['propertyNameAddressFarmNo'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'code': code,
      'departmentReferenceNumber': departmentReferenceNumber,
      'propertyNameAddressFarmNo': propertyNameAddressFarmNo,
    };
  }

  ProjectOverview copyWith({
    String? title,
    String? code,
    String? departmentReferenceNumber,
    String? propertyNameAddressFarmNo,
  }) {
    return ProjectOverview(
      title: title ?? this.title,
      code: code ?? this.code,
      departmentReferenceNumber:
          departmentReferenceNumber ?? this.departmentReferenceNumber,
      propertyNameAddressFarmNo:
          propertyNameAddressFarmNo ?? this.propertyNameAddressFarmNo,
    );
  }
}

// Step 2 - Location Details
class LocationDetails {
  final String? province;
  final String? districtOrMetroMunicipality;
  final String? localMunicipality;
  final String? projectLocation;
  final GeoPoint? coordinates;

  LocationDetails({
    this.province,
    this.districtOrMetroMunicipality,
    this.localMunicipality,
    this.projectLocation,
    this.coordinates,
  });

  factory LocationDetails.fromMap(Map<String, dynamic> data) {
    return LocationDetails(
      province: data['province'],
      districtOrMetroMunicipality: data['districtOrMetroMunicipality'],
      localMunicipality: data['localMunicipality'],
      projectLocation: data['projectLocation'],
      coordinates: data['coordinates'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'province': province,
      'districtOrMetroMunicipality': districtOrMetroMunicipality,
      'localMunicipality': localMunicipality,
      'projectLocation': projectLocation,
      'coordinates': coordinates,
    };
  }

  LocationDetails copyWith({
    String? province,
    String? districtOrMetroMunicipality,
    String? localMunicipality,
    String? projectLocation,
    GeoPoint? coordinates,
  }) {
    return LocationDetails(
      province: province ?? this.province,
      districtOrMetroMunicipality:
          districtOrMetroMunicipality ?? this.districtOrMetroMunicipality,
      localMunicipality: localMunicipality ?? this.localMunicipality,
      projectLocation: projectLocation ?? this.projectLocation,
      coordinates: coordinates ?? this.coordinates,
    );
  }
}

// Step 3 - Applicant and Landowner Information
class ApplicantLandownerInfo {
  final String? applicantName;
  final String? applicantDetails;
  final String? landowner;
  final String? landownerDetails;

  ApplicantLandownerInfo({
    this.applicantName,
    this.applicantDetails,
    this.landowner,
    this.landownerDetails,
  });

  factory ApplicantLandownerInfo.fromMap(Map<String, dynamic> data) {
    return ApplicantLandownerInfo(
      applicantName: data['applicantName'],
      applicantDetails: data['applicantDetails'],
      landowner: data['landowner'],
      landownerDetails: data['landownerDetails'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'applicantName': applicantName,
      'applicantDetails': applicantDetails,
      'landowner': landowner,
      'landownerDetails': landownerDetails,
    };
  }

  ApplicantLandownerInfo copyWith({
    String? applicantName,
    String? applicantDetails,
    String? landowner,
    String? landownerDetails,
  }) {
    return ApplicantLandownerInfo(
      applicantName: applicantName ?? this.applicantName,
      applicantDetails: applicantDetails ?? this.applicantDetails,
      landowner: landowner ?? this.landowner,
      landownerDetails: landownerDetails ?? this.landownerDetails,
    );
  }
}

// Step 4 - Project Description
class ProjectDescription {
  final String? applicationType;
  final String? projectDescription;

  ProjectDescription({
    this.applicationType,
    this.projectDescription,
  });

  factory ProjectDescription.fromMap(Map<String, dynamic> data) {
    return ProjectDescription(
      applicationType: data['applicationType'],
      projectDescription: data['projectDescription'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'applicationType': applicationType,
      'projectDescription': projectDescription,
    };
  }

  ProjectDescription copyWith({
    String? applicationType,
    String? projectDescription,
  }) {
    return ProjectDescription(
      applicationType: applicationType ?? this.applicationType,
      projectDescription: projectDescription ?? this.projectDescription,
    );
  }
}

// Step 5 - Environmental Details
class EnvironmentalDetails {
  final String? relevantListingNotice;
  final String? currentPropertyZoning;
  final String? propertySize;
  final String? existingServicesOnSite;
  final String? plannedServicesWater;
  final String? plannedServicesElectricity;
  final String? plannedServicesSanitation;

  EnvironmentalDetails({
    this.relevantListingNotice,
    this.currentPropertyZoning,
    this.propertySize,
    this.existingServicesOnSite,
    this.plannedServicesWater,
    this.plannedServicesElectricity,
    this.plannedServicesSanitation,
  });

  factory EnvironmentalDetails.fromMap(Map<String, dynamic> data) {
    return EnvironmentalDetails(
      relevantListingNotice: data['relevantListingNotice'],
      currentPropertyZoning: data['currentPropertyZoning'],
      propertySize: data['propertySize'],
      existingServicesOnSite: data['existingServicesOnSite'],
      plannedServicesWater: data['plannedServicesWater'],
      plannedServicesElectricity: data['plannedServicesElectricity'],
      plannedServicesSanitation: data['plannedServicesSanitation'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'relevantListingNotice': relevantListingNotice,
      'currentPropertyZoning': currentPropertyZoning,
      'propertySize': propertySize,
      'existingServicesOnSite': existingServicesOnSite,
      'plannedServicesWater': plannedServicesWater,
      'plannedServicesElectricity': plannedServicesElectricity,
      'plannedServicesSanitation': plannedServicesSanitation,
    };
  }

  EnvironmentalDetails copyWith({
    String? relevantListingNotice,
    String? currentPropertyZoning,
    String? propertySize,
    String? existingServicesOnSite,
    String? plannedServicesWater,
    String? plannedServicesElectricity,
    String? plannedServicesSanitation,
  }) {
    return EnvironmentalDetails(
      relevantListingNotice:
          relevantListingNotice ?? this.relevantListingNotice,
      currentPropertyZoning:
          currentPropertyZoning ?? this.currentPropertyZoning,
      propertySize: propertySize ?? this.propertySize,
      existingServicesOnSite:
          existingServicesOnSite ?? this.existingServicesOnSite,
      plannedServicesWater: plannedServicesWater ?? this.plannedServicesWater,
      plannedServicesElectricity:
          plannedServicesElectricity ?? this.plannedServicesElectricity,
      plannedServicesSanitation:
          plannedServicesSanitation ?? this.plannedServicesSanitation,
    );
  }
}

// Step 6 - EIA Team and Specialist Studies
class EiaTeamAndStudies {
  final List<String>? eiaProjectTeam;
  final List<String>? specialistStudiesRequired;
  final List<String>? specialistStudiesCompleted;

  EiaTeamAndStudies({
    this.eiaProjectTeam,
    this.specialistStudiesRequired,
    this.specialistStudiesCompleted,
  });

  factory EiaTeamAndStudies.fromMap(Map<String, dynamic> data) {
    return EiaTeamAndStudies(
      eiaProjectTeam: data['eiaProjectTeam'] != null
          ? List<String>.from(data['eiaProjectTeam'])
          : [],
      specialistStudiesRequired: data['specialistStudiesRequired'] != null
          ? List<String>.from(data['specialistStudiesRequired'])
          : [],
      specialistStudiesCompleted: data['specialistStudiesCompleted'] != null
          ? List<String>.from(data['specialistStudiesCompleted'])
          : [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'eiaProjectTeam': eiaProjectTeam,
      'specialistStudiesRequired': specialistStudiesRequired,
      'specialistStudiesCompleted': specialistStudiesCompleted,
    };
  }

  EiaTeamAndStudies copyWith({
    List<String>? eiaProjectTeam,
    List<String>? specialistStudiesRequired,
    List<String>? specialistStudiesCompleted,
  }) {
    return EiaTeamAndStudies(
      eiaProjectTeam: eiaProjectTeam ?? this.eiaProjectTeam,
      specialistStudiesRequired:
          specialistStudiesRequired ?? this.specialistStudiesRequired,
      specialistStudiesCompleted:
          specialistStudiesCompleted ?? this.specialistStudiesCompleted,
    );
  }
}

// Step 7 - Public Review Periods
class PublicReviewPeriods {
  final DateTime? publicReviewPeriod1StartDate;
  final DateTime? publicReviewPeriod1EndDate;
  final int? publicReviewPeriod1Duration;
  final DateTime? publicReviewPeriod2StartDate;
  final DateTime? publicReviewPeriod2EndDate;
  final int? publicReviewPeriod2Duration;

  PublicReviewPeriods({
    this.publicReviewPeriod1StartDate,
    this.publicReviewPeriod1EndDate,
    this.publicReviewPeriod1Duration,
    this.publicReviewPeriod2StartDate,
    this.publicReviewPeriod2EndDate,
    this.publicReviewPeriod2Duration,
  });

  factory PublicReviewPeriods.fromMap(Map<String, dynamic> data) {
    return PublicReviewPeriods(
      publicReviewPeriod1StartDate: data['publicReviewPeriod1StartDate'] != null
          ? (data['publicReviewPeriod1StartDate'] as Timestamp).toDate()
          : null,
      publicReviewPeriod1EndDate: data['publicReviewPeriod1EndDate'] != null
          ? (data['publicReviewPeriod1EndDate'] as Timestamp).toDate()
          : null,
      publicReviewPeriod1Duration: data['publicReviewPeriod1Duration'],
      publicReviewPeriod2StartDate: data['publicReviewPeriod2StartDate'] != null
          ? (data['publicReviewPeriod2StartDate'] as Timestamp).toDate()
          : null,
      publicReviewPeriod2EndDate: data['publicReviewPeriod2EndDate'] != null
          ? (data['publicReviewPeriod2EndDate'] as Timestamp).toDate()
          : null,
      publicReviewPeriod2Duration: data['publicReviewPeriod2Duration'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'publicReviewPeriod1StartDate': publicReviewPeriod1StartDate != null
          ? Timestamp.fromDate(publicReviewPeriod1StartDate!)
          : null,
      'publicReviewPeriod1EndDate': publicReviewPeriod1EndDate != null
          ? Timestamp.fromDate(publicReviewPeriod1EndDate!)
          : null,
      'publicReviewPeriod1Duration': publicReviewPeriod1Duration,
      'publicReviewPeriod2StartDate': publicReviewPeriod2StartDate != null
          ? Timestamp.fromDate(publicReviewPeriod2StartDate!)
          : null,
      'publicReviewPeriod2EndDate': publicReviewPeriod2EndDate != null
          ? Timestamp.fromDate(publicReviewPeriod2EndDate!)
          : null,
      'publicReviewPeriod2Duration': publicReviewPeriod2Duration,
    };
  }

  PublicReviewPeriods copyWith({
    DateTime? publicReviewPeriod1StartDate,
    DateTime? publicReviewPeriod1EndDate,
    int? publicReviewPeriod1Duration,
    DateTime? publicReviewPeriod2StartDate,
    DateTime? publicReviewPeriod2EndDate,
    int? publicReviewPeriod2Duration,
  }) {
    return PublicReviewPeriods(
      publicReviewPeriod1StartDate:
          publicReviewPeriod1StartDate ?? this.publicReviewPeriod1StartDate,
      publicReviewPeriod1EndDate:
          publicReviewPeriod1EndDate ?? this.publicReviewPeriod1EndDate,
      publicReviewPeriod1Duration:
          publicReviewPeriod1Duration ?? this.publicReviewPeriod1Duration,
      publicReviewPeriod2StartDate:
          publicReviewPeriod2StartDate ?? this.publicReviewPeriod2StartDate,
      publicReviewPeriod2EndDate:
          publicReviewPeriod2EndDate ?? this.publicReviewPeriod2EndDate,
      publicReviewPeriod2Duration:
          publicReviewPeriod2Duration ?? this.publicReviewPeriod2Duration,
    );
  }
}

// Step 8 - Submission and Contacts
class SubmissionAndContacts {
  final String? relevantEnvironmentalAffairsOffice;
  final List<String>? environmentalAffairsContacts;
  final DateTime? dateOfPreapplicationMeeting;
  final DateTime? dateOfSubmissionOfApplication;
  final DateTime? dateOfSubmissionOfDraftDocuments;
  final DateTime? dateOfSubmissionOfFinalDocuments;

  SubmissionAndContacts({
    this.relevantEnvironmentalAffairsOffice,
    this.environmentalAffairsContacts,
    this.dateOfPreapplicationMeeting,
    this.dateOfSubmissionOfApplication,
    this.dateOfSubmissionOfDraftDocuments,
    this.dateOfSubmissionOfFinalDocuments,
  });

  factory SubmissionAndContacts.fromMap(Map<String, dynamic> data) {
    return SubmissionAndContacts(
      relevantEnvironmentalAffairsOffice:
          data['relevantEnvironmentalAffairsOffice'],
      environmentalAffairsContacts: data['environmentalAffairsContacts'] != null
          ? List<String>.from(data['environmentalAffairsContacts'])
          : [],
      dateOfPreapplicationMeeting: data['dateOfPreapplicationMeeting'] != null
          ? (data['dateOfPreapplicationMeeting'] as Timestamp).toDate()
          : null,
      dateOfSubmissionOfApplication:
          data['dateOfSubmissionOfApplication'] != null
              ? (data['dateOfSubmissionOfApplication'] as Timestamp).toDate()
              : null,
      dateOfSubmissionOfDraftDocuments:
          data['dateOfSubmissionOfDraftDocuments'] != null
              ? (data['dateOfSubmissionOfDraftDocuments'] as Timestamp).toDate()
              : null,
      dateOfSubmissionOfFinalDocuments:
          data['dateOfSubmissionOfFinalDocuments'] != null
              ? (data['dateOfSubmissionOfFinalDocuments'] as Timestamp).toDate()
              : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'relevantEnvironmentalAffairsOffice': relevantEnvironmentalAffairsOffice,
      'environmentalAffairsContacts': environmentalAffairsContacts,
      'dateOfPreapplicationMeeting': dateOfPreapplicationMeeting != null
          ? Timestamp.fromDate(dateOfPreapplicationMeeting!)
          : null,
      'dateOfSubmissionOfApplication': dateOfSubmissionOfApplication != null
          ? Timestamp.fromDate(dateOfSubmissionOfApplication!)
          : null,
      'dateOfSubmissionOfDraftDocuments':
          dateOfSubmissionOfDraftDocuments != null
              ? Timestamp.fromDate(dateOfSubmissionOfDraftDocuments!)
              : null,
      'dateOfSubmissionOfFinalDocuments':
          dateOfSubmissionOfFinalDocuments != null
              ? Timestamp.fromDate(dateOfSubmissionOfFinalDocuments!)
              : null,
    };
  }

  SubmissionAndContacts copyWith({
    String? relevantEnvironmentalAffairsOffice,
    List<String>? environmentalAffairsContacts,
    DateTime? dateOfPreapplicationMeeting,
    DateTime? dateOfSubmissionOfApplication,
    DateTime? dateOfSubmissionOfDraftDocuments,
    DateTime? dateOfSubmissionOfFinalDocuments,
  }) {
    return SubmissionAndContacts(
      relevantEnvironmentalAffairsOffice: relevantEnvironmentalAffairsOffice ??
          this.relevantEnvironmentalAffairsOffice,
      environmentalAffairsContacts:
          environmentalAffairsContacts ?? this.environmentalAffairsContacts,
      dateOfPreapplicationMeeting:
          dateOfPreapplicationMeeting ?? this.dateOfPreapplicationMeeting,
      dateOfSubmissionOfApplication:
          dateOfSubmissionOfApplication ?? this.dateOfSubmissionOfApplication,
      dateOfSubmissionOfDraftDocuments: dateOfSubmissionOfDraftDocuments ??
          this.dateOfSubmissionOfDraftDocuments,
      dateOfSubmissionOfFinalDocuments: dateOfSubmissionOfFinalDocuments ??
          this.dateOfSubmissionOfFinalDocuments,
    );
  }
}

// Step 9 - Notes
class ProjectNotes {
  final String? notes;

  ProjectNotes({
    this.notes,
  });

  factory ProjectNotes.fromMap(Map<String, dynamic> data) {
    return ProjectNotes(
      notes: data['notes'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'notes': notes,
    };
  }

  ProjectNotes copyWith({
    String? notes,
  }) {
    return ProjectNotes(
      notes: notes ?? this.notes,
    );
  }
}

class Project {
  final String? id;

  // Step data
  final ProjectOverview overview;
  final LocationDetails location;
  final ApplicantLandownerInfo applicantLandowner;
  final ProjectDescription? projectDescription;
  final EnvironmentalDetails? environmentalDetails;
  final EiaTeamAndStudies? eiaTeamAndStudies;
  final PublicReviewPeriods? publicReviewPeriods;
  final SubmissionAndContacts? submissionAndContacts;
  final ProjectNotes? projectNotes;

  // Other fields
  final String? projectType;
  final String? projectStatus;
  final List<String>? teamMembers;
  final List<String>? documents;
  final Timestamp? createdAt;
  final String? userId;
  final int currentStep;
  final bool isComplete;

  Project({
    this.id,
    // Steps 1-3
    required this.overview,
    required this.location,
    required this.applicantLandowner,
    // Steps 4-9 as nested objects
    this.projectDescription,
    this.environmentalDetails,
    this.eiaTeamAndStudies,
    this.publicReviewPeriods,
    this.submissionAndContacts,
    this.projectNotes,
    // Other fields
    this.projectType,
    this.projectStatus,
    this.teamMembers,
    this.documents,
    this.createdAt,
    this.userId,
    this.currentStep = 1,
    this.isComplete = false,
  });

  // Create a Project from a DocumentSnapshot
  factory Project.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return Project(
      id: snapshot.id,
      // Steps 1-3 as nested objects
      overview: ProjectOverview.fromMap({
        'title': data['title'] ?? '',
        'code': data['code'] ?? '',
        'departmentReferenceNumber': data['departmentReferenceNumber'] ?? '',
        'propertyNameAddressFarmNo': data['propertyNameAddressFarmNo'] ?? '',
      }),
      location: LocationDetails.fromMap({
        'province': data['province'],
        'districtOrMetroMunicipality': data['districtOrMetroMunicipality'],
        'localMunicipality': data['localMunicipality'],
        'projectLocation': data['projectLocation'],
        'coordinates': data['coordinates'],
      }),
      applicantLandowner: ApplicantLandownerInfo.fromMap({
        'applicantName': data['applicantName'],
        'applicantDetails': data['applicantDetails'],
        'landowner': data['landowner'],
        'landownerDetails': data['landownerDetails'],
      }),
      // Step 4 - Project Description
      projectDescription:
          data['applicationType'] != null || data['projectDescription'] != null
              ? ProjectDescription(
                  applicationType: data['applicationType'],
                  projectDescription: data['projectDescription'],
                )
              : null,
      // Step 5 - Environmental Details
      environmentalDetails: data['relevantListingNotice'] != null ||
              data['currentPropertyZoning'] != null ||
              data['propertySize'] != null ||
              data['existingServicesOnSite'] != null ||
              data['plannedServicesWater'] != null ||
              data['plannedServicesElectricity'] != null ||
              data['plannedServicesSanitation'] != null
          ? EnvironmentalDetails(
              relevantListingNotice: data['relevantListingNotice'],
              currentPropertyZoning: data['currentPropertyZoning'],
              propertySize: data['propertySize'],
              existingServicesOnSite: data['existingServicesOnSite'],
              plannedServicesWater: data['plannedServicesWater'],
              plannedServicesElectricity: data['plannedServicesElectricity'],
              plannedServicesSanitation: data['plannedServicesSanitation'],
            )
          : null,
      // Step 6 - EIA Team and Specialist Studies
      eiaTeamAndStudies: data['eiaProjectTeam'] != null ||
              data['specialistStudiesRequired'] != null ||
              data['specialistStudiesCompleted'] != null
          ? EiaTeamAndStudies(
              eiaProjectTeam: data['eiaProjectTeam'] != null
                  ? List<String>.from(data['eiaProjectTeam'])
                  : [],
              specialistStudiesRequired:
                  data['specialistStudiesRequired'] != null
                      ? List<String>.from(data['specialistStudiesRequired'])
                      : [],
              specialistStudiesCompleted:
                  data['specialistStudiesCompleted'] != null
                      ? List<String>.from(data['specialistStudiesCompleted'])
                      : [],
            )
          : null,
      // Step 7 - Public Review Periods
      publicReviewPeriods: data['publicReviewPeriod1StartDate'] != null ||
              data['publicReviewPeriod1EndDate'] != null ||
              data['publicReviewPeriod1Duration'] != null ||
              data['publicReviewPeriod2StartDate'] != null ||
              data['publicReviewPeriod2EndDate'] != null ||
              data['publicReviewPeriod2Duration'] != null
          ? PublicReviewPeriods(
              publicReviewPeriod1StartDate:
                  data['publicReviewPeriod1StartDate'] != null
                      ? (data['publicReviewPeriod1StartDate'] as Timestamp)
                          .toDate()
                      : null,
              publicReviewPeriod1EndDate: data['publicReviewPeriod1EndDate'] !=
                      null
                  ? (data['publicReviewPeriod1EndDate'] as Timestamp).toDate()
                  : null,
              publicReviewPeriod1Duration: data['publicReviewPeriod1Duration'],
              publicReviewPeriod2StartDate:
                  data['publicReviewPeriod2StartDate'] != null
                      ? (data['publicReviewPeriod2StartDate'] as Timestamp)
                          .toDate()
                      : null,
              publicReviewPeriod2EndDate: data['publicReviewPeriod2EndDate'] !=
                      null
                  ? (data['publicReviewPeriod2EndDate'] as Timestamp).toDate()
                  : null,
              publicReviewPeriod2Duration: data['publicReviewPeriod2Duration'],
            )
          : null,
      // Step 8 - Submission and Contacts
      submissionAndContacts: data['relevantEnvironmentalAffairsOffice'] !=
                  null ||
              data['environmentalAffairsContacts'] != null ||
              data['dateOfPreapplicationMeeting'] != null ||
              data['dateOfSubmissionOfApplication'] != null ||
              data['dateOfSubmissionOfDraftDocuments'] != null ||
              data['dateOfSubmissionOfFinalDocuments'] != null
          ? SubmissionAndContacts(
              relevantEnvironmentalAffairsOffice:
                  data['relevantEnvironmentalAffairsOffice'],
              environmentalAffairsContacts:
                  data['environmentalAffairsContacts'] != null
                      ? List<String>.from(data['environmentalAffairsContacts'])
                      : [],
              dateOfPreapplicationMeeting:
                  data['dateOfPreapplicationMeeting'] != null
                      ? (data['dateOfPreapplicationMeeting'] as Timestamp)
                          .toDate()
                      : null,
              dateOfSubmissionOfApplication:
                  data['dateOfSubmissionOfApplication'] != null
                      ? (data['dateOfSubmissionOfApplication'] as Timestamp)
                          .toDate()
                      : null,
              dateOfSubmissionOfDraftDocuments:
                  data['dateOfSubmissionOfDraftDocuments'] != null
                      ? (data['dateOfSubmissionOfDraftDocuments'] as Timestamp)
                          .toDate()
                      : null,
              dateOfSubmissionOfFinalDocuments:
                  data['dateOfSubmissionOfFinalDocuments'] != null
                      ? (data['dateOfSubmissionOfFinalDocuments'] as Timestamp)
                          .toDate()
                      : null,
            )
          : null,
      // Step 9 - Notes
      projectNotes: data['notes'] != null
          ? ProjectNotes(
              notes: data['notes'],
            )
          : null,
      // Other fields
      projectType: data['projectType'],
      projectStatus: data['projectStatus'],
      teamMembers: List<String>.from(data['teamMembers'] ?? []),
      documents: List<String>.from(data['documents'] ?? []),
      createdAt: data['createdAt'],
      userId: data['userId'],
      currentStep: data['currentStep'] ?? 1,
      isComplete: data['isComplete'] ?? false,
    );
  }

  // Convert a Project to a Map
  Map<String, dynamic> toMap() {
    // Merge the nested objects' maps with the main map
    final overviewMap = overview.toMap();
    final locationMap = location.toMap();
    final applicantLandownerMap = applicantLandowner.toMap();

    // Create maps for the nested objects for steps 4-9 if they exist
    final projectDescriptionMap = projectDescription?.toMap() ?? {};
    final environmentalDetailsMap = environmentalDetails?.toMap() ?? {};
    final eiaTeamAndStudiesMap = eiaTeamAndStudies?.toMap() ?? {};
    final publicReviewPeriodsMap = publicReviewPeriods?.toMap() ?? {};
    final submissionAndContactsMap = submissionAndContacts?.toMap() ?? {};
    final projectNotesMap = projectNotes?.toMap() ?? {};

    return {
      // Include all fields from the nested objects
      ...overviewMap,
      ...locationMap,
      ...applicantLandownerMap,
      ...projectDescriptionMap,
      ...environmentalDetailsMap,
      ...eiaTeamAndStudiesMap,
      ...publicReviewPeriodsMap,
      ...submissionAndContactsMap,
      ...projectNotesMap,
      // Other fields
      'projectType': projectType,
      'projectStatus': projectStatus,
      'teamMembers': teamMembers,
      'documents': documents,
      'createdAt': createdAt ?? Timestamp.now(),
      'userId': userId,
      'currentStep': currentStep,
      'isComplete': isComplete,
    };
  }

  // Create a copy of the Project with some fields updated
  Project copyWith({
    String? id,
    // Steps 1-3 as nested objects
    ProjectOverview? overview,
    LocationDetails? location,
    ApplicantLandownerInfo? applicantLandowner,
    // Steps 4-9 as nested objects
    ProjectDescription? projectDescription,
    EnvironmentalDetails? environmentalDetails,
    EiaTeamAndStudies? eiaTeamAndStudies,
    PublicReviewPeriods? publicReviewPeriods,
    SubmissionAndContacts? submissionAndContacts,
    ProjectNotes? projectNotes,
    // Other fields
    String? projectType,
    String? projectStatus,
    List<String>? teamMembers,
    List<String>? documents,
    Timestamp? createdAt,
    String? userId,
    int? currentStep,
    bool? isComplete,
  }) {
    return Project(
      id: id ?? this.id,
      // Steps 1-3 as nested objects
      overview: overview ?? this.overview,
      location: location ?? this.location,
      applicantLandowner: applicantLandowner ?? this.applicantLandowner,
      // Steps 4-9 as nested objects
      projectDescription: projectDescription ?? this.projectDescription,
      environmentalDetails: environmentalDetails ?? this.environmentalDetails,
      eiaTeamAndStudies: eiaTeamAndStudies ?? this.eiaTeamAndStudies,
      publicReviewPeriods: publicReviewPeriods ?? this.publicReviewPeriods,
      submissionAndContacts:
          submissionAndContacts ?? this.submissionAndContacts,
      projectNotes: projectNotes ?? this.projectNotes,
      // Other fields
      projectType: projectType ?? this.projectType,
      projectStatus: projectStatus ?? this.projectStatus,
      teamMembers: teamMembers ?? this.teamMembers,
      documents: documents ?? this.documents,
      createdAt: createdAt ?? this.createdAt,
      userId: userId ?? this.userId,
      currentStep: currentStep ?? this.currentStep,
      isComplete: isComplete ?? this.isComplete,
    );
  }
}
