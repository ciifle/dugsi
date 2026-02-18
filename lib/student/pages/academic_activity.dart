import 'package:flutter/material.dart';

// ---------- BRAND COLORS ----------
const Color kPrimaryColor = Color(0xFF023471);   // Dark Blue
const Color kAccentColor = Color(0xFF5AB04B);    // Orange
const Color kBackgroundColor = Color(0xFFF9F9F9); // Very light gray
const Color kTextColor = kPrimaryColor;

// ---------- DUMMY ACTIVITY DATA ----------
class AcademicActivity {
  final String title;
  final String subject;
  final String type;
  final DateTime dueDate;
  final String status;
  final String description;
  final DateTime? submissionDate;
  final String? teacherRemark;

  AcademicActivity({
    required this.title,
    required this.subject,
    required this.type,
    required this.dueDate,
    required this.status,
    required this.description,
    this.submissionDate,
    this.teacherRemark,
  });
}

final List<AcademicActivity> dummyActivities = [
  AcademicActivity(
    title: "Algebra Homework 1",
    subject: "Mathematics",
    type: "Homework",
    dueDate: DateTime.now().add(const Duration(days: 2)),
    status: "Pending",
    description: "Solve all exercises from Chapter 3 (pages 34-36).",
  ),
  AcademicActivity(
    title: "Physics Assignment",
    subject: "Physics",
    type: "Assignment",
    dueDate: DateTime.now().subtract(const Duration(days: 1)),
    status: "Late",
    description: "Write a report on Newton's Laws of Motion.",
    submissionDate: null,
    teacherRemark: null,
  ),
  AcademicActivity(
    title: "Chemistry Project",
    subject: "Chemistry",
    type: "Project",
    dueDate: DateTime.now().add(const Duration(days: 10)),
    status: "Pending",
    description: "Prepare a project on polymers and plastics.",
  ),
  AcademicActivity(
    title: "Art Class Drawing",
    subject: "Art",
    type: "Classwork",
    dueDate: DateTime.now().subtract(const Duration(days: 5)),
    status: "Submitted",
    description: "Draw a landscape using watercolors.",
    submissionDate: DateTime.now().subtract(const Duration(days: 3)),
    teacherRemark: "Excellent color technique!",
  ),
  AcademicActivity(
    title: "Computer Lab Practical",
    subject: "Computer Science",
    type: "Practical",
    dueDate: DateTime.now().add(const Duration(days: 3)),
    status: "Pending",
    description: "Implement a calculator in Python.",
  ),
  AcademicActivity(
    title: "English Essay",
    subject: "English",
    type: "Assignment",
    dueDate: DateTime.now(),
    status: "Submitted",
    description: "Write a 500-word essay on Shakespeare.",
    submissionDate: DateTime.now().subtract(const Duration(days: 1)),
    teacherRemark: "Well structured analysis.",
  ),
];

// ---------- FILTER CHIP DATA ----------
const List<String> filterCategories = [
  'All', 'Assignments', 'Projects', 'Homework'
];

// ---------- MAIN SCREEN ----------
class StudentAcademicActivityScreen extends StatefulWidget {
  const StudentAcademicActivityScreen({Key? key}) : super(key: key);

  @override
  State<StudentAcademicActivityScreen> createState() => _StudentAcademicActivityScreenState();
}

class _StudentAcademicActivityScreenState extends State<StudentAcademicActivityScreen> {
  String selectedCategory = 'All';

  List<AcademicActivity> getFilteredActivities() {
    if (selectedCategory == 'All') {
      return dummyActivities;
    }
    return dummyActivities.where((a) {
      if (selectedCategory == 'Assignments') {
        return a.type == 'Assignment';
      }
      if (selectedCategory == 'Projects') {
        return a.type == 'Project';
      }
      if (selectedCategory == 'Homework') {
        return a.type == 'Homework';
      }
      return false;
    }).toList();
  }

  // Safe summary statistic calculation
  int getTotal() => getFilteredActivities().length;
  int getCompleted() => getFilteredActivities().where((a) => a.status == 'Submitted').length;
  int getPending() => getFilteredActivities().where((a) => a.status == 'Pending').length;
  int getOverdue() => getFilteredActivities().where((a) => a.status == 'Late').length;

