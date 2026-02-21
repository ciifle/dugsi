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
import 'package:kobac/teacher/pages/notifications.dart';
import 'package:kobac/services/local_auth_service.dart';

// ======================= BRAND COLORS =======================
const Color _kPrimaryBlue = Color(0xFF023471);
const Color _kPrimaryGreen = Color(0xFF5AB04B);
const Color _kBg = Color(0xFFF4F6F8);
const double _kRadius = 24.0;
const double _kPadding = 20.0;

class TeacherDashboardScreen extends StatelessWidget {
  TeacherDashboardScreen({Key? key}) : super(key: key);

  final Map<String, String> teacher = const {
    'name': "Mr. Imran Yusuf",
    'role': "Mathematics Teacher",
    'avatarUrl': "",
  };

  final int notificationCount = 3;
  final int todayClassesCount = 2;
  final int pendingAttendanceCount = 1;
  final int marksToEnterCount = 3;

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
    final double width = MediaQuery.of(context).size.width;
    final bool isSmall = width < 380;

    return Scaffold(
      backgroundColor: _kBg,
      drawer: _TeacherDrawer(teacher: teacher),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(_kPadding, _kPadding, _kPadding, 10),
                child: Row(
                  children: [
                    Builder(
                      builder: (context) => _NeuIconButton(
                        icon: Icons.menu_rounded,
                        onTap: () => Scaffold.of(context).openDrawer(),
                      ),
                    ),
                    const Spacer(),
                    const SizedBox(width: 12),
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        _NeuIconButton(
                          icon: Icons.notifications_outlined,
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => TeacherNotificationsScreen())),
                          iconColor: Colors.white,
                          backgroundColor: _kPrimaryBlue,
                        ),
                        if (notificationCount > 0)
                          Positioned(
                            top: -2,
                            right: -2,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(color: _kPrimaryGreen, shape: BoxShape.circle),
                              constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                              child: Center(child: Text('$notificationCount', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold))),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: _kPadding, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Welcome back,", style: TextStyle(fontSize: 16, color: _kPrimaryBlue.withOpacity(0.6), fontWeight: FontWeight.w500)),
                    const SizedBox(height: 4),
                    Text(teacher['name'] ?? "Teacher", style: const TextStyle(fontSize: 26, color: _kPrimaryBlue, fontWeight: FontWeight.bold, letterSpacing: -0.5)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: _kPadding, vertical: 6),
                child: _SummaryGrid(
                  todayClasses: todayClassesCount,
                  pendingAttendance: pendingAttendanceCount,
                  marksToEnter: marksToEnterCount,
                  recentActivity: 5,
                  isSmall: isSmall,
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: _kPadding),
                child: _SectionTitle(title: "Today's Classes"),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: _kPadding),
                child: _TodaysClassesCards(classes: todaysClasses, isSmall: isSmall),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
      floatingActionButton: _FAB(),
    );
  }

  String _formatDate(DateTime d) {
    const w = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    const m = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
    return '${w[d.weekday - 1]}, ${d.day} ${m[d.month - 1]} ${d.year}';
  }
}

// ======================= DRAWER =======================
class _TeacherDrawer extends StatelessWidget {
  final Map<String, String> teacher;

  const _TeacherDrawer({required this.teacher});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            _DrawerHeader(teacher: teacher),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                children: [
                  _DrawerTile(icon: Icons.dashboard_rounded, label: 'Dashboard', isActive: true, onTap: () => Navigator.pop(context)),
                  _DrawerTile(icon: Icons.class_rounded, label: 'My Classes', onTap: () => _nav(context, TeacherMyClassesScreen())),
                  _DrawerTile(icon: Icons.people_rounded, label: 'Students', onTap: () => _nav(context, TeacherStudentManagementScreen())),
                  _DrawerTile(icon: Icons.assignment_turned_in_rounded, label: 'Attendance', onTap: () => _nav(context, TeacherAttendanceScreen())),
                  _DrawerTile(icon: Icons.assignment_outlined, label: 'Assignments', onTap: () => _nav(context, TeacherAssignmentsScreen())),
                  _DrawerTile(icon: Icons.quiz_rounded, label: 'Quizzes', onTap: () => _nav(context, TeacherQuizzesScreen())),
                  _DrawerTile(icon: Icons.assessment_rounded, label: 'Exams & Results', onTap: () => _nav(context, TeacherExamsResultsScreen())),
                  _DrawerTile(icon: Icons.campaign_rounded, label: 'Notices', onTap: () => _nav(context, TeacherNoticesScreen())),
                  _DrawerTile(icon: Icons.account_circle_rounded, label: 'Profile', onTap: () => _nav(context, TeacherProfileScreen())),
                  const Divider(height: 24),
                  _DrawerTile(icon: Icons.logout_rounded, label: 'Logout', onTap: () async {
                    await LocalAuthService().logout();
                    if (context.mounted) {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginPage()));
                    }
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _nav(BuildContext context, Widget screen) {
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }
}

class _DrawerHeader extends StatelessWidget {
  final Map<String, String> teacher;

