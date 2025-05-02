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
  
  // Current step in the wizard
  int _currentStep = 1;
  int get currentStep => _currentStep;
  
  // Total number of steps in the wizard
  final int _totalSteps = 9;
  int get totalSteps => _totalSteps;
  
  // Progress percentage
  double get progress => (_currentStep / _totalSteps) * 100;
  
  // Whether the user can continue to the next step
  bool get canContinue => !isBusy && validateCurrentStep();
  
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
        // Set the current step from the project
        _currentStep = _project!.currentStep;
        
        // Load data for the current step
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
    }
  }
  
  // Validate the current step
  bool validateCurrentStep() {
    switch (_currentStep) {
      case 1:
        return _projectTitle.isNotEmpty && 
               _projectCode.isNotEmpty && 
               _departmentReferenceNumber.isNotEmpty && 
               _propertyNameAddressFarmNo.isNotEmpty;
      case 2:
        return _province.isNotEmpty && 
               _districtOrMetroMunicipality.isNotEmpty && 
               _localMunicipality.isNotEmpty;
      case 3:
        return _applicantName.isNotEmpty && 
               _applicantDetails.isNotEmpty && 
               _landowner.isNotEmpty && 
               _landownerDetails.isNotEmpty;
      case 4:
        return _applicationType.isNotEmpty && 
               _projectDescription.isNotEmpty;
      case 5:
        return _relevantListingNotice.isNotEmpty && 
               _currentPropertyZoning.isNotEmpty && 
               _propertySize.isNotEmpty && 
               _existingServicesOnSite.isNotEmpty && 
               _plannedServicesWater.isNotEmpty && 
               _plannedServicesElectricity.isNotEmpty && 
               _plannedServicesSanitation.isNotEmpty;
      case 6:
        return _eiaProjectTeam.isNotEmpty && 
               _specialistStudiesRequired.isNotEmpty && 
               _specialistStudiesCompleted.isNotEmpty;
      case 7:
        return _publicReviewPeriod1StartDate != null && 
               _publicReviewPeriod1EndDate != null && 
               _publicReviewPeriod1Duration > 0 && 
               _publicReviewPeriod2StartDate != null && 
               _publicReviewPeriod2EndDate != null && 
               _publicReviewPeriod2Duration > 0;
      case 8:
        return _relevantEnvironmentalAffairsOffice.isNotEmpty && 
               _environmentalAffairsContacts.isNotEmpty && 
               _dateOfPreapplicationMeeting != null && 
               _dateOfSubmissionOfApplication != null && 
               _dateOfSubmissionOfDraftDocuments != null && 
               _dateOfSubmissionOfFinalDocuments != null;
      case 9:
        return _notes.isNotEmpty; // Notes are now required
      default:
        return true;
    }
  }
  
  // Save the current step and continue to the next step
  Future<void> saveAndContinue() async {
    if (!validateCurrentStep()) {
      setError('Please fill in all required fields');
      return;
    }
    
    try {
      setBusy(true);
      
      // Create or update the project based on the current step
      if (_currentStep == 1) {
        // Create the project overview data
        final projectOverview = ProjectOverview(
          title: _projectTitle,
          code: _projectCode,
          departmentReferenceNumber: _departmentReferenceNumber,
          propertyNameAddressFarmNo: _propertyNameAddressFarmNo,
        );
        
        // Check if we're editing an existing project or creating a new one
        if (_projectId != null) {
          // Get the existing project
          final existingProject = await _projectService.getProject(_projectId!);
          
          if (existingProject != null) {
            // Update the project with step 1 data
            final updatedProject = existingProject.copyWith(
              overview: projectOverview,
              currentStep: _currentStep,
            );
            
            // Save the updated project
            await _projectService.updateProject(updatedProject);
          } else {
            throw Exception('Project not found');
          }
        } else {
          // Create empty location and applicant details for new project
          final locationDetails = LocationDetails();
          final applicantLandowner = ApplicantLandownerInfo();
          
          final project = Project(
            overview: projectOverview,
            location: locationDetails,
            applicantLandowner: applicantLandowner,
            currentStep: _currentStep,
          );
          
          // Save the project and get the ID
          _projectId = await _projectService.createProject(project);
        }
        
        // Move to the next step
        _currentStep++;
      } else if (_currentStep == 2) {
        // Get the existing project
        if (_projectId != null) {
          final existingProject = await _projectService.getProject(_projectId!);
          
          if (existingProject != null) {
            // Create updated location details
            final updatedLocation = existingProject.location.copyWith(
              province: _province,
              districtOrMetroMunicipality: _districtOrMetroMunicipality,
              localMunicipality: _localMunicipality,
            );
            
            // Update the project with step 2 data
            final updatedProject = existingProject.copyWith(
              location: updatedLocation,
              currentStep: _currentStep,
            );
            
            // Save the updated project
            await _projectService.updateProject(updatedProject);
            
            // Move to the next step
            _currentStep++;
          }
        } else {
          throw Exception('Project ID is missing');
        }
      } else if (_currentStep == 3) {
        // Get the existing project
        if (_projectId != null) {
          final existingProject = await _projectService.getProject(_projectId!);
          
          if (existingProject != null) {
            // Create updated applicant and landowner info
            final updatedApplicantLandowner = existingProject.applicantLandowner.copyWith(
              applicantName: _applicantName,
              applicantDetails: _applicantDetails,
              landowner: _landowner,
              landownerDetails: _landownerDetails,
            );
            
            // Update the project with step 3 data
            final updatedProject = existingProject.copyWith(
              applicantLandowner: updatedApplicantLandowner,
              currentStep: _currentStep,
            );
            
            // Save the updated project
            await _projectService.updateProject(updatedProject);
            
            // Move to the next step
            _currentStep++;
          }
        } else {
          throw Exception('Project ID is missing');
        }
      } else if (_currentStep == 4) {
        // Get the existing project
        if (_projectId != null) {
          final existingProject = await _projectService.getProject(_projectId!);
          
          if (existingProject != null) {
            // Create updated project description
            final updatedProjectDescription = ProjectDescription(
              applicationType: _applicationType,
              projectDescription: _projectDescription,
            );
            
            // Update the project with step 4 data
            final updatedProject = existingProject.copyWith(
              projectDescription: updatedProjectDescription,
              currentStep: _currentStep,
            );
            
            // Save the updated project
            await _projectService.updateProject(updatedProject);
            
            // Move to the next step
            _currentStep++;
          }
        } else {
          throw Exception('Project ID is missing');
        }
      } else if (_currentStep == 5) {
        // Get the existing project
        if (_projectId != null) {
          final existingProject = await _projectService.getProject(_projectId!);
          
          if (existingProject != null) {
            // Create updated environmental details
            final updatedEnvironmentalDetails = EnvironmentalDetails(
              relevantListingNotice: _relevantListingNotice,
              currentPropertyZoning: _currentPropertyZoning,
              propertySize: _propertySize,
              existingServicesOnSite: _existingServicesOnSite,
              plannedServicesWater: _plannedServicesWater,
              plannedServicesElectricity: _plannedServicesElectricity,
              plannedServicesSanitation: _plannedServicesSanitation,
            );
            
            // Update the project with step 5 data
            final updatedProject = existingProject.copyWith(
              environmentalDetails: updatedEnvironmentalDetails,
              currentStep: _currentStep,
            );
            
            // Save the updated project
            await _projectService.updateProject(updatedProject);
            
            // Move to the next step
            _currentStep++;
          }
        } else {
          throw Exception('Project ID is missing');
        }
      } else if (_currentStep == 6) {
        // Get the existing project
        if (_projectId != null) {
          final existingProject = await _projectService.getProject(_projectId!);
          
          if (existingProject != null) {
            // Create updated EIA team and specialist studies
            final updatedEiaTeamAndStudies = EiaTeamAndStudies(
              eiaProjectTeam: _eiaProjectTeam,
              specialistStudiesRequired: _specialistStudiesRequired,
              specialistStudiesCompleted: _specialistStudiesCompleted,
            );
            
            // Update the project with step 6 data
            final updatedProject = existingProject.copyWith(
              eiaTeamAndStudies: updatedEiaTeamAndStudies,
              currentStep: _currentStep,
            );
            
            // Save the updated project
            await _projectService.updateProject(updatedProject);
            
            // Move to the next step
            _currentStep++;
          }
        } else {
          throw Exception('Project ID is missing');
        }
      } else if (_currentStep == 7) {
        // Get the existing project
        if (_projectId != null) {
          final existingProject = await _projectService.getProject(_projectId!);
          
          if (existingProject != null) {
            // Create updated public review periods
            final updatedPublicReviewPeriods = PublicReviewPeriods(
              publicReviewPeriod1StartDate: _publicReviewPeriod1StartDate,
              publicReviewPeriod1EndDate: _publicReviewPeriod1EndDate,
              publicReviewPeriod1Duration: _publicReviewPeriod1Duration,
              publicReviewPeriod2StartDate: _publicReviewPeriod2StartDate,
              publicReviewPeriod2EndDate: _publicReviewPeriod2EndDate,
              publicReviewPeriod2Duration: _publicReviewPeriod2Duration,
            );
            
            // Update the project with step 7 data
            final updatedProject = existingProject.copyWith(
              publicReviewPeriods: updatedPublicReviewPeriods,
              currentStep: _currentStep,
            );
            
            // Save the updated project
            await _projectService.updateProject(updatedProject);
            
            // Move to the next step
            _currentStep++;
          }
        } else {
          throw Exception('Project ID is missing');
        }
      } else if (_currentStep == 8) {
        // Get the existing project
        if (_projectId != null) {
          final existingProject = await _projectService.getProject(_projectId!);
          
          if (existingProject != null) {
            // Create updated submission and contacts
            final updatedSubmissionAndContacts = SubmissionAndContacts(
              relevantEnvironmentalAffairsOffice: _relevantEnvironmentalAffairsOffice,
              environmentalAffairsContacts: _environmentalAffairsContacts,
              dateOfPreapplicationMeeting: _dateOfPreapplicationMeeting,
              dateOfSubmissionOfApplication: _dateOfSubmissionOfApplication,
              dateOfSubmissionOfDraftDocuments: _dateOfSubmissionOfDraftDocuments,
              dateOfSubmissionOfFinalDocuments: _dateOfSubmissionOfFinalDocuments,
            );
            
            // Update the project with step 8 data
            final updatedProject = existingProject.copyWith(
              submissionAndContacts: updatedSubmissionAndContacts,
              currentStep: _currentStep,
            );
            
            // Save the updated project
            await _projectService.updateProject(updatedProject);
            
            // Move to the next step
            _currentStep++;
          }
        } else {
          throw Exception('Project ID is missing');
        }
      } else if (_currentStep == 9) {
        // Get the existing project
        if (_projectId != null) {
          final existingProject = await _projectService.getProject(_projectId!);
          
          if (existingProject != null) {
            // Create updated project notes
            final updatedProjectNotes = ProjectNotes(
              notes: _notes,
            );
            
            // Update the project with step 9 data
            final updatedProject = existingProject.copyWith(
              projectNotes: updatedProjectNotes,
              currentStep: _currentStep,
              isComplete: true,
            );
            
            // Save the updated project
            await _projectService.updateProject(updatedProject);
            
            // Complete the project
            await _projectService.completeProject(_projectId!);
            _navigationService.pop(); // Return to projects list
            return;
          }
        } else {
          throw Exception('Project ID is missing');
        }
      }
      
      setBusy(false);
      notifyListeners(); // Update the UI with the new step
      
    } catch (e) {
      setBusy(false);
      setError('Failed to save project: ${e.toString()}');
    }
  }
  
  // Navigate to the previous step or back to projects list
  void navigateBack() {
    if (_currentStep > 1) {
      _currentStep--;
      notifyListeners();
    } else {
      _navigationService.pop(); // Return to projects list
    }
  }
}
