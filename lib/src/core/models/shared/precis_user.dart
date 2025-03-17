class PrecisUser {
  final String id;
  final String name;
  final String token;

  PrecisUser({required this.id, required this.name, required this.token});

  factory PrecisUser.fromMap(Map<String, dynamic> map) {
    return PrecisUser(id: map['id'], name: map['name'], token: map['token']);
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'token': token};
  }
}
