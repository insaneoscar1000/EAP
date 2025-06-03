import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:stacked/stacked.dart';
import 'package:the_eap_app/src/core/view_models/view_models.dart';
import 'package:the_eap_app/src/ui/shared/widgets/widgets.dart';

class CreateEventView extends StatefulWidget {
  @override
  _CreateEventViewState createState() => _CreateEventViewState();
}

class _CreateEventViewState extends State<CreateEventView> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CreateEventViewModel>.reactive(
        viewModelBuilder: () => CreateEventViewModel(),
        builder:
            (BuildContext context, CreateEventViewModel model, Widget? child) {
          return Stack(
            children: [
              Scaffold(
                  appBar: DefaultAppBar(
                    title: 'Create Event',
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
                                SizedBox(height: 16),
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
                                    child: model.flyerUrl != null
                                        ? ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            child: Image.network(
                                              model.flyerUrl!,
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
                                SizedBox(height: 16),
                                _buildTextField(
                                  'Title*',
                                  model.nameController,
                                  required: true,
                                ),
                                SizedBox(height: 16),
                                _buildTextField(
                                  'Organization',
                                  model.organizationController,
                                ),
                                SizedBox(height: 16),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Expiry Date & Time',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () async {
                                              final DateTime? picked =
                                                  await showDatePicker(
                                                context: context,
                                                initialDate: model.expiryDate,
                                                firstDate: DateTime.now(),
                                                lastDate: DateTime.now()
                                                    .add(Duration(days: 365)),
                                              );
                                              if (picked != null) {
                                                model.setExpiryDate(
                                                  DateTime(
                                                    picked.year,
                                                    picked.month,
                                                    picked.day,
                                                    model.expiryDate.hour,
                                                    model.expiryDate.minute,
                                                  ),
                                                );
                                              }
                                            },
                                            child: Container(
                                              padding: EdgeInsets.all(16),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                border: Border.all(
                                                  color: Colors.grey[300]!,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    IconsaxPlusLinear.calendar,
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                  ),
                                                  SizedBox(width: 12),
                                                  Text(
                                                    model.expiryDate
                                                        .toString()
                                                        .split(' ')[0],
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.grey[700],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 16),
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () async {
                                              final TimeOfDay? picked =
                                                  await showTimePicker(
                                                context: context,
                                                initialTime:
                                                    TimeOfDay.fromDateTime(
                                                        model.expiryDate),
                                              );
                                              if (picked != null) {
                                                model.setExpiryDate(
                                                  DateTime(
                                                    model.expiryDate.year,
                                                    model.expiryDate.month,
                                                    model.expiryDate.day,
                                                    picked.hour,
                                                    picked.minute,
                                                  ),
                                                );
                                              }
                                            },
                                            child: Container(
                                              padding: EdgeInsets.all(16),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                border: Border.all(
                                                  color: Colors.grey[300]!,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    IconsaxPlusLinear.clock,
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                  ),
                                                  SizedBox(width: 12),
                                                  Text(
                                                    TimeOfDay.fromDateTime(
                                                            model.expiryDate)
                                                        .format(context),
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.grey[700],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: 16),
                                _buildTextField(
                                  'Location*',
                                  model.locationController,
                                  required: true,
                                ),
                                SizedBox(height: 16),
                                _buildTextField(
                                  'Role*',
                                  model.roleController,
                                  required: true,
                                ),
                                SizedBox(height: 16),
                                _buildTextField(
                                  'Contact Number*',
                                  model.contactNumberController,
                                  keyboardType: TextInputType.phone,
                                  required: true,
                                ),
                                SizedBox(height: 16),
                                _buildTextField(
                                  'Website URL',
                                  model.websiteUrlController,
                                  keyboardType: TextInputType.url,
                                ),
                                SizedBox(height: 16),
                                _buildTextField(
                                  'Contact Person*',
                                  model.contactNameController,
                                  required: true,
                                ),
                                SizedBox(height: 16),
                                _buildTextField(
                                  'Email Address*',
                                  model.emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  required: true,
                                ),
                                SizedBox(height: 24),
                                ElevatedButton(
                                  onPressed: model.isBusy
                                      ? null
                                      : () async {
                                          if (model.selectedImage == null) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                    'Please select an image'),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
                                            return;
                                          }

                                          if (_formKey.currentState!
                                              .validate()) {
                                            // Show payment confirmation dialog
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title:
                                                      Text('Payment Required'),
                                                  content: Text(
                                                      'Creating an event requires a payment of ₦100.00. Would you like to proceed with payment?'),
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
                                                        try {
                                                          await model
                                                              .initiatePaymentAndCreateEvent(
                                                                  context);
                                                        } catch (e) {
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                            SnackBar(
                                                              content: Text(
                                                                  e.toString()),
                                                              backgroundColor:
                                                                  Colors.red,
                                                            ),
                                                          );
                                                        }
                                                      },
                                                      child: Text(
                                                          'Proceed to Payment'),
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
                                          'Create Event',
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
    TextInputType? keyboardType,
    int maxLines = 1,
    bool required = false,
  }) {
    return Column(
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
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          validator: (value) {
            if (required && (value == null || value.isEmpty)) {
              return 'Please enter ${label.replaceAll('*', '').trim()}';
            }
            return null;
          },
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.all(16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Colors.grey[300]!,
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Colors.grey[300]!,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Theme.of(context).primaryColor,
                width: 1,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
