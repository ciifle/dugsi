import 'package:flutter/material.dart';

class TeacherStudentManagementScreen extends StatefulWidget {
  const TeacherStudentManagementScreen({Key? key}) : super(key: key);

  @override
  State<TeacherStudentManagementScreen> createState() => _TeacherStudentManagementScreenState();
}

class _TeacherStudentManagementScreenState extends State<TeacherStudentManagementScreen> {
  // Dummy teacher and students data
  final String teacherName = "Mrs. Katherine Johnson";
  final String subtitle = "Manage your students efficiently!";
  final List<Student> allStudents = [
    Student(
      name: "Ava Carter",
      grade: "Grade 6",
      section: "A",
      attendance: 97,
      pendingAssignments: 1,
      averageGrade: "A+",
      performance: "Top",
      contact: "ava.carter@example.com, +1 (123) 555-0100",
      remarks: "Has shown excellent progress.",
      specialAttention: "None",
    ),
    Student(
      name: "Liam Brown",
      grade: "Grade 6",
      section: "B",
      attendance: 82,
      pendingAssignments: 3,
      averageGrade: "B-",
      performance: "Needs Attention",
      contact: "liam.brown@example.com, +1 (123) 555-0101",
      remarks: "Needs encouragement for homework.",
      specialAttention: "Monitor participation",
    ),
    Student(
      name: "Sofia Patel",
      grade: "Grade 7",
      section: "A",
      attendance: 90,
      pendingAssignments: 0,
      averageGrade: "A",
      performance: "Top",
      contact: "sofia.patel@example.com, +1 (123) 555-0102",
      remarks: "Great leadership skills.",
      specialAttention: "Encourage peer mentoring",
    ),
    Student(
      name: "Ethan Lee",
      grade: "Grade 7",
      section: "A",
      attendance: 70,
      pendingAssignments: 4,
      averageGrade: "C",
      performance: "Needs Attention",
      contact: "ethan.lee@example.com, +1 (123) 555-0103",
      remarks: "Struggles with math concepts.",
      specialAttention: "Assign extra math sessions",
    ),
    // Add more dummy students as needed
  ];

  // Filters
  final List<String> gradeFilters = ["Grade 6", "Grade 7"];
  final List<String> performanceFilters = ["Top", "Needs Attention"];
  String selectedFilter = "All";

  List<Student> get filteredStudents {
    if (selectedFilter == "All") return allStudents;
    if (gradeFilters.contains(selectedFilter)) {
      return allStudents.where((s) => s.grade == selectedFilter).toList();
    }
    if (performanceFilters.contains(selectedFilter)) {
      return allStudents.where((s) => s.performance == selectedFilter).toList();
    }
    return allStudents;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF023471),
        elevation: 2,
        centerTitle: true,
        automaticallyImplyLeading: true,
        title: const Text(
          "Students",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
            letterSpacing: 0.2,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white, // back arrow color
        ),
      ),
      body: SingleChildScrollView(
        // Ensures vertical scrolling, helps prevent overflow everywhere
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section 1: Page Intro Card
              TeacherIntroCard(
                teacherName: teacherName,
                totalStudents: allStudents.length,
                subtitle: subtitle,
              ),
              const SizedBox(height: 20),

              // Section 2: Student Filter (Wrap to prevent horizontal overflow)
              Text(
                "Filter Students",
                style: const TextStyle(
                  color: Color(0xFF023471),
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildFilterChip("All"),
                  ...gradeFilters.map((grade) => _buildFilterChip(grade)),
                  ...performanceFilters.map((perf) => _buildFilterChip(perf)),
                ],
              ),
              const SizedBox(height: 20),

              // Section 3: Student List (cards)
              ListView.builder(
                itemCount: filteredStudents.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(), // no vertical ListView scrolling
                itemBuilder: (context, index) {
                  final student = filteredStudents[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: StudentCard(
                      student: student,
                      // No fixed heights, no row overflow: content wraps safely.
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

  Widget _buildFilterChip(String label) {
    final bool selected = label == selectedFilter;
    return FilterChip(
      label: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: selected ? Colors.white : const Color(0xFF023471),
          fontWeight: FontWeight.w500,
        ),
      ),
      selected: selected,
      onSelected: (_) {
        setState(() {
          selectedFilter = label;
        });
      },
      backgroundColor: Colors.white,
      selectedColor: const Color(0xFF5AB04B),
      checkmarkColor: Colors.white,
      side: selected
          ? BorderSide.none
          : const BorderSide(color: Color(0xFF023471), width: 1.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      showCheckmark: false,
    );
  }
}

// Section 1: Teacher Intro Card
class TeacherIntroCard extends StatelessWidget {
  final String teacherName;
  final int totalStudents;
  final String subtitle;
  const TeacherIntroCard({
    super.key,
    required this.teacherName,
    required this.totalStudents,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Accent Orange vertical line for brand accent
            Container(
              width: 6,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFF5AB04B),
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    teacherName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF023471),
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Total Students: $totalStudents",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF023471),
                      fontWeight: FontWeight.w400,
                      fontSize: 15,
                    ),
                  ),
                  if (subtitle.trim().isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF023471),
                        fontWeight: FontWeight.w300,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            // Accent icon for style
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF5AB04B).withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(8),
              child: const Icon(
                Icons.school_rounded,
                color: Color(0xFF5AB04B),
                size: 28,
              ),
            )
          ],
        ),
      ),
    );
  }
}

