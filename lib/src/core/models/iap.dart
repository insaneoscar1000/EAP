import 'package:cloud_firestore/cloud_firestore.dart';

class IAP {
  final String? id;
  final String projectId;
  final String name;
  final String? organization;
  final String? email;
  final String? phone;
  final String? contactNumber2;
  final String? address;
  final String? comments;
  final String? correspondenceDate;
  final String? issueRaised;
  final String? eapResponse;
  final Timestamp createdAt;

  IAP({
    this.id,
    required this.projectId,
    required this.name,
    this.organization,
    this.email,
    this.phone,
    this.contactNumber2,
    this.address,
    this.comments,
    this.correspondenceDate,
    this.issueRaised,
    this.eapResponse,
    required this.createdAt,
  });

  factory IAP.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return IAP(
      id: doc.id,
      projectId: data['projectId'] ?? '',
      name: data['name'] ?? '',
      organization: data['organization'],
      email: data['email'],
      phone: data['phone'],
      contactNumber2: data['contactNumber2'],
      address: data['address'],
      comments: data['comments'],
      correspondenceDate: data['correspondenceDate'] as String?,
      issueRaised: data['issueRaised'],
      eapResponse: data['eapResponse'],
      createdAt: data['createdAt'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'projectId': projectId,
      'name': name,
      'organization': organization,
      'email': email,
      'phone': phone,
      'contactNumber2': contactNumber2,
      'address': address,
      'comments': comments,
      'correspondenceDate': correspondenceDate,
      'issueRaised': issueRaised,
      'eapResponse': eapResponse,
      'createdAt': createdAt,
    };
  }

  IAP copyWith({
    String? id,
    String? projectId,
    String? name,
    String? organization,
    String? email,
    String? phone,
    String? contactNumber2,
    String? address,
    String? comments,
    String? correspondenceDate,
    String? issueRaised,
    String? eapResponse,
    Timestamp? createdAt,
  }) {
    return IAP(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      name: name ?? this.name,
      organization: organization ?? this.organization,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      contactNumber2: contactNumber2 ?? this.contactNumber2,
      address: address ?? this.address,
      comments: comments ?? this.comments,
      correspondenceDate: correspondenceDate ?? this.correspondenceDate,
      issueRaised: issueRaised ?? this.issueRaised,
      eapResponse: eapResponse ?? this.eapResponse,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
