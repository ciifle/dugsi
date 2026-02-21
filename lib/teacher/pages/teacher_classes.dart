import 'package:flutter/material.dart';

class TeacherMyClassesScreen extends StatefulWidget {
  const TeacherMyClassesScreen({Key? key}) : super(key: key);

  @override
  State<TeacherMyClassesScreen> createState() => _TeacherMyClassesScreenState();
}

class _TeacherMyClassesScreenState extends State<TeacherMyClassesScreen> {
  // Dummy teacher details and class data
  final String teacherName = "Mrs. Olivia Bennett";
  final String subtitle = "Your assigned subject classes are listed below.";
  final List<String> filterTypes = [
    "All",
    "Primary",
    "Secondary",
    "Higher Secondary"
  ];
  int selectedFilter = 0;

  // Dummy data model for class cards
  final List<Map<String, dynamic>> allClasses = [
    {
      "category": "Primary",
      "className": "Grade 3 – B",
      "subject": "Mathematics",
      "totalStudents": 27,
      "weeklyPeriods": 5,
      "timing": "8:30 AM - 9:20 AM",
      "syllabus":
          "Numbers, Addition & Subtraction, Basic Geometry, Problem Solving.",
      "classTeacher": "Yes",
      "notes": "Support required for slow learners."
    },
    {
      "category": "Secondary",
      "className": "Grade 8 – A",
      "subject": "Science",
      "totalStudents": 32,
      "weeklyPeriods": 6,
      "timing": "10:15 AM - 11:05 AM",
      "syllabus": "Physics (Force, Energy), Chemistry (Mixtures), Biology.",
      "classTeacher": "No",
      "notes": "Lab work planned for next week."
    },
    {
      "category": "Secondary",
      "className": "Grade 7 – C",
      "subject": "Mathematics",
      "totalStudents": 29,
      "weeklyPeriods": 5,
      "timing": "9:20 AM - 10:10 AM",
      "syllabus": "Algebra, Fractions, Ratios.",
      "classTeacher": "No",
      "notes": ""
    },
    {
      "category": "Higher Secondary",
      "className": "Grade 12 – Sci.",
      "subject": "Biology",
      "totalStudents": 18,
      "weeklyPeriods": 8,
      "timing": "11:15 AM - 12:05 PM",
      "syllabus":
          "Human Physiology, Plant Biology, Ecology, Genetics overview.",
      "classTeacher": "No",
      "notes": "Additional assignments sent to students."
    },
    {
      "category": "Primary",
      "className": "Grade 5 – A",
      "subject": "Science",
      "totalStudents": 30,
      "weeklyPeriods": 4,
      "timing": "1:00 PM - 1:50 PM",
      "syllabus": "Plants, Animals, Water cycle.",
      "classTeacher": "Yes",
      "notes": ""
    },
  ];

  List<Map<String, dynamic>> get filteredClasses {
    if (selectedFilter == 0) return allClasses;
    final type = filterTypes[selectedFilter];
    return allClasses.where((c) => c['category'] == type).toList();
  }

  static const Color _kBlue = Color(0xFF023471);
  static const Color _kGreen = Color(0xFF5AB04B);
  static const Color _kBg = Color(0xFFF4F6F8);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBg,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _ClassesTopBar(onBack: () => Navigator.of(context).maybePop()),
                const SizedBox(height: 20),
                _IntroCard(
                teacherName: teacherName,
                totalClasses: allClasses.length,
                subtitle: subtitle,
                ),
                const SizedBox(height: 22),
                const Text(
                  "Filter by class type",
                  style: TextStyle(color: Color(0xFF023471), fontWeight: FontWeight.w600, fontSize: 16),
                ),
                const SizedBox(height: 10),
                Wrap(
                spacing: 8,
                runSpacing: 8,
                children: List.generate(
                  filterTypes.length,
                  (idx) => ChoiceChip(
                    label: Text(
                      filterTypes[idx],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: selectedFilter == idx
                            ? Colors.white
                            : const Color(0xFF023471),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    selected: selectedFilter == idx,
                    backgroundColor: Colors.white,
                    selectedColor: const Color(0xFF5AB04B),
                    shape: StadiumBorder(
                      side: BorderSide(
                        color: const Color(0xFF023471).withOpacity(0.24),
                      ),
                    ),
                    onSelected: (_) {
                      setState(() {
                        selectedFilter = idx;
                      });
                    },
                  ),
                ),
                ),
                const SizedBox(height: 22),
                ListView.builder(
                itemCount: filteredClasses.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (ctx, index) {
                  final classData = filteredClasses[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: _ClassCard(
                      classData: classData,
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
class _ClassesTopBar extends StatelessWidget {
  final VoidCallback onBack;

  const _ClassesTopBar({required this.onBack});

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
                  BoxShadow(color: const Color(0xFF023471).withOpacity(0.1), blurRadius: 12, offset: const Offset(0, 4)),
                ],
              ),
              child: const Icon(Icons.arrow_back_rounded, color: Color(0xFF023471), size: 24),
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Text(
              "My Classes",
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

// ------------------- Reusable Widgets Below ----------------------

// ---------- SECTION 1: Intro Card ----------
class _IntroCard extends StatelessWidget {
  final String teacherName, subtitle;
  final int totalClasses;
  const _IntroCard({
    required this.teacherName,
    required this.totalClasses,
    required this.subtitle,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: const Color(0xFF023471).withOpacity(0.1), blurRadius: 16, offset: const Offset(0, 6)),
          BoxShadow(color: const Color(0xFF023471).withOpacity(0.06), blurRadius: 32, offset: const Offset(0, 12)),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF5AB04B).withOpacity(0.12),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: const Color(0xFF5AB04B).withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 3))],
            ),
            child: const Icon(Icons.school_rounded, color: Color(0xFF5AB04B), size: 28),
          ),
            const SizedBox(width: 16),
            // Expanded: To ensure overflow safety if text is long
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
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "$totalClasses classes assigned",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF023471),
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF023471),
                      fontSize: 13,
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

