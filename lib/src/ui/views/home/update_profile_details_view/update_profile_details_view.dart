import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:the_eap_app/src/core/arguments/arguments.dart';
import 'package:the_eap_app/src/core/view_models/view_models.dart';
import 'package:the_eap_app/src/ui/shared/widgets/widgets.dart';
import 'package:the_eap_app/src/ui/shared/theme.dart';

class UpdateProfileDetailsView extends StatelessWidget {
  final UpdateProfileDetailsArguments arguments;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  UpdateProfileDetailsView({required this.arguments});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<UpdateProfileDetailsViewModel>.reactive(
        viewModelBuilder: () => UpdateProfileDetailsViewModel(),
        onViewModelReady: (UpdateProfileDetailsViewModel model) {
          model.init(arguments.user!);
          _firstNameController.text = arguments.user!.details!.firstName ?? '';
          _lastNameController.text = arguments.user!.details!.lastName ?? '';
          _dateController.text = arguments.user!.details!.dateOfBirth != null
              ? DateFormat('d MMMM yyyy')
                  .format(arguments.user!.details!.dateOfBirth!.toDate())
              : '';
        },
        builder: (BuildContext context, UpdateProfileDetailsViewModel model,
            Widget? child) {
          return Scaffold(
            appBar: DefaultAppBar(
              title: 'Update Profile Details',
            ),
            body: BackgroundContainer(
              background: 'background-2',
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        SizedBox(height: 20),
                        TextInputField(
                          controller: _firstNameController,
                          label: 'Firstname',
                          hintText: 'Enter your first name',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your first name';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        TextInputField(
                          controller: _lastNameController,
                          label: 'Lastname',
                          hintText: 'Enter your last name',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your last name';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        DateInputField(
                          controller: _dateController,
                          label: 'Date of Birth',
                          hintText: 'Select a date',
                          validator: null,
                        ),
                        SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: model.isBusy
                              ? null
                              : () async {
                                  if (_formKey.currentState!.validate()) {
                                    await model.updateUser(
                                        _firstNameController.text,
                                        _lastNameController.text,
                                        _dateController.text);
                                    Navigator.pop(context);
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 16),
                            minimumSize: Size(double.infinity, 50),
                            backgroundColor: AppTheme.themeData.primaryColor,
                          ),
                          child: model.isBusy
                              ? SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        AppTheme.themeData.primaryColorLight),
                                  ),
                                )
                              : Text(
                                  'Save',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          AppTheme.themeData.primaryColorLight),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
