import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:the_eap_app/src/core/view_models/network/add_contact_view_model.dart';
import 'package:the_eap_app/src/ui/shared/widgets/widgets.dart';

class AddContactView extends StatefulWidget {
  @override
  _AddContactViewState createState() => _AddContactViewState();
}

class _AddContactViewState extends State<AddContactView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _organisationController = TextEditingController();
  final _phoneNumber1Controller = TextEditingController();
  final _phoneNumber2Controller = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _organisationController.dispose();
    _phoneNumber1Controller.dispose();
    _phoneNumber2Controller.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AddContactViewModel>.reactive(
      viewModelBuilder: () => AddContactViewModel(),
      builder: (context, model, child) => Scaffold(
        appBar: DefaultAppBar(
          title: 'New Contact',
        ),
        backgroundColor: Colors.white,
        body: BackgroundContainer(
          background: 'background-3',
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextInputField(
                      controller: _nameController,
                      label: 'Name',
                      hintText: 'Enter contact name',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextInputField(
                      controller: _organisationController,
                      label: 'Organisation',
                      hintText: 'Enter organisation name',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an organisation';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextInputField(
                      controller: _phoneNumber1Controller,
                      label: 'Primary Phone',
                      hintText: 'Enter primary phone number',
                      keyboardType: TextInputType.phone,
                    ),
                    SizedBox(height: 16),
                    TextInputField(
                      controller: _phoneNumber2Controller,
                      label: 'Secondary Phone',
                      hintText: 'Enter secondary phone number',
                      keyboardType: TextInputType.phone,
                    ),
                    SizedBox(height: 16),
                    TextInputField(
                      controller: _emailController,
                      label: 'Email',
                      hintText: 'Enter email address',
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value != null && value.isNotEmpty) {
                          final emailRegex = RegExp(
                              r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                          if (!emailRegex.hasMatch(value)) {
                            return 'Please enter a valid email address';
                          }
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextInputField(
                      controller: _addressController,
                      label: 'Physical Address',
                      hintText: 'Enter physical address',
                      maxLines: 3,
                    ),
                    SizedBox(height: 16),
                    TextInputField(
                      controller: _notesController,
                      label: 'Notes',
                      hintText: 'Enter any additional notes',
                      maxLines: 5,
                    ),
                    SizedBox(height: 24),
                    Container(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: model.isBusy
                            ? null
                            : () async {
                                if (_formKey.currentState!.validate()) {
                                  try {
                                    await model.createContact(
                                      name: _nameController.text,
                                      organisation:
                                          _organisationController.text,
                                      phoneNumber1:
                                          _phoneNumber1Controller.text.isEmpty
                                              ? null
                                              : _phoneNumber1Controller.text,
                                      phoneNumber2:
                                          _phoneNumber2Controller.text.isEmpty
                                              ? null
                                              : _phoneNumber2Controller.text,
                                      emailAddress:
                                          _emailController.text.isEmpty
                                              ? null
                                              : _emailController.text,
                                      physicalAddress:
                                          _addressController.text.isEmpty
                                              ? null
                                              : _addressController.text,
                                      notes: _notesController.text.isEmpty
                                          ? null
                                          : _notesController.text,
                                    );
                                    Navigator.pop(context);
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content:
                                            Text('Failed to create contact'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
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
                        child: model.isBusy
                            ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            : Text(
                                'Create Contact',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
