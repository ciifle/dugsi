import 'package:flutter/material.dart';
import 'exam_details_page.dart';

// Color palette
const Color kDarkBlue = Color(0xFF023471);
const Color kOrange = Color(0xFF5AB04B);
const Color kBg = Color(0xFFF7F8FA);

// Dummy exam data model
class Exam {
  final String name;
  final String subject;
  final String grade;
  final DateTime date;
  final bool isCompleted;

  Exam({
    required this.name,
    required this.subject,
    required this.grade,
    required this.date,
    required this.isCompleted,
  });
}

// Dummy data
final List<Exam> _exams = [
  Exam(
    name: "Midterm Exam",
    subject: "Mathematics",
    grade: "Class 7A",
    date: DateTime(2024, 6, 21),
    isCompleted: false,
  ),
  Exam(
    name: "Final Exam",
    subject: "History",
    grade: "Class 8B",
    date: DateTime(2024, 3, 15),
    isCompleted: true,
  ),
  Exam(
    name: "Quarterly Test",
    subject: "Physics",
    grade: "Grade 10",
    date: DateTime(2024, 7, 13),
    isCompleted: false,
  ),
  Exam(
    name: "Unit Test I",
    subject: "English",
    grade: "Grade 9",
    date: DateTime(2024, 2, 7),
    isCompleted: true,
  ),
  Exam(
    name: "Pre-Board",
    subject: "Chemistry",
    grade: "Grade 12",
    date: DateTime(2024, 8, 20),
    isCompleted: false,
  ),
];

// Main ExamsPage widget
class ExamsPage extends StatelessWidget {
  const ExamsPage({Key? key}) : super(key: key);

  // Format date for display
  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        backgroundColor: kDarkBlue,
        elevation: 0,
        title: const Text(
          "Exams",
          style: TextStyle(
            color: Colors.white, fontWeight: FontWeight.w600, fontSize: 22,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white, // Ensures all icons (including back arrow) are white
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.add_circle,
              color: kOrange,
              size: 28,
            ),
            tooltip: "Add Exam",
            onPressed: () {
              // TODO: Implement add exam action
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Add Exam tapped!'), duration: Duration(seconds: 1),)
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          itemCount: _exams.length,
          separatorBuilder: (_, __) => const SizedBox(height: 14),
          itemBuilder: (context, index) {
            final exam = _exams[index];
            return ExamTile(
              exam: exam,
              formattedDate: _formatDate(exam.date),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ExamDetailsPage(), // Navigate to the "real" ExamDetailsPage
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

// Reusable widget for each exam card
class ExamTile extends StatelessWidget {
  final Exam exam;
  final String formattedDate;
  final VoidCallback onTap;

  const ExamTile({
    Key? key,
    required this.exam,
    required this.formattedDate,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Card color and border is very minimal/subtle
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Card(
        elevation: 2,
        shadowColor: Colors.black12,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(
            color: exam.isCompleted ? Colors.grey[300]! : kOrange.withOpacity(0.12),
            width: 1.1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          child: Row(
            children: [
              // Leading icon
              Container(
                decoration: BoxDecoration(
                  color: kOrange.withOpacity(0.075),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(10),
                child: Icon(
                  Icons.school_rounded,
                  color: kOrange,
                  size: 27,
                ),
              ),
              const SizedBox(width: 16),
              // Exam description
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Exam name
                    Text(
                      exam.name,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16.7,
                        color: kDarkBlue,
                      ),
                    ),
                    const SizedBox(height: 2),
                    // Subject + Grade Row
                    Row(
                      children: [
                        Text(
                          exam.subject,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14.2,
                            color: kDarkBlue.withOpacity(0.80),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 6),
                          child: Text("•", style: TextStyle(fontSize: 13, color: Colors.grey)),
                        ),
                        Text(
                          exam.grade,
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 13.7,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    // Date + Status Row
                    Row(
                      children: [
                        Icon(Icons.calendar_today_rounded, size: 15, color: kOrange.withOpacity(0.9)),
                        const SizedBox(width: 5),
                        Text(
                          formattedDate,
                          style: const TextStyle(
                            fontSize: 12.8,
                            color: Colors.black54,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Icon(
                          exam.isCompleted
                              ? Icons.check_circle_rounded
                              : Icons.schedule_rounded,
                          size: 15,
                          color: kOrange.withOpacity(0.82),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          exam.isCompleted ? "Completed" : "Upcoming",
                          style: TextStyle(
                            color: exam.isCompleted
                                ? kDarkBlue.withOpacity(0.50)
                                : kDarkBlue,
                            fontWeight: FontWeight.w500,
                            fontSize: 12.5,
                            letterSpacing: 0.1,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Chevron arrow
              Padding(
                padding: const EdgeInsets.only(left: 6.0),
                child: Icon(
                  Icons.chevron_right_rounded,
                  color: kOrange,
                  size: 28,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
