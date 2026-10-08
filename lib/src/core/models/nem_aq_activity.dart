class NEMAQActivity {
  final String id;
  final String category;
  final String categoryDescription;
  final String subcategory;
  final String subcategoryDescription;
  final String application;
  final int sortOrder;

  NEMAQActivity({
    required this.id,
    required this.category,
    required this.categoryDescription,
    required this.subcategory,
    required this.subcategoryDescription,
    required this.application,
    required this.sortOrder,
  });

  factory NEMAQActivity.fromMap(String id, Map<String, dynamic> data) {
    return NEMAQActivity(
      id: id,
      category: (data['category'] ?? '').toString(),
      categoryDescription: (data['categoryDescription'] ?? '').toString(),
      subcategory: (data['subcategory'] ?? '').toString(),
      subcategoryDescription: (data['subcategoryDescription'] ?? '').toString(),
      application: (data['application'] ?? '').toString(),
      sortOrder: (data['sortOrder'] is num)
          ? (data['sortOrder'] as num).toInt()
          : 1 << 30,
    );
  }
}
