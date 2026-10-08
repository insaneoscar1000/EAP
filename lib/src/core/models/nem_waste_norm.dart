class NEMWasteNorm {
  final String id;
  final String title;
  final String pdfUrl;
  final int sortOrder;

  NEMWasteNorm({
    required this.id,
    required this.title,
    required this.pdfUrl,
    required this.sortOrder,
  });

  factory NEMWasteNorm.fromMap(String id, Map<String, dynamic> data) {
    return NEMWasteNorm(
      id: id,
      title: (data['title'] ?? '').toString(),
      pdfUrl: (data['pdfUrl'] ?? '').toString(),
      sortOrder: (data['sortOrder'] is num)
          ? (data['sortOrder'] as num).toInt()
          : 1 << 30,
    );
  }
}