  @override
  Widget build(BuildContext context) {
    final activitiesToShow = getFilteredActivities();
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'Academic Activities',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            // Ensure safe truncation for appbar title
            overflow: TextOverflow.ellipsis,
            fontSize: 20,
          ),
          maxLines: 1,
        ),
        backgroundColor: kPrimaryColor,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        elevation: 0.5,
      ),
      body: SingleChildScrollView(
        // Prevents RenderFlex overflow by allowing full vertical scroll
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- SECTION 1: ACTIVITY SUMMARY ---
              _ActivitySummaryCard(
                total: getTotal(),
                completed: getCompleted(),
                pending: getPending(),
                overdue: getOverdue(),
              ),

              const SizedBox(height: 20),

              // --- SECTION 3: CATEGORY FILTER CHIPS (UI ONLY) ---
              _ActivityFilterChips(
                selectedCategory: selectedCategory,
                onCategoryChange: (cat) {
                  setState(() {
                    selectedCategory = cat;
                  });
                },
              ),

              const SizedBox(height: 20),

              // --- SECTION 2: ACTIVITY LIST CARDS ---
              // Column with shrinkWrap*ListView inside, physics: NeverScrollable
              Column(
                children: List.generate(
                  activitiesToShow.length,
                  (i) => Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: _AcademicActivityCard(activity: activitiesToShow[i]),
                  ),
                ),
              ),
              // If no activities
              if (activitiesToShow.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40.0),
                  child: Center(
                    child: Text(
                      'No activities found.',
                      style: TextStyle(
                        color: kTextColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        overflow: TextOverflow.ellipsis,
                      ),
                      maxLines: 1,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------- WIDGETS ----------

class _ActivitySummaryCard extends StatelessWidget {
  final int total;
  final int completed;
  final int pending;
  final int overdue;
  const _ActivitySummaryCard({
    Key? key,
    required this.total,
    required this.completed,
    required this.pending,
    required this.overdue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use Row -> Expanded Column for no-fix width & overflow safety
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _SummaryInfo(
              label: 'Total',
              count: total,
              color: kPrimaryColor,
            ),
            _SummaryInfo(
              label: 'Completed',
              count: completed,
              color: kAccentColor,
            ),
            _SummaryInfo(
              label: 'Pending',
              count: pending,
              color: kPrimaryColor,
            ),
            _SummaryInfo(
              label: 'Overdue',
              count: overdue,
              color: kAccentColor,
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryInfo extends StatelessWidget {
  final String label;
  final int count;
  final Color color;
  const _SummaryInfo({
    Key? key,
    required this.label,
    required this.count,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Column is fine in a Row, so wrap in Expanded to enforce constraints
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$count',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
              overflow: TextOverflow.ellipsis,
            ),
            maxLines: 1,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: kTextColor,
              fontSize: 13,
              fontWeight: FontWeight.w500,
              overflow: TextOverflow.ellipsis,
            ),
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}

class _ActivityFilterChips extends StatelessWidget {
  final String selectedCategory;
  final ValueChanged<String> onCategoryChange;
  const _ActivityFilterChips({
    Key? key,
    required this.selectedCategory,
    required this.onCategoryChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Always use Wrap for chips. No Row.
    return Wrap(
      spacing: 12,
      runSpacing: 8,
      children: filterCategories.map((cat) {
        final isSelected = selectedCategory == cat;
        return ChoiceChip(
          label: Text(
            cat,
            style: TextStyle(
              color: isSelected ? Colors.white : kTextColor,
              fontWeight: FontWeight.w600,
              overflow: TextOverflow.ellipsis,
            ),
            maxLines: 1,
          ),
          selected: isSelected,
          selectedColor: kAccentColor,
          backgroundColor: Colors.white,
          side: BorderSide(
            color: isSelected ? kAccentColor : kPrimaryColor.withOpacity(0.15),
            width: 1,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          onSelected: (_) => onCategoryChange(cat),
          // Material chip clicks only change state, no overflow risk
        );
      }).toList(),
    );
  }
}

class _AcademicActivityCard extends StatelessWidget {
  final AcademicActivity activity;
  const _AcademicActivityCard({Key? key, required this.activity}) : super(key: key);

  String getFormattedDueDate(DateTime dt) {
    // dd MMM yyyy
    return "${dt.day.toString().padLeft(2, '0')} "
        "${_month(dt.month)} ${dt.year}";
  }

  static String _month(int m) {
    const months = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug',
      'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return (m >= 1 && m <= 12) ? months[m] : '';
  }

  @override
  Widget build(BuildContext context) {
    // Safe Column, status badge, and ExpansionTile
    return Card(
      color: Colors.white,
      elevation: 3,
      shadowColor: kPrimaryColor.withOpacity(.06),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // LEFT: Icon
                  Padding(
                    padding: const EdgeInsets.only(right: 12, top: 2),
                    child: _activityIcon(activity.type),
                  ),
                  // CENTER: Main Info (Expanded for overflow prevention)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          activity.title,
                          style: const TextStyle(
                            color: kPrimaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            overflow: TextOverflow.ellipsis,
                          ),
                          maxLines: 1,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          activity.subject,
                          style: const TextStyle(
                            color: kTextColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            overflow: TextOverflow.ellipsis,
                          ),
                          maxLines: 1,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            // Type
                            Flexible(
                              child: Text(
                                activity.type,
                                style: TextStyle(
                                  color: kPrimaryColor.withOpacity(.8),
                                  fontWeight: FontWeight.w400,
                                  fontSize: 13,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                maxLines: 1,
                              ),
                            ),
                            const SizedBox(width: 16),
                            // Due
                            Flexible(
                              child: Text(
                                'Due: ${getFormattedDueDate(activity.dueDate)}',
                                style: const TextStyle(
                                  color: kPrimaryColor,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 13,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // RIGHT: Status badge
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 0),
                    child: _StatusBadge(status: activity.status),
                  ),
                ],
              ),
            ),
            // Optional: ExpansionTile for details
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: _ActivityExpansionTile(activity: activity),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

// Safe custom ExpansionTile for details (not manually animated)
class _ActivityExpansionTile extends StatelessWidget {
  final AcademicActivity activity;
  const _ActivityExpansionTile({Key? key, required this.activity})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      tilePadding: const EdgeInsets.symmetric(horizontal: 6),
      childrenPadding: const EdgeInsets.only(left: 6, right: 6, bottom: 10),
      title: Text(
        'Show Details',
        style: TextStyle(
          color: kPrimaryColor.withOpacity(0.9),
          fontWeight: FontWeight.w600,
          fontSize: 13,
          overflow: TextOverflow.ellipsis,
        ),
        maxLines: 1,
      ),
      iconColor: kAccentColor,
      collapsedIconColor: kAccentColor,
      // No nested scroll, safe expansion
      children: [
        // Description
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.description_outlined, size: 18, color: kPrimaryColor),
            const SizedBox(width: 7),
            Expanded(
              child: Text(
                activity.description,
                style: const TextStyle(
                  color: kTextColor,
                  fontSize: 13,
                  overflow: TextOverflow.ellipsis,
                ),
                maxLines: 3,
              ),
            ),
          ],
        ),
        const SizedBox(height: 9),
        // Submission date
        if (activity.submissionDate != null)
          Row(
            children: [
              const Icon(Icons.check_circle_outline, size: 18, color: kAccentColor),
              const SizedBox(width: 7),
              Text(
                'Submitted: '
                "${activity.submissionDate!.day.toString().padLeft(2, '0')} "
                "${_AcademicActivityCard._month(activity.submissionDate!.month)} "
                "${activity.submissionDate!.year}",
                style: const TextStyle(
                  color: kPrimaryColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                  overflow: TextOverflow.ellipsis,
                ),
                maxLines: 1,
              ),
            ],
          ),
        // Teacher remarks
        if (activity.teacherRemark != null)
          Padding(
            padding: const EdgeInsets.only(top: 7.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.emoji_objects_outlined, size: 18, color: kAccentColor),
                const SizedBox(width: 7),
                Expanded(
                  child: Text(
                    activity.teacherRemark ?? "",
                    style: const TextStyle(
                      color: kAccentColor,
                      fontStyle: FontStyle.italic,
                      fontSize: 13,
                      overflow: TextOverflow.ellipsis,
                    ),
                    maxLines: 2,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

// Status badge (orange, always overflow safe)
class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  Color get badgeColor {
    switch (status) {
      case "Pending":
        return kAccentColor;
      case "Submitted":
        return kPrimaryColor;
      case "Late":
        return kAccentColor;
      default:
        return kPrimaryColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.11),
        border: Border.all(color: badgeColor, width: 1),
        borderRadius: BorderRadius.circular(40),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: badgeColor,
          fontWeight: FontWeight.w700,
          fontSize: 12,
          overflow: TextOverflow.ellipsis,
          letterSpacing: .2,
        ),
        maxLines: 1,
      ),
    );
  }
}

// Maps activity type to academic-friendly icon (always safe and small)
Widget _activityIcon(String type) {
  IconData icon;
  switch (type) {
    case "Assignment":
      icon = Icons.assignment;
      break;
    case "Project":
      icon = Icons.engineering_outlined;
      break;
    case "Homework":
      icon = Icons.book_outlined;
      break;
    case "Classwork":
      icon = Icons.class_outlined;
      break;
    case "Practical":
      icon = Icons.science_outlined;
      break;
    default:
      icon = Icons.assignment_outlined;
  }
  return CircleAvatar(
    backgroundColor: kPrimaryColor.withOpacity(0.08),
    radius: 18,
    child: Icon(icon, color: kPrimaryColor, size: 18),
  );
}

