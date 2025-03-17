class Definition {
  final String id;
  final String title;
  final String meaning;

  Definition({
    required this.id,
    required this.title,
    required this.meaning,
  });

  factory Definition.fromMap(String id, Map<String, dynamic> data) {
    return Definition(
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