  const _DrawerHeader({required this.teacher});

  @override
  Widget build(BuildContext context) {
    final parts = (teacher['name'] ?? '').trim().split(RegExp(r'\s+')).where((e) => e.isNotEmpty);
    final initials = parts.isEmpty ? '' : parts.take(2).map((e) => e[0]).join().toUpperCase();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 24),
      decoration: const BoxDecoration(
        color: _kPrimaryBlue,
        borderRadius: BorderRadius.only(bottomRight: Radius.circular(28)),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: _kPrimaryBlue.withOpacity(0.2), blurRadius: 8, offset: const Offset(0, 4)),
              ],
            ),
            child: Center(
              child: Text(
                initials.isEmpty ? 'T' : initials,
                style: const TextStyle(color: _kPrimaryBlue, fontWeight: FontWeight.bold, fontSize: 22),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  teacher['name'] ?? '',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  teacher['role'] ?? '',
                  style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 13),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DrawerTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback? onTap;

  const _DrawerTile({required this.icon, required this.label, this.isActive = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Material(
        color: isActive ? _kPrimaryBlue.withOpacity(0.08) : Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: isActive ? Border.all(color: _kPrimaryBlue.withOpacity(0.3), width: 1) : null,
            ),
            child: Row(
              children: [
                Icon(icon, size: 24, color: isActive ? _kPrimaryBlue : _kPrimaryBlue.withOpacity(0.7)),
                const SizedBox(width: 16),
                Text(
                  label,
                  style: TextStyle(
                    color: isActive ? _kPrimaryBlue : _kPrimaryBlue.withOpacity(0.9),
                    fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ======================= 3D SUMMARY GRID =======================
class _SummaryGrid extends StatelessWidget {
  final int todayClasses;
  final int pendingAttendance;
  final int marksToEnter;
  final int recentActivity;
  final bool isSmall;

  const _SummaryGrid({
    required this.todayClasses,
    required this.pendingAttendance,
    required this.marksToEnter,
    required this.recentActivity,
    required this.isSmall,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = (constraints.maxWidth - 14) / 2;
        return Wrap(
          spacing: 14,
          runSpacing: 14,
          children: [
            _SummaryCard3D(
              icon: Icons.schedule_rounded,
              title: "Today's Classes",
              value: todayClasses.toString(),
              color: _kPrimaryBlue,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => TeacherTodayClassesScreen())),
            ),
            _SummaryCard3D(
              icon: Icons.assignment_turned_in_rounded,
              title: "Pending Attendance",
              value: pendingAttendance.toString(),
              color: _kPrimaryGreen,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => TeacherAttendanceScreen())),
            ),
            _SummaryCard3D(
              icon: Icons.edit_note_rounded,
              title: "Marks to Enter",
              value: marksToEnter.toString(),
              color: Colors.orange,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => TeacherExamsResultsScreen())),
            ),
            _SummaryCard3D(
              icon: Icons.history_rounded,
              title: "Recent Activity",
              value: recentActivity.toString(),
              color: Colors.deepPurple,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => TeacherWeeklyScheduleScreen())),
            ),
          ],
        );
      },
    );
  }
}

