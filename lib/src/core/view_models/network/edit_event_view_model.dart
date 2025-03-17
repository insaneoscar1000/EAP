import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stacked/stacked.dart';
import 'package:the_eap_app/src/core/constants/constants.dart';
import 'package:the_eap_app/src/core/models/models.dart';
import 'package:the_eap_app/src/core/services/services.dart';
import 'package:the_eap_app/src/locator.dart';

class EditEventViewModel extends BaseViewModel {
  final _eventService = locator<EventService>();
  final _storageService = locator<StorageService>();
  final _imagePicker = ImagePicker();
  final _navigationService = locator<NavigationService>();

  File? selectedImage;
  String? flyerUrl;
  late DateTime expiryDate;
  late String eventId;

  final nameController = TextEditingController();
  final organizationController = TextEditingController();
  final contactNameController = TextEditingController();
  final emailController = TextEditingController();
  final websiteUrlController = TextEditingController();

  void initialize(Event event) {
    eventId = event.id;
    nameController.text = event.name;
    organizationController.text = event.organization;
    contactNameController.text = event.contact.name;
    emailController.text = event.contact.emailAddress;
    websiteUrlController.text = event.linkUrl;
    flyerUrl = event.flyerUrl;
    expiryDate = event.expiryDate.toDate();
    notifyListeners();
  }

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

  Future<void> updateEvent() async {
    try {
      setBusy(true);
      notifyListeners();

      String? updatedFlyerUrl = flyerUrl;
      if (selectedImage != null) {
        updatedFlyerUrl = await _eventService.uploadEventImage(
          eventId,
          selectedImage!,
        );
      }

      final userId = await _storageService.getString(StorageConstants.userId);
      if (userId == null) throw Exception('User not found');

      final data = {
        'name': nameController.text,
        'organization': organizationController.text,
        'expiryDate': Timestamp.fromDate(expiryDate),
        'flyerUrl': updatedFlyerUrl ?? '',
        'linkUrl': websiteUrlController.text,
        'contact': {
          'id': userId,
          'name': contactNameController.text,
          'emailAddress': emailController.text,
        },
      };

      await _eventService.updateEvent(eventId, data);

      _navigationService.pop();
    } catch (e) {
      setError(e.toString());
    } finally {
      setBusy(false);
      notifyListeners();
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    organizationController.dispose();
    contactNameController.dispose();
    emailController.dispose();
    websiteUrlController.dispose();
    super.dispose();
  }
}
