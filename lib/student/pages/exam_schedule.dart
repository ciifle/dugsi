import 'package:flutter/material.dart';

// BRAND COLORS (MANDATORY)
const Color _kPrimaryColor = Color(0xFF023471); // Dark Blue
const Color _kAccentColor = Color(0xFF5AB04B);  // Orange
const Color _kBackgroundColor = Color(0xFFF8F9FA); // Very light grey

class StudentExamScheduleScreen extends StatelessWidget {
  StudentExamScheduleScreen({Key? key}) : super(key: key);

  // Dummy exam data, each exam MUST have a unique timestamp for date grouping.
  final List<Map<String, dynamic>> _exams = [
    {
      "name": "Midterm Examination",
      "subject": "Mathematics",
      "date": DateTime(2024, 6, 18, 9, 0),
      "endTime": DateTime(2024, 6, 18, 11, 0),
      "duration": "2h",
      "room": "Room A201",
      "isOnline": false,
      "status": "Upcoming",
      "instructions": "Arrive 10 minutes early. Bring calculator and ID card. Mobile phones not allowed.",
      "syllabus": "Chapters 1-6: Algebra, Trigonometry, Calculus. Practice previous year papers.",
      "teacher": "Ms. Evelyn Harper",
    },
    {
      "name": "Final Exam",
      "subject": "History",
      "date": DateTime(2024, 6, 22, 14, 0),
      "endTime": DateTime(2024, 6, 22, 17, 0),
      "duration": "3h",
      "room": "Online",
      "isOnline": true,
      "status": "Upcoming",
      "instructions": "Stable internet connection required. Webcam must be ON throughout.",
      "syllabus": "World Wars, Industrial Revolution, Colonialism.",
      "teacher": "Mr. Alan Shepherd",
    },
    {
      "name": "Quiz 2",
      "subject": "Physics",
      "date": DateTime(2024, 5, 28, 10, 30),
      "endTime": DateTime(2024, 5, 28, 11, 30),
      "duration": "1h",
      "room": "Room B102",
      "isOnline": false,
      "status": "Completed",
      "instructions": "No electronic devices allowed. Carry only transparent stationery.",
      "syllabus": "Chapter 4: Newton's Laws. Chapter 5: Energy.",
      "teacher": "Dr. Wendy Lin",
    },
    {
      "name": "Assignment Assessment",
      "subject": "Computer Science",
      "date": DateTime(2024, 5, 20, 16, 0),
      "endTime": DateTime(2024, 5, 20, 17, 30),
      "duration": "1.5h",
      "room": "Online",
      "isOnline": true,
      "status": "Completed",
      "instructions": "Individual work only. Code must be submitted before end time.",
      "syllabus": "Unit 3: Data structures. Unit 4: Algorithms.",
      "teacher": "Ms. Rebecca Storm",
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Calculate summary counts
    final int totalCount = _exams.length;
    final int upcomingCount = _exams.where((e) => e['status'] == 'Upcoming').length;
    final int completedCount = _exams.where((e) => e['status'] == 'Completed').length;

    // Group exams by date (YYYY-MM-DD)
    final Map<DateTime, List<Map<String, dynamic>>> examsByDate = {};
    for (final exam in _exams) {
      final dt = exam['date'] as DateTime;
      final grouped = DateTime(dt.year, dt.month, dt.day); // strip time part
      examsByDate.putIfAbsent(grouped, () => []).add(exam);
    }
    // Sort by (latest upcoming on top)
    final List<DateTime> sortedDates = examsByDate.keys.toList()
      ..sort((a, b) => b.compareTo(a));

    return Scaffold(
      backgroundColor: _kBackgroundColor,
      appBar: AppBar(
        backgroundColor: _kPrimaryColor,
        elevation: 1,
        centerTitle: true,
        automaticallyImplyLeading: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Exam Schedule",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.2,
            fontSize: 20,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: SingleChildScrollView(
        // ABSOLUTE SAFETY RULE: Always wraps everything.
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // SECTION 1: HEADER SUMMARY CARD
              _SummaryHeaderCard(
                total: totalCount,
                upcoming: upcomingCount,
                completed: completedCount,
              ),
              const SizedBox(height: 24),

              // SECTION 2 & 3: DATE GROUPING + EXAM CARDS/EXPANDABLE
              ...sortedDates.map((date) => _ExamDateSection(
                    date: date,
                    exams: examsByDate[date]!,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

/// ------------------------
/// Section 1: Header Summary Card
/// ------------------------
class _SummaryHeaderCard extends StatelessWidget {
  final int total, upcoming, completed;
  const _SummaryHeaderCard({
    required this.total,
    required this.upcoming,
    required this.completed,
  });

  @override
  Widget build(BuildContext context) {
    // Use Safe Row & Expanded to guarantee no overflow.
    return Card(
      color: Colors.white,
      elevation: 3,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 16.0),
        child: Row(
          // Wrap not needed unless many, but 3 summary items is safe in Row if we use Expanded!
          children: [
            Expanded(
              child: _SummaryItem(
                icon: Icons.list_alt_rounded,
                label: "Total",
                value: total.toString(),
                color: _kPrimaryColor,
                accent: false,
              ),
            ),
            Container(
              width: 1,
              height: 46,
              color: _kBackgroundColor,
              margin: const EdgeInsets.symmetric(horizontal: 6),
            ),
            Expanded(
              child: _SummaryItem(
                icon: Icons.upcoming_rounded,
                label: "Upcoming",
                value: upcoming.toString(),
                color: _kAccentColor,
                accent: true,
              ),
            ),
            Container(
              width: 1,
              height: 46,
              color: _kBackgroundColor,
              margin: const EdgeInsets.symmetric(horizontal: 6),
            ),
            Expanded(
              child: _SummaryItem(
                icon: Icons.check_circle_outline_rounded,
                label: "Completed",
                value: completed.toString(),
                color: _kPrimaryColor,
                accent: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final bool accent;
  const _SummaryItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    // Guarantee vertical layout, no risk of overflow
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 17,
          backgroundColor: accent ? _kAccentColor.withOpacity(0.12) : _kPrimaryColor.withOpacity(0.10),
          child: Icon(icon, color: color, size: 21),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: color,
            letterSpacing: 0.3,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            color: _kPrimaryColor.withOpacity(0.65),
            fontWeight: FontWeight.w500,
            fontSize: 13.5,
            letterSpacing: 0.05,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

/// ------------------------
/// Section 2: Date Group Heading
/// Section 3: ExamCards
/// ------------------------

class _ExamDateSection extends StatelessWidget {
  final DateTime date;
  final List<Map<String, dynamic>> exams;
  const _ExamDateSection({required this.date, required this.exams});

  String get _humanDate {
    // Example: "18 June 2024"
    final months = [
      "January", "February", "March", "April", "May", "June",
      "July", "August", "September", "October", "November", "December"
    ];
    return "${date.day} ${months[date.month - 1]} ${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    // Date header with orange underline indicator
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Row(
          children: [
            Text(
              _humanDate,
              style: const TextStyle(
                fontSize: 16.5,
                fontWeight: FontWeight.w600,
                color: _kPrimaryColor,
                letterSpacing: 0.1,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(width: 7),
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: _kAccentColor,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
        Container(
          margin: const EdgeInsets.only(top: 3, bottom: 10),
          height: 2,
          width: 40,
          color: _kAccentColor,
        ),
        // List of exams under this date
        ListView.builder(
          itemCount: exams.length,
          shrinkWrap: true, // SAFETY RULE
          physics: const NeverScrollableScrollPhysics(), // SAFETY RULE
          itemBuilder: (context, idx) {
            final exam = exams[idx];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: _ExamCard(exam: exam),
            );
          },
        ),
      ],
    );
  }
}

/// SECTION 3: Modern Exam Card ─ Safe, touch-friendly

class _ExamCard extends StatelessWidget {
  final Map<String, dynamic> exam;
  const _ExamCard({required this.exam});

  String _formatTime(DateTime dt) {
    // 09:00 or 14:30 (24-hr, removes seconds)
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return "$h:$m";
  }

  @override
  Widget build(BuildContext context) {
    final DateTime date = exam['date'];
    final DateTime? endTime = exam['endTime'];
    final bool isUpcoming = exam['status'] == 'Upcoming';

    // All text labels set appropriately
    String location;
    IconData locationIcon;
    if (exam['isOnline'] == true) {
      location = "Online";
      locationIcon = Icons.laptop_chromebook_rounded;
    } else {
      location = exam['room'] ?? "TBA";
      locationIcon = Icons.meeting_room_rounded;
    }

    final status = exam['status'];
    String badgeText;
    Color badgeColor, borderColor, textColor;
    if (isUpcoming) {
      badgeText = "Upcoming";
      badgeColor = _kAccentColor;
      borderColor = _kAccentColor;
      textColor = Colors.white;
    } else {
      badgeText = "Completed";
      badgeColor = Colors.transparent;
      borderColor = _kPrimaryColor;
      textColor = _kPrimaryColor;
    }

    return Card(
      color: Colors.white,
      elevation: 3,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.only(left: 12, top: 13, right: 10, bottom: 0),
        child: Stack(
          children: [
            // Main Content
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title Row + Status badge
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Main info block -- use Expanded for no overflow
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            exam['name'] ?? "-",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.2,
                              color: _kPrimaryColor,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            exam['subject'] ?? "-",
                            style: const TextStyle(
                              color: _kPrimaryColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 13.5,
                              letterSpacing: 0.1,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 10),
                          // Time, Duration, Location as a Wrap to prevent overflow
                          Wrap(
                            spacing: 14,
                            runSpacing: 2,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.access_time_rounded,
                                      size: 15,
                                      color: _kAccentColor),
                                  const SizedBox(width: 3),
                                  Text(
                                    _formatTime(date) +
                                        (endTime != null
                                            ? " – ${_formatTime(endTime)}"
                                            : ""),
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: _kAccentColor,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.timer_rounded,
                                      size: 15, color: _kPrimaryColor),
                                  const SizedBox(width: 3),
                                  Text(
                                    exam['duration'] ?? "-",
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: _kPrimaryColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    locationIcon,
                                    size: 15,
                                    color: _kPrimaryColor.withOpacity(.7),
                                  ),
                                  const SizedBox(width: 3),
                                  Text(
                                    location,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: _kPrimaryColor.withOpacity(
                                          (exam['isOnline'] == true) ? 0.82 : 0.90),
                                      fontWeight: FontWeight.w500,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                        ],
                      ),
                    ),
                    // Status Badge (top-right), always SAFE since not inside a Row with text
                    _ExamStatusBadge(
                      isUpcoming: isUpcoming,
                      badgeText: badgeText,
                      badgeColor: badgeColor,
                      borderColor: borderColor,
                      textColor: textColor,
                    ),
                  ],
                ),
                // ExpansionTile for details - no fixed height
                Padding(
                  padding: const EdgeInsets.only(right: 2.0),
                  child: Theme(
                    // Minimize ExpansionTile icon size for subtle look
                    data: Theme.of(context).copyWith(
                      dividerColor: Colors.transparent,
                      visualDensity: VisualDensity.compact,
                      listTileTheme: const ListTileThemeData(
                        dense: true,
                        horizontalTitleGap: 0,
                        minVerticalPadding: 0,
                        minLeadingWidth: 20,
                      ),
                    ),
                    child: ExpansionTile(
                      tilePadding: EdgeInsets.zero,
                      childrenPadding: const EdgeInsets.only(
                        left: 4, right: 4, bottom: 13, top: 0,
                      ),
                      title: Text(
                        "Details",
                        style: TextStyle(
                          fontSize: 14.4,
                          color: _kPrimaryColor.withOpacity(.93),
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: const Icon(Icons.keyboard_arrow_down_rounded,
                          color: _kPrimaryColor, size: 22),
                      children: [
                        _ExamDetailRow(
                          icon: Icons.info_outline_rounded,
                          label: "Instructions",
                          content: exam['instructions'] ?? "-",
                        ),
                        const SizedBox(height: 10),
                        _ExamDetailRow(
                          icon: Icons.menu_book_outlined,
                          label: "Syllabus",
                          content: exam['syllabus'] ?? "-",
                        ),
                        const SizedBox(height: 10),
                        _ExamDetailRow(
                          icon: Icons.person_outline_rounded,
                          label: "Teacher",
                          content: exam['teacher'] ?? "-",
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Status Chip
class _ExamStatusBadge extends StatelessWidget {
  final bool isUpcoming;
  final String badgeText;
  final Color badgeColor;
  final Color borderColor;
  final Color textColor;
  const _ExamStatusBadge({
    required this.isUpcoming,
    required this.badgeText,
    required this.badgeColor,
    required this.borderColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    // Always safe: Container in a Stack, not inside Row/Column with text
    return Container(
      margin: const EdgeInsets.only(left: 8, right: 3, top: 3),
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 5),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: borderColor,
          width: 1.3,
        ),
      ),
      child: Text(
        badgeText,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w700,
          fontSize: 12.6,
          letterSpacing: 0.15,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

/// ------------------------
/// Section 4: Expandable Exam Details
/// (Each in a Row, but the right part is Expanded)
/// ------------------------
class _ExamDetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String content;
  const _ExamDetailRow({
    required this.icon,
    required this.label,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    // ABSOLUTE SAFETY: ROW → Expanded on Column (for texts), never overflows
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: _kPrimaryColor, size: 18),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14.1,
                  color: _kPrimaryColor,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 3),
              Text(
                content,
                style: const TextStyle(
                  fontSize: 13.3,
                  color: _kPrimaryColor,
                  fontWeight: FontWeight.w400,
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

