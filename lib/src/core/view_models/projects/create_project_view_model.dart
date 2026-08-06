// No need for direct Firestore imports as we're using the model classes
import 'package:stacked/stacked.dart';
import 'package:the_eap_app/src/core/models/models.dart';
import 'package:the_eap_app/src/core/services/services.dart';
import 'package:the_eap_app/src/locator.dart';

class CreateProjectViewModel extends BaseViewModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final ProjectService _projectService = locator<ProjectService>();

  // Project data
  Project? _project;
  Project? get project => _project;
  String? _projectId;
  
  // Form fields for step 1 - Project Overview
  String _projectTitle = '';
  String _projectCode = '';
  String _departmentReferenceNumber = '';
  String _propertyNameAddressFarmNo = '';
  
  // Form fields for step 2 - Location Details
  String _province = '';
  String _districtOrMetroMunicipality = '';
  String _localMunicipality = '';
  
  // Form fields for step 3 - Applicant and Landowner Information
  String _applicantName = '';
  String _applicantDetails = '';
  String _landowner = '';
  String _landownerDetails = '';
  
  // Form fields for step 4 - Project Description
  String _applicationType = '';
  String _projectDescription = '';
  
  // Form fields for step 5 - Environmental Details
  String _relevantListingNotice = '';
  String _currentPropertyZoning = '';
  String _propertySize = '';
  String _existingServicesOnSite = '';
  String _plannedServicesWater = '';
  String _plannedServicesElectricity = '';
  String _plannedServicesSanitation = '';
  
  // Form fields for step 6 - EIA Team and Specialist Studies
  List<String> _eiaProjectTeam = [];
  List<String> _specialistStudiesRequired = [];
  List<String> _specialistStudiesCompleted = [];
  
  // Form fields for step 7 - Public Review Periods
  DateTime? _publicReviewPeriod1StartDate;
  DateTime? _publicReviewPeriod1EndDate;
  int _publicReviewPeriod1Duration = 24; // Default 24 days
  DateTime? _publicReviewPeriod2StartDate;
  DateTime? _publicReviewPeriod2EndDate;
  int _publicReviewPeriod2Duration = 30; // Default 30 days
  
  // Form fields for step 8 - Submission and Contacts
  String _relevantEnvironmentalAffairsOffice = '';
  List<String> _environmentalAffairsContacts = [];
  DateTime? _dateOfPreapplicationMeeting;
  DateTime? _dateOfSubmissionOfApplication;
  DateTime? _dateOfSubmissionOfDraftDocuments;
  DateTime? _dateOfSubmissionOfFinalDocuments;
  
  // Form fields for step 9 - Notes
  String _notes = '';

  // Project Status stage (1-10), null means not set
  int? _projectStage;

  // Whether the whole form can be saved
  bool get canSave => !isBusy;

  // Getters and setters for step 1 form fields
  String get projectTitle => _projectTitle;
  set projectTitle(String value) {
    _projectTitle = value;
    notifyListeners();
  }
  
  String get projectCode => _projectCode;
  set projectCode(String value) {
    _projectCode = value;
    notifyListeners();
  }
  
  String get departmentReferenceNumber => _departmentReferenceNumber;
  set departmentReferenceNumber(String value) {
    _departmentReferenceNumber = value;
    notifyListeners();
  }
  
  String get propertyNameAddressFarmNo => _propertyNameAddressFarmNo;
  set propertyNameAddressFarmNo(String value) {
    _propertyNameAddressFarmNo = value;
    notifyListeners();
  }
  
  // Getters and setters for step 2 form fields - Location Details
  String get province => _province;
  set province(String value) {
    _province = value;
    notifyListeners();
  }
  
  String get districtOrMetroMunicipality => _districtOrMetroMunicipality;
  set districtOrMetroMunicipality(String value) {
    _districtOrMetroMunicipality = value;
    notifyListeners();
  }
  
  String get localMunicipality => _localMunicipality;
  set localMunicipality(String value) {
    _localMunicipality = value;
    notifyListeners();
  }
  
  // Getters and setters for step 3 form fields - Applicant and Landowner Information
  String get applicantName => _applicantName;
  set applicantName(String value) {
    _applicantName = value;
    notifyListeners();
  }
  
  String get applicantDetails => _applicantDetails;
  set applicantDetails(String value) {
    _applicantDetails = value;
    notifyListeners();
  }
  
  String get landowner => _landowner;
  set landowner(String value) {
    _landowner = value;
    notifyListeners();
  }
  
  String get landownerDetails => _landownerDetails;
  set landownerDetails(String value) {
    _landownerDetails = value;
    notifyListeners();
  }
  
  // Getters and setters for step 4 form fields - Project Description
  String get applicationType => _applicationType;
  set applicationType(String value) {
    _applicationType = value;
    notifyListeners();
  }
  
  String get projectDescription => _projectDescription;
  set projectDescription(String value) {
    _projectDescription = value;
    notifyListeners();
  }
  
  // This helper method is now integrated into _loadProjectData
  
  // Getters and setters for step 5 form fields - Environmental Details
  String get relevantListingNotice => _relevantListingNotice;
  set relevantListingNotice(String value) {
    _relevantListingNotice = value;
    notifyListeners();
  }
  
  String get currentPropertyZoning => _currentPropertyZoning;
  set currentPropertyZoning(String value) {
    _currentPropertyZoning = value;
    notifyListeners();
  }
  
  String get propertySize => _propertySize;
  set propertySize(String value) {
    _propertySize = value;
    notifyListeners();
  }
  
  String get existingServicesOnSite => _existingServicesOnSite;
  set existingServicesOnSite(String value) {
    _existingServicesOnSite = value;
    notifyListeners();
  }
  
  String get plannedServicesWater => _plannedServicesWater;
  set plannedServicesWater(String value) {
    _plannedServicesWater = value;
    notifyListeners();
  }
  
  String get plannedServicesElectricity => _plannedServicesElectricity;
  set plannedServicesElectricity(String value) {
    _plannedServicesElectricity = value;
    notifyListeners();
  }
  
  String get plannedServicesSanitation => _plannedServicesSanitation;
  set plannedServicesSanitation(String value) {
    _plannedServicesSanitation = value;
    notifyListeners();
  }
  
  // Getters and setters for step 6 form fields - EIA Team and Specialist Studies
  List<String> get eiaProjectTeam => _eiaProjectTeam;
  set eiaProjectTeam(List<String> value) {
    _eiaProjectTeam = value;
    notifyListeners();
  }
  void addEiaTeamMember(String member) {
    _eiaProjectTeam.add(member);
    notifyListeners();
  }
  
  List<String> get specialistStudiesRequired => _specialistStudiesRequired;
  set specialistStudiesRequired(List<String> value) {
    _specialistStudiesRequired = value;
    notifyListeners();
  }
  void addSpecialistStudyRequired(String study) {
    _specialistStudiesRequired.add(study);
    notifyListeners();
  }
  
  List<String> get specialistStudiesCompleted => _specialistStudiesCompleted;
  set specialistStudiesCompleted(List<String> value) {
    _specialistStudiesCompleted = value;
    notifyListeners();
  }
  void addSpecialistStudyCompleted(String study) {
    _specialistStudiesCompleted.add(study);
    notifyListeners();
  }
  
  // Getters and setters for step 7 form fields - Public Review Periods
  DateTime? get publicReviewPeriod1StartDate => _publicReviewPeriod1StartDate;
  set publicReviewPeriod1StartDate(DateTime? value) {
    _publicReviewPeriod1StartDate = value;
    notifyListeners();
  }
  
  DateTime? get publicReviewPeriod1EndDate => _publicReviewPeriod1EndDate;
  set publicReviewPeriod1EndDate(DateTime? value) {
    _publicReviewPeriod1EndDate = value;
    notifyListeners();
  }
  
  int get publicReviewPeriod1Duration => _publicReviewPeriod1Duration;
  set publicReviewPeriod1Duration(int value) {
    _publicReviewPeriod1Duration = value;
    notifyListeners();
  }
  
  DateTime? get publicReviewPeriod2StartDate => _publicReviewPeriod2StartDate;
  set publicReviewPeriod2StartDate(DateTime? value) {
    _publicReviewPeriod2StartDate = value;
    notifyListeners();
  }
  
  DateTime? get publicReviewPeriod2EndDate => _publicReviewPeriod2EndDate;
  set publicReviewPeriod2EndDate(DateTime? value) {
    _publicReviewPeriod2EndDate = value;
    notifyListeners();
  }
  
  int get publicReviewPeriod2Duration => _publicReviewPeriod2Duration;
  set publicReviewPeriod2Duration(int value) {
    _publicReviewPeriod2Duration = value;
    notifyListeners();
  }
  
  // Getters and setters for step 8 form fields - Submission and Contacts
  String get relevantEnvironmentalAffairsOffice => _relevantEnvironmentalAffairsOffice;
  set relevantEnvironmentalAffairsOffice(String value) {
    _relevantEnvironmentalAffairsOffice = value;
    notifyListeners();
  }
  
  List<String> get environmentalAffairsContacts => _environmentalAffairsContacts;
  set environmentalAffairsContacts(List<String> value) {
    _environmentalAffairsContacts = value;
    notifyListeners();
  }
  void addEnvironmentalAffairsContact(String contact) {
    _environmentalAffairsContacts.add(contact);
    notifyListeners();
  }
  
  DateTime? get dateOfPreapplicationMeeting => _dateOfPreapplicationMeeting;
  set dateOfPreapplicationMeeting(DateTime? value) {
    _dateOfPreapplicationMeeting = value;
    notifyListeners();
  }
  
  DateTime? get dateOfSubmissionOfApplication => _dateOfSubmissionOfApplication;
  set dateOfSubmissionOfApplication(DateTime? value) {
    _dateOfSubmissionOfApplication = value;
    notifyListeners();
  }
  
  DateTime? get dateOfSubmissionOfDraftDocuments => _dateOfSubmissionOfDraftDocuments;
  set dateOfSubmissionOfDraftDocuments(DateTime? value) {
    _dateOfSubmissionOfDraftDocuments = value;
    notifyListeners();
  }
  
  DateTime? get dateOfSubmissionOfFinalDocuments => _dateOfSubmissionOfFinalDocuments;
  set dateOfSubmissionOfFinalDocuments(DateTime? value) {
    _dateOfSubmissionOfFinalDocuments = value;
    notifyListeners();
  }
  
  // Getters and setters for step 9 form fields - Notes
  String get notes => _notes;
  set notes(String value) {
    _notes = value;
    notifyListeners();
  }

  // Getter and setter for the Project Status stage
  int? get projectStage => _projectStage;
  set projectStage(int? value) {
    _projectStage = value;
    notifyListeners();
  }

  // Initialize the view model
  void initialize({String? projectId}) async {
    setBusy(true);
    
    // Set the project ID if provided
    if (projectId != null) {
      _projectId = projectId;
    }
    
    // If we have a project ID, load the existing project
    if (_projectId != null) {
      _project = await _projectService.getProject(_projectId!);

      if (_project != null) {
        // Load the existing project's data into the form fields
        _loadProjectData();
      }
    }
    
    setBusy(false);
  }
  
  // Load project data into form fields
  void _loadProjectData() {
    if (_project != null) {
      // Step 1 - Project Overview
      _projectTitle = _project!.overview.title;
      _projectCode = _project!.overview.code;
      _departmentReferenceNumber = _project!.overview.departmentReferenceNumber;
      _propertyNameAddressFarmNo = _project!.overview.propertyNameAddressFarmNo;
      
      // Step 2 - Location Details
      _province = _project!.location.province ?? '';
      _districtOrMetroMunicipality = _project!.location.districtOrMetroMunicipality ?? '';
      _localMunicipality = _project!.location.localMunicipality ?? '';
      
      // Step 3 - Applicant and Landowner Information
      _applicantName = _project!.applicantLandowner.applicantName ?? '';
      _applicantDetails = _project!.applicantLandowner.applicantDetails ?? '';
      _landowner = _project!.applicantLandowner.landowner ?? '';
      _landownerDetails = _project!.applicantLandowner.landownerDetails ?? '';
      
      // Step 4 - Project Description
      if (_project!.projectDescription != null) {
        _applicationType = _project!.projectDescription!.applicationType ?? '';
        _projectDescription = _project!.projectDescription!.projectDescription ?? '';
      }
      
      // Step 5 - Environmental Details
      if (_project!.environmentalDetails != null) {
        _relevantListingNotice = _project!.environmentalDetails!.relevantListingNotice ?? '';
        _currentPropertyZoning = _project!.environmentalDetails!.currentPropertyZoning ?? '';
        _propertySize = _project!.environmentalDetails!.propertySize ?? '';
        _existingServicesOnSite = _project!.environmentalDetails!.existingServicesOnSite ?? '';
        _plannedServicesWater = _project!.environmentalDetails!.plannedServicesWater ?? '';
        _plannedServicesElectricity = _project!.environmentalDetails!.plannedServicesElectricity ?? '';
        _plannedServicesSanitation = _project!.environmentalDetails!.plannedServicesSanitation ?? '';
      }
      
      // Step 6 - EIA Team and Specialist Studies
      if (_project!.eiaTeamAndStudies != null) {
        _eiaProjectTeam = _project!.eiaTeamAndStudies!.eiaProjectTeam ?? [];
        _specialistStudiesRequired = _project!.eiaTeamAndStudies!.specialistStudiesRequired ?? [];
        _specialistStudiesCompleted = _project!.eiaTeamAndStudies!.specialistStudiesCompleted ?? [];
      }
      
      // Step 7 - Public Review Periods
      if (_project!.publicReviewPeriods != null) {
        _publicReviewPeriod1StartDate = _project!.publicReviewPeriods!.publicReviewPeriod1StartDate;
        _publicReviewPeriod1EndDate = _project!.publicReviewPeriods!.publicReviewPeriod1EndDate;
        _publicReviewPeriod1Duration = _project!.publicReviewPeriods!.publicReviewPeriod1Duration ?? 24;
        _publicReviewPeriod2StartDate = _project!.publicReviewPeriods!.publicReviewPeriod2StartDate;
        _publicReviewPeriod2EndDate = _project!.publicReviewPeriods!.publicReviewPeriod2EndDate;
        _publicReviewPeriod2Duration = _project!.publicReviewPeriods!.publicReviewPeriod2Duration ?? 30;
      }
      
      // Step 8 - Submission and Contacts
      if (_project!.submissionAndContacts != null) {
        _relevantEnvironmentalAffairsOffice = _project!.submissionAndContacts!.relevantEnvironmentalAffairsOffice ?? '';
        _environmentalAffairsContacts = _project!.submissionAndContacts!.environmentalAffairsContacts ?? [];
        _dateOfPreapplicationMeeting = _project!.submissionAndContacts!.dateOfPreapplicationMeeting;
        _dateOfSubmissionOfApplication = _project!.submissionAndContacts!.dateOfSubmissionOfApplication;
        _dateOfSubmissionOfDraftDocuments = _project!.submissionAndContacts!.dateOfSubmissionOfDraftDocuments;
        _dateOfSubmissionOfFinalDocuments = _project!.submissionAndContacts!.dateOfSubmissionOfFinalDocuments;
      }
      
      // Step 9 - Notes
      if (_project!.projectNotes != null) {
        _notes = _project!.projectNotes!.notes ?? '';
      }

      // Project Status stage
      _projectStage = _project!.projectStage;
    }
  }
  
  // Save the whole form in one go (the wizard's per-step saving was
  // collapsed into a single long form at the client's request).
  Future<void> saveProject() async {
    try {
      setBusy(true);

      final overview = ProjectOverview(
        title: _projectTitle,
        code: _projectCode,
        departmentReferenceNumber: _departmentReferenceNumber,
        propertyNameAddressFarmNo: _propertyNameAddressFarmNo,
      );
      final projectDescription = ProjectDescription(
        applicationType: _applicationType,
        projectDescription: _projectDescription,
      );
      final environmentalDetails = EnvironmentalDetails(
        relevantListingNotice: _relevantListingNotice,
        currentPropertyZoning: _currentPropertyZoning,
        propertySize: _propertySize,
        existingServicesOnSite: _existingServicesOnSite,
        plannedServicesWater: _plannedServicesWater,
        plannedServicesElectricity: _plannedServicesElectricity,
        plannedServicesSanitation: _plannedServicesSanitation,
      );
      final eiaTeamAndStudies = EiaTeamAndStudies(
        eiaProjectTeam: _eiaProjectTeam,
        specialistStudiesRequired: _specialistStudiesRequired,
        specialistStudiesCompleted: _specialistStudiesCompleted,
      );
      final publicReviewPeriods = PublicReviewPeriods(
        publicReviewPeriod1StartDate: _publicReviewPeriod1StartDate,
        publicReviewPeriod1EndDate: _publicReviewPeriod1EndDate,
        publicReviewPeriod1Duration: _publicReviewPeriod1Duration,
        publicReviewPeriod2StartDate: _publicReviewPeriod2StartDate,
        publicReviewPeriod2EndDate: _publicReviewPeriod2EndDate,
        publicReviewPeriod2Duration: _publicReviewPeriod2Duration,
      );
      final submissionAndContacts = SubmissionAndContacts(
        relevantEnvironmentalAffairsOffice: _relevantEnvironmentalAffairsOffice,
        environmentalAffairsContacts: _environmentalAffairsContacts,
        dateOfPreapplicationMeeting: _dateOfPreapplicationMeeting,
        dateOfSubmissionOfApplication: _dateOfSubmissionOfApplication,
        dateOfSubmissionOfDraftDocuments: _dateOfSubmissionOfDraftDocuments,
        dateOfSubmissionOfFinalDocuments: _dateOfSubmissionOfFinalDocuments,
      );
      final projectNotes = ProjectNotes(notes: _notes);

      if (_projectId != null) {
        final existingProject = await _projectService.getProject(_projectId!);
        if (existingProject == null) {
          throw Exception(
              'Could not load this project — check your connection and try again');
        }

        final updatedLocation = existingProject.location.copyWith(
          province: _province,
          districtOrMetroMunicipality: _districtOrMetroMunicipality,
          localMunicipality: _localMunicipality,
        );
        final updatedApplicantLandowner =
            existingProject.applicantLandowner.copyWith(
          applicantName: _applicantName,
          applicantDetails: _applicantDetails,
          landowner: _landowner,
          landownerDetails: _landownerDetails,
        );

        final updatedProject = existingProject.copyWith(
          overview: overview,
          location: updatedLocation,
          applicantLandowner: updatedApplicantLandowner,
          projectDescription: projectDescription,
          environmentalDetails: environmentalDetails,
          eiaTeamAndStudies: eiaTeamAndStudies,
          publicReviewPeriods: publicReviewPeriods,
          submissionAndContacts: submissionAndContacts,
          projectNotes: projectNotes,
          projectStage: _projectStage,
          currentStep: 9,
          isComplete: true,
        );

        await _projectService.updateProject(updatedProject);
      } else {
        final location = LocationDetails(
          province: _province,
          districtOrMetroMunicipality: _districtOrMetroMunicipality,
          localMunicipality: _localMunicipality,
        );
        final applicantLandowner = ApplicantLandownerInfo(
          applicantName: _applicantName,
          applicantDetails: _applicantDetails,
          landowner: _landowner,
          landownerDetails: _landownerDetails,
        );

        final project = Project(
          overview: overview,
          location: location,
          applicantLandowner: applicantLandowner,
          projectDescription: projectDescription,
          environmentalDetails: environmentalDetails,
          eiaTeamAndStudies: eiaTeamAndStudies,
          publicReviewPeriods: publicReviewPeriods,
          submissionAndContacts: submissionAndContacts,
          projectNotes: projectNotes,
          projectStage: _projectStage,
          currentStep: 9,
          isComplete: true,
        );

        _projectId = await _projectService.createProject(project);
      }

      setBusy(false);
      _navigationService.pop(); // Return to projects list
    } catch (e) {
      setBusy(false);
      setError('Failed to save project: ${e.toString()}');
    }
  }

  // Return to the projects list
  void navigateBack() {
    _navigationService.pop();
  }
}
