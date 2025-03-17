class NEMAActivity {
  final String id;
  final String legislation;
  final int activityNumber;
  final String authorizationProcess;
  final String selectedListActivity;
  final String exclusions;

  NEMAActivity({
    required this.id,
    required this.legislation,
    required this.activityNumber,
    required this.authorizationProcess,
    required this.selectedListActivity,
    required this.exclusions,
  });

  factory NEMAActivity.fromMap(String id, Map<String, dynamic> data) {
    return NEMAActivity(
      id: id,
      legislation: data['legislation'] ?? '',
      activityNumber: data['activityNumber'] ?? 0,
      authorizationProcess: data['authorizationProcess'] ?? '',
      selectedListActivity: data['selectedListActivity'] ?? '',
      exclusions: data['exclusions'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'legislation': legislation,
      'activityNumber': activityNumber,
      'authorizationProcess': authorizationProcess,
      'selectedListActivity': selectedListActivity,
      'exclusions': exclusions,
    };
  }
}
