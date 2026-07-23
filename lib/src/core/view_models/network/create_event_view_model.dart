import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
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

  /// Cost of a single event listing, in major currency units (ZAR).
  static const double eventCost = 990.00;

  /// Creates the event in a pending state and launches PayStack's
  /// hosted checkout. The PayStack webhook flips the event's payment
  /// status to `paid` once the transaction completes.
  Future<void> initiatePaymentAndCreateEvent(BuildContext context) async {
    if (!kIsWeb) {
      setError('Event listings are purchased on our website. '
          'Please use the web version of The EAP App to list an event.');
      return;
    }
    try {
      setBusy(true);
      setProcessing(true);
      notifyListeners();

      if (nameController.text.isEmpty) throw 'Event name is required';
      if (organizationController.text.isEmpty) {
        throw 'Organization is required';
      }
      if (contactNameController.text.isEmpty) throw 'Contact name is required';
      if (emailController.text.isEmpty) throw 'Email address is required';

      final String? userId =
          await _storageService.getString(StorageConstants.userId);
      if (userId == null) {
        throw 'User ID not found. Please log in again.';
      }

      final String eventId = await _createPendingEvent(userId);

      if (selectedImage != null) {
        try {
          flyerUrl =
              await _eventService.uploadEventImage(eventId, selectedImage!);
          await _eventService.updateEvent(eventId, <String, dynamic>{
            'flyerUrl': flyerUrl,
          });
        } catch (_) {
          // Non-fatal.
        }
      }

      final bool launched = await _paymentService.startEventPayment(
        eventId: eventId,
        amount: eventCost,
        email: emailController.text,
      );
      if (!launched) {
        throw 'Could not launch PayStack checkout. Please try again.';
      }

      try {
        await _mailService.sendEventCreationEmail(
          nameController.text,
          organizationController.text,
          contactNameController.text,
          emailController.text,
        );
      } catch (_) {
        // Non-fatal.
      }

      _navigationService.pop();
    } catch (e) {
      setError(e);
    } finally {
      setBusy(false);
      setProcessing(false);
      notifyListeners();
    }
  }

  Future<String> _createPendingEvent(String userId) async {
    final Map<String, dynamic> event = <String, dynamic>{
      // Listing is hidden from public feed until payment lands.
      'status': 'PendingPayment',
      'name': nameController.text,
      'organization': organizationController.text,
      'expiryDate': Timestamp.fromDate(expiryDate),
      'contact': <String, dynamic>{
        'id': userId,
        'name': contactNameController.text,
        'emailAddress': emailController.text,
      },
      'flyerUrl': '',
      'linkUrl': websiteUrlController.text,
      'payment': <String, dynamic>{
        'amount': eventCost,
        'status': 'pending',
        'date': Timestamp.now(),
      },
      'meta': <String, dynamic>{
        'createdDate': FieldValue.serverTimestamp(),
        'modifiedDate': FieldValue.serverTimestamp(),
      },
    };
    return _eventService.createEvent(event);
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
