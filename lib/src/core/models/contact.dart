import 'package:cloud_firestore/cloud_firestore.dart';

class Contact {
  final String? id;
  final String name;
  final String organisation;
  final String? phoneNumber1;
  final String? phoneNumber2;
  final String? emailAddress;
  final String? physicalAddress;
  final String? notes;

  Contact({
    this.id,
    required this.name,
    required this.organisation,
    this.phoneNumber1,
    this.phoneNumber2,
    this.emailAddress,
    this.physicalAddress,
    this.notes,
  });

  factory Contact.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Contact(
      id: doc.id,
      name: data['name'] ?? '',
      organisation: data['organisation'] ?? '',
      phoneNumber1: data['phoneNumber1'],
      phoneNumber2: data['phoneNumber2'],
      emailAddress: data['emailAddress'],
      physicalAddress: data['physicalAddress'],
      notes: data['notes'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'organisation': organisation,
      'phoneNumber1': phoneNumber1,
      'phoneNumber2': phoneNumber2,
      'emailAddress': emailAddress,
      'physicalAddress': physicalAddress,
      'notes': notes,
    };
  }
}
