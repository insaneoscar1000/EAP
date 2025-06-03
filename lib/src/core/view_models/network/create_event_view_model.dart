import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stacked/stacked.dart';
import 'package:the_eap_app/src/core/constants/constants.dart';
import 'package:the_eap_app/src/core/services/services.dart';
import 'package:the_eap_app/src/locator.dart';

class CreateEventViewModel extends BaseViewModel {
  final _eventService = locator<EventService>();
  final _storageService = locator<StorageService>();
  final _imagePicker = ImagePicker();
  final _navigationService = locator<NavigationService>();
  final _paymentService = locator<PaymentService>();
  final _mailService = locator<MailService>();

  File? selectedImage;
  String? flyerUrl;

  // Track if we're processing the payment and event creation
  bool _isProcessing = false;
  bool get isProcessing => _isProcessing;

  void setProcessing(bool value) {
    _isProcessing = value;
    notifyListeners();
  }

  DateTime expiryDate = DateTime.now().add(Duration(days: 30));

  final nameController = TextEditingController();
  final organizationController = TextEditingController();
  final contactNameController = TextEditingController();
  final emailController = TextEditingController();
  final websiteUrlController = TextEditingController();
  final locationController = TextEditingController();
  final roleController = TextEditingController();
  final contactNumberController = TextEditingController();

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

  void setExpiryDate(DateTime date) {
    expiryDate = date;
    notifyListeners();
  }

  /// Initiates the payment process before creating an event
  Future<void> initiatePaymentAndCreateEvent(BuildContext context) async {
    try {
      print('Starting payment and event creation process');
      setBusy(true);
      setProcessing(true);
      notifyListeners();

      // Validate required fields
      if (nameController.text.isEmpty) {
        throw 'Event name is required';
      }
      if (organizationController.text.isEmpty) {
        throw 'Organization is required';
      }
      if (contactNameController.text.isEmpty) {
        throw 'Contact name is required';
      }
      if (emailController.text.isEmpty) {
        throw 'Email address is required';
      }

      final String? userId =
          await _storageService.getString(StorageConstants.userId);
      if (userId == null) {
        throw 'User ID not found. Please log in again.';
      }

      // Process payment
      print('Initiating payment...');
      final paymentReference = 'event_${DateTime.now().millisecondsSinceEpoch}';

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
        throw 'Payment was not completed. Event creation cancelled.';
      }

      print('Payment was successful!');

      // Get the payment reference from the result
      final String confirmedReference =
          paymentResult['reference'] ?? paymentReference;

      // If payment is successful, proceed with event creation
      print('Proceeding to create event after successful payment');
      try {
        await createEvent(confirmedReference, paymentResult);
        print('Event creation completed successfully');
        setBusy(false);
        setProcessing(false);
        notifyListeners();
        _navigationService.pop();
      } catch (e) {
        print('Error creating event after payment: $e');
        setBusy(false);
        setProcessing(false);
        notifyListeners();
        setError(e);
      }
    } catch (e) {
      print('Error in initiatePaymentAndCreateEvent: $e');
      setBusy(false);
      setProcessing(false);
      notifyListeners();
      setError(e);
    }
  }

  /// Creates an event after successful payment
  Future<void> createEvent(
      String paymentReference, Map<String, dynamic> paymentData) async {
    print('Starting createEvent method');
    try {
      print('Creating event with data:');
      print('Name: ${nameController.text}');
      print('Organization: ${organizationController.text}');
      print('Expiry Date: $expiryDate');
      print('Contact Name: ${contactNameController.text}');
      print('Email: ${emailController.text}');
      print('Website URL: ${websiteUrlController.text}');
      print('Payment Reference: $paymentReference');

      final String? userId =
          await _storageService.getString(StorageConstants.userId);
      if (userId == null) {
        throw 'User ID not found. Please log in again.';
      }

      final event = {
        'status': 'Approved',
        'name': nameController.text,
        'organization': organizationController.text,
        'expiryDate': Timestamp.fromDate(expiryDate),
        'contact': {
          'id': userId,
          'name': contactNameController.text,
          'emailAddress': emailController.text,
        },
        'flyerUrl': '',
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
        }
      };

      print(
          'Calling createEvent on EventService with event data: ${event.toString()}');
      String eventId = await _eventService.createEvent(event);
      print('Event created with ID: $eventId');

      if (selectedImage != null) {
        try {
          print('Uploading event image');
          flyerUrl = await _eventService.uploadEventImage(
            eventId,
            selectedImage!,
          );
          print('Image uploaded successfully: $flyerUrl');

          print('Updating event with flyer URL');
          await _eventService.updateEvent(eventId, {
            'flyerUrl': flyerUrl,
          });
          print('Event updated successfully');
        } catch (e) {
          print('Error uploading image: $e');
          // Continue even if image upload fails
        }
      }

      print('Event creation and image upload completed successfully');
      
      // Send email notification to the creator
      try {
        await _mailService.sendEventCreationEmail(
          nameController.text,
          organizationController.text,
          contactNameController.text,
          emailController.text
        );
        print('Event creation email sent successfully');
      } catch (e) {
        print('Error sending event creation email: $e');
        // Continue even if email sending fails
      }
      
      return;
    } catch (e) {
      print('Error in createEvent: $e');
      setBusy(false);
      notifyListeners();
      setError(e);
    }
  }

  void setFlyerUrl(String url) {
    flyerUrl = url;
    notifyListeners();
  }

  @override
  void dispose() {
    nameController.dispose();
    organizationController.dispose();
    contactNameController.dispose();
    emailController.dispose();
    websiteUrlController.dispose();
    locationController.dispose();
    roleController.dispose();
    contactNumberController.dispose();
    super.dispose();
  }
}
