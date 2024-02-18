import 'package:cloud_firestore/cloud_firestore.dart';

class ExamModel {
  final String? subject;
  final Timestamp? timestamp;
  final String? id;
  final String? longitude;
  final String? latitude;

  ExamModel(
      {this.id, this.subject, this.timestamp, this.longitude, this.latitude});

  static ExamModel fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return ExamModel(
      subject: snapshot['subject'],
      timestamp: snapshot['timestamp'],
      id: snapshot['id'],
      longitude: snapshot['longitude'],
      latitude: snapshot['latitude'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "subject": subject,
      "timestamp": timestamp,
      "id": id,
      "longitude": longitude,
      "latitude": latitude,
    };
  }

  void _createData(ExamModel examModel) {
    final examCollection = FirebaseFirestore.instance.collection("exams");

    String id = examCollection.doc().id;
    final newExam = ExamModel(
      subject: examModel.subject,
      timestamp: examModel.timestamp,
      id: examModel.id,
      longitude: examModel.longitude,
      latitude: examModel.latitude,
    ).toJson();

    examCollection.doc(id).set(newExam);
  }

  Stream<List<ExamModel>> _readData() {
    final examCollection = FirebaseFirestore.instance.collection("exams");

    return examCollection.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => ExamModel.fromSnapshot(e)).toList());
  }
}
