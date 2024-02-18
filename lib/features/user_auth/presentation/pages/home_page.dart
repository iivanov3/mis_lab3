import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lab3/exam_model.dart';
import 'package:lab3/features/user_auth/presentation/pages/calendar_page.dart';
import 'package:lab3/features/user_auth/presentation/widgets/map_widget.dart';
import 'package:lab3/notification_controller.dart';
import '../widgets/exam_widget.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    AwesomeNotifications().setListeners(
        onActionReceivedMethod: NotificationController.onActionReceivedMethod,
        onNotificationCreatedMethod:
            NotificationController.onNotificationCreatedMethod,
        onNotificationDisplayedMethod:
            NotificationController.onNotificationDisplayedMethod,
        onDismissActionReceivedMethod:
            NotificationController.onDismissedReceivedMethod);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exams schedule'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _addExamFunction(context),
          ),
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () => _toCalendarPage(),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _signOut,
          ),
        ],
      ),
      body: StreamBuilder<List<ExamModel>>(
        stream: _readData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.waiting &&
              snapshot.hasData &&
              snapshot.hasData != null) {
            final List<ExamModel> exams = snapshot.data!;

            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: exams.length,
              itemBuilder: (context, index) {
                final subject = exams[index].subject;
                final timestamp = exams[index].timestamp;

                return Card(
                  color: Colors.amberAccent,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: Colors.black),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          subject!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          timestamp!.toDate().toString().substring(0, 19),
                          style: const TextStyle(color: Colors.black),
                        ),
                        const SizedBox(height: 60.0),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MapClass(
                                  latitude:
                                      double.tryParse(exams[index].latitude!)!,
                                  longitude:
                                      double.tryParse(exams[index].longitude!)!,
                                  locationName: "FINKI",
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.lightBlueAccent,
                            padding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 40),
                            textStyle: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            elevation: 3,
                          ),
                          child: Text(
                            'See location',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) => LoginPage()), (route) => false);
  }

  Future<void> _addExamFunction(BuildContext context) async {
    return showModalBottomSheet(
      context: context,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          behavior: HitTestBehavior.opaque,
          child: ExamWidget(
            addExam: _addExam,
          ),
        );
      },
    );
  }

  void _addExam(ExamModel examModel) {
    setState(() {
      _createData(examModel);
      AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 1,
          channelKey: "basic_channel",
          title: "Exam added",
          body: "You have successfully added an exam.",
        ),
      );
    });
  }

  void _createData(ExamModel examModel) {
    final examCollection = FirebaseFirestore.instance.collection("exams");

    String id = examCollection.doc().id;
    final newExam = ExamModel(
      subject: examModel.subject,
      timestamp: examModel.timestamp,
      id: id,
      latitude: examModel.latitude,
      longitude: examModel.longitude,
    ).toJson();

    examCollection.doc(id).set(newExam);
  }

  Stream<List<ExamModel>> _readData() {
    final examCollection = FirebaseFirestore.instance.collection("exams");

    return examCollection.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => ExamModel.fromSnapshot(e)).toList());
  }

  void _toCalendarPage() async {
    final exams = await _readData().first;

    Navigator.push(context,
        MaterialPageRoute(builder: (context) => CalendarPage(exams: exams)));
  }
}
