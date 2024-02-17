import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lab3/exam_model.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  final List<ExamModel> exams;

  const CalendarPage({Key? key, required this.exams}) : super(key: key);

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime? _selectedDay;

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  List<ExamModel> getExamsForSelectedDay() {
    if (_selectedDay == null) {
      return [];
    }
    return widget.exams.where((exam) {
      return isSameDay(exam.timestamp!.toDate(), _selectedDay!);
    }).toList();
  }

  List<ExamModel> _getEventsForDay(DateTime day) {
    return widget.exams
        .where((exam) => isSameDay(exam.timestamp!.toDate(), day))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar Page'),
      ),
      body: Center(
        child: Column(
          children: [
            TableCalendar(
              firstDay: DateTime.utc(2000, 1, 1),
              lastDay: DateTime.utc(2030, 1, 1),
              focusedDay: DateTime.now(),
              selectedDayPredicate: (day) {
                return _selectedDay != null && isSameDay(_selectedDay!, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                });
              },
              eventLoader: _getEventsForDay,
            ),
            const SizedBox(height: 20),
            const Text('Exams for the selected day:'),
            Expanded(
              child: ExamListView(exams: getExamsForSelectedDay()),
            ),
          ],
        ),
      ),
    );
  }
}

class ExamListView extends StatelessWidget {
  final List<ExamModel> exams;

  const ExamListView({Key? key, required this.exams}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return exams.isEmpty
        ? const Center(child: Text('No exams for the selected day.'))
        : ListView.builder(
            itemCount: exams.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(exams[index].subject!),
                subtitle: Text(exams[index]
                    .timestamp!
                    .toDate()
                    .toString()
                    .substring(0, 19)),
              );
            },
          );
  }
}
