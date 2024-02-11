import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../../exam.dart';
import '../widgets/exam_widget.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Exam> exams = [
    Exam(course: 'Mathematics 1', timestamp: DateTime(2024, 01, 01, 01, 01)),
    Exam(course: 'Databases', timestamp: DateTime(2024, 01, 01, 01, 02)),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exams schedule'),
        actions: [
          IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => _addExamFunction(context)),
          IconButton(
            icon: const Icon(Icons.login),
            onPressed: _signOut,
          ),
        ],
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: exams.length,
        itemBuilder: (context, index) {
          final course = exams[index].course;
          final timestamp = exams[index].timestamp;

          return Card(
              color: Colors.amberAccent,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      timestamp.toString().substring(0, 19),
                      style: const TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
              elevation: 4, // Add elevation for shadow effect
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), // Add rounded corners
                  side: BorderSide(color: Colors.black)) // Add border color
              );
        },
      ),
    );
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
      (route) => false,
    );
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
        });
  }

  void _addExam(Exam exam) {
    setState(() {
      exams.add(exam);
    });
  }
}
