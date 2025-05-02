import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:stacked/stacked.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:the_eap_app/src/core/models/models.dart';
import 'package:the_eap_app/src/core/view_models/network/contact_details_view_model.dart';
import 'package:the_eap_app/src/ui/shared/widgets/widgets.dart';
import 'package:the_eap_app/src/ui/views/network/edit_contact_view/edit_contact_view.dart';

class ContactDetailsView extends StatelessWidget {
  final Contact initialContact;

  const ContactDetailsView({Key? key, required this.initialContact})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ContactDetailsViewModel>.reactive(
        viewModelBuilder: () =>
            ContactDetailsViewModel()..setContact(initialContact),
        builder: (context, model, child) => Scaffold(
              appBar: DefaultAppBar(
                title: model.contact.name,
              ),
              backgroundColor: Colors.white,
              body: BackgroundContainer(
                background: 'background-3',
                child: Stack(children: [
                  SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInfoSection(
                            context,
                            'Organisation',
                            model.contact.organisation,
                            IconsaxPlusLinear.building,
                          ),
                          if (model.contact.phoneNumber1 != null)
                            _buildInfoSection(
                              context,
                              'Primary Phone',
                              model.contact.phoneNumber1!,
                              IconsaxPlusLinear.call,
                              isPhone: true,
                            ),
                          if (model.contact.phoneNumber2 != null)
                            _buildInfoSection(
                              context,
                              'Secondary Phone',
                              model.contact.phoneNumber2!,
                              IconsaxPlusLinear.call,
                              isPhone: true,
                            ),
                          if (model.contact.emailAddress != null)
                            _buildInfoSection(
                              context,
                              'Email',
                              model.contact.emailAddress!,
                              IconsaxPlusLinear.message,
                              isEmail: true,
                            ),
                          if (model.contact.physicalAddress != null)
                            _buildInfoSection(
                              context,
                              'Physical Address',
                              model.contact.physicalAddress!,
                              IconsaxPlusLinear.location,
                            ),
                          if (model.contact.notes != null)
                            _buildInfoSection(
                              context,
                              'Notes',
                              model.contact.notes!,
                              IconsaxPlusLinear.note_1,
                            ),
                          SizedBox(height: 80), // Space for the button
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 24,
                    right: 24,
                    bottom: 24,
                    child: Column(children: [
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () async {
                                final confirmed = await showDialog<bool>(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text('Delete Contact'),
                                    content: Text(
                                        'Are you sure you want to delete this contact?'),
                                    actions: [
                                      TextButton(
                                        child: Text('Cancel'),
                                        onPressed: () =>
                                            Navigator.pop(context, false),
                                      ),
                                      TextButton(
                                        child: Text(
                                          'Delete',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                        onPressed: () =>
                                            Navigator.pop(context, true),
                                      ),
                                    ],
                                  ),
                                );

                                if (confirmed == true &&
                                    model.contact.id != null) {
                                  try {
                                    await model
                                        .deleteContact(model.contact.id!);
                                    Navigator.pop(context);
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content:
                                            Text('Failed to delete contact'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor:
                                    Theme.of(context).primaryColorLight,
                                padding: EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(IconsaxPlusLinear.trash,
                                      color: Colors.white),
                                  SizedBox(width: 10),
                                  Text(
                                    'Delete',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () async {
                                final updatedContact =
                                    await Navigator.push<Contact>(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        EditContactView(contact: model.contact),
                                  ),
                                );
                                if (updatedContact != null) {
                                  model.setContact(updatedContact);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey[100],
                                foregroundColor: Colors.black87,
                                padding: EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(IconsaxPlusLinear.edit,
                                      color: Colors.black),
                                  SizedBox(width: 10),
                                  Text(
                                    'Edit',
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
                      SizedBox(height: 16),
                      if (model.contact.phoneNumber1 != null)
                        Container(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              final phoneNumber = model.contact.phoneNumber1!
                                  .replaceAll(RegExp(r'[^0-9+]'), '');
                              final uri = Uri.parse('tel:$phoneNumber');
                              if (await canLaunchUrl(uri)) {
                                await launchUrl(uri);
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
                                Icon(IconsaxPlusLinear.call,
                                    color: Colors.white),
                                SizedBox(width: 10),
                                Text(
                                  'Call',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ]),
                  ),
                ]),
              ),
            ));
  }

  Widget _buildInfoSection(
    BuildContext context,
    String label,
    String value,
    IconData icon, {
    bool isPhone = false,
    bool isEmail = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context).secondaryHeaderColor,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(icon, color: Theme.of(context).primaryColor, size: 20),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: 16,
                      color: isPhone || isEmail
                          ? Theme.of(context).primaryColor
                          : Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
