import 'package:flutter/material.dart';

// --- Color Constants ---
const Color kDarkBlue = Color(0xFF023471);
const Color kOrange = Color(0xFF5AB04B);
const Color kBgColor = Color(0xFFF7F8FA); // optional: faint light grey for background

class SubjectDetailsPage extends StatelessWidget {
  // Dummy subject data
  final Map<String, String> subject = const {
    'name': 'Mathematics',
    'code': 'MATH101',
    'class': 'Grade 10',
    'teacher': 'Mr. Alan Turing',
    'status': 'Active',
  };

  // Dummy exams data
  final List<Map<String, String>> exams = const [
    {
      'name': 'Midterm Exam',
      'totalMarks': '100',
      'date': 'March 10, 2024',
      'term': 'Term 1'
    },
    {
      'name': 'Final Exam',
      'totalMarks': '120',
      'date': 'June 20, 2024',
      'term': 'Term 2'
    },
    {
      'name': 'Quiz - Algebra',
      'totalMarks': '20',
      'date': 'February 2, 2024',
      'term': 'Term 1'
    },
    {
      'name': 'Project Assessment',
      'totalMarks': '30',
      'date': 'May 3, 2024',
      'term': 'Term 2'
    },
  ];

  SubjectDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgColor,
      appBar: AppBar(
        backgroundColor: kDarkBlue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
          tooltip: "Back",
        ),
        title: const Text(
          'Subject Details',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.2,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: kOrange),
            tooltip: 'Edit Subject',
            onPressed: () {
              // Implement edit action
            },
          ),
          const SizedBox(width: 4),
        ],
        elevation: 3,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _SubjectOverviewCard(subject: subject),
            const SizedBox(height: 26),
            const Text(
              "Exams",
              style: TextStyle(
                color: kDarkBlue,
                fontSize: 18.5,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.02,
              ),
            ),
            const SizedBox(height: 12),
            ...exams.map((exam) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: ExamTile(
                  examName: exam['name'] ?? '',
                  totalMarks: exam['totalMarks'] ?? '',
                  date: exam['date'] ?? '',
                  term: exam['term'] ?? '',
                ),
              );
            }).toList(),
            SizedBox(height: 24), // For spacing above button if scrolled
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.all(18),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.add, color: Colors.white),
            label: const Padding(
              padding: EdgeInsets.symmetric(vertical: 13),
              child: Text(
                'Add Exam',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 17,
                  color: Colors.white,
                  letterSpacing: 0.1,
                ),
              ),
            ),
            onPressed: () {
              // Implement Add Exam functionality
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: kOrange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
          ),
        ),
      ),
    );
  }
}

// SUBJECT OVERVIEW CARD
class _SubjectOverviewCard extends StatelessWidget {
  final Map<String, String> subject;
  const _SubjectOverviewCard({required this.subject});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 8,
      shadowColor: kDarkBlue.withOpacity(0.10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              subject['name'] ?? '',
              style: const TextStyle(
                color: kDarkBlue,
                fontWeight: FontWeight.w800,
                fontSize: 22.5,
                letterSpacing: 0.01,
              ),
            ),
            const SizedBox(height: 10),
            InfoRow(
              icon: Icons.confirmation_number_rounded,
              label: "Code",
              value: subject['code'] ?? '',
            ),
            const SizedBox(height: 5),
            InfoRow(
              icon: Icons.class_rounded,
              label: "Class",
              value: subject['class'] ?? '',
            ),
            const SizedBox(height: 5),
            InfoRow(
              icon: Icons.person,
              label: "Teacher",
              value: subject['teacher'] ?? '',
            ),
            const SizedBox(height: 5),
            InfoRow(
              icon: Icons.check_circle_rounded,
              label: "Status",
              valueWidget: Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: kOrange.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  subject['status'] ?? '',
                  style: const TextStyle(
                    color: kOrange,
                    fontWeight: FontWeight.bold,
                    fontSize: 13.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// REUSABLE INFO ROW
class InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? value;
  final Widget? valueWidget;

  const InfoRow({
    required this.icon,
    required this.label,
    this.value,
    this.valueWidget,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, color: kOrange, size: 22),
        const SizedBox(width: 12),
        Text(
          '$label:',
          style: const TextStyle(
            color: kDarkBlue,
            fontWeight: FontWeight.w600,
            fontSize: 15.1,
          ),
        ),
        const SizedBox(width: 10),
        Flexible(
          child: valueWidget ??
              Text(
                value ?? '',
                style: const TextStyle(
                  color: kDarkBlue,
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
        ),
      ],
    );
  }
}

// REUSABLE EXAM TILE WIDGET
class ExamTile extends StatelessWidget {
  final String examName;
  final String totalMarks;
  final String date;
  final String term;

  const ExamTile({
    required this.examName,
    required this.totalMarks,
    required this.date,
    required this.term,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      elevation: 3,
      shadowColor: kDarkBlue.withOpacity(0.07),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: kDarkBlue.withOpacity(0.07),
            width: 1,
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 18),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.notes_rounded, color: kOrange, size: 32),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    examName,
                    style: const TextStyle(
                      color: kDarkBlue,
                      fontWeight: FontWeight.w700,
                      fontSize: 16.8,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 14,
                    runSpacing: 7,
                    children: [
                      _ExamInfoChip(
                        icon: Icons.score_rounded,
                        text: '$totalMarks marks',
                      ),
                      _ExamInfoChip(
                        icon: Icons.date_range_rounded,
                        text: date,
                      ),
                      _ExamInfoChip(
                        icon: Icons.timeline_rounded,
                        text: term,
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

// Helper widget for exam info chips.
class _ExamInfoChip extends StatelessWidget {
  final IconData icon;
  final String text;
  const _ExamInfoChip({required this.icon, required this.text, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: kOrange, size: 18),
        const SizedBox(width: 5),
        Flexible(
          child: Text(
            text,
            style: const TextStyle(
              color: kDarkBlue,
              fontWeight: FontWeight.w500,
              fontSize: 13.5,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }
}