// ---------- SECTION 3-5: Class Card & Details ----------
class _ClassCard extends StatelessWidget {
  final Map<String, dynamic> classData;
  const _ClassCard({required this.classData, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: const Color(0xFF023471).withOpacity(0.1), blurRadius: 16, offset: const Offset(0, 6)),
          BoxShadow(color: const Color(0xFF023471).withOpacity(0.06), blurRadius: 32, offset: const Offset(0, 12)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF5AB04B).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [BoxShadow(color: const Color(0xFF5AB04B).withOpacity(0.08), blurRadius: 6, offset: const Offset(0, 2))],
                ),
                child: const Icon(Icons.class_rounded, color: Color(0xFF5AB04B), size: 24),
              ),
                const SizedBox(width: 12),
                // Expanded Column INSIDE Row (overflow protection)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        classData['className'] ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFF023471),
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        classData['subject'] ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFF023471),
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Details row (all expanded/wrapped/overflow safe)
            Wrap(
              spacing: 16,
              runSpacing: 8, // Prevents horizontal overflow
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                _InfoRow(
                    icon: Icons.people,
                    label: 'Students',
                    value: "${classData['totalStudents']}"),
                _InfoRow(
                    icon: Icons.schedule,
                    label: "Weekly Periods",
                    value: "${classData['weeklyPeriods']}"),
                _InfoRow(
                    icon: Icons.access_time,
                    label: "Timing",
                    value: classData['timing']),
              ],
            ),
            const SizedBox(height: 10),

            // ---------- SECTION 4: Class Actions (overflow-safe wrap) ----------
            _ClassActions(),

            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: _ClassExpansionDetails(classData: classData),
            ),
          ],
        ),
    );
  }
}

/// Small icon+text value row (never overflows)
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      // No fixed width; if tight, will compress safely
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 17, color: Color(0xFF5AB04B)),
        const SizedBox(width: 5),
        Text(
          "$label: ",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Color(0xFF023471),
            fontWeight: FontWeight.w500,
            fontSize: 13,
          ),
        ),
        Flexible(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFF023471),
              fontWeight: FontWeight.w400,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }
}

// ---------- SECTION 4: Class Actions Wrap ----------
class _ClassActions extends StatelessWidget {
  // These actions are only for UI demo; no logic
  final List<Map<String, dynamic>> actions = const [
    {
      "label": "Students",
      "icon": Icons.group,
    },
    {
      "label": "Attendance",
      "icon": Icons.check_circle_outline,
    },
    {
      "label": "Assignments",
      "icon": Icons.assignment_outlined,
    },
    {
      "label": "Results",
      "icon": Icons.assessment_outlined,
    },
  ];

  const _ClassActions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Wrap for overflow safety, NO fixed widths
    return Wrap(
      spacing: 10,
      runSpacing: 8,
      children: actions.map((action) {
        return Material(
          color: const Color(0xFF5AB04B),
          borderRadius: BorderRadius.circular(30),
          child: InkWell(
            borderRadius: BorderRadius.circular(30),
            // onTap: () {}, // Could implement action dialog
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(action['icon'], color: Colors.white, size: 19),
                  const SizedBox(width: 6),
                  Text(
                    action['label'],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 13.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ---------- SECTION 5: Expandable Details ----------
class _ClassExpansionDetails extends StatelessWidget {
  final Map<String, dynamic> classData;
  const _ClassExpansionDetails({required this.classData, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use ExpansionTile only, default animation
    return ExpansionTile(
      tilePadding: const EdgeInsets.symmetric(horizontal: 0),
      title: Text(
        "More Details",
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          color: Color(0xFF023471),
          fontWeight: FontWeight.w600,
          fontSize: 14.5,
        ),
      ),
      iconColor: const Color(0xFF5AB04B),
      collapsedIconColor: const Color(0xFF5AB04B),
      childrenPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
      children: [
        // Syllabus
        _ExpansionTileRow(
          icon: Icons.menu_book_outlined,
          label: "Syllabus",
          value: classData['syllabus'] ?? "Not available",
        ),
        if ((classData['classTeacher'] as String?) == 'Yes')
          _ExpansionTileRow(
            icon: Icons.star_outline,
            label: "You are the class teacher",
            value: "",
          ),
        if ((classData['notes'] as String?)?.trim().isNotEmpty == true)
          _ExpansionTileRow(
            icon: Icons.note_outlined,
            label: "Notes",
            value: classData['notes'],
          ),
      ],
    );
  }
}

// Helper for expansion tile details
class _ExpansionTileRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _ExpansionTileRow(
      {required this.icon, required this.label, required this.value, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 4, 0, 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 19, color: Color(0xFF5AB04B)),
          const SizedBox(width: 10),
          // Expanded Column for label and value (overflow safety)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                      color: Color(0xFF023471),
                      fontWeight: FontWeight.w600,
                      fontSize: 13.5),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (value.trim().isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 2.0),
                    child: Text(
                      value,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF023471),
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
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

