import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:the_eap_app/src/core/models/models.dart';

class UserRecord {
  String? id;
  String? token;
  UserContact? contact;
  UserDetails? details;
  Meta? meta;

  UserRecord({
    this.id,
    this.token,
    this.contact,
    this.details,
    this.meta,
  });

  factory UserRecord.fromMap(Map<String, dynamic>? data, String id) {
    return UserRecord(
      id: id,
      token: data!['token'] as String?,
      contact: UserContact.fromMap(data['contact']),
      details: UserDetails.fromMap(data['details']),
      meta: Meta.fromMap(data['meta']),
    );
  }
}

class UserContact {
  String? emailAddress;

  UserContact({
    this.emailAddress,
  });

  factory UserContact.fromMap(Map<String, dynamic> data) {
    return UserContact(
      emailAddress: data['emailAddress'] as String?,
    );
  }
}

class UserDetails {
  String? firstName;
  String? lastName;
  Timestamp? dateOfBirth;

  UserDetails({
    this.firstName,
    this.lastName,
    this.dateOfBirth,
  });

  factory UserDetails.fromMap(Map<String, dynamic> data) {
    return UserDetails(
      firstName: data['firstName'] as String?,
      lastName: data['lastName'] as String?,
      dateOfBirth: data['dateOfBirth'] as Timestamp?,
    );
  }
}
