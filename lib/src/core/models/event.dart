import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String id;
  final String name;
  final String organization;
  final Timestamp expiryDate;
  final String flyerUrl;
  final String linkUrl;
  final EventContact contact;
  final String status;

  Event({
    required this.id,
    required this.name,
    required this.organization,
    required this.expiryDate,
    required this.flyerUrl,
    required this.linkUrl,
    required this.contact,
    required this.status,
  });

  factory Event.fromMap(Map<String, dynamic> map, String id) {
    return Event(
      id: id,
      name: map['name'] ?? '',
      organization: map['organization'] ?? '',
      expiryDate: map['expiryDate'] ?? Timestamp.now(),
      flyerUrl: map['flyerUrl'] ?? '',
      linkUrl: map['linkUrl'] ?? '',
      contact: EventContact.fromMap(map['contact'] ?? {}),
      status: map['status'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'organization': organization,
      'expiryDate': expiryDate,
      'flyerUrl': flyerUrl,
      'linkUrl': linkUrl,
      'contact': contact.toMap(),
      'status': status,
    };
  }
}

class EventContact {
  final String id;
  final String name;
  final String emailAddress;

  EventContact({
    required this.id,
    required this.name,
    required this.emailAddress,
  });

  factory EventContact.fromMap(Map<String, dynamic> map) {
    return EventContact(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      emailAddress: map['emailAddress'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'emailAddress': emailAddress,
    };
  }
}
