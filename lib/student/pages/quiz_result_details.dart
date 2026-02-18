import 'package:flutter/material.dart';

// Dummy Data Models
class QuizResult {
  final String quizName;
  final String subject;
  final int totalMarks;
  final int obtainedMarks;
  final List<QuestionResult> questionResults;
  final String teacherRemarks;

  QuizResult({
    required this.quizName,
    required this.subject,
    required this.totalMarks,
    required this.obtainedMarks,
    required this.questionResults,
    required this.teacherRemarks,
  });

  double get percentage =>
      totalMarks == 0 ? 0 : (obtainedMarks / totalMarks) * 100;

  bool get isPassed => percentage >= 40.0; // Example pass rule
}

class QuestionResult {
  final int number;
  final int obtained;
  final int max;
  final bool isCorrect;

  QuestionResult({
    required this.number,
    required this.obtained,
    required this.max,
    required this.isCorrect,
  });
}

// Dummy quiz result for demo
final QuizResult kDummyResult = QuizResult(
  quizName: "Mid-Term Mathematics Quiz",
  subject: "Mathematics",
  totalMarks: 20,
  obtainedMarks: 16,
  questionResults: [
    QuestionResult(number: 1, obtained: 2, max: 2, isCorrect: true),
    QuestionResult(number: 2, obtained: 1, max: 2, isCorrect: false),
    QuestionResult(number: 3, obtained: 2, max: 2, isCorrect: true),
    QuestionResult(number: 4, obtained: 2, max: 2, isCorrect: true),
    QuestionResult(number: 5, obtained: 2, max: 2, isCorrect: true),
    QuestionResult(number: 6, obtained: 0, max: 2, isCorrect: false),
    QuestionResult(number: 7, obtained: 2, max: 2, isCorrect: true),
    QuestionResult(number: 8, obtained: 1, max: 2, isCorrect: false),
    QuestionResult(number: 9, obtained: 2, max: 2, isCorrect: true),
    QuestionResult(number: 10, obtained: 2, max: 2, isCorrect: true),
  ],
  teacherRemarks:
      "Excellent job overall! Revise your approach to the incorrect answers for better understanding.",
);

class StudentQuizResultScreen extends StatelessWidget {
  final QuizResult result;

  StudentQuizResultScreen({Key? key, QuizResult? result})
      : result = result ?? kDummyResult,
        super(key: key);

  Color get _darkBlue => const Color(0xFF023471);
  Color get _orange => const Color(0xFF5AB04B);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: _darkBlue,
        title: const Text(
          'Quiz Result',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            overflow: TextOverflow.ellipsis,
            fontSize: 22,
          ),
          maxLines: 1,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 1,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // SECTION 1: Quiz Summary Card
              _QuizSummaryCard(result: result, darkBlue: _darkBlue, orange: _orange),
              const SizedBox(height: 24),

              // SECTION 2: Result Table
              const Text(
                "Question-wise Breakdown",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF023471),
                  overflow: TextOverflow.ellipsis,
                ),
                maxLines: 1,
              ),
              const SizedBox(height: 6),
              _ResultTable(result: result, darkBlue: _darkBlue, orange: _orange),
              const SizedBox(height: 24),

              // SECTION 3: Teacher Remarks
              const Text(
                "Teacher's Remarks",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF023471),
                  overflow: TextOverflow.ellipsis,
                ),
                maxLines: 1,
              ),
              const SizedBox(height: 6),
              _TeacherRemarksCard(remarks: result.teacherRemarks, orange: _orange),
            ],
          ),
        ),
      ),
    );
  }
}

// Quiz Summary Card
class _QuizSummaryCard extends StatelessWidget {
  final QuizResult result;
  final Color darkBlue;
  final Color orange;

  const _QuizSummaryCard({
    Key? key,
    required this.result,
    required this.darkBlue,
    required this.orange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool passed = result.isPassed;
    String statusText = passed ? "Pass" : "Fail";
    Color statusColor = passed ? darkBlue : orange;

    return Card(
      color: darkBlue.withOpacity(0.045),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Quiz Name
            Text(
              result.quizName,
              style: TextStyle(
                color: darkBlue,
                fontSize: 18,
                fontWeight: FontWeight.w700,
                overflow: TextOverflow.ellipsis,
              ),
              maxLines: 1,
            ),
            const SizedBox(height: 4),
            // Subject
            Text(
              "Subject: ${result.subject}",
              style: TextStyle(
                color: darkBlue.withOpacity(0.75),
                fontSize: 15,
                fontWeight: FontWeight.w500,
                overflow: TextOverflow.ellipsis,
              ),
              maxLines: 1,
            ),
            const SizedBox(height: 8),
            // Marks, percentage & status row
            Wrap(
              runSpacing: 8,
              spacing: 32,
              children: [
                _summaryChip(
                  icon: Icons.score,
                  label: 'Total Marks',
                  value: "${result.totalMarks}",
                  color: darkBlue,
                ),
                _summaryChip(
                  icon: Icons.assignment_turned_in_outlined,
                  label: 'Obtained',
                  value: "${result.obtainedMarks}",
                  color: orange,
                ),
                _summaryChip(
                  icon: Icons.percent,
                  label: 'Percent',
                  value: "${result.percentage.toStringAsFixed(1)}%",
                  color: darkBlue,
                ),
                _summaryChip(
                  icon: passed
                      ? Icons.check_circle_outline
                      : Icons.cancel_outlined,
                  label: 'Status',
                  value: statusText,
                  color: statusColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryChip(
      {required IconData icon,
      required String label,
      required String value,
      required Color color}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color.withOpacity(0.82), size: 19),
        const SizedBox(width: 5),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: color.withOpacity(0.73),
                fontWeight: FontWeight.w400,
                fontSize: 13,
                overflow: TextOverflow.ellipsis,
              ),
              maxLines: 1,
            ),
            Text(
              value,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 15,
                overflow: TextOverflow.ellipsis,
              ),
              maxLines: 1,
            ),
          ],
        ),
      ],
    );
  }
}