// Section 3: Student Card
class StudentCard extends StatelessWidget {
  final Student student;
  const StudentCard({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Name, Class, Section
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Orange avatar/initial for brand accent
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF5AB04B).withOpacity(0.1),
                  ),
                  padding: const EdgeInsets.all(9),
                  child: Icon(
                    Icons.person,
                    color: const Color(0xFF5AB04B),
                    size: 26,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  // Prevents overflow if name/class is too long
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        student.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFF023471),
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        "${student.grade} • Section ${student.section}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFF023471),
                          fontSize: 13.5,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                // Short summary (Attendance or Top/Needs Attention icon highlight)
                const SizedBox(width: 8),
                _StudentPerformanceBadge(performance: student.performance),
              ],
            ),
            const SizedBox(height: 10),

            // Attendance, Assignments, Grade (horizontal, use Wrap to avoid overflow)
            Wrap(
              spacing: 18,
              runSpacing: 6,
              children: [
                _infoChip(
                  icon: Icons.event_available_outlined,
                  label: "${student.attendance}%",
                  caption: "Attendance",
                  accent: false,
                ),
                _infoChip(
                  icon: Icons.assignment_outlined,
                  label: "${student.pendingAssignments}",
                  caption: "Pending Assignments",
                  accent: student.pendingAssignments > 0,
                ),
                _infoChip(
                  icon: Icons.grade_rounded,
                  label: student.averageGrade,
                  caption: "Avg. Grade",
                  accent: false,
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Section 4: Student Actions (Wrap to be always overflow-safe)
            Wrap(
              spacing: 10,
              runSpacing: 8,
              children: [
                // All action chips use accent style
                _actionChip(icon: Icons.check, label: "Mark Attendance"),
                _actionChip(icon: Icons.assignment, label: "View Assignments"),
                _actionChip(icon: Icons.edit_rounded, label: "Enter Results"),
                _actionChip(icon: Icons.message, label: "Send Message"),
              ],
            ),
            const SizedBox(height: 4),
            // Section 5: Expandable Details
            ExpansionTile(
              tilePadding: EdgeInsets.zero,
              childrenPadding: const EdgeInsets.only(left: 2, right: 2, bottom: 6),
              iconColor: const Color(0xFF023471),
              collapsedIconColor: const Color(0xFF023471),
              title: Text(
                "More Details",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xFF023471),
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
              ),
              children: [
                // Contact info
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.email_outlined,
                        size: 18, color: Color(0xFF023471)),
                    const SizedBox(width: 7),
                    Expanded(
                      child: Text(
                        student.contact,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFF023471),
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.note_alt_outlined,
                        size: 18, color: Color(0xFF023471)),
                    const SizedBox(width: 7),
                    Expanded(
                      child: Text(
                        student.remarks,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFF023471),
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.flag,
                        size: 18, color: Color(0xFF5AB04B)),
                    const SizedBox(width: 7),
                    Expanded(
                      child: Text(
                        student.specialAttention,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFF5AB04B),
                          fontSize: 14,
                        ),
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

  // Information chip (attendance, grade, assignment)
  Widget _infoChip(
    {required IconData icon,
    required String label,
    required String caption,
    required bool accent}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
      decoration: BoxDecoration(
        color: accent
            ? const Color(0xFF5AB04B).withOpacity(0.10)
            : const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: accent ? const Color(0xFF5AB04B) : const Color(0xFF023471),
          width: accent ? 1.3 : 0.8,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon,
              color: accent ? const Color(0xFF5AB04B) : const Color(0xFF023471),
              size: 18),
          const SizedBox(width: 6),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: accent ? const Color(0xFF5AB04B) : const Color(0xFF023471),
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              Text(
                caption,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: accent ? const Color(0xFF5AB04B) : const Color(0xFF023471),
                  fontWeight: FontWeight.w400,
                  fontSize: 11,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  // Action chip for student actions
  Widget _actionChip({required IconData icon, required String label}) {
    return ActionChip(
      backgroundColor: const Color(0xFF5AB04B),
      elevation: 1,
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 18),
          const SizedBox(width: 4),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
      onPressed: () {
        // No-op for demo
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      labelPadding: const EdgeInsets.symmetric(horizontal: 7, vertical: 0),
      visualDensity: VisualDensity.compact,
    );
  }
}

class _StudentPerformanceBadge extends StatelessWidget {
  final String performance;
  const _StudentPerformanceBadge({required this.performance});
  @override
  Widget build(BuildContext context) {
    Color badgeColor = performance == "Top"
        ? const Color(0xFF5AB04B)
        : const Color(0xFF023471);
    IconData badgeIcon = performance == "Top"
        ? Icons.star_rounded
        : Icons.report_problem_rounded;
    return Container(
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.18),
        borderRadius: BorderRadius.circular(7),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          Icon(
            badgeIcon,
            color: badgeColor,
            size: 17,
          ),
          const SizedBox(width: 3),
          Text(
            performance,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: badgeColor,
              fontWeight: FontWeight.w500,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

// Dummy student model
class Student {
  final String name;
  final String grade;
  final String section;
  final int attendance;
  final int pendingAssignments;
  final String averageGrade;
  final String performance;
  final String contact;
  final String remarks;
  final String specialAttention;
  Student({
    required this.name,
    required this.grade,
    required this.section,
    required this.attendance,
    required this.pendingAssignments,
    required this.averageGrade,
    required this.performance,
    required this.contact,
    required this.remarks,
    required this.specialAttention,
  });
}

