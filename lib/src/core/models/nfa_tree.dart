class NFATree {
  final String id;
  final String botanicalName;
  final String commonName;
  final String otherCommonName;
  final dynamic nationalTreeNumber; // Can be int or String
  final String linkUrl;

  NFATree({
    required this.id,
    required this.botanicalName,
    required this.commonName,
    required this.otherCommonName,
    required this.nationalTreeNumber,
    required this.linkUrl,
  });

  factory NFATree.fromMap(String id, Map<String, dynamic> data) {
    var ntn = data['nationalTreeNumber'];
    // Accept int or String, but keep as-is
    return NFATree(
      id: id,
      botanicalName: data['botanicalName'] ?? '',
      commonName: data['commonName'] ?? '',
      otherCommonName: data['otherCommonName'] ?? '',
      nationalTreeNumber: ntn,
      linkUrl: data['linkUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'botanicalName': botanicalName,
      'commonName': commonName,
      'otherCommonName': otherCommonName,
      // Store as int if possible, else string
      'nationalTreeNumber': (nationalTreeNumber is int)
          ? nationalTreeNumber
          : int.tryParse(nationalTreeNumber.toString()) ?? nationalTreeNumber,
      'linkUrl': linkUrl,
    };
  }
}
