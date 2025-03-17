class Association {
  final String id;
  final String title;
  final String description;
  final String url;

  Association({
    required this.id,
    required this.title,
    required this.description,
    required this.url,
  });

  factory Association.fromMap(Map<String, dynamic> map, {required String id}) {
    return Association(
      id: id,
      title: map['title'] as String,
      description: map['description'] as String,
      url: map['url'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'url': url,
    };
  }
}
