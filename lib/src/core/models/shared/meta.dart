import 'package:cloud_firestore/cloud_firestore.dart';

class Meta {
  Timestamp? createdDate;
  Timestamp? modifiedDate;

  Meta({this.createdDate, this.modifiedDate});

  factory Meta.fromMap(dynamic data) {
    data = data ?? Object();

    return Meta(
      createdDate: data['createdDate'] as Timestamp?,
      modifiedDate: data['modifiedDate'] as Timestamp?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'createdDate': createdDate,
      'modifiedDate': modifiedDate,
    };
  }
}
