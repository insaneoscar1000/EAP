import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:stacked/stacked.dart';
import 'package:the_eap_app/src/core/view_models/view_models.dart';
import 'package:the_eap_app/src/ui/shared/widgets/widgets.dart';

class CreateAdvertView extends StatefulWidget {
  @override
  _CreateAdvertViewState createState() => _CreateAdvertViewState();
}

class _CreateAdvertViewState extends State<CreateAdvertView> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CreateAdvertViewModel>.reactive(
        viewModelBuilder: () => CreateAdvertViewModel(),
        builder:
            (BuildContext context, CreateAdvertViewModel model, Widget? child) {
          return Stack(
            children: [
              Scaffold(
                  appBar: DefaultAppBar(
                    title: 'Create Own Listing',
                    showBackButton: !model.isProcessing,
                  ),
                  backgroundColor: Colors.white,
                  body: WillPopScope(
                    onWillPop: () async {
                      // Prevent navigation when processing
                      return !model.isProcessing;
                    },
                    child: BackgroundContainer(
                      background: 'background-3',
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.all(24),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Container(
                                  height: 200,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Theme.of(context)
                                          .secondaryHeaderColor,
                                      width: 1,
                                    ),
                                  ),
                                  child: InkWell(
                                    onTap: () async {
                                      try {
                                        await model.pickImage();
                                      } catch (e) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(e.toString()),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      }
                                    },
                                    child: model.photoUrl != null
                                        ? ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            child: Image.network(
                                              model.photoUrl!,
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                        : model.selectedImage != null
                                            ? ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                child: Image.file(
                                                  model.selectedImage!,
                                                  fit: BoxFit.cover,
                                                ),
                                              )
                                            : Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    padding: EdgeInsets.all(12),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: Icon(
                                                      IconsaxPlusLinear
                                                          .document_upload,
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                    ),
                                                  ),
                                                  SizedBox(height: 8),
                                                  Text(
                                                    'Upload',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  SizedBox(height: 4),
                                                  Text(
                                                    'SVG, PNG, JPG or GIF (max 800x400px)',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.grey[600],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                  ),
                                ),
                                SizedBox(height: 24),
                                _buildTextField(
                                  'Advert Title *',
                                  model.titleController,
                                  required: true,
                                ),
                                SizedBox(height: 16),
                                _buildTextField(
                                  'Contact Person *',
                                  model.contactNameController,
                                  required: true,
                                ),
                                SizedBox(height: 16),
                                _buildTextField(
                                  'Company',
                                  model.companyController,
                                ),
                                SizedBox(height: 16),
                                _buildTextField(
                                  'Location *',
                                  model.locationController,
                                  required: true,
                                ),
                                SizedBox(height: 16),
                                _buildTextField(
                                  'Role (EAP Specialist, ECO) *',
                                  model.roleController,
                                  required: true,
                                ),
                                SizedBox(height: 16),
                                _buildTextField(
                                  'Specify services offered or wanted',
                                  model.servicesController,
                                  maxLines: 3,
                                ),
                                SizedBox(height: 16),
                                _buildTextField(
                                  'Contact Email *',
                                  model.emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  required: true,
                                ),
                                SizedBox(height: 16),
                                _buildTextField(
                                  'Contact Phone',
                                  model.phoneController,
                                  keyboardType: TextInputType.phone,
                                ),
                                SizedBox(height: 16),
                                _buildTextField(
                                  'Website URL',
                                  model.websiteUrlController,
                                  keyboardType: TextInputType.url,
                                ),
                                SizedBox(height: 24),
                                ElevatedButton(
                                  onPressed: model.isBusy
                                      ? null
                                      : () async {
                                          // Image is optional, no need to validate

                                          if (_formKey.currentState!
                                              .validate()) {
                                            // Show payment confirmation dialog
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title:
                                                      Text('Payment Required'),
                                                  content: Text(
                                                      'Creating an advert requires a payment of ₦100.00. Would you like to proceed with payment?'),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: Text('Cancel'),
                                                    ),
                                                    TextButton(
                                                      onPressed: () async {
                                                        Navigator.of(context)
                                                            .pop();
                                                        await model
                                                            .initiatePaymentAndCreateAdvert(
                                                                context);
                                                      },
                                                      child: Text('Proceed'),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          }
                                        },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                    foregroundColor: Colors.white,
                                    disabledBackgroundColor:
                                        Theme.of(context).primaryColor,
                                    disabledForegroundColor: Colors.white,
                                    padding: EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: (model.isBusy)
                                      ? SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: LoadingIndicator())
                                      : Text(
                                          'Create EAP Team Advert',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  )),
              if (model.isProcessing)
                Container(
                  color: Colors.black.withOpacity(0.5),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        LoadingIndicator(),
                      ],
                    ),
                  ),
                ),
            ],
          );
        });
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    int maxLines = 1,
    TextInputType? keyboardType,
    bool required = false,
  }) {
    return TextInputField(
      controller: controller,
      label: label,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: (value) {
        if (required && (value == null || value.isEmpty)) {
          return 'Please enter $label';
        }
        if (keyboardType == TextInputType.emailAddress &&
            value != null &&
            value.isNotEmpty &&
            !value.contains('@')) {
          return 'Please enter a valid email address';
        }
        return null;
      },
    );
  }
}
