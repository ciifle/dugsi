import 'package:flutter/material.dart';

// MAIN SCREEN
class StudentResultsScreen extends StatefulWidget {
  const StudentResultsScreen({Key? key}) : super(key: key);

  @override
  State<StudentResultsScreen> createState() => _StudentResultsScreenState();
}

class _StudentResultsScreenState extends State<StudentResultsScreen> {
  // Dummy result data
  final List<Map<String, dynamic>> _subjects = [
    {
      'name': 'Mathematics',
      'obtained': 87,
      'total': 100,
      'grade': 'A',
      'status': 'Pass',
    },
    {
      'name': 'Science',
      'obtained': 76,
      'total': 100,
      'grade': 'B+',
      'status': 'Pass',
    },
    {
      'name': 'English Literature',
      'obtained': 68,
      'total': 100,
      'grade': 'B',
      'status': 'Pass',
    },
    {
      'name': 'History',
      'obtained': 54,
      'total': 100,
      'grade': 'C+',
      'status': 'Improve',
    },
    {
      'name': 'Physical Education',
      'obtained': 89,
      'total': 100,
      'grade': 'A',
      'status': 'Pass',
    },
  ];

  final List<String> _terms = ["Term 1", "Term 2", "Final"];
  String _selectedTerm = "Term 1";
  final String _remarkText =
      "Great effort this term! Focus on History for improvement next semester.";

  @override
  Widget build(BuildContext context) {
    // COLOR CONSTANTS
    const Color primaryColor = Color(0xFF023471); // Dark Blue
    const Color accentColor = Color(0xFF5AB04B); // Orange
    const Color bgColor = Color(0xFFF9FAFB); // Very light gray

    // Calculate overall
    int totalSubjects = _subjects.length;
    int totalObtained = _subjects.fold<int>(
      0,
      (a, b) => a + b['obtained'] as int,
    );
    int totalMarks = _subjects.fold<int>(0, (a, b) => a + b['total'] as int);

    double overallPercent = totalMarks > 0
        ? (totalObtained / totalMarks) * 100
        : 0.0;
    String resultGrade = overallPercent >= 75
        ? 'A'
        : (overallPercent >= 60 ? 'B' : (overallPercent >= 50 ? 'C' : 'D'));
    String resultStatus = overallPercent >= 50 ? 'Pass' : 'Improve';

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        title: const Text(
          "Results",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            // Typography: Clear
            fontSize: 22,
            overflow: TextOverflow.ellipsis,
            // Ensuring NO overflow in AppBar
            // maxLines removed from TextStyle (invalid param)
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        // Prevents any RenderFlex overflow by scrolling entire body
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // === SECTION 1: OVERALL SUMMARY ===
              _ResultSummaryCard(
                totalSubjects: totalSubjects,
                percent: overallPercent,
                grade: resultGrade,
                status: resultStatus,
                primaryColor: primaryColor,
                accentColor: accentColor,
              ),
              const SizedBox(height: 20),

              // === SECTION 3: TERM DROPDOWN (Optional) ===
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  // Safe padding for dropdown so layout never shifts
                  padding: const EdgeInsets.only(bottom: 18),
                  child: DropdownButton<String>(
                    value: _selectedTerm,
                    borderRadius: BorderRadius.circular(10),
                    style: const TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      overflow: TextOverflow.ellipsis,
                      // maxLines is not a valid parameter for TextStyle, removing it
                    ),
                    icon: const Icon(Icons.arrow_drop_down, color: accentColor),
                    underline: Container(height: 2, color: accentColor),
                    dropdownColor: Colors.white,
                    onChanged: (String? newVal) {
                      if (newVal != null) {
                        setState(() {
                          _selectedTerm = newVal;
                        });
                      }
                    },
                    items: _terms.map((String term) {
                      return DropdownMenuItem<String>(
                        value: term,
                        child: Text(
                          term,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),

              // === SECTION 2: SUBJECT CARDS ===
              // Using Column, not ListView; safe from overflow
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: List.generate(_subjects.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: _SubjectResultCard(
                      subjectName: _subjects[index]['name'],
                      obtained: _subjects[index]['obtained'],
                      total: _subjects[index]['total'],
                      grade: _subjects[index]['grade'],
                      status: _subjects[index]['status'],
                      primaryColor: primaryColor,
                      accentColor: accentColor,
                    ),
                  );
                }),
              ),

              // === SECTION 4: TEACHER REMARKS (Optional) ===
              if (_remarkText.isNotEmpty) ...[
                const SizedBox(height: 22),
                _RemarksCard(remark: _remarkText, primaryColor: primaryColor),
              ],
              const SizedBox(height: 18), // Final safe bottom spacing
            ],
          ),
        ),
      ),
    );
  }
}