class _SummaryCard3D extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;
  final VoidCallback? onTap;

  const _SummaryCard3D({required this.icon, required this.title, required this.value, required this.color, this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: (MediaQuery.of(context).size.width - _kPadding * 2 - 14) / 2,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(_kRadius),
            boxShadow: [
              BoxShadow(color: color.withOpacity(0.18), offset: const Offset(0, 8), blurRadius: 18),
              BoxShadow(color: _kPrimaryBlue.withOpacity(0.06), offset: const Offset(0, 14), blurRadius: 28),
            ],
          ),
          child: Stack(
            children: [
              Positioned(right: -8, top: -8, child: Icon(icon, size: 72, color: color.withOpacity(0.06))),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(icon, color: color, size: 24),
                    ),
                    const SizedBox(height: 16),
                    Text(value, style: const TextStyle(color: _kPrimaryBlue, fontWeight: FontWeight.bold, fontSize: 26)),
                    const SizedBox(height: 4),
                    Text(title, style: TextStyle(fontSize: 14, color: _kPrimaryBlue.withOpacity(0.6), fontWeight: FontWeight.w500), maxLines: 2, overflow: TextOverflow.ellipsis),
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

// ======================= TODAY'S CLASSES =======================
class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(color: _kPrimaryBlue, fontWeight: FontWeight.bold, fontSize: 18),
    );
  }
}

class _TodaysClassesCards extends StatelessWidget {
  final List<Map<String, String>> classes;
  final bool isSmall;

  const _TodaysClassesCards({required this.classes, required this.isSmall});

  @override
  Widget build(BuildContext context) {
    if (classes.isEmpty) {
      return _Card3D(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: Text("You have no classes scheduled for today.", style: TextStyle(color: _kPrimaryBlue.withOpacity(0.8), fontSize: 15)),
          ),
        ),
      );
    }
    return Column(
      children: classes.map((c) => Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: _ClassCard3D(
          className: c['className'] ?? '',
          subject: c['subject'] ?? '',
          time: c['time'] ?? '',
          notes: c['notes'],
          syllabus: c['syllabus'],
        ),
      )).toList(),
    );
  }
}

class _ClassCard3D extends StatelessWidget {
  final String className;
  final String subject;
  final String time;
  final String? notes;
  final String? syllabus;

  const _ClassCard3D({required this.className, required this.subject, required this.time, this.notes, this.syllabus});

  @override
  Widget build(BuildContext context) {
    return _Card3D(
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          childrenPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_kRadius)),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: _kPrimaryGreen.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.schedule_rounded, color: _kPrimaryGreen, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(className, style: const TextStyle(color: _kPrimaryBlue, fontWeight: FontWeight.bold, fontSize: 16)),
                    Text(subject, style: TextStyle(color: _kPrimaryBlue.withOpacity(0.85), fontSize: 14)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.access_time_rounded, size: 16, color: _kPrimaryGreen),
                        const SizedBox(width: 6),
                        Text(time, style: TextStyle(color: _kPrimaryBlue.withOpacity(0.7), fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          children: [
            if ((notes ?? '').trim().isNotEmpty) _DetailRow(icon: Icons.note_alt_outlined, text: notes!),
            if ((syllabus ?? '').trim().isNotEmpty) _DetailRow(icon: Icons.menu_book_rounded, text: 'Syllabus: $syllabus'),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _DetailRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: _kPrimaryGreen),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: TextStyle(color: _kPrimaryBlue.withOpacity(0.85), fontSize: 13), maxLines: 2, overflow: TextOverflow.ellipsis)),
        ],
      ),
    );
  }
}

// ======================= SHARED 3D CARD =======================
class _Card3D extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;

  const _Card3D({required this.child, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(_kRadius),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(_kRadius),
            boxShadow: [
              BoxShadow(color: _kPrimaryBlue.withOpacity(0.1), blurRadius: 16, offset: const Offset(0, 6)),
              BoxShadow(color: _kPrimaryBlue.withOpacity(0.06), blurRadius: 32, offset: const Offset(0, 12)),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

// ======================= NEUMORPHIC ICON BUTTON (like admin) =======================
class _NeuIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? backgroundColor;

  const _NeuIconButton({required this.icon, required this.onTap, this.iconColor, this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    final bg = backgroundColor ?? Colors.white;
    final iconClr = iconColor ?? _kPrimaryBlue;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(color: _kPrimaryBlue.withOpacity(0.1), blurRadius: 12, offset: const Offset(0, 4)),
          ],
        ),
        child: Icon(icon, color: iconClr, size: 24),
      ),
    );
  }
}

class _FAB extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => MessageScreen())),
      backgroundColor: Colors.white,
      elevation: 8,
      child: const Icon(Icons.chat_bubble_rounded, color: _kPrimaryGreen, size: 28),
    );
  }
}
