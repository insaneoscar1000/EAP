import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stacked/stacked.dart';
import 'package:the_eap_app/src/core/constants/route_constants.dart';
import 'package:the_eap_app/src/core/models/models.dart';
import 'package:the_eap_app/src/core/services/services.dart';
import 'package:the_eap_app/src/locator.dart';

class IAPDatabaseViewModel extends StreamViewModel<List<IAP>> {
  final NavigationService _navigationService = locator<NavigationService>();
  final IAPService _iapService = locator<IAPService>();
  final DialogService _dialogService = locator<DialogService>();
  final ProjectService _projectService = locator<ProjectService>();

  String _projectId = '';
  String get projectId => _projectId;
  String _projectName = '';
  String get projectName => _projectName;

  // Search functionality
  String _searchQuery = '';
  String get searchQuery => _searchQuery;
  List<IAP> _filteredIAPs = [];
  List<IAP> get filteredIAPs => _filteredIAPs;

  // Editing functionality
  IAP? _editingIAP;
  IAP? get editingIAP => _editingIAP;
  DateTime? get correspondenceDate => _correspondenceDate;

  // Form fields
  String _name = '';
  String _organization = '';
  String _email = '';
  String _phone = '';
  String _contactNumber2 = '';
  String _address = '';
  String _comments = '';
  DateTime? _correspondenceDate;
  String _issueRaised = '';
  String _eapResponse = '';

  void setProjectId(String id) async {
    print('IAPDatabaseViewModel.setProjectId called with id: "$id"');
    if (id.isEmpty) {
      print('WARNING: Empty projectId passed to IAPDatabaseViewModel.setProjectId');
      return;
    }
    
    _projectId = id;
    print('Setting _projectId to: "$_projectId"');
    
    // Get project name
    try {
      print('Attempting to fetch project details for id: "$id"');
      final project = await _projectService.getProject(id);
      if (project != null) {
        _projectName = project.overview.title;
        print('Project found, title: "${_projectName}"');
      } else {
        print('No project found with id: "$id"');
      }
    } catch (e) {
      print('Error fetching project: ${e.toString()}');
    }
    
    // Force a refresh of the stream
    initialise();
    notifyListeners();
  }

  void setEditingIAP(IAP iap) {
    _editingIAP = iap;
    _name = iap.name;
    _organization = iap.organization ?? '';
    _email = iap.email ?? '';
    _phone = iap.phone ?? '';
    _contactNumber2 = iap.contactNumber2 ?? '';
    _address = iap.address ?? '';
    _comments = iap.comments ?? '';
    _correspondenceDate = iap.correspondenceDate != null
        ? (iap.correspondenceDate is Timestamp
            ? (iap.correspondenceDate as Timestamp).toDate()
            : null)
        : null;
    _issueRaised = iap.issueRaised ?? '';
    _eapResponse = iap.eapResponse ?? '';
    notifyListeners();
  }

  // Form field setters
  void setName(String value) {
    _name = value;
    notifyListeners();
  }

  void setOrganization(String value) {
    _organization = value;
    notifyListeners();
  }

  void setEmail(String value) {
    _email = value;
    notifyListeners();
  }

  void setPhone(String value) {
    _phone = value;
    notifyListeners();
  }

  void setContactNumber2(String value) {
    _contactNumber2 = value;
    notifyListeners();
  }

  void setAddress(String value) {
    _address = value;
    notifyListeners();
  }

  void setComments(String value) {
    _comments = value;
    notifyListeners();
  }

  void setCorrespondenceDate(DateTime? value) {
    _correspondenceDate = value;
    notifyListeners();
  }

  void setIssueRaised(String value) {
    _issueRaised = value;
    notifyListeners();
  }

  void setEAPResponse(String value) {
    _eapResponse = value;
    notifyListeners();
  }

  @override
  Stream<List<IAP>> get stream => _iapService.getIAPsForProject(_projectId);
  
  // Method to force a refresh of the data
  Future<void> refreshData() async {
    print('Refreshing IAP data for project: $_projectId');
    // Set busy to true to show loading indicator
    setBusy(true);
    // Short delay to ensure Firestore has the latest data
    await Future.delayed(Duration(milliseconds: 500));
    // Manually trigger a reload of the stream
    initialise();
    // Set busy to false after data is loaded
    setBusy(false);
  }

  @override
  void onData(List<IAP>? data) {
    print('IAPDatabaseViewModel received data: ${data?.length ?? 0} IAPs');
    if (data != null) {
      for (var iap in data) {
        print(
            'IAP in data: ID=${iap.id}, Name=${iap.name}, ProjectID=${iap.projectId}');
      }
    }
    super.onData(data);
    _applySearch();
    notifyListeners(); // Ensure UI updates
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _applySearch();
    notifyListeners();
  }