// ===== REUSABLE WIDGETS =====

class _ResultSummaryCard extends StatelessWidget {
  final int totalSubjects;
  final double percent;
  final String grade;
  final String status;
  final Color primaryColor;
  final Color accentColor;

  const _ResultSummaryCard({
    Key? key,
    required this.totalSubjects,
    required this.percent,
    required this.grade,
    required this.status,
    required this.primaryColor,
    required this.accentColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Card with minimal, clear info and bold percent
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: accentColor.withOpacity(0.2)),
      ),
      color: Colors.white,
      elevation: 1.5,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Overall %
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Subjects",
                  style: TextStyle(
                    color: primaryColor.withOpacity(0.7),
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '$totalSubjects',
                  style: TextStyle(
                    color: accentColor,
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            const SizedBox(width: 30),

            // Percentage
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Percent",
                  style: TextStyle(
                    color: primaryColor.withOpacity(0.7),
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '${percent.toStringAsFixed(1)}%',
                  style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 21,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            const SizedBox(width: 30),

            // Grade and Status
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Grade",
                    style: TextStyle(
                      color: primaryColor.withOpacity(0.7),
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        grade,
                        style: TextStyle(
                          color: accentColor,
                          fontWeight: FontWeight.w800,
                          fontSize: 20,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(width: 8),
                      _StatusBadge(
                        status: status,
                        accentColor: accentColor,
                        fontColor: primaryColor,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SubjectResultCard extends StatelessWidget {
  final String subjectName;
  final int obtained;
  final int total;
  final String grade;
  final String status;
  final Color primaryColor;
  final Color accentColor;

  const _SubjectResultCard({
    Key? key,
    required this.subjectName,
    required this.obtained,
    required this.total,
    required this.grade,
    required this.status,
    required this.primaryColor,
    required this.accentColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Each subject in a card
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: accentColor.withOpacity(0.19)),
      ),
      color: Colors.white,
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Subject details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name
                  Text(
                    subjectName,
                    style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  // Marks
                  Text(
                    "Marks: $obtained/$total",
                    style: TextStyle(
                      color: primaryColor.withOpacity(0.8),
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  // Grade
                  Text(
                    "Grade: $grade",
                    style: TextStyle(
                      color: accentColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // Status Badge
            _StatusBadge(
              status: status,
              accentColor: accentColor,
              fontColor: primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  final Color accentColor;
  final Color fontColor;

  const _StatusBadge({
    Key? key,
    required this.status,
    required this.accentColor,
    required this.fontColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Orange capsule badge, safe text
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: accentColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: accentColor, width: 1.2),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: accentColor,
          fontWeight: FontWeight.w700,
          fontSize: 13,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class _RemarksCard extends StatelessWidget {
  final String remark;
  final Color primaryColor;

  const _RemarksCard({
    Key? key,
    required this.remark,
    required this.primaryColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Card for teacher remarks
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: primaryColor.withOpacity(0.09)),
      ),
      color: Colors.white,
      elevation: 0.8,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.comment, color: primaryColor.withOpacity(0.8), size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                remark,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
