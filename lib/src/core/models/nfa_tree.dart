class NFATree {
  final String id;
  final String botanicalName;
  final String commonName;
  final String otherCommonName;
  final int nationalTreeNumber;
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
    return NFATree(
      id: id,
      botanicalName: data['botanicalName'] ?? '',
      commonName: data['commonName'] ?? '',
      otherCommonName: data['otherCommonName'] ?? '',
      nationalTreeNumber: data['nationalTreeNumber'] ?? 0,
      linkUrl: data['linkUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'botanicalName': botanicalName,
      'commonName': commonName,
      'otherCommonName': otherCommonName,
      'nationalTreeNumber': nationalTreeNumber,
      'linkUrl': linkUrl,
    };
  }
}
