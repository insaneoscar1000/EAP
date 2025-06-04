class NEMAActivity {
  final String id;
  final String legislation;
  final dynamic activityNumber; // Can be int or String
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
    var actNum = data['activityNumber'];
    // Accept int or String, but keep as-is
    return NEMAActivity(
      id: id,
      legislation: data['legislation'] ?? '',
      activityNumber: actNum,
      authorizationProcess: data['authorizationProcess'] ?? '',
      selectedListActivity: data['selectedListActivity'] ?? '',
      exclusions: data['exclusions'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'legislation': legislation,
      // Store as int if possible, else string
      'activityNumber': (activityNumber is int)
          ? activityNumber
          : int.tryParse(activityNumber.toString()) ?? activityNumber,
      'authorizationProcess': authorizationProcess,
      'selectedListActivity': selectedListActivity,
      'exclusions': exclusions,
    };
  }
}
