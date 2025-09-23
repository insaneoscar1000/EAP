import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:the_eap_app/src/core/models/models.dart';
import 'package:the_eap_app/src/core/view_models/projects/iap_database_view_model.dart';
import 'package:the_eap_app/src/ui/shared/widgets/widgets.dart';

class AddIAPEntryView extends StatefulWidget {
  final String projectId;
  final String projectName;
  final IAP? iap;
  final VoidCallback? onSave;

  const AddIAPEntryView({
    super.key,
    required this.projectId,
    required this.projectName,
    this.iap,
    this.onSave,
  });

  @override
  _AddIAPEntryViewState createState() => _AddIAPEntryViewState();
}

class _AddIAPEntryViewState extends State<AddIAPEntryView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<IAPDatabaseViewModel>.reactive(
      onViewModelReady: (IAPDatabaseViewModel model) {
        model.setProjectId(widget.projectId);
        if (widget.iap != null) {
          model.setEditingIAP(widget.iap!);
        } else {
          // Set default correspondence date for new entries as empty string
          model.setCorrespondenceDate('');
        }
      },
      viewModelBuilder: () => IAPDatabaseViewModel(),
      builder:
          (BuildContext context, IAPDatabaseViewModel model, Widget? child) =>
              Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            widget.iap == null ? 'I&AP Add Entry' : 'Edit I&AP Entry',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.chevron_left,
                size: 34, color: Theme.of(context).primaryColorLight),
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: BackgroundContainer(
          background: 'background-1',
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 16),
                  _buildProjectName(context, widget.projectName),
                  const SizedBox(height: 16),
                  _buildIAPNameField(context, model),
                  const SizedBox(height: 16),
                  _buildIAPOrganizationField(context, model),
                  const SizedBox(height: 16),
                  _buildIAPEmailField(context, model),
                  const SizedBox(height: 16),
                  _buildIAPPhoneField(context, model),
                  const SizedBox(height: 16),
                  _buildIAPContactNumber2Field(context, model),
                  const SizedBox(height: 16),
                  _buildCorrespondenceDateField(context, model),
                  const SizedBox(height: 16),
                  _buildIssueRaisedField(context, model),
                  const SizedBox(height: 16),
                  _buildEAPResponseField(context, model),
                  const SizedBox(height: 24),
                  _buildAddEntryButton(context, model),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to build consistent form fields
  Widget _buildFormField({
    required String label,
    required String hintText,
    required Function(String) onChanged,
    String? initialValue,
    int maxLines = 1,
    bool isRequired = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            if (isRequired)
              Text(
                ' *',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.red,
                ),
              ),
          ],
        ),
        SizedBox(height: 8),
        TextFormField(
          initialValue: initialValue,
          maxLines: maxLines,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              color: Colors.grey[400],
            ),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Colors.grey[300]!,
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Colors.grey[300]!,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Colors.grey[400]!,
                width: 1,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildProjectName(BuildContext context, String projectName) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        projectName,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  Widget _buildIAPNameField(BuildContext context, IAPDatabaseViewModel model) {
    return _buildFormField(
      label: 'Name',
      hintText: 'Start typing...',
      initialValue: model.editingIAP?.name,
      onChanged: model.setName,
      isRequired: true,
    );
  }

  Widget _buildIAPOrganizationField(
      BuildContext context, IAPDatabaseViewModel model) {
    return _buildFormField(
      label: 'Organization',
      hintText: 'Start typing...',
      initialValue: model.editingIAP?.organization,
      onChanged: model.setOrganization,
      isRequired: true,
    );
  }

  Widget _buildIAPEmailField(BuildContext context, IAPDatabaseViewModel model) {
    return _buildFormField(
      label: 'Email Address',
      hintText: 'Start typing...',
      initialValue: model.editingIAP?.email,
      onChanged: model.setEmail,
      keyboardType: TextInputType.emailAddress,
    );
  }

  Widget _buildIAPPhoneField(BuildContext context, IAPDatabaseViewModel model) {
    return _buildFormField(
      label: 'Contact Number',
      hintText: 'Start typing...',
      initialValue: model.editingIAP?.phone,
      onChanged: model.setPhone,
      keyboardType: TextInputType.phone,
    );
  }

  Widget _buildIAPContactNumber2Field(
      BuildContext context, IAPDatabaseViewModel model) {
    return _buildFormField(
      label: 'Contact Number 2',
      hintText: 'Start typing...',
      initialValue: model.editingIAP?.contactNumber2,
      onChanged: model.setContactNumber2,
      keyboardType: TextInputType.phone,
    );
  }

  Widget _buildCorrespondenceDateField(
      BuildContext context, IAPDatabaseViewModel model) {
    return _buildFormField(
      label: 'Correspondence & Date Sent',
      hintText: 'e.g., 12/05/2025 or May 12, 2025',
      initialValue: model.correspondenceDate,
      onChanged: model.setCorrespondenceDate,
      isRequired: false,
    );
  }

  Widget _buildIssueRaisedField(
      BuildContext context, IAPDatabaseViewModel model) {
    return _buildFormField(
      label: 'Issue Raised',
      hintText: 'Start typing...',
      initialValue: model.editingIAP?.issueRaised,
      onChanged: model.setIssueRaised,
      maxLines: 3,
      isRequired: false,
    );
  }

  Widget _buildEAPResponseField(
      BuildContext context, IAPDatabaseViewModel model) {
    return _buildFormField(
      label: 'EAP\'s Response',
      hintText: 'Start typing...',
      initialValue: model.editingIAP?.eapResponse,
      onChanged: model.setEAPResponse,
      maxLines: 3,
      isRequired: false,
    );
  }

  Widget _buildAddEntryButton(
      BuildContext context, IAPDatabaseViewModel model) {
    return Column(
      children: <Widget>[
        // Show validation error if any
        if (model.getValidationError() != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Text(
                model.getValidationError()!,
                style: TextStyle(
                  color: Colors.red.shade900,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () async {
              // Show validation in UI first
              if (model.getValidationError() != null) {
                model.notifyListeners();
                return;
              }

              // Show a loading indicator
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return Dialog(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          CircularProgressIndicator(),
                          SizedBox(width: 20),
                          Text('Saving I&AP entry...'),
                        ],
                      ),
                    ),
                  );
                },
              );

              // If validation passes, save the IAP
              bool success = await model.saveIAP();

              // Close the loading dialog
              Navigator.of(context).pop();

              if (success) {
                // Show success message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(model.editingIAP != null
                        ? 'I&AP updated successfully'
                        : 'I&AP added successfully'),
                    backgroundColor: Colors.green,
                  ),
                );

                // Just pop without a result
                Navigator.of(context).pop();

                // Call the onSave callback if provided
                if (widget.onSave != null) {
                  widget.onSave!();
                }
              } else {
                // Show error dialog if save failed
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'Failed to save I&AP entry. Please check all fields and try again.'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: Text(
              widget.iap == null ? 'Add Entry' : 'Update Entry',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
