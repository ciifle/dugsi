import 'package:flutter/material.dart';

// Color constants for theme
const Color kPrimaryOrange = Color(0xFF5AB04B);
const Color kDarkBlue = Color(0xFF023471);
const Color kLightGrey = Color(0xFFF7F8FA);
const Color kDividerGrey = Color(0xFFE2E4EA);

/// Data model for Student
class Student {
  final String name;
  final String profileUrl;
  final double gpa;
  final int rank;

  Student({
    required this.name,
    required this.profileUrl,
    required this.gpa,
    required this.rank,
  });
}

/// Data model for ClassInfo
class ClassInfo {
  final String className;
  final String academicYear;
  final String teacherName;
  final int totalStudents;
  final double averageGpa;
  final double attendancePercent;

  ClassInfo({
    required this.className,
    required this.academicYear,
    required this.teacherName,
    required this.totalStudents,
    required this.averageGpa,
    required this.attendancePercent,
  });
}

// --- Redesigned Modern Grid Card for Class Overview
class ModernClassOverviewGrid extends StatelessWidget {
  final ClassInfo classInfo;

  const ModernClassOverviewGrid({Key? key, required this.classInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // For responsive sizing
    final screenWidth = MediaQuery.of(context).size.width;
    final boxHeight = 112.0;
    final boxWidth = screenWidth > 410 ? 170.0 : (screenWidth - 68) / 2;
    const iconSize = 30.0;

    // Modern style for active border highlight
    Border specialBorder({bool highlight = false}) => Border.all(
      color: highlight ? kPrimaryOrange : kDividerGrey,
      width: highlight ? 1.3 : 1,
    );

    // Modern content box
    Widget statBox({
      required IconData icon,
      required String title,
      required String? subtitle,
      required Color iconColor,
      required bool main,
      Color? valueColor,
      Color? borderColor,
      double? titleSize,
      double? subtitleSize,
      bool highlight = false,
    }) {
      return Container(
        // Remove explicit width for grid responsiveness
        height: boxHeight,
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: specialBorder(highlight: highlight),
          boxShadow: [
            BoxShadow(
              color: kDarkBlue.withOpacity(.07),
              blurRadius: 13,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Wrap Column in SingleChildScrollView to avoid overflow, or constrain its height
            return SingleChildScrollView(
              // Makes it scroll vertically if overflow occurs; padding tweak for visual comfort
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(), // Prevents scroll unless overflow
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  // Prevent children Column from exceeding the size of the container
                  // Subtract a few px for possible padding/margin to avoid tight fit
                  maxHeight: boxHeight - 8,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: main ? CrossAxisAlignment.start : CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon, color: iconColor, size: iconSize),
                    const SizedBox(height: 7),
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: main ? FontWeight.w800 : FontWeight.bold,
                        fontSize: titleSize ?? (main ? 19 : 18),
                        color: valueColor ?? (highlight ? kPrimaryOrange : kDarkBlue),
                        letterSpacing: 0.02,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (subtitle != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 3.5),
                        child: Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: subtitleSize ?? (main ? 14 : 13),
                            color: !main ? kDarkBlue : const Color(0xFF828AAB),
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.01,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.all(14),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: kLightGrey,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Modern header row
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: kPrimaryOrange.withOpacity(0.11),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(7),
                child: const Icon(Icons.class_, color: kPrimaryOrange, size: 28),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Text(
                  classInfo.className,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 21,
                    color: kDarkBlue,
                    letterSpacing: -0.16,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: kPrimaryOrange, width: 1.2),
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: kPrimaryOrange.withOpacity(.05),
                      blurRadius: 2,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  classInfo.academicYear,
                  style: const TextStyle(
                    color: kPrimaryOrange,
                    fontWeight: FontWeight.w700,
                    fontSize: 14.2,
                    letterSpacing: 0.01,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          // --- Modern stats grid
          LayoutBuilder(
            builder: (context, constraints) {
              // For 2 columns on small screens, 4 columns on larger; adjust as needed
              int crossAxisCount = constraints.maxWidth > 600 ? 4 : 2;
              // Calculate item aspect ratio (width/height)
              double itemWidth = (constraints.maxWidth - (22 * (crossAxisCount - 1))) / crossAxisCount;

              // Slightly increase min aspect ratio to allow for text+icon stack
              // Use a minimum of 120 (boxHeight) to avoid grid attempting very tight vertical packing
              double minBoxHeight = 120;
              double aspectRatio = itemWidth / minBoxHeight;

              return GridView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 2),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 22,
                  mainAxisSpacing: 16,
                  childAspectRatio: aspectRatio,
                ),
                children: [
                  // Teacher card - main look (left column)
                  statBox(
                    icon: Icons.person,
                    title: classInfo.teacherName,
                    subtitle: "Class Teacher",
                    iconColor: kPrimaryOrange,
                    main: true,
                    valueColor: kDarkBlue,
                    titleSize: 18.6,
                    subtitleSize: 13.2,
                  ),
                  // Students card
                  statBox(
                    icon: Icons.people,
                    title: classInfo.totalStudents.toString(),
                    subtitle: "Students",
                    iconColor: kPrimaryOrange,
                    main: false,
                  ),
                  // Avg GPA card - highlighted with orange border and big number
                  statBox(
                    icon: Icons.stacked_line_chart,
                    title: classInfo.averageGpa.toStringAsFixed(2),
                    subtitle: "Avg GPA",
                    iconColor: kPrimaryOrange,
                    main: false,
                    highlight: true,
                    valueColor: kPrimaryOrange,
                    titleSize: 19,
                    subtitleSize: 12.5,
                  ),
                  // Attendance card
                  statBox(
                    icon: Icons.check_circle,
                    title: "${classInfo.attendancePercent.toStringAsFixed(1)}%",
                    subtitle: "Attendance",
                    iconColor: kPrimaryOrange,
                    main: false,
                    valueColor: kDarkBlue,
                    titleSize: 19,
                    subtitleSize: 12.5,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

/// Student tile widget (Reusable)
class StudentTile extends StatelessWidget {
  final Student student;
  final VoidCallback? onTap;
  final bool showRank;

  const StudentTile({
    Key? key,
    required this.student,
    this.onTap,
    this.showRank = false,
  }) : super(key: key);

  Widget _buildRankBadge(int rank) {
    final ranks = ["1st", "2nd", "3rd"];
    final badgeColors = [kPrimaryOrange, Color(0xFFD7D9DE), Color(0xFFCDA569)];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColors[rank - 1],
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: kPrimaryOrange.withOpacity(0.13),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        ranks[rank - 1],
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Material(
        color: kLightGrey,
        elevation: 0,
        borderRadius: BorderRadius.circular(14),
        child: ListTile(
          onTap: onTap,
          leading: student.profileUrl.trim().isNotEmpty
              ? CircleAvatar(
                  backgroundImage: NetworkImage(student.profileUrl),
                  radius: 24,
                  onBackgroundImageError: (_, __) {},
                  child: null,
                )
              : CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, color: kDarkBlue.withOpacity(0.45)),
                ),
          title: Text(
            student.name,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 17,
              color: kDarkBlue,
              letterSpacing: -.1,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(
              "GPA: ${student.gpa.toStringAsFixed(2)}",
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: Color(0xFF636880),
              ),
            ),
          ),
          trailing: showRank && student.rank <= 3
              ? _buildRankBadge(student.rank)
              : null,
          contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          // subtle shadow for each card
          tileColor: kLightGrey,
        ),
      ),
    );
  }
}

/// Widget for displaying a stat card (used in performance and attendance tabs)
class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final bool highlight;

  const StatCard({
    Key? key,
    required this.label,
    required this.value,
    required this.icon,
    this.highlight = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 15),
      decoration: BoxDecoration(
        color: highlight ? kPrimaryOrange.withOpacity(0.13) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: highlight ? kPrimaryOrange : kDividerGrey,
          width: highlight ? 1.3 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: kDarkBlue.withOpacity(.045),
            blurRadius: 9,
            offset: const Offset(0, 2.2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: highlight ? kPrimaryOrange : kPrimaryOrange.withOpacity(.2),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(9),
            child: Icon(icon, color: Colors.white, size: highlight ? 27 : 21),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: highlight ? 21 : 18,
                    color: highlight ? kPrimaryOrange : kDarkBlue,
                    letterSpacing: -0.05,
                  ),
                ),
                const SizedBox(height: 2.8),
                Text(
                  label,
                  style: TextStyle(
                    color: highlight ? kPrimaryOrange : kDarkBlue.withOpacity(0.7),
                    fontWeight: FontWeight.w600,
                    fontSize: 13.9,
                    letterSpacing: 0.02,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

///
/// ClassDetailsPage displays detailed info for a selected class.
///
class ClassDetailsPage extends StatefulWidget {
  final ClassInfo classInfo;
  final List<Student> topStudents;
  final List<Student> allStudents;
  final List<Map<String, dynamic>> subjectPerformance;
  final List<Map<String, dynamic>> attendanceMonthlySummary;
  final List<Map<String, dynamic>> notesTimeline;

  const ClassDetailsPage({
    Key? key,
    required this.classInfo,
    required this.topStudents,
    required this.allStudents,
    required this.subjectPerformance,
    required this.attendanceMonthlySummary,
    required this.notesTimeline,
  }) : super(key: key);

  @override
  State<ClassDetailsPage> createState() => _ClassDetailsPageState();
}

class _ClassDetailsPageState extends State<ClassDetailsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String studentSearchQuery = "";
  late List<Map<String, dynamic>> notes;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    notes = List<Map<String, dynamic>>.from(widget.notesTimeline);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void onEditClass() {
    // TODO: Replace with your real edit logic or navigation
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Edit Class tapped.")));
  }

  void onStudentTap(Student student) {
    // TODO: Replace with your navigation to Student Detail page
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Open details for ${student.name}")));
  }

  // --- Modern class overview grid at the top
  Widget buildClassOverviewCard() {
    return ModernClassOverviewGrid(classInfo: widget.classInfo);
  }

  // --- Tabs Implementation ---

  Widget buildTopStudentsTab() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: kDarkBlue.withOpacity(.06),
              blurRadius: 13,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 6),
          itemCount: widget.topStudents.length,
          separatorBuilder: (_, __) => Divider(
            height: 0,
            thickness: .95,
            color: kDividerGrey,
            indent: 8,
            endIndent: 8,
          ),
          itemBuilder: (context, idx) {
            final student = widget.topStudents[idx];
            return StudentTile(
              student: student,
              showRank: true,
              onTap: () => onStudentTap(student),
            );
          },
        ),
      ),
    );
  }

  Widget buildStudentsTab() {
    // Filter students by search
    final filteredStudents = widget.allStudents
        .where((st) => studentSearchQuery.isEmpty ||
            st.name.toLowerCase().contains(studentSearchQuery.toLowerCase()))
        .toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
              left: 15, right: 15, top: 15, bottom: 4),
          child: TextField(
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search, color: kDarkBlue),
              hintText: "Search students...",
              hintStyle: const TextStyle(color: Color(0xFFB1B5C2)),
              fillColor: kLightGrey,
              filled: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(13),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(13),
                borderSide: const BorderSide(color: kPrimaryOrange, width: 1.2),
              ),
            ),
            style: const TextStyle(
              color: kDarkBlue,
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
            onChanged: (val) {
              setState(() {
                studentSearchQuery = val;
              });
            },
          ),
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(13),
              boxShadow: [
                BoxShadow(
                  color: kDarkBlue.withOpacity(.072),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 5, bottom: 7),
              itemCount: filteredStudents.length,
              itemBuilder: (context, idx) {
                final student = filteredStudents[idx];
                return StudentTile(
                  student: student,
                  onTap: () => onStudentTap(student),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget buildPerformanceTab() {
    final classInfo = widget.classInfo;
    final subjectPerformance = widget.subjectPerformance;
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StatCard(
            label: "Class Avg. GPA",
            value: classInfo.averageGpa.toStringAsFixed(2),
            icon: Icons.leaderboard,
            highlight: true,
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.only(left: 2, bottom: 3),
            child: Text(
              "Subject-wise GPA",
              style: const TextStyle(
                color: kDarkBlue,
                fontWeight: FontWeight.bold,
                fontSize: 17,
                letterSpacing: -.2,
              ),
            ),
          ),
          const SizedBox(height: 13),
          ...subjectPerformance.map((sp) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Builder(
                  builder: (context) {
                    final Object? rawGpa = sp['gpa'];
                    final double gpa = (rawGpa is num) ? rawGpa.toDouble() : 0.0;

                    // Always use orange bar color
                    final Color barColor = kPrimaryOrange;

                    final subject = sp['subject'] ?? 'Unknown';

                    double progressValue;
                    try {
                      progressValue = gpa / 4.0;
                    } catch (_) {
                      progressValue = 0.0;
                    }
                    if (progressValue.isNaN || progressValue < 0) progressValue = 0.0;
                    if (progressValue > 1.0) progressValue = 1.0;

                    return Container(
                      decoration: BoxDecoration(
                        color: kLightGrey,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: kDarkBlue.withOpacity(.054),
                            blurRadius: 7,
                            offset: const Offset(0, 3),
                          )
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.book, color: barColor, size: 22),
                          const SizedBox(width: 13),
                          Expanded(
                            flex: 3,
                            child: Text(
                              subject.toString(),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: kDarkBlue,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            flex: 7,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: LinearProgressIndicator(
                                value: progressValue,
                                backgroundColor: kDividerGrey,
                                color: barColor,
                                minHeight: 13,
                              ),
                            ),
                          ),
                          const SizedBox(width: 11),
                          Text(
                            gpa.toStringAsFixed(2),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: barColor,
                              fontSize: 15.5,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              )),
          const SizedBox(height: 28), // Add space at bottom to prevent overflow
        ],
      ),
    );
  }

  Widget buildAttendanceTab() {
    final classInfo = widget.classInfo;
    final attendanceMonthlySummary = widget.attendanceMonthlySummary;
    int totalPresent = 0;
    int totalAbsent = 0;
    for (final m in attendanceMonthlySummary) {
      final Object? pres = m['present'];
      final Object? abs = m['absent'];
      if (pres is int) totalPresent += pres;
      if (abs is int) totalAbsent += abs;
    }
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          StatCard(
            label: "Attendance %",
            value: "${classInfo.attendancePercent.toStringAsFixed(1)}%",
            icon: Icons.task_alt,
            highlight: true,
          ),
          const SizedBox(height: 13),
          Row(
            children: [
              Expanded(
                child: StatCard(
                  label: "Present",
                  value: "$totalPresent",
                  icon: Icons.check,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: StatCard(
                  label: "Absent",
                  value: "$totalAbsent",
                  icon: Icons.clear,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 1.5),
              child: Text(
                "Monthly Summary",
                style: const TextStyle(
                  color: kDarkBlue,
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                  letterSpacing: -.16,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 100,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: attendanceMonthlySummary.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, idx) {
                final m = attendanceMonthlySummary[idx];
                final String month = m['month']?.toString() ?? "N/A";
                final Object? presentValue = m['present'];
                final Object? absentValue = m['absent'];
                final int present = (presentValue is int) ? presentValue : 0;
                final int absent = (absentValue is int) ? absentValue : 0;
                return Container(
                  width: 98,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                  decoration: BoxDecoration(
                    color: kLightGrey,
                    borderRadius: BorderRadius.circular(11),
                    border: Border.all(color: kPrimaryOrange.withOpacity(0.13)),
                    boxShadow: [
                      BoxShadow(
                        color: kDarkBlue.withOpacity(.064),
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        month,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          color: kDarkBlue,
                        ),
                      ),
                      const SizedBox(height: 7),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check, color: kPrimaryOrange, size: 18),
                          const SizedBox(width:4),
                          Text(
                            "$present",
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: kDarkBlue,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.clear, color: kDividerGrey, size: 18),
                          const SizedBox(width:4),
                          Text(
                            "$absent",
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: kDarkBlue,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget buildNotesTab() {
    void onAddNote() {
      // Simulate adding a new note - show dialog for this demo
      showDialog(
        context: context,
        builder: (ctx) {
          String noteText = "";
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            title: const Text("Add Note",
                style: TextStyle(color: kDarkBlue, fontWeight: FontWeight.bold, fontSize: 19)),
            content: TextField(
              maxLines: 3,
              onChanged: (val) => noteText = val,
              decoration: InputDecoration(
                hintText: "Write note about this class...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            actions: [
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: kPrimaryOrange,
                  side: const BorderSide(color: kPrimaryOrange, width: 1.2),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                  textStyle: const TextStyle(fontWeight: FontWeight.bold),
                ),
                child: const Text("Cancel"),
                onPressed: () => Navigator.pop(ctx),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryOrange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
                  textStyle: const TextStyle(fontWeight: FontWeight.bold),
                  elevation: 0,
                ),
                child: const Text("Add"),
                onPressed: () {
                  if (noteText.trim().isNotEmpty) {
                    setState(() {
                      notes.insert(0, {
                        "date": DateTime.now().toString().substring(0, 10),
                        "note": noteText.trim(),
                      });
                    });
                    Navigator.pop(ctx);
                  }
                },
              ),
            ],
          );
        },
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 13),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.add, color: Colors.white, size: 22),
              label: const Text(
                "Add Note",
                style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white, fontSize: 16),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                backgroundColor: kPrimaryOrange,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                elevation: 2,
              ),
              onPressed: onAddNote,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: notes.isEmpty
                ? const Center(
                    child: Text(
                      "No notes yet.",
                      style: TextStyle(color: kDarkBlue, fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                  )
                : ListView.separated(
                    itemCount: notes.length,
                    separatorBuilder: (_, __) => Divider(
                      height: 0,
                      thickness: 1.0,
                      color: kDividerGrey,
                      indent: 2,
                      endIndent: 2,
                    ),
                    itemBuilder: (context, idx) {
                      final nt = notes[idx];
                      final String noteText = nt["note"]?.toString() ?? "";
                      final String dateText = nt["date"]?.toString() ?? "";
                      return Container(
                        decoration: BoxDecoration(
                          color: kLightGrey,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: kDarkBlue.withOpacity(0.045),
                              blurRadius: 7,
                              offset: const Offset(0, 2),
                            ),
                          ],
                          border: Border.all(color: kDividerGrey, width: .82),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            LayoutBuilder(builder: (context, constraints) {
                              return ConstrainedBox(
                                constraints: const BoxConstraints(
                                  maxHeight: 70,
                                  minHeight: 0,
                                ),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: Text(
                                    noteText,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        color: kDarkBlue,
                                        fontWeight: FontWeight.w500,
                                        height: 1.23
                                    ),
                                    softWrap: true,
                                    overflow: TextOverflow.visible,
                                  ),
                                ),
                              );
                            }),
                            const SizedBox(height: 5),
                            Text(
                              dateText,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF969BAD),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // --- Main Scaffold ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kLightGrey,
      appBar: AppBar(
        leading: const BackButton(color: Colors.white),
        backgroundColor: kDarkBlue,
        title: const Text(
          "Class Details",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
            letterSpacing: -.3,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 7),
            child: IconButton(
              icon: const Icon(Icons.edit, color: kPrimaryOrange, size: 26),
              tooltip: "Edit Class",
              onPressed: onEditClass,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
          ),
        ],
        elevation: 9,
        shadowColor: kDarkBlue.withOpacity(0.04),
      ),
      body: SafeArea(
        child: Column(
          children: [
            buildClassOverviewCard(),
            Container(
              decoration: const BoxDecoration(
                  color: kLightGrey,
                  border: Border(
                    top: BorderSide(color: kDividerGrey, width: 1.1),
                  )),
              child: TabBar(
                controller: _tabController,
                isScrollable: true,
                labelColor: kPrimaryOrange,
                unselectedLabelColor: kDarkBlue.withOpacity(.47),
                indicatorColor: kPrimaryOrange,
                indicatorWeight: 4,
                indicator: UnderlineTabIndicator(
                  borderSide: const BorderSide(width: 4, color: kPrimaryOrange),
                  insets: const EdgeInsets.symmetric(horizontal: 22),
                ),
                splashFactory: NoSplash.splashFactory,
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  letterSpacing: 0.02,
                ),
                tabs: const [
                  Tab(
                    icon: Icon(Icons.leaderboard, color: kPrimaryOrange),
                    child: Text("Top Students"),
                  ),
                  Tab(
                    icon: Icon(Icons.people_alt, color: kPrimaryOrange),
                    child: Text("Students"),
                  ),
                  Tab(
                    icon: Icon(Icons.bar_chart, color: kPrimaryOrange),
                    child: Text("Performance"),
                  ),
                  Tab(
                    icon: Icon(Icons.fact_check, color: kPrimaryOrange),
                    child: Text("Attendance"),
                  ),
                  Tab(
                    icon: Icon(Icons.note_alt, color: kPrimaryOrange),
                    child: Text("Notes"),
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                physics: const BouncingScrollPhysics(),
                children: [
                  buildTopStudentsTab(),
                  buildStudentsTab(),
                  buildPerformanceTab(),
                  buildAttendanceTab(),
                  buildNotesTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
