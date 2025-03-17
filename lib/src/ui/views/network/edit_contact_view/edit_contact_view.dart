import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:stacked/stacked.dart';
import 'package:the_eap_app/src/core/models/contact.dart';
import 'package:the_eap_app/src/core/view_models/network/edit_contact_view_model.dart';
import 'package:the_eap_app/src/ui/shared/widgets/widgets.dart';

class EditContactView extends StatefulWidget {
  final Contact contact;

  const EditContactView({Key? key, required this.contact}) : super(key: key);

  @override
  _EditContactViewState createState() => _EditContactViewState();
}

class _EditContactViewState extends State<EditContactView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _organisationController;
  late final TextEditingController _phoneNumber1Controller;
  late final TextEditingController _phoneNumber2Controller;
  late final TextEditingController _emailController;
  late final TextEditingController _addressController;
  late final TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.contact.name);
    _organisationController =
        TextEditingController(text: widget.contact.organisation);
    _phoneNumber1Controller =
        TextEditingController(text: widget.contact.phoneNumber1 ?? '');
    _phoneNumber2Controller =
        TextEditingController(text: widget.contact.phoneNumber2 ?? '');
    _emailController =
        TextEditingController(text: widget.contact.emailAddress ?? '');
    _addressController =
        TextEditingController(text: widget.contact.physicalAddress ?? '');
    _notesController = TextEditingController(text: widget.contact.notes ?? '');
  }

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
    return ViewModelBuilder<EditContactViewModel>.reactive(
      viewModelBuilder: () => EditContactViewModel(),
      builder: (context, model, child) => Scaffold(
        appBar: DefaultAppBar(
          title: 'Edit Contact',
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
                                    final updatedContact = Contact(
                                      id: widget.contact.id!,
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

                                    await model.updateContact(
                                      id: updatedContact.id!,
                                      name: updatedContact.name,
                                      organisation: updatedContact.organisation,
                                      phoneNumber1: updatedContact.phoneNumber1,
                                      phoneNumber2: updatedContact.phoneNumber2,
                                      emailAddress: updatedContact.emailAddress,
                                      physicalAddress:
                                          updatedContact.physicalAddress,
                                      notes: updatedContact.notes,
                                    );

                                    Navigator.pop(context, updatedContact);
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content:
                                            Text('Failed to update contact'),
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(IconsaxPlusBold.edit),
                            SizedBox(width: 10),
                            Text(
                              'Save Changes',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
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
