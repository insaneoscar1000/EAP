import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
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
  final _mailService = locator<MailService>();
  final _subscriptionService = locator<SubscriptionService>();

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

  /// Creates a service provider listing.
  ///
  /// - Premium subscribers (web): listing is created immediately as part
  ///   of their membership, no payment is charged. Listing enters the
  ///   admin-moderation queue (`status: 'Pending'`).
  /// - Non-premium users (web): blocked with a "subscribe to list" message.
  /// - Mobile: blocked with an "available on web" message.
  Future<void> initiatePaymentAndCreateAdvert(BuildContext context) async {
    if (!kIsWeb) {
      setError('Service provider listings are managed on our website. '
          'Please use the web version of The EAP App to list your services.');
      return;
    }

    try {
      setBusy(true);
      setProcessing(true);
      notifyListeners();

      final String? userId =
          await _storageService.getString(StorageConstants.userId);
      if (userId == null) {
        throw 'User ID not found. Please log in again.';
      }

      // Premium gate — service provider listings are a subscription perk.
      final bool isPremium = await _subscriptionService.isPremium();
      if (!isPremium) {
        throw 'A Premium subscription is required to create a service '
            'provider listing. Please subscribe from the Subscription page '
            'and try again.';
      }

      // 1. Create the listing tied to the subscription. No payment row.
      final String advertId = await _createSubscriptionAdvert(userId);

      // 2. Upload image (if any). Non-fatal on failure.
      if (selectedImage != null) {
        try {
          photoUrl =
              await _advertService.uploadAdvertImage(advertId, selectedImage!);
          await _advertService.updateAdvert(advertId, <String, dynamic>{
            'photoUrl': photoUrl,
          });
        } catch (_) {
          // Non-fatal.
        }
      }

      // 3. Notification email (best-effort).
      try {
        await _mailService.sendAdvertCreationEmail(
          titleController.text,
          companyController.text,
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

  Future<String> _createSubscriptionAdvert(String userId) async {
    final Map<String, dynamic> advert = <String, dynamic>{
      // Awaits admin moderation. The advert service hides anything not
      // 'Approved' from the public feed.
      'status': 'Pending',
      'title': titleController.text,
      'company': companyController.text,
      'role': roleController.text,
      'location': locationController.text,
      'services': servicesController.text,
      'contact': <String, dynamic>{
        'id': userId,
        'name': contactNameController.text,
        'emailAddress': emailController.text,
        'phoneNumber': phoneController.text,
      },
      'photoUrl': '',
      'linkUrl': websiteUrlController.text,
      'payment': <String, dynamic>{
        // Subscription-backed: no one-off charge.
        'type': 'subscription',
        'status': 'paid',
        'subscriberUid': userId,
        'date': Timestamp.now(),
      },
      'meta': <String, dynamic>{
        'createdDate': FieldValue.serverTimestamp(),
        'modifiedDate': FieldValue.serverTimestamp(),
      },
    };
    return _advertService.createAdvert(advert);
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
