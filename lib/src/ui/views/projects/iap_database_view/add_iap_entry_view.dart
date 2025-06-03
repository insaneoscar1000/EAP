import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:the_eap_app/src/core/models/models.dart';
import 'package:the_eap_app/src/core/view_models/projects/iap_database_view_model.dart';
import 'package:the_eap_app/src/ui/shared/widgets/widgets.dart';
import 'package:intl/intl.dart';

class AddIAPEntryView extends StatefulWidget {
  final String projectId;
  final String projectName;
  final IAP? iap;

  const AddIAPEntryView({
    Key? key,
    required this.projectId,
    required this.projectName,
    this.iap,
  }) : super(key: key);

  @override
  _AddIAPEntryViewState createState() => _AddIAPEntryViewState();
}

class _AddIAPEntryViewState extends State<AddIAPEntryView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<IAPDatabaseViewModel>.reactive(
      onViewModelReady: (model) {
        model.setProjectId(widget.projectId);
        if (widget.iap != null) {
          model.setEditingIAP(widget.iap!);
        } else {
          // Set default correspondence date for new entries
          model.setCorrespondenceDate(DateTime.now());
        }
      },
      viewModelBuilder: () => IAPDatabaseViewModel(),
      builder: (context, model, child) => Scaffold(
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
                children: [
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
      children: [
        Row(
          children: [
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Project Name',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Text(
            projectName,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildIAPNameField(BuildContext context, IAPDatabaseViewModel model) {
    return _buildFormField(
      label: 'I&AP Name',
      hintText: 'Start typing...',
      initialValue: model.editingIAP?.name,
      onChanged: model.setName,
      isRequired: true,
    );
  }

  Widget _buildIAPOrganizationField(
      BuildContext context, IAPDatabaseViewModel model) {
    return _buildFormField(
      label: 'I&AP Organization',
      hintText: 'Start typing...',
      initialValue: model.editingIAP?.organization,
      onChanged: model.setOrganization,
      isRequired: true,
    );
  }

  Widget _buildIAPEmailField(BuildContext context, IAPDatabaseViewModel model) {
    return _buildFormField(
      label: 'I&AP Email Address',
      hintText: 'Start typing...',
      initialValue: model.editingIAP?.email,
      onChanged: model.setEmail,
      keyboardType: TextInputType.emailAddress,
    );
  }

  Widget _buildIAPPhoneField(BuildContext context, IAPDatabaseViewModel model) {
    return _buildFormField(
      label: 'I&AP Contact Number',
      hintText: 'Start typing...',
      initialValue: model.editingIAP?.phone,
      onChanged: model.setPhone,
      keyboardType: TextInputType.phone,
    );
  }

  Widget _buildIAPContactNumber2Field(
      BuildContext context, IAPDatabaseViewModel model) {
    return _buildFormField(
      label: 'I&AP Contact Number 2',
      hintText: 'Start typing...',
      initialValue: model.editingIAP?.contactNumber2,
      onChanged: model.setContactNumber2,
      keyboardType: TextInputType.phone,
    );
  }

  Widget _buildCorrespondenceDateField(
      BuildContext context, IAPDatabaseViewModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Correspondence & Date Sent',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
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
        InkWell(
          onTap: () async {
            final DateTime? picked = await showDatePicker(
              context: context,
              initialDate: model.correspondenceDate ?? DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );
            if (picked != null) {
              model.setCorrespondenceDate(picked);
              model.notifyListeners(); // Ensure UI updates
            }
          },
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  model.correspondenceDate != null
                      ? DateFormat('dd/MM/yyyy')
                          .format(model.correspondenceDate!)
                      : 'Select a date',
                  style: TextStyle(
                    color: model.correspondenceDate != null
                        ? Colors.black
                        : Colors.grey[400],
                    fontSize: 16,
                  ),
                ),
                Icon(Icons.calendar_today, color: Colors.grey),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildIssueRaisedField(
      BuildContext context, IAPDatabaseViewModel model) {
    return _buildFormField(
      label: 'Correspondence & Issue Raised',
      hintText: 'Start typing...',
      initialValue: model.editingIAP?.issueRaised,
      onChanged: model.setIssueRaised,
      maxLines: 3,
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
    );
  }

  Widget _buildAddEntryButton(
      BuildContext context, IAPDatabaseViewModel model) {
    return Column(
      children: [
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
        Container(
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
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(width: 20),
                          Text("Saving I&AP entry..."),
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
                // The StreamViewModel will update the main list automatically
                // Just pop this view/dialog
                Navigator.of(context).pop();
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
