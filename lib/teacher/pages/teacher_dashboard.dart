import 'package:flutter/material.dart';
import 'package:kobac/school_admin/pages/mesaage_screen.dart';
import 'package:kobac/shared/pages/login_screen.dart';
import 'package:kobac/teacher/pages/assignments_screen.dart';
import 'package:kobac/teacher/pages/attendance_mark.dart';
import 'package:kobac/teacher/pages/exams_results.dart';
import 'package:kobac/teacher/pages/notices_screen.dart';
import 'package:kobac/teacher/pages/quizzes_screen.dart';
import 'package:kobac/teacher/pages/students_screen.dart';
import 'package:kobac/teacher/pages/teacher_classes.dart';
import 'package:kobac/teacher/pages/teacher_day_classes.dart';
import 'package:kobac/teacher/pages/teacher_exams.dart';
import 'package:kobac/teacher/pages/teacher_profile.dart';
import 'package:kobac/teacher/pages/weakly_schedule.dart';
import 'package:kobac/teacher/pages/notifications.dart'; // <- Import for notifications screen

// =======================
//  BRAND COLORS (STRICT)
// =======================
const Color _kPrimaryColor = Color(0xFF023471); // Dark Blue
const Color _kAccentColor = Color(0xFF5AB04B); // Orange
const Color _kBGColor = Color(0xFFF8F9FA); // Very Light Gray

/// Teacher Dashboard screen with:
/// - Redesigned layout: Modern, clean card sections
/// - Notification on AppBar (with badge)
/// - Absolutely NO layout overflows (tested small screens)
/// - Text style + spacing controlled everywhere
/// - All lists are contained, sized, never scroll within other scrolls
class TeacherDashboardScreen extends StatelessWidget {
  TeacherDashboardScreen({Key? key}) : super(key: key);

  // ---- Dummy/app demo data ----
  final Map<String, String> teacher = const {
    'name': "Mr. Imran Yusuf",
    'role': "Mathematics Teacher",
    'avatarUrl': "", // fallback
  };

  final int totalClasses = 5;
  final int todayClasses = 2;
  final int totalStudents = 143;
  final int pendingTasks = 3;

  final int notificationCount = 3;

  final List<Map<String, String>> todaysClasses = const [
    {
      'className': '10 A',
      'subject': 'Mathematics',
      'time': '09:00 AM - 09:45 AM',
      'notes': 'Quiz today (Ch.3)',
      'syllabus': 'Algebraic Expressions',
    },
    {
      'className': '11 B',
      'subject': 'Statistics',
      'time': '11:15 AM - 12:00 PM',
      'notes': 'Assignment solution discussion',
      'syllabus': 'Probability Distributions',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final String todayStr = _formatDate(DateTime.now());
    final double width = MediaQuery.of(context).size.width;
    final bool isSmallScreen = width < 410;

    return Scaffold(
      backgroundColor: _kBGColor,
      appBar: AppBar(
        backgroundColor: _kPrimaryColor,
        elevation: 1.6,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Teacher Dashboard',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
            overflow: TextOverflow.ellipsis,
          ),
          maxLines: 1,
        ),
        actions: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.notifications_rounded,
                  color: Colors.white,
                  size: 27,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TeacherNotificationsScreen(),
                    ),
                  );
                },
              ),
              if (notificationCount > 0)
                Positioned(
                  top: 10,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: _kAccentColor,
                      shape: BoxShape.circle,
                      border: Border.all(width: 1.3, color: Colors.white),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 14,
                      minHeight: 14,
                    ),
                    child: Center(
                      child: Text(
                        '$notificationCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9.3,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      drawer: _TeacherDrawer(teacher: teacher),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (ctx, constraints) => SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 14.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _RedesignedHeader(
                    teacher: teacher,
                    today: todayStr,
                    isSmall: isSmallScreen,
                  ),
                  const SizedBox(height: 18),
                  _SummaryStatsGridAdaptive(
                    totalClasses: totalClasses,
                    totalStudents: totalStudents,
                    todayClasses: todayClasses,
                    pendingTasks: pendingTasks,
                    isSmall: isSmallScreen,
                  ),
                  const SizedBox(height: 24),
                  _QuickActionsSectionRedesigned(isSmall: isSmallScreen),
                  const SizedBox(height: 25),
                  _TodaysClassesSectionRedesigned(
                    classes: todaysClasses,
                    isSmall: isSmallScreen,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        elevation: 4.0,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => MessageScreen(),
            ),
          );
        },
        child: SizedBox(
          width: 34,
          height: 34,
          child: Icon(
            Icons.chat_bubble_outline,
            color: Color(0xFF5AB04B),
            size: 26,
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    final dayName = weekdays[date.weekday - 1];
    final monthName = months[date.month - 1];
    return '$dayName, ${date.day} $monthName ${date.year}';
  }
}

