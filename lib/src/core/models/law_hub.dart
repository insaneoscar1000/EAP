class LawHub {
  final String id;
  final String title;
  final String description;
  final String fileUrl;

  LawHub({
    required this.id,
    required this.title,
    required this.description,
    required this.fileUrl,
  });

  factory LawHub.fromMap(String id, Map<String, dynamic> data) {
    return LawHub(
      id: id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      fileUrl: data['fileUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'fileUrl': fileUrl,
    };
  }
}
