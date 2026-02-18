import 'package:flutter/material.dart';

//-----------------------------
// BRAND COLORS
//-----------------------------
const Color kPrimaryColor = Color(0xFF023471); // Dark Blue
const Color kAccentColor = Color(0xFF5AB04B);  // Orange
const Color kBackgroundColor = Color(0xFFF8F9FA); // Very light grey
const Color kTextColor = Color(0xFF023471); // Dark Blue

class TeacherExamsScreen extends StatelessWidget {
  TeacherExamsScreen({Key? key}) : super(key: key);

  // Dummy exam data
  final List<Map<String, dynamic>> exams = [
    {
      'name': 'Mathematics Midterm',
      'class': 'Grade 10-A',
      'subject': 'Mathematics',
      'date': DateTime.now().add(Duration(days: 7)),
      'duration': '90 minutes',
      'status': 'Upcoming',
      'syllabus': 'Algebra, Geometry, Trigonometry',
      'instructions': 'No calculators allowed.',
      'notes': 'Bring geometry tools.'
    },
    {
      'name': 'Chemistry Practical',
      'class': 'Grade 11-B',
      'subject': 'Chemistry',
      'date': DateTime.now().subtract(Duration(days: 3)),
      'duration': '2 hours',
      'status': 'Completed',
      'syllabus': 'Organic reactions, Safety protocol',
      'instructions': 'Lab coat required.',
      'notes': 'Complete worksheet before exam.'
    },
    {
      'name': 'English Literature',
      'class': 'Grade 9-C',
      'subject': 'English',
      'date': DateTime.now().add(Duration(days: 2)),
      'duration': '60 minutes',
      'status': 'Upcoming',
      'syllabus': 'Shakespeare, Poetry, Essay writing',
      'instructions': 'Write in pen.',
      'notes': 'Review all poems.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Summary calculations
    final int totalExams = exams.length;
    final int upcomingExams =
        exams.where((e) => e['status'] == 'Upcoming').length;
    final int completedExams =
        exams.where((e) => e['status'] == 'Completed').length;

    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: const Text(
          'Exams',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 2.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).maybePop();
          },
          tooltip: 'Back',
        ),
      ),
      body: SingleChildScrollView(
        // Prevent overflow: Vertical scrolling only
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              //--------------------------
              // SECTION 1: SUMMARY CARD
              //--------------------------
              ExamSummaryCard(
                total: totalExams,
                upcoming: upcomingExams,
                completed: completedExams,
              ),
              const SizedBox(height: 22),

              //--------------------------
              // SECTION 2: EXAM CARDS LIST
              //--------------------------
              ListView.builder(
                itemCount: exams.length,
                shrinkWrap: true, // Prevent overflow!
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, idx) {
                  final exam = exams[idx];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 18.0),
                    child: ExamCard(
                      exam: exam,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//-------------------------------------------
//  Widget: Exam Summary Card
//-------------------------------------------
class ExamSummaryCard extends StatelessWidget {
  final int total;
  final int upcoming;
  final int completed;
  const ExamSummaryCard({
    Key? key,
    required this.total,
    required this.upcoming,
    required this.completed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // textStyle all with overflow & maxLines
    TextStyle statLabel = const TextStyle(
      color: kTextColor,
      fontWeight: FontWeight.w500,
      fontSize: 14,
    );
    TextStyle statNumber = const TextStyle(
      color: kPrimaryColor,
      fontWeight: FontWeight.bold,
      fontSize: 22,
    );

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(13),
      ),
      elevation: 2.5,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 18),
        child: Wrap(
          alignment: WrapAlignment.spaceBetween,
          runSpacing: 16,
          children: [
            _SummaryItem(
              icon: Icons.assignment,
              color: kAccentColor,
              title: 'Total Exams',
              value: total,
              statNumber: statNumber,
              statLabel: statLabel,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              child: const VerticalDivider(
                thickness: 1.4,
                color: kAccentColor,
                width: 0,
              ),
            ),
            _SummaryItem(
              icon: Icons.schedule,
              color: Colors.deepOrangeAccent,
              title: 'Upcoming',
              value: upcoming,
              statNumber: statNumber,
              statLabel: statLabel,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              child: const VerticalDivider(
                thickness: 1.4,
                color: kAccentColor,
                width: 0,
              ),
            ),
            _SummaryItem(
              icon: Icons.check_circle_outlined,
              color: Colors.green,
              title: 'Completed',
              value: completed,
              statNumber: statNumber,
              statLabel: statLabel,
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final int value;
  final TextStyle statLabel;
  final TextStyle statNumber;
  const _SummaryItem({
    required this.icon,
    required this.color,
    required this.title,
    required this.value,
    required this.statLabel,
    required this.statNumber,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 90,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 5),
          Text(
            '$value',
            style: statNumber,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: statLabel,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

//-------------------------------------------
//  Widget: Exam Card (with ExpansionTile)
//-------------------------------------------
class ExamCard extends StatelessWidget {
  final Map<String, dynamic> exam;
  const ExamCard({Key? key, required this.exam}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final statusColor =
        exam['status'] == 'Upcoming' ? kAccentColor : Colors.green;
    final statusText = exam['status'];
    // Date formatting:
    final DateTime date = exam['date'];
    final dateStr =
        "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(13),
      ),
      elevation: 3,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Exam name and status
            Wrap(
              spacing: 0,
              runSpacing: 6,
              crossAxisAlignment: WrapCrossAlignment.center,
              alignment: WrapAlignment.spaceBetween,
              children: [
                // Exam Name
                Text(
                  exam['name'],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: kTextColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                // Status chip
                Container(
                  margin: const EdgeInsets.only(left: 12, top: 6),
                  child: Chip(
                    label: Text(
                      statusText,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    backgroundColor: statusColor,
                    elevation: 0,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),

            // Class + Subject, Date, Duration
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              runSpacing: 8,
              children: [
                Icon(Icons.class_, color: kPrimaryColor, size: 19),
                const SizedBox(width: 4),
                Text(
                  '${exam['class']} • ${exam['subject']}',
                  style: const TextStyle(
                    color: kTextColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(width: 13),
                Icon(Icons.today, color: kPrimaryColor, size: 18),
                const SizedBox(width: 4),
                Text(
                  dateStr,
                  style: const TextStyle(
                    color: kTextColor,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(width: 13),
                Icon(Icons.timer, color: kAccentColor, size: 18),
                const SizedBox(width: 4),
                Text(
                  exam['duration'],
                  style: const TextStyle(
                    color: kTextColor,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            const SizedBox(height: 14),

            //---------------------------
            // Actions
            //---------------------------
            Wrap(
              spacing: 12,
              runSpacing: 10,
              children: [
                _ExamActionChip(
                  icon: Icons.group,
                  label: 'View Students',
                  onTap: () {},
                ),
                _ExamActionChip(
                  icon: Icons.edit_note,
                  label: 'Enter Marks',
                  onTap: () {},
                ),
                _ExamActionChip(
                  icon: Icons.edit,
                  label: 'Edit Exam',
                  onTap: () {},
                ),
                _ExamActionChip(
                  icon: Icons.assessment,
                  label: 'Results',
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 10),

            //---------------------------------
            // ExpansionTile (Exam Details)
            //---------------------------------
            // Wrapped in Theme to adjust ExpansionTile UI if needed.
            Theme(
              data: Theme.of(context).copyWith(
                dividerColor: Colors.transparent,
                splashColor: kAccentColor.withOpacity(0.09),
              ),
              child: ExpansionTile(
                title: Text(
                  "Details",
                  style: const TextStyle(
                    color: kTextColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                childrenPadding: const EdgeInsets.only(
                  left: 12, right: 4, bottom: 10, top: 0),
                tilePadding: const EdgeInsets.symmetric(horizontal: 2.0),
                expandedAlignment: Alignment.centerLeft,
                maintainState: true,
                children: [
                  _ExamDetailRow(
                    label: 'Syllabus',
                    content: exam['syllabus'] ?? '-',
                  ),
                  const SizedBox(height: 4),
                  _ExamDetailRow(
                    label: 'Instructions',
                    content: exam['instructions'] ?? '-',
                  ),
                  const SizedBox(height: 4),
                  _ExamDetailRow(
                    label: 'Notes',
                    content: exam['notes'] ?? '-',
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

//---------------------------
// Action Chip (Reusable)
//---------------------------
class _ExamActionChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ExamActionChip({
    Key? key,
    required this.icon,
    required this.label,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      onPressed: onTap,
      backgroundColor: kAccentColor.withOpacity(0.13),
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      avatar: Icon(
        icon,
        color: kAccentColor,
        size: 20,
      ),
      label: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          color: kAccentColor,
          fontWeight: FontWeight.w600,
        ),
      ),
      elevation: 0.5,
      pressElevation: 1,
    );
  }
}

//---------------------------
// Exam Detail Row
//---------------------------
class _ExamDetailRow extends StatelessWidget {
  final String label;
  final String content;
  const _ExamDetailRow({required this.label, required this.content});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 8,
      runSpacing: 2,
      children: [
        Text(
          "$label:",
          style: const TextStyle(
            color: kPrimaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 14.5,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          content,
          style: const TextStyle(
            color: kTextColor,
            fontSize: 14,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

