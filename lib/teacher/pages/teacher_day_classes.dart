import 'package:flutter/material.dart';

class TeacherTodayClassesScreen extends StatelessWidget {
  TeacherTodayClassesScreen({Key? key}) : super(key: key);

  // BRAND COLORS
  static const Color _kPrimaryColor = Color(0xFF023471);
  static const Color _kAccentColor = Color(0xFF5AB04B);
  static const Color _kBgColor = Color(0xFFF4F6F8);

  // Dummy data for exactly 2 classes
  final List<_ClassCardData> _classes = const [
    _ClassCardData(
      className: "Grade 7 – B",
      subject: "Mathematics",
      time: "09:00 AM – 09:45 AM",
      section: "Room 204",
      numStudents: 32,
      lessonTopic: "Fractions and Decimals",
      syllabusProgress: "Unit 3 of 7",
      teacherNotes:
          "Revise last homework; prepare students for weekly quiz.",
    ),
    _ClassCardData(
      className: "Grade 8 – A",
      subject: "Science",
      time: "11:10 AM – 11:55 AM",
      section: "Lab 2",
      numStudents: 29,
      lessonTopic: "Cell Structure",
      syllabusProgress: "Unit 2 of 6",
      teacherNotes: "Bring lab coats for practical; check previous lab reports.",
    ),
  ];

  final String teacherName = "Mrs. Arya Singh";

  String _todayDate() {
    final now = DateTime.now();
    final weekday = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ][now.weekday - 1];
    return "$weekday, ${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _TodayClassesTopBar(onBack: () => Navigator.of(context).maybePop()),
                const SizedBox(height: 20),
                _DaySummaryCard(
                teacherName: teacherName,
                date: _todayDate(),
                totalClasses: _classes.length,
              ),
              const SizedBox(height: 24),
              // SECTION 2 & 3 & 4: CLASS CARDS
              ListView.builder(
                shrinkWrap: true, // Prevents RenderFlex overflow
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _classes.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 18.0),
                    child: _ClassCard(
                      data: _classes[index],
                    ),
                  );
                },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ======================= TOP BAR (no color, 3D back) =======================
class _TodayClassesTopBar extends StatelessWidget {
  final VoidCallback onBack;

  const _TodayClassesTopBar({required this.onBack});

