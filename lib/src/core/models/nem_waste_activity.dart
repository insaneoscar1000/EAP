class NEMWasteActivity {
  final String id;
  final String wasteCategory;
  final String applicationProcess;
  final String activityType;
  final String gnrSection;
  final String activity;
  final String exclusions;
  final int sortOrder;

  NEMWasteActivity({
    required this.id,
    required this.wasteCategory,
    required this.applicationProcess,
    required this.activityType,
    required this.gnrSection,
    required this.activity,
    required this.exclusions,
    required this.sortOrder,
  });

  factory NEMWasteActivity.fromMap(String id, Map<String, dynamic> data) {
    return NEMWasteActivity(
      id: id,
      wasteCategory: (data['wasteCategory'] ?? '').toString(),
      applicationProcess: (data['applicationProcess'] ?? '').toString(),
      activityType: (data['activityType'] ?? '').toString(),
      gnrSection: (data['gnrSection'] ?? '').toString(),
      activity: (data['activity'] ?? '').toString(),
      exclusions: (data['exclusions'] ?? '').toString(),
      sortOrder: (data['sortOrder'] is num)
          ? (data['sortOrder'] as num).toInt()
          : 1 << 30,
    );
  }
}
