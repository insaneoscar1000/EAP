import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:the_eap_app/src/core/models/models.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:the_eap_app/src/ui/shared/widgets/widgets.dart';
import 'package:the_eap_app/src/ui/views/projects/iap_database_view/add_iap_entry_view.dart';

class IAPDetailsView extends StatelessWidget {
  final IAP initialIAP;
  final String projectId;
  final String projectName;
  final VoidCallback? onSave;

  const IAPDetailsView({
    Key? key,
    required this.initialIAP,
    required this.projectId,
    required this.projectName,
    this.onSave,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Listen for changes to this IAP document in real-time
    return StreamBuilder<IAP>(
      stream: _iapStream(),
      builder: (context, snapshot) {
        final iap = snapshot.data ?? initialIAP;
        return Scaffold(
          appBar: DefaultAppBar(
            title: iap.name,
          ),
          body: BackgroundContainer(
            background: 'background-3',
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoSection(
                          context,
                          'Organization',
                          iap.organization ?? 'Not specified',
                          IconsaxPlusLinear.building,
                        ),
                        _buildInfoSection(
                          context,
                          'Email',
                          iap.email ?? 'Not specified',
                          IconsaxPlusLinear.message,
                          isEmail: true,
                        ),
                        _buildInfoSection(
                          context,
                          'Primary Phone',
                          iap.phone ?? 'Not specified',
                          IconsaxPlusLinear.call,
                          isPhone: true,
                        ),
                        if (iap.contactNumber2 != null && iap.contactNumber2!.isNotEmpty)
                          _buildInfoSection(
                            context,
                            'Secondary Phone',
                            iap.contactNumber2!,
                            IconsaxPlusLinear.call,
                            isPhone: true,
                          ),
                        if (iap.address != null && iap.address!.isNotEmpty)
                          _buildInfoSection(
                            context,
                            'Address',
                            iap.address!,
                            IconsaxPlusLinear.location,
                          ),
                        if (iap.correspondenceDate != null && iap.correspondenceDate!.isNotEmpty)
                          _buildInfoSection(
                            context,
                            'Correspondence Date',
                            iap.correspondenceDate!,
                            IconsaxPlusLinear.calendar,
                          ),
                        if (iap.issueRaised != null && iap.issueRaised!.isNotEmpty)
                          _buildInfoSection(
                            context,
                            'Issue Raised',
                            iap.issueRaised!,
                            IconsaxPlusLinear.message_question,
                          ),
                        if (iap.eapResponse != null && iap.eapResponse!.isNotEmpty)
                          _buildInfoSection(
                            context,
                            'EAP Response',
                            iap.eapResponse!,
                            IconsaxPlusLinear.message_text,
                          ),
                        if (iap.comments != null && iap.comments!.isNotEmpty)
                          _buildInfoSection(
                            context,
                            'Comments',
                            iap.comments!,
                            IconsaxPlusLinear.message,
                          ),
                        SizedBox(height: 80), // Space for the buttons
                      ],
                    ),
                  ),
                ),
                // Action buttons at the bottom
                Positioned(
                  left: 24,
                  right: 24,
                  bottom: 24,
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            if (iap.id != null) {
                              // TODO: Implement delete logic (model.deleteIAP)
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
                              Icon(IconsaxPlusLinear.trash, color: Colors.white),
                              SizedBox(width: 10),
                              Text('Delete', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
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
                                  iap: iap,
                                  onSave: () {
                                    // Call the parent's onSave callback if provided
                                    if (onSave != null) {
                                      onSave!();
                                    }
                                  },
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
                              Icon(IconsaxPlusLinear.edit, color: Colors.black),
                              SizedBox(width: 10),
                              Text('Edit', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Helper to get a stream of this IAP document
  Stream<IAP> _iapStream() {
    final firestore = FirebaseFirestore.instance;
    return firestore
        .collection('iap')
        .doc(initialIAP.id)
        .snapshots()
        .map((doc) => IAP.fromSnapshot(doc));
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
