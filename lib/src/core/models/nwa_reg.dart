class NWAReg {
  final String id;
  final String section;
  final String regulation;
  final String linkUrl;

  NWAReg({
    required this.id,
    required this.section,
    required this.regulation,
    required this.linkUrl,
  });

  factory NWAReg.fromMap(String id, Map<String, dynamic> data) {
    return NWAReg(
      id: id,
      section: data['section'] ?? '',
      regulation: data['regulation'] ?? '',
      linkUrl: data['linkUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'section': section,
      'regulation': regulation,
      'linkUrl': linkUrl,
    };
  }
}
