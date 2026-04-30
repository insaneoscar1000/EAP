import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:the_eap_app/src/core/arguments/arguments.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:the_eap_app/src/core/models/models.dart';
import 'package:the_eap_app/src/core/constants/constants.dart';
import 'package:the_eap_app/src/core/view_models/view_models.dart';
import 'package:the_eap_app/src/ui/shared/theme.dart';
import 'package:the_eap_app/src/ui/shared/widgets/widgets.dart';

class AccountView extends StatelessWidget {
  void _launchURL(String url) async {
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AccountViewModel>.reactive(
      viewModelBuilder: () => AccountViewModel(),
      onViewModelReady: (AccountViewModel model) => model.init(),
      builder: (BuildContext context, AccountViewModel model, Widget? child) {
        return Scaffold(
          appBar: DefaultAppBar(
            title: 'Account',
          ),
          body: BackgroundContainer(
            background: 'background-2',
            child: model.isBusy
                ? LoadingIndicator()
                : StreamBuilder<UserRecord>(
                    stream: model.userStream,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return LoadingIndicator();
                      }
                      if (!snapshot.hasData) {
                        return Center(child: Text('No user data available'));
                      }
                      final user = snapshot.data!;
                      return SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSectionTitle('Your Account'),
                              _buildAccountFields(user),
                              _buildResetPasswordButton(context, user),
                              SizedBox(height: 18),
                              _buildSectionTitle('App Settings'),
                              _buildSettingsOptions(context),
                              SizedBox(height: 18),
                              _buildActionButtons(
                                  context, model.logout, model.deleteAccount),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey[600],
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildAccountFields(UserRecord user) {
    return Column(
      children: [
        _buildTextField(
            '${user.details!.firstName!} ${user.details!.lastName!}'),
        _buildTextField(user.contact!.emailAddress!),
        _buildTextField(user.details!.dateOfBirth != null
            ? DateFormat('d MMMM yyyy')
                .format(user.details!.dateOfBirth!.toDate())
            : 'N/A'),
      ],
    );
  }

  Widget _buildTextField(String text) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResetPasswordButton(BuildContext context, UserRecord user) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ElevatedButton(
        onPressed: () => Navigator.pushNamed(
            context, RoutePaths.updateProfileDetails,
            arguments: UpdateProfileDetailsArguments(user: user)),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.themeData.primaryColor,
          padding: EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          'Update Details',
          style: TextStyle(
              color: Theme.of(context).primaryColorLight,
              fontWeight: FontWeight.bold,
              fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildSettingsOptions(BuildContext context) {
    return Column(
      children: [
        _buildSettingOption('Subscription',
            onTap: () => Navigator.pushNamed(context, RoutePaths.subscription)),
        _buildSettingOption('Support',
            onTap: () => Navigator.pushNamed(context, RoutePaths.support)),
        _buildSettingOption('Terms & Conditions',
            onTap: () =>
                _launchURL('http://www.forgetthesocks.app/conditions')),
        _buildSettingOption('Privacy Policy',
            onTap: () => _launchURL('http://www.forgetthesocks.app/privacy')),
      ],
    );
  }

  Widget _buildSettingOption(String title, {Function()? onTap}) {
    return GestureDetector(
      onTap: () => onTap!(),
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.black),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, Function deleteProfile) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Text(
            'Delete Account',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently deleted.',
            style: TextStyle(color: Colors.black87),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                deleteProfile();
              },
              child: Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildActionButtons(
      BuildContext context, VoidCallback logout, VoidCallback deleteProfile) {
    return Row(
      children: [
        Expanded(
          child: _buildActionButton(
            onTap: logout,
            icon: IconsaxPlusLinear.logout,
            label: 'Logout',
            color: Colors.grey[800]!,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _buildActionButton(
            onTap: () => _showDeleteConfirmation(context, deleteProfile),
            icon: IconsaxPlusLinear.trash,
            label: 'Delete Account',
            color: Colors.red,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required VoidCallback onTap,
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 30,
              color: color,
            ),
            SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
