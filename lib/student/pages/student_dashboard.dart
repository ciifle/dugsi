import 'package:flutter/material.dart';
import 'package:kobac/student/pages/academic_activity.dart';
import 'package:kobac/student/pages/exam_schedule.dart';
import 'package:kobac/student/pages/student_fees.dart';
import 'package:kobac/student/pages/student_quizzes.dart';
import 'package:kobac/student/pages/student_result.dart';
import 'package:kobac/student/pages/student_attendance.dart';
import 'package:kobac/student/widgets/student_drawer.dart'; // import your drawer widget

// --- Feature Card Data Class ---
class _FeatureCardData {
  final String title;
  final String subtitle;
  final IconData icon;
  final void Function(BuildContext context)? onTap; // Make onTap nullable

  const _FeatureCardData({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });
}

class StudentDashboardScreen extends StatelessWidget {
  StudentDashboardScreen({Key? key}) : super(key: key);

  // The correct type: List<_FeatureCardData>
  late final List<_FeatureCardData> _featureCards = [
    _FeatureCardData(
      title: 'Results',
      subtitle: 'View recent scores',
      icon: Icons.grade,
      onTap: (context) {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (ctx) => const StudentResultsScreen()),
        );
      },
    ),
    _FeatureCardData(
      title: 'Fees',
      subtitle: 'Dues cleared',
      icon: Icons.account_balance_wallet,
      onTap: (context) {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (ctx) => const StudentFeesScreen()),
        );
      },
    ),
    _FeatureCardData(
      title: 'Attendance',
      subtitle: 'Track your presence',
      icon: Icons.event_available,
     onTap: (context) {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (ctx) => const StudentAttendanceScreen()),
        );
      },
    ),
    _FeatureCardData(
      title: 'Academic Activity',
      subtitle: 'Latest updates',
      icon: Icons.school,
      onTap: (context) {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (ctx) => const StudentAcademicActivityScreen()),
        );
      },
    ),
    _FeatureCardData(
      title: 'Quizzes',
      subtitle: 'New quiz posted',
      icon: Icons.quiz,
      onTap: (context) {
         Navigator.of(context).push(
          MaterialPageRoute(builder: (ctx) => const StudentQuizzesScreen()),
        );
      },
    ),
    _FeatureCardData(
      title: 'Exam Schedule',
      subtitle: 'Upcoming exams',
      icon: Icons.schedule,
      onTap: (context) {
         Navigator.of(context).push(
          MaterialPageRoute(builder: (ctx) => StudentExamScheduleScreen()),
        );
      },
    ),
  ];

  // Dummy notice data
  final List<_NoticeData> _notices = const [
    _NoticeData(
      title: "Campus closed on Friday",
      description:
          "Due to maintenance, the campus will remain closed this Friday.",
      date: "12 Jun",
    ),
    _NoticeData(
      title: "Exam forms open",
      description: "Submit your forms before the 18th of June.",
      date: "10 Jun",
    ),
    _NoticeData(
      title: "New library books",
      description: "Check out the new arrivals in the library section.",
      date: "08 Jun",
    ),
  ];

  // Dummy attendance data
  final double _attendancePercent = 0.87;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Dashboard",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF023471),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 1,
      ),
      drawer: AppDrawer(), // use the separated widget as AppDrawer
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ----------- Feature Cards Grid -----------
              LayoutBuilder(
                builder: (context, constraints) {
                  final double cardWidth = (constraints.maxWidth - 12) / 2;
                  final double cardHeight = cardWidth * 0.75;

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _featureCards.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 14,
                      crossAxisSpacing: 14,
                      childAspectRatio: cardWidth / cardHeight,
                    ),
                    itemBuilder: (context, index) {
                      final card = _featureCards[index];
                      return _ClickableFeatureCard(
                        icon: card.icon,
                        title: card.title,
                        subtitle: card.subtitle,
                        // Use the correct context for navigation!
                        onTap: card.onTap != null
                            ? () => card.onTap!(context)
                            : null,
                        height: cardHeight,
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 28),

              // ----------- Notices Section -----------
              Text(
                "Notices",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF023471),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Column(
                children: List.generate(
                  _notices.length.clamp(0, 3),
                  (index) => Padding(
                    padding: EdgeInsets.only(
                      bottom: index == _notices.length.clamp(0, 3) - 1
                          ? 0
                          : 12.0,
                    ),
                    child: _NoticeCard(notice: _notices[index]),
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // ----------- Attendance Summary -----------
              Text(
                "Attendance Summary",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF023471),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              _AttendanceSummaryCard(percent: _attendancePercent),
            ],
          ),
        ),
      ),
    );
  }
}


// --------------------- Redesigned & Clickable Feature Card ----------------------
class _ClickableFeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final double? height;

  const _ClickableFeatureCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color deepBlue = const Color(0xFF023471);
    final Color orange = const Color(0xFF5AB04B);

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      splashColor: orange.withOpacity(0.12),
      highlightColor: orange.withOpacity(0.07),
      child: Container(
        height: height ?? 108,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: deepBlue.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 3),
            ),
          ],
          border: Border.all(color: orange.withOpacity(0.09), width: 1),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: orange.withOpacity(0.09),
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(7.0),
                  child: Icon(icon, color: orange, size: 22),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: deepBlue,
                        letterSpacing: 0.1,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: deepBlue.withOpacity(0.78),
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.04,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ----------------------- Notice Card ---------------------------
class _NoticeCard extends StatelessWidget {
  final _NoticeData notice;

  const _NoticeCard({Key? key, required this.notice}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 1,
      shadowColor: Colors.black12,
      borderRadius: BorderRadius.circular(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 4,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFF5AB04B),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notice.title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF023471),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notice.description,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF023471),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notice.date,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF5AB04B),
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NoticeData {
  final String title;
  final String description;
  final String date;

  const _NoticeData({
    required this.title,
    required this.description,
    required this.date,
  });
}

// ------------------ Attendance Summary Card --------------------
class _AttendanceSummaryCard extends StatelessWidget {
  final double percent;

  const _AttendanceSummaryCard({Key? key, required this.percent})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 2,
      shadowColor: Colors.black12,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${(percent * 100).toStringAsFixed(1)}%",
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF023471),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            SizedBox(
              height: 8,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: percent,
                  backgroundColor: const Color(0xFF023471).withOpacity(0.12),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xFF5AB04B),
                  ),
                  minHeight: 8,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              percent >= 0.75
                  ? "Good attendance this month."
                  : "Low attendance, please attend more.",
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF023471),
                fontWeight: FontWeight.w400,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
