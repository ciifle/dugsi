import 'package:flutter/material.dart';
import 'marks_page.dart';

// Main Exam Details Page
class ExamDetailsPage extends StatelessWidget {
  // Dummy exam data
  final Map<String, dynamic> examData = {
    'examName': 'Mid Term Examination',
    'subject': 'Mathematics',
    'classGrade': 'Grade 8',
    'date': '2024-05-14',
    'totalMarks': 100,
    'status': 'Scheduled',
    'instructions': 'Be punctual. Calculators not allowed.',
    'term': 'Term 2',
    'academicYear': '2023 - 2024',
  };

  ExamDetailsPage({Key? key}) : super(key: key);

  // Colors
  static const Color colorDarkBlue = Color(0xFF023471);
  static const Color colorOrange = Color(0xFF5AB04B);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // For very light background
      appBar: AppBar(
        backgroundColor: colorDarkBlue,
        elevation: 2,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Exam Details',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: colorOrange),
            onPressed: () {
              // Handle edit
            },
            tooltip: 'Edit Exam',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Exam Overview Card
            Card(
              elevation: 4,
              shadowColor: colorDarkBlue.withOpacity(0.10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              margin: const EdgeInsets.only(bottom: 24),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InfoRow(
                      icon: Icons.assignment,
                      label: 'Exam Name',
                      value: examData['examName'],
                      iconColor: colorOrange,
                    ),
                    const SizedBox(height: 12),
                    InfoRow(
                      icon: Icons.menu_book,
                      label: 'Subject',
                      value: examData['subject'],
                      iconColor: colorOrange,
                    ),
                    const SizedBox(height: 12),
                    InfoRow(
                      icon: Icons.class_,
                      label: 'Class / Grade',
                      value: examData['classGrade'],
                      iconColor: colorOrange,
                    ),
                    const SizedBox(height: 12),
                    InfoRow(
                      icon: Icons.date_range,
                      label: 'Exam Date',
                      value: examData['date'],
                      iconColor: colorOrange,
                    ),
                    const SizedBox(height: 12),
                    InfoRow(
                      icon: Icons.stacked_bar_chart,
                      label: 'Total Marks',
                      value: '${examData['totalMarks']}',
                      iconColor: colorOrange,
                    ),
                    const SizedBox(height: 12),
                    InfoRow(
                      icon: Icons.flag,
                      label: 'Status',
                      value: examData['status'],
                      valueStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: examData['status'] == 'Scheduled'
                            ? colorDarkBlue
                            : colorOrange,
                      ),
                      iconColor: colorOrange,
                    ),
                  ],
                ),
              ),
            ),

            // ACTION BUTTONS SECTION
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                OrangeButton(
                  text: 'View Marks',
                  icon: Icons.visibility,
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const MarksPage(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 14),
                OrangeButton(
                  text: 'Add / Update Marks',
                  icon: Icons.add_circle_outline,
                  onPressed: () {
                    // Action for adding/updating marks
                  },
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Optional Info Section
            if (examData['instructions'] != null ||
                examData['term'] != null ||
                examData['academicYear'] != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Additional Information',
                    style: TextStyle(
                      color: colorDarkBlue,
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (examData['instructions'] != null)
                    InfoRow(
                      icon: Icons.info_outline,
                      label: 'Instructions',
                      value: examData['instructions'],
                      iconColor: colorOrange,
                    ),
                  if (examData['instructions'] != null) const SizedBox(height: 13),
                  if (examData['term'] != null)
                    InfoRow(
                      icon: Icons.timeline,
                      label: 'Term',
                      value: examData['term'],
                      iconColor: colorOrange,
                    ),
                  if (examData['term'] != null) const SizedBox(height: 13),
                  if (examData['academicYear'] != null)
                    InfoRow(
                      icon: Icons.calendar_today,
                      label: 'Academic Year',
                      value: examData['academicYear'],
                      iconColor: colorOrange,
                    ),
                ],
              ),
            // SizedBox for bottom padding
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

/// A reusable horizontal info row with icon, label and value.
class InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color iconColor;
  final TextStyle? valueStyle;

  const InfoRow({
    Key? key,
    required this.icon,
    required this.label,
    required this.value,
    this.iconColor = const Color(0xFF5AB04B),
    this.valueStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2.0),
          child: Icon(icon, color: iconColor, size: 22),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w600,
                  fontSize: 13.6,
                  letterSpacing: 0.06,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: valueStyle ??
                    TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Orange full-width button with icon and white text.
class OrangeButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onPressed;

  const OrangeButton({
    Key? key,
    required this.text,
    required this.icon,
    required this.onPressed,
  }) : super(key: key);

  static const Color colorOrange = Color(0xFF5AB04B);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 46,
      child: ElevatedButton.icon(
        icon: Icon(icon, color: Colors.white, size: 22),
        label: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 15.5,
            letterSpacing: 0.01,
          ),
        ),
        style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all<Color>(colorOrange),
          shadowColor: MaterialStateProperty.all<Color>(colorOrange.withOpacity(0.1)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          elevation: MaterialStateProperty.all<double>(2),
        ),
        onPressed: onPressed,
      ),
    );
  }
}