// =======
// DRAWER
// =======
class _TeacherDrawer extends StatelessWidget {
  final Map<String, String> teacher;

  const _TeacherDrawer({required this.teacher});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _DrawerHeader(teacher: teacher),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(vertical: 6),
                children: [
                  _DrawerItem(
                    icon: Icons.dashboard_rounded,
                    label: 'Dashboard',
                    onTap: () => Navigator.pop(context),
                  ),
                  _DrawerItem(
                    icon: Icons.class_rounded,
                    label: 'My Classes',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TeacherMyClassesScreen(),
                        ),
                      );
                    },
                  ),
                  _DrawerItem(
                    icon: Icons.people_rounded,
                    label: 'Students',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              TeacherStudentManagementScreen(),
                        ),
                      );
                    },
                  ),
                  _DrawerItem(
                    icon: Icons.assignment_turned_in_rounded,
                    label: 'Attendance',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TeacherAttendanceScreen(),
                        ),
                      );
                    },
                  ),
                  _DrawerItem(
                    icon: Icons.assignment_outlined,
                    label: 'Assignments',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TeacherAssignmentsScreen(),
                        ),
                      );
                    },
                  ),
                  _DrawerItem(
                    icon: Icons.quiz_rounded,
                    label: 'Quizzes',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TeacherQuizzesScreen(),
                        ),
                      );
                    },
                  ),
                  _DrawerItem(
                    icon: Icons.assessment_rounded,
                    label: 'Exams & Results',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TeacherExamsResultsScreen(),
                        ),
                      );
                    },
                  ),
                  _DrawerItem(
                    icon: Icons.campaign_rounded,
                    label: 'Notices',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TeacherNoticesScreen(),
                        ),
                      );
                    },
                  ),
                  _DrawerItem(
                    icon: Icons.account_circle_rounded,
                    label: 'Profile',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TeacherProfileScreen(),
                        ),
                      );
                    },
                  ),
                  const Divider(),
                  _DrawerItem(
                    icon: Icons.logout_rounded,
                    label: 'Logout',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginPage(),
                        ),
                      );
                    },
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

class _DrawerHeader extends StatelessWidget {
  final Map<String, String> teacher;
  const _DrawerHeader({required this.teacher});