// Question-wise Result Table
class _ResultTable extends StatelessWidget {
  final QuizResult result;
  final Color darkBlue;
  final Color orange;

  const _ResultTable({
    Key? key,
    required this.result,
    required this.darkBlue,
    required this.orange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Table: Horizontal scroll is always enabled by wrapping with SingleChildScrollView(horizontal)
    return Card(
      color: darkBlue.withOpacity(0.025),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: EdgeInsets.zero,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            DataColumn(
              label: Text(
                'Q No',
                style: TextStyle(
                  color: darkBlue,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  overflow: TextOverflow.ellipsis,
                ),
                maxLines: 1,
              ),
            ),
            DataColumn(
              label: Text(
                'Marks Obtained',
                style: TextStyle(
                  color: darkBlue,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  overflow: TextOverflow.ellipsis,
                ),
                maxLines: 1,
              ),
            ),
            DataColumn(
              label: Text(
                'Max Marks',
                style: TextStyle(
                  color: darkBlue,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  overflow: TextOverflow.ellipsis,
                ),
                maxLines: 1,
              ),
            ),
            DataColumn(
              label: Text(
                'Status',
                style: TextStyle(
                  color: darkBlue,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  overflow: TextOverflow.ellipsis,
                ),
                maxLines: 1,
              ),
            ),
          ],
          rows: result.questionResults.map((q) {
            return DataRow(
              cells: [
                DataCell(
                  Text(
                    "${q.number}",
                    style: TextStyle(
                      color: darkBlue,
                      fontWeight: FontWeight.w500,
                      fontSize: 12.5,
                      overflow: TextOverflow.ellipsis,
                    ),
                    maxLines: 1,
                  ),
                ),
                DataCell(
                  Text(
                    "${q.obtained}",
                    style: TextStyle(
                      color: q.isCorrect ? darkBlue : orange,
                      fontWeight: FontWeight.w500,
                      fontSize: 12.5,
                      overflow: TextOverflow.ellipsis,
                    ),
                    maxLines: 1,
                  ),
                ),
                DataCell(
                  Text(
                    "${q.max}",
                    style: TextStyle(
                      color: darkBlue.withOpacity(0.75),
                      fontWeight: FontWeight.w500,
                      fontSize: 12.5,
                      overflow: TextOverflow.ellipsis,
                    ),
                    maxLines: 1,
                  ),
                ),
                DataCell(
                  Row(
                    children: [
                      Icon(
                        q.isCorrect ?
                          Icons.check_circle_outline :
                          Icons.cancel_outlined,
                        color: q.isCorrect ? darkBlue : orange,
                        size: 17,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        q.isCorrect ? "Correct" : "Wrong",
                        style: TextStyle(
                          color: q.isCorrect ? darkBlue : orange,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          overflow: TextOverflow.ellipsis,
                        ),
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
              ],
            );
          }).toList(),
          // No fixed column spacing, allows tight responsive table
          headingRowColor: MaterialStateProperty.resolveWith<Color?>(
              (states) => Colors.transparent),
          dataRowColor: MaterialStateProperty.resolveWith<Color?>(
            (states) => Colors.transparent,
          ),
          dividerThickness: 0.5,
        ),
      ),
    );
  }
}

// Teacher Remarks Card
class _TeacherRemarksCard extends StatelessWidget {
  final String remarks;
  final Color orange;

  const _TeacherRemarksCard({
    Key? key,
    required this.remarks,
    required this.orange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: orange.withOpacity(0.07),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.comment_outlined,
              color: orange,
              size: 24,
            ),
            const SizedBox(width: 8),
            // Constrained to avoid overflow on ultra-long remarks
            Expanded(
              child: Text(
                remarks,
                style: TextStyle(
                  color: orange,
                  fontWeight: FontWeight.w600,
                  fontSize: 14.5,
                  overflow: TextOverflow.ellipsis,
                ),
                maxLines: 4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
