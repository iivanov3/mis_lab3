import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ExamModel {
  final String? subject;
  final Timestamp? timestamp;
  final String? id;

  ExamModel({this.id, this.subject, this.timestamp});

  static ExamModel fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return ExamModel(
      subject: snapshot['subject'],
      timestamp: snapshot['timestamp'],
      id: snapshot['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "subject": subject,
      "timestamp": timestamp,
      "id": id,
    };
  }

  void _createData(ExamModel examModel) {
    final examCollection = FirebaseFirestore.instance.collection("exams");

    String id = examCollection.doc().id;
    final newExam = ExamModel(
      subject: examModel.subject,
      timestamp: examModel.timestamp,
      id: examModel.id,
    ).toJson();

    examCollection.doc(id).set(newExam);
  }

  Stream<List<ExamModel>> _readData() {
    final examCollection = FirebaseFirestore.instance.collection("exams");

    return examCollection.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => ExamModel.fromSnapshot(e)).toList());
  }
}