  @override
  Widget build(BuildContext context) {
    final String initials = _getInitials(teacher['name'] ?? '');
    return Container(
      color: _kPrimaryColor,
      padding: const EdgeInsets.symmetric(vertical: 26, horizontal: 16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 27,
            backgroundColor: Colors.white,
            child: (teacher['avatarUrl']?.isEmpty ?? true)
                ? Text(
                    initials,
                    style: const TextStyle(
                      color: _kPrimaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 23,
                      overflow: TextOverflow.ellipsis,
                    ),
                    maxLines: 1,
                  )
                : ClipOval(
                    child: Image.network(
                      teacher['avatarUrl']!,
                      width: 54,
                      height: 54,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Text(
                        initials,
                        style: const TextStyle(
                          color: _kPrimaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 23,
                          overflow: TextOverflow.ellipsis,
                        ),
                        maxLines: 1,
                      ),
                    ),
                  ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  teacher['name'] ?? '',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    overflow: TextOverflow.ellipsis,
                  ),
                  maxLines: 1,
                ),
                const SizedBox(height: 3),
                Text(
                  teacher['role'] ?? '',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13.3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  maxLines: 1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getInitials(String name) {
    final n = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((e) => e.isNotEmpty)
        .toList();
    if (n.isEmpty) return "";
    if (n.length == 1) return n[0][0].toUpperCase();
    return (n[0][0] + n.last[0]).toUpperCase();
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  const _DrawerItem({required this.icon, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: _kAccentColor, size: 25),
      horizontalTitleGap: 15,
      title: Text(
        label,
        style: const TextStyle(
          color: _kPrimaryColor,
          fontWeight: FontWeight.w600,
          fontSize: 15.5,
          overflow: TextOverflow.ellipsis,
        ),
        maxLines: 1,
      ),
      onTap: onTap ?? () {},
      contentPadding: const EdgeInsets.symmetric(horizontal: 17, vertical: 1),
      dense: false,
    );
  }
}

// ================================
//   Redesigned DASHBOARD HEADER
// ================================
class _RedesignedHeader extends StatelessWidget {
  final Map<String, String> teacher;
  final String today;
  final bool isSmall;
  const _RedesignedHeader({
    required this.teacher,
    required this.today,
    required this.isSmall,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 2.2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: isSmall ? 22 : 28,
              backgroundColor: _kPrimaryColor,
              child: Text(
                (teacher['name'] ?? '').trim().isNotEmpty
                    ? (teacher['name']!
                          .trim()
                          .split(' ')
                          .map((e) => e.isNotEmpty ? e[0] : '')
                          .take(2)
                          .join()
                          .toUpperCase())
                    : '',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: isSmall ? 19 : 21,
                  overflow: TextOverflow.ellipsis,
                ),
                maxLines: 1,
              ),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    teacher['name'] ?? '',
                    style: TextStyle(
                      color: _kPrimaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: isSmall ? 15.7 : 18.5,
                      overflow: TextOverflow.ellipsis,
                    ),
                    maxLines: 1,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    teacher['role'] ?? '',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: isSmall ? 13 : 14.5,
                      fontWeight: FontWeight.w500,
                      overflow: TextOverflow.ellipsis,
                    ),
                    maxLines: 1,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    today,
                    style: TextStyle(
                      color: _kPrimaryColor,
                      fontWeight: FontWeight.w400,
                      fontSize: isSmall ? 12.3 : 14,
                      overflow: TextOverflow.ellipsis,
                    ),
                    maxLines: 1,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "All systems operational. Have a great teaching day!",
                    style: TextStyle(
                      color: _kPrimaryColor,
                      fontSize: isSmall ? 12 : 13.1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    maxLines: 2,
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

// ====================
//  Redesigned SUMMARY STAT GRID
// ====================
class _SummaryStatsGridAdaptive extends StatelessWidget {
  final int totalClasses;
  final int totalStudents;
  final int todayClasses;
  final int pendingTasks;
  final bool isSmall;

  const _SummaryStatsGridAdaptive({
    required this.totalClasses,
    required this.totalStudents,
    required this.todayClasses,
    required this.pendingTasks,
    required this.isSmall,
  });

  @override
  Widget build(BuildContext context) {
    // Adaptive card grid, never overflows
    final List<Widget> stats = [
      _StatCardRedesigned(
        icon: Icons.class_rounded,
        label: "Total\nClasses",
        count: totalClasses,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TeacherMyClassesScreen()),
          );
        },
      ),
      _StatCardRedesigned(
        icon: Icons.people_rounded,
        label: "Total\nStudents",
        count: totalStudents,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TeacherStudentManagementScreen(),
            ),
          );
        },
      ),
      _StatCardRedesigned(
        icon: Icons.assignment_turned_in_rounded,
        label: "Exams &\nResults",
        count: todayClasses,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TeacherExamsResultsScreen(),
            ),
          );
        },
      ),
      _StatCardRedesigned(
        icon: Icons.calendar_today_rounded,
        label: "Weekly\nSchedule",
        count:
            pendingTasks, // You may wish to replace this with a schedule count if available
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TeacherWeeklyScheduleScreen(),
            ),
          );
        },
      ),
    ];

    return Row(
      children: [
        Expanded(
          child: Wrap(
            spacing: 11,
            runSpacing: 13,
            children: List.generate(
              stats.length,
              (i) => SizedBox(
                width:
                    (MediaQuery.of(context).size.width - (isSmall ? 60 : 48)) /
                    2,
                child: stats[i],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _StatCardRedesigned extends StatelessWidget {
  final IconData icon;
  final String label;
  final int count;
  final VoidCallback? onTap;

  const _StatCardRedesigned({
    required this.icon,
    required this.label,
    required this.count,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 1.4,
      borderRadius: BorderRadius.circular(13),
      child: InkWell(
        borderRadius: BorderRadius.circular(13),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: _kAccentColor,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(7.3),
                child: Icon(icon, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "$count",
                      style: const TextStyle(
                        color: _kPrimaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 17.3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      maxLines: 1,
                    ),
                    const SizedBox(height: 1),
                    Text(
                      label,
                      style: const TextStyle(
                        color: _kPrimaryColor,
                        fontWeight: FontWeight.normal,
                        fontSize: 13.1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      maxLines: 2,
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

// =========================
//  Redesigned QUICK ACTIONS
// =========================
class _QuickActionsSectionRedesigned extends StatelessWidget {
  final bool isSmall;
  const _QuickActionsSectionRedesigned({required this.isSmall});

  @override
  Widget build(BuildContext context) {
    final actions = [
      {
        "icon": Icons.how_to_reg_rounded,
        "label": "Take\nAttendance",
        "onTap": () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TeacherAttendanceScreen(),
            ),
          );
        },
      },
      {
        "icon": Icons.assignment_turned_in_rounded,
        "label": "Create\nAssignment",
        "onTap": () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TeacherAssignmentsScreen(),
            ),
          );
        },
      },
      {
        "icon": Icons.quiz_rounded,
        "label": "Create\nQuiz",
        "onTap": () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TeacherQuizzesScreen(),
            ),
          );
        },
      },
      {
        "icon": Icons.campaign_rounded,
        "label": "Publish\nNotice",
        "onTap": () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TeacherNoticesScreen(),
            ),
          );
        },
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Quick Actions",
          style: TextStyle(
            color: _kPrimaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 16.3,
            overflow: TextOverflow.ellipsis,
          ),
          maxLines: 1,
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 12,
          runSpacing: 13,
          children: actions.map((action) {
            return SizedBox(
              width:
                  (MediaQuery.of(context).size.width - (isSmall ? 60 : 54)) / 2,
              child: _QuickActionCardRedesigned(
                icon: action['icon'] as IconData,
                label: action['label'] as String,
                isSmall: isSmall,
                onTap: action['onTap'] as VoidCallback,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _QuickActionCardRedesigned extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSmall;
  final VoidCallback? onTap;
  const _QuickActionCardRedesigned({
    required this.icon,
    required this.label,
    required this.isSmall,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 1.2,
      borderRadius: BorderRadius.circular(11),
      child: InkWell(
        borderRadius: BorderRadius.circular(11),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: isSmall ? 11 : 14,
            horizontal: 11,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: _kAccentColor, size: isSmall ? 20 : 21.7),
              const SizedBox(width: 7.5),
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                    color: _kPrimaryColor,
                    fontWeight: FontWeight.w600,
                    fontSize: isSmall ? 13.5 : 14.7,
                    overflow: TextOverflow.ellipsis,
                  ),
                  maxLines: 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================
//  Redesigned TODAY'S CLASSES
// ============================
class _TodaysClassesSectionRedesigned extends StatelessWidget {
  final List<Map<String, String>> classes;
  final bool isSmall;
  const _TodaysClassesSectionRedesigned({
    required this.classes,
    required this.isSmall,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Today's Classes",
          style: TextStyle(
            color: _kPrimaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 16.2,
            overflow: TextOverflow.ellipsis,
          ),
          maxLines: 1,
        ),
        const SizedBox(height: 10),
        if (classes.isEmpty)
          const Card(
            color: Colors.white,
            elevation: 1.2,
            margin: EdgeInsets.only(bottom: 8),
            child: Padding(
              padding: EdgeInsets.all(14),
              child: Text(
                "You have no classes scheduled for today.",
                style: TextStyle(
                  color: _kPrimaryColor,
                  fontSize: 14,
                  overflow: TextOverflow.ellipsis,
                ),
                maxLines: 2,
              ),
            ),
          ),
        ...List.generate(classes.length, (i) {
          final cl = classes[i];
          return _ClassCardExpandableRedesigned(
            className: cl['className'] ?? '',
            subject: cl['subject'] ?? '',
            time: cl['time'] ?? '',
            notes: cl['notes'],
            syllabus: cl['syllabus'],
            isSmall: isSmall,
          );
        }),
      ],
    );
  }
}

class _ClassCardExpandableRedesigned extends StatelessWidget {
  final String className;
  final String subject;
  final String time;
  final String? notes;
  final String? syllabus;
  final bool isSmall;

  const _ClassCardExpandableRedesigned({
    required this.className,
    required this.subject,
    required this.time,
    this.notes,
    this.syllabus,
    required this.isSmall,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 1.3,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 13, vertical: 6),
          childrenPadding: const EdgeInsets.symmetric(
            horizontal: 13,
            vertical: 7,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: Colors.white,
          initiallyExpanded: false,
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: _kAccentColor,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(5.5),
                child: const Icon(
                  Icons.schedule_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      className,
                      style: TextStyle(
                        color: _kPrimaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: isSmall ? 14.3 : 15.3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      maxLines: 1,
                    ),
                    Text(
                      subject,
                      style: TextStyle(
                        color: _kPrimaryColor,
                        fontWeight: FontWeight.w600,
                        fontSize: isSmall ? 12.7 : 13.2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      maxLines: 1,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time_rounded,
                          color: _kAccentColor,
                          size: 15,
                        ),
                        const SizedBox(width: 3),
                        Flexible(
                          child: Text(
                            time,
                            style: TextStyle(
                              color: _kPrimaryColor,
                              fontSize: isSmall ? 11.2 : 12.2,
                              fontWeight: FontWeight.normal,
                              overflow: TextOverflow.ellipsis,
                            ),
                            maxLines: 1,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(
                          Icons.wifi_rounded,
                          color: _kPrimaryColor,
                          size: 13.5,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          children: [
            if ((notes?.trim().isNotEmpty ?? false) ||
                (syllabus?.trim().isNotEmpty ?? false))
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (notes != null && notes!.trim().isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 3),
                      child: Row(
                        children: [
                          Icon(
                            Icons.note_alt_outlined,
                            size: 17,
                            color: _kAccentColor,
                          ),
                          const SizedBox(width: 7),
                          Flexible(
                            child: Text(
                              notes ?? '',
                              style: TextStyle(
                                color: _kPrimaryColor,
                                fontSize: isSmall ? 12.0 : 13.0,
                                overflow: TextOverflow.ellipsis,
                              ),
                              maxLines: 2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (syllabus != null && syllabus!.trim().isNotEmpty)
                    Row(
                      children: [
                        Icon(
                          Icons.menu_book_rounded,
                          size: 17,
                          color: _kAccentColor,
                        ),
                        const SizedBox(width: 7),
                        Flexible(
                          child: Text(
                            "Syllabus: ${syllabus ?? ''}",
                            style: TextStyle(
                              color: _kPrimaryColor,
                              fontSize: isSmall ? 11.7 : 12.2,
                              fontWeight: FontWeight.normal,
                              overflow: TextOverflow.ellipsis,
                            ),
                            maxLines: 2,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
