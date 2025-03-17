class Acronym {
  final String id;
  final String title;
  final String meaning;

  Acronym({
    required this.id,
    required this.title,
    required this.meaning,
  });

  factory Acronym.fromMap(String id, Map<String, dynamic> data) {
    return Acronym(
      id: id,
      title: data['title'] ?? '',
      meaning: data['meaning'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'meaning': meaning,
    };
  }
}