  void _applySearch() {
    if (_searchQuery.isEmpty) {
      _filteredIAPs = data ?? [];
      print(
          '_applySearch: No search query, showing all ${_filteredIAPs.length} IAPs');
    } else {
      final query = _searchQuery.toLowerCase();
      _filteredIAPs = (data ?? []).where((iap) {
        final matches = iap.name.toLowerCase().contains(query) ||
            (iap.organization?.toLowerCase().contains(query) ?? false) ||
            (iap.email?.toLowerCase().contains(query) ?? false);
        return matches;
      }).toList();
      print(
          '_applySearch: With search query "$_searchQuery", showing ${_filteredIAPs.length} IAPs');
    }

    // Debug print all filtered IAPs
    for (var iap in _filteredIAPs) {
      print(
          'Filtered IAP: ID=${iap.id}, Name=${iap.name}, ProjectID=${iap.projectId}');
    }
  }

  void navigateToAddIAP() {
    _navigationService.navigateTo(
      RoutePaths.addIapEntry,
      arguments: {
        'projectId': _projectId,
        'projectName': _projectName,
      },
    );
  }

  void navigateToEditIAP(IAP iap) {
    _navigationService.navigateTo(
      RoutePaths.editIapEntry,
      arguments: {
        'projectId': _projectId,
        'projectName': _projectName,
        'iap': iap,
      },
    );
  }

  Future<bool> validateFields() async {
    // Validate all required fields
    if (_name.isEmpty) {
      return false;
    }

    if (_organization.isEmpty) {
      return false;
    }

    if (_email.isEmpty) {
      return false;
    }

    if (_phone.isEmpty) {
      return false;
    }

    if (_correspondenceDate == null) {
      return false;
    }

    if (_issueRaised.isEmpty) {
      return false;
    }

    if (_eapResponse.isEmpty) {
      return false;
    }

    return true;
  }

  String? getValidationError() {
    if (_name.isEmpty) {
      return 'I&AP Name is required';
    }

    if (_organization.isEmpty) {
      return 'I&AP Organization is required';
    }

    return null;
  }

  Future<bool> saveIAP() async {
    // Check for validation errors
    String? validationError = getValidationError();
    if (validationError != null) {
      notifyListeners();
      return false;
    }

    try {
      setBusy(true);

      // Check if correspondence date is set
      if (_correspondenceDate == null) {
        print('Error: Correspondence date is null');
        setBusy(false);
        return false;
      }

      final iap = IAP(
        id: _editingIAP?.id,
        projectId: _projectId,
        name: _name,
        organization: _organization,
        email: _email,
        phone: _phone,
        contactNumber2: _contactNumber2.isNotEmpty ? _contactNumber2 : null,
        address: _address.isNotEmpty ? _address : null,
        comments: _comments.isNotEmpty ? _comments : null,
        correspondenceDate: Timestamp.fromDate(_correspondenceDate!),
        issueRaised: _issueRaised,
        eapResponse: _eapResponse,
        createdAt: _editingIAP?.createdAt ?? Timestamp.now(),
      );

      if (_editingIAP != null) {
        await _iapService.updateIAP(iap);
      } else {
        await _iapService.createIAP(iap);
      }

      // No need to manually refresh; StreamViewModel will update automatically
      // Just reset the form state
      _editingIAP = null;
      _name = '';
      _organization = '';
      _email = '';
      _phone = '';
      _contactNumber2 = '';
      _address = '';
      _comments = '';
      _correspondenceDate = null;
      _issueRaised = '';
      _eapResponse = '';

      setBusy(false);
      notifyListeners();
      return true;
    } catch (e) {
      print('Error saving IAP: ${e.toString()}');
      print('Stack trace: ${StackTrace.current}');
      setBusy(false);
      return false;
    }
  }

  Future<void> deleteIAP(String iapId) async {
    try {
      final result = await _dialogService.showConfirmationDialog(
        title: 'Delete I&AP',
        description: 'Are you sure you want to delete this I&AP?',
        confirmationTitle: 'Delete',
        cancelTitle: 'Cancel',
      );

      if (result?.confirmed ?? false) {
        setBusy(true);
        await _iapService.deleteIAP(iapId);
        setBusy(false);
      }
    } catch (e) {
      setBusy(false);
      _dialogService.showDialog(
        title: 'Error',
        description: 'Failed to delete I&AP: ${e.toString()}',
      );
    }
  }

  void navigateBack() {
    _navigationService.pop();
  }
}
