import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stacked/stacked.dart';
import 'package:the_eap_app/src/locator.dart';
import 'package:the_eap_app/src/core/services/services.dart';
import 'package:the_eap_app/src/core/constants/constants.dart';

class CreateAdvertViewModel extends BaseViewModel {
  final _advertService = locator<AdvertService>();
  final _storageService = locator<StorageService>();
  final _imagePicker = ImagePicker();
  final _navigationService = locator<NavigationService>();
  final _paymentService = locator<PaymentService>();
  final _mailService = locator<MailService>();

  File? selectedImage;

  // Track if we're processing the payment and advert creation
  bool _isProcessing = false;
  bool get isProcessing => _isProcessing;

  void setProcessing(bool value) {
    _isProcessing = value;
    notifyListeners();
  }

  final titleController = TextEditingController();
  final companyController = TextEditingController();
  final roleController = TextEditingController();
  final locationController = TextEditingController();
  final servicesController = TextEditingController();
  final contactNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final websiteUrlController = TextEditingController();
  String? photoUrl;

  Future<void> pickImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 400,
      );
      if (image == null) return;

      selectedImage = File(image.path);
      notifyListeners();
    } catch (e) {
      setError('Failed to pick image: $e');
    }
  }

  /// Initiates the payment process before creating an advert
  Future<void> initiatePaymentAndCreateAdvert(BuildContext context) async {
    try {
      print('Starting payment and advert creation process');
      setBusy(true);
      setProcessing(true);
      notifyListeners();

      final String? userId =
          await _storageService.getString(StorageConstants.userId);

      if (userId == null) {
        setBusy(false);
        notifyListeners();
        throw 'User ID not found. Please log in again.';
      }

      // Process payment
      print('Initiating payment...');
      final paymentReference =
          'advert_${DateTime.now().millisecondsSinceEpoch}';

      final paymentResult = await _paymentService.makePayment(
        context: context,
        email: emailController.text,
        name: contactNameController.text,
        amount: 100.00,
        reference: paymentReference,
      );

      print('Payment result: $paymentResult');

      // Check if payment was successful
      if (paymentResult['status'] != 'success') {
        print('Payment failed with status: ${paymentResult['status']}');
        setBusy(false);
        setProcessing(false);
        notifyListeners();
        throw 'Payment was not completed. Advert creation cancelled.';
      }

      print('Payment was successful!');

      // Get the payment reference from the result
      final String confirmedReference =
          paymentResult['reference'] ?? paymentReference;

      // If payment is successful, proceed with advert creation
      print('Proceeding to create advert after successful payment');
      try {
        await createAdvert(confirmedReference, paymentResult);
        print('Advert creation completed successfully');
        setBusy(false);
        setProcessing(false);
        notifyListeners();
      } catch (e) {
        print('Error creating advert after payment: $e');
        setBusy(false);
        setProcessing(false);
        notifyListeners();
        setError(e);
      }
    } catch (e) {
      print('Error in initiatePaymentAndCreateAdvert: $e');
      setBusy(false);
      setProcessing(false);
      notifyListeners();
      setError(e);
    }
  }

  /// Creates an advert after successful payment
  Future<void> createAdvert(
      String paymentReference, Map<String, dynamic> paymentData) async {
    try {
      final String? userId =
          await _storageService.getString(StorageConstants.userId);

      // Create the advert JSON
      final advert = {
        'status': 'Approved',
        'title': titleController.text,
        'company': companyController.text,
        'role': roleController.text,
        'location': locationController.text,
        'services': servicesController.text,
        'contact': {
          'id': userId!,
          'name': contactNameController.text,
          'emailAddress': emailController.text,
          'phoneNumber': phoneController.text,
        },
        'photoUrl': '',
        'linkUrl': websiteUrlController.text,
        'payment': {
          'amount': paymentData['amount'] ?? 100.00,
          'currency': paymentData['currency'] ?? 'NGN',
          'reference': paymentReference,
          'date': Timestamp.now(),
          'status': paymentData['status'] ?? 'success',
        },
        'meta': {
          'createdDate': FieldValue.serverTimestamp(),
          'modifiedDate': FieldValue.serverTimestamp(),
        },
      };

      String advertId = await _advertService.createAdvert(advert);

      if (selectedImage != null) {
        try {
          photoUrl = await _advertService.uploadAdvertImage(
            advertId,
            selectedImage!,
          );

          await _advertService.updateAdvert(advertId, {
            'photoUrl': photoUrl,
          });
        } catch (e) {
          // Continue even if image upload fails
        }
      }

      // Send email notification to the creator
      try {
        await _mailService.sendAdvertCreationEmail(
          titleController.text,
          companyController.text,
          contactNameController.text,
          emailController.text
        );
        print('Advert creation email sent successfully');
      } catch (e) {
        print('Error sending advert creation email: $e');
        // Continue even if email sending fails
      }
      
      setBusy(false);
      notifyListeners();
      _navigationService.pop();
    } catch (e) {
      setBusy(false);
      notifyListeners();
      setError(e);
    }
  }

  void setPhotoUrl(String url) {
    photoUrl = url;
    notifyListeners();
  }

  @override
  void dispose() {
    titleController.dispose();
    companyController.dispose();
    roleController.dispose();
    locationController.dispose();
    servicesController.dispose();
    contactNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    websiteUrlController.dispose();
    super.dispose();
  }
}