  static const Color _kBlue = Color(0xFF023471);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          GestureDetector(
            onTap: onBack,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(color: _kBlue.withOpacity(0.1), blurRadius: 12, offset: const Offset(0, 4)),
                ],
              ),
              child: Icon(Icons.arrow_back_rounded, color: _kBlue, size: 24),
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Text(
              "Today's Classes",
              style: TextStyle(color: Color(0xFF023471), fontWeight: FontWeight.bold, fontSize: 20),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _DaySummaryCard extends StatelessWidget {
  final String teacherName;
  final String date;
  final int totalClasses;

  static const Color _kPrimaryColor = Color(0xFF023471);
  static const Color _kAccentColor = Color(0xFF5AB04B);

  const _DaySummaryCard({
    required this.teacherName,
    required this.date,
    required this.totalClasses,
  });

  @override
  Widget build(BuildContext context) {
    // Safety: Always wrap with IntrinsicHeight or let padding adapt
    return Card(
      elevation: 3,
      color: Colors.white,
      surfaceTintColor: Colors.white,
      shadowColor: Colors.black.withOpacity(0.10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.today, color: _kAccentColor, size: 27),
                const SizedBox(width: 12),
                Expanded(
                  // To guarantee text never overflows
                  child: Text(
                    teacherName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: _kPrimaryColor,
                      fontSize: 16.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.calendar_month, size: 19, color: _kPrimaryColor),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    date,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: _kPrimaryColor,
                      fontSize: 14.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Container(
                  width: 7,
                  height: 27,
                  margin: const EdgeInsets.only(left: 7),
                  decoration: BoxDecoration(
                    color: _kAccentColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.class_, color: _kPrimaryColor, size: 18),
                const SizedBox(width: 7),
                Text(
                  "Total classes today: ",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _kPrimaryColor,
                    fontSize: 14,
                  ),
                ),
                Text(
                  "$totalClasses",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _kAccentColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
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

class _ClassCardData {
  final String className;
  final String subject;
  final String time;
  final String section;
  final int numStudents;
  final String lessonTopic;
  final String syllabusProgress;
  final String teacherNotes;

  const _ClassCardData({
    required this.className,
    required this.subject,
    required this.time,
    required this.section,
    required this.numStudents,
    required this.lessonTopic,
    required this.syllabusProgress,
    required this.teacherNotes,
  });
}

class _ClassCard extends StatelessWidget {
  final _ClassCardData data;

  static const Color _kPrimaryColor = Color(0xFF023471);
  static const Color _kAccentColor = Color(0xFF5AB04B);

  const _ClassCard({required this.data});

  @override
  Widget build(BuildContext context) {
    // Allows width to adapt, ensures overflow safety
    return Card(
      elevation: 3,
      color: Colors.white,
      surfaceTintColor: Colors.white,
      shadowColor: Colors.black.withOpacity(0.09),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Main class info (no fixed width/height, all Expanded or Wrap)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: _kAccentColor.withOpacity(0.11),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.menu_book_rounded,
                    color: _kAccentColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 13),
                // Content for class info (Expanded for safety)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.className,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: _kPrimaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        data.subject,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: _kAccentColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 14.5,
                        ),
                      ),
                      const SizedBox(height: 7),
                      Wrap(
                        spacing: 12,
                        runSpacing: 4,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          _ClassInfoItem(
                            icon: Icons.schedule,
                            text: data.time,
                          ),
                          _ClassInfoItem(
                            icon: Icons.location_on_outlined,
                            text: data.section,
                          ),
                          _ClassInfoItem(
                            icon: Icons.people_outline,
                            text: "${data.numStudents} students",
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            // Quick Actions (safe on any screen: always Wrap)
            _ClassQuickActions(),
            const SizedBox(height: 5),
            // Expandable class details (overflow-safe ExpansionTile)
            _ClassExpansionDetails(
              lessonTopic: data.lessonTopic,
              syllabusProgress: data.syllabusProgress,
              teacherNotes: data.teacherNotes,
            ),
          ],
        ),
      ),
    );
  }
}

class _ClassInfoItem extends StatelessWidget {
  final IconData icon;
  final String text;

  static const Color _kPrimaryColor = Color(0xFF023471);
  static const Color _kAccentColor = Color(0xFF5AB04B);

  const _ClassInfoItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min, // Prevents wide row overflow
      children: [
        Icon(
          icon,
          color: _kAccentColor,
          size: 17,
        ),
        const SizedBox(width: 4),
        Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: _kPrimaryColor,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _ClassQuickActions extends StatelessWidget {
  // No instance state needed; use for UI only
  static const Color _kAccentColor = Color(0xFF5AB04B);
  static const Color _kPrimaryColor = Color(0xFF023471);

  const _ClassQuickActions();

  @override
  Widget build(BuildContext context) {
    // Wrap ensures chips/buttons wrap on small screens, 100% overflow safe
    return Padding(
      padding: const EdgeInsets.only(top: 2.0, bottom: 6.0),
      child: Wrap(
        spacing: 9,
        runSpacing: 7,
        children: [
          _QuickActionChip(
            icon: Icons.play_arrow_rounded,
            label: "Start Class",
          ),
          _QuickActionChip(
            icon: Icons.check_circle_outline,
            label: "Attendance",
          ),
          _QuickActionChip(
            icon: Icons.people,
            label: "Students",
          ),
          _QuickActionChip(
            icon: Icons.assignment_outlined,
            label: "Assignments",
          ),
        ],
      ),
    );
  }
}

class _QuickActionChip extends StatelessWidget {
  final IconData icon;
  final String label;

  static const Color _kAccentColor = Color(0xFF5AB04B);
  static const Color _kPrimaryColor = Color(0xFF023471);

  const _QuickActionChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    // No fixed width, text wraps, uses chip for touch target
    return Material(
      color: _kAccentColor.withOpacity(0.1),
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        // No fixed height/width; safe touch area
        borderRadius: BorderRadius.circular(22),
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
          child: Row(
            mainAxisSize: MainAxisSize.min, // Prevents overflow
            children: [
              Icon(icon, size: 17, color: _kAccentColor),
              const SizedBox(width: 5),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: _kPrimaryColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ClassExpansionDetails extends StatelessWidget {
  final String lessonTopic;
  final String syllabusProgress;
  final String teacherNotes;

  static const Color _kAccentColor = Color(0xFF5AB04B);
  static const Color _kPrimaryColor = Color(0xFF023471);

  const _ClassExpansionDetails({
    required this.lessonTopic,
    required this.syllabusProgress,
    required this.teacherNotes,
  });

  @override
  Widget build(BuildContext context) {
    // ExpansionTile is overflow safe since all contents use maxLines
    return Theme(
      // Custom theme to control ExpansionTile icon colors
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent,
        unselectedWidgetColor: _kAccentColor,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: _kAccentColor,
        ),
      ),
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        iconColor: _kAccentColor,
        collapsedIconColor: _kAccentColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: Text(
          "More Details",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: _kPrimaryColor,
            fontWeight: FontWeight.w500,
            fontSize: 15,
          ),
        ),
        childrenPadding: const EdgeInsets.only(left: 6, right: 6, bottom: 9),
        children: [
          // Lesson topic
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.info_outline, size: 17, color: _kPrimaryColor),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  lessonTopic,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _kPrimaryColor,
                    fontSize: 13.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Syllabus progress
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.menu_book_rounded, size: 17, color: _kAccentColor),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  "Syllabus: $syllabusProgress",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _kPrimaryColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Teacher notes
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.note_alt_outlined, size: 17, color: _kAccentColor),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  teacherNotes,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _kPrimaryColor,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

