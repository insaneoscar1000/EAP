import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:the_eap_app/src/core/models/models.dart';
import 'package:the_eap_app/src/core/view_models/projects/iap_database_view_model.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:the_eap_app/src/ui/shared/widgets/widgets.dart';
import 'package:intl/intl.dart';
import 'package:the_eap_app/src/ui/views/projects/iap_database_view/add_iap_entry_view.dart';

class IAPDetailsView extends StatelessWidget {
  final IAP initialIAP;
  final String projectId;
  final String projectName;

  const IAPDetailsView({
    Key? key,
    required this.initialIAP,
    required this.projectId,
    required this.projectName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<IAPDatabaseViewModel>.reactive(
      viewModelBuilder: () => IAPDatabaseViewModel()..setEditingIAP(initialIAP)..setProjectId(projectId),
      builder: (context, model, child) => Scaffold(
        appBar: DefaultAppBar(
          title: initialIAP.name,
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
                      'Organization',
                      initialIAP.organization ?? 'Not specified',
                      IconsaxPlusLinear.building,
                    ),
                    _buildInfoSection(
                      context,
                      'Email',
                      initialIAP.email ?? 'Not specified',
                      IconsaxPlusLinear.message,
                      isEmail: true,
                    ),
                    _buildInfoSection(
                      context,
                      'Primary Phone',
                      initialIAP.phone ?? 'Not specified',
                      IconsaxPlusLinear.call,
                      isPhone: true,
                    ),
                    if (initialIAP.contactNumber2 != null && initialIAP.contactNumber2!.isNotEmpty)
                      _buildInfoSection(
                        context,
                        'Secondary Phone',
                        initialIAP.contactNumber2!,
                        IconsaxPlusLinear.call,
                        isPhone: true,
                      ),
                    if (initialIAP.address != null && initialIAP.address!.isNotEmpty)
                      _buildInfoSection(
                        context,
                        'Address',
                        initialIAP.address!,
                        IconsaxPlusLinear.location,
                      ),
                    if (initialIAP.correspondenceDate != null)
                      _buildInfoSection(
                        context,
                        'Correspondence Date',
                        DateFormat('dd MMMM yyyy').format(initialIAP.correspondenceDate!.toDate()),
                        IconsaxPlusLinear.calendar,
                      ),
                    if (initialIAP.issueRaised != null && initialIAP.issueRaised!.isNotEmpty)
                      _buildInfoSection(
                        context,
                        'Issue Raised',
                        initialIAP.issueRaised!,
                        IconsaxPlusLinear.message_question,
                      ),
                    if (initialIAP.eapResponse != null && initialIAP.eapResponse!.isNotEmpty)
                      _buildInfoSection(
                        context,
                        'EAP Response',
                        initialIAP.eapResponse!,
                        IconsaxPlusLinear.message_text,
                      ),
                    if (initialIAP.comments != null && initialIAP.comments!.isNotEmpty)
                      _buildInfoSection(
                        context,
                        'Comments',
                        initialIAP.comments!,
                        IconsaxPlusLinear.note_1,
                      ),
                    SizedBox(height: 80), // Space for the buttons
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
                          if (initialIAP.id != null) {
                            await model.deleteIAP(initialIAP.id!);
                            Navigator.pop(context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[600],
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddIAPEntryView(
                                projectId: projectId,
                                projectName: projectName,
                                iap: initialIAP,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[100],
                          foregroundColor: Colors.black,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: Colors.grey[300]!),
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
              ]),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _buildInfoSection(
    BuildContext context,
    String title,
    String content,
    IconData icon, {
    bool isEmail = false,
    bool isPhone = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Theme.of(context).primaryColor, size: 20),
              SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
