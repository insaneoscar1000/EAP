class Advert {
  final String id;
  final String title;
  final AdvertContact contact;
  final String company;
  final String role;
  final String location;
  final String linkUrl;
  final String photoUrl;
  final String services;
  final String status;

  Advert({
    required this.id,
    required this.title,
    required this.contact,
    required this.company,
    required this.role,
    required this.location,
    required this.linkUrl,
    required this.photoUrl,
    required this.services,
    required this.status,
  });

  factory Advert.fromMap(Map<String, dynamic> map, String id) {
    return Advert(
      id: id,
      title: map['title'] ?? '',
      contact: AdvertContact.fromMap(map['contact'] ?? {}),
      company: map['company'] ?? '',
      role: map['role'] ?? '',
      location: map['location'] ?? '',
      linkUrl: map['linkUrl'] ?? '',
      photoUrl: map['photoUrl'] ?? '',
      services: map['services'] ?? '',
      status: map['status'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'contact': contact.toMap(),
      'company': company,
      'role': role,
      'location': location,
      'linkUrl': linkUrl,
      'photoUrl': photoUrl,
      'services': services,
      'status': status,
    };
  }
}

class AdvertContact {
  final String id;
  final String name;
  final String emailAddress;

  AdvertContact({
    required this.id,
    required this.name,
    required this.emailAddress,
  });

  factory AdvertContact.fromMap(Map<String, dynamic> map) {
    return AdvertContact(
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
