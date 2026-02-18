import 'package:flutter/material.dart';

// =======================
//  BRAND COLORS
// =======================
const Color kPrimaryDarkBlue = Color(0xFF023471);
const Color kAccentOrange = Color(0xFF5AB04B);
const Color kBackground = Color(0xFFF8F9FA);
const Color kTextDarkBlue = Color(0xFF023471);

// ================
//  ENUMS & MODELS
// ================
enum AssignmentStatus { active, submitted, reviewed, overdue }

class Assignment {
  final String id;
  final String title;
  final String className;
  final String subject;
  final String dueDate;
  final int submittedCount;
  final int totalCount;
  final AssignmentStatus status;
  final String description;
  final String instructions;
  final String? attachedInfo;
  final String? teacherNotes;

  Assignment({
    required this.id,
    required this.title,
    required this.className,
    required this.subject,
    required this.dueDate,
    required this.submittedCount,
    required this.totalCount,
    required this.status,
    required this.description,
    required this.instructions,
    this.attachedInfo,
    this.teacherNotes,
  });
}

// ============
//  DUMMY DATA
// ============
final List<Assignment> dummyAssignments = [
  Assignment(
    id: 'a1',
    title: 'Algebra Practice Sheet',
    className: '9A',
    subject: 'Mathematics',
    dueDate: '2024-06-10',
    submittedCount: 20,
    totalCount: 25,
    status: AssignmentStatus.active,
    description: 'Solve questions 1-10 from the given worksheet.',
    instructions: 'Show all work. Submit on LMS or as hard copy.',
    attachedInfo: 'Worksheet PDF provided via LMS.',
    teacherNotes: 'Focus on factorization techniques.',
  ),
  Assignment(
    id: 'a2',
    title: 'Essay: Water Conservation',
    className: '8B',
    subject: 'English',
    dueDate: '2024-05-25',
    submittedCount: 28,
    totalCount: 28,
    status: AssignmentStatus.reviewed,
    description: 'Write an essay of 300 words about water conservation.',
    instructions: 'Type or write neatly. Review grammar and punctuation.',
    attachedInfo: null,
    teacherNotes: 'Best submissions will be displayed on notice board.',
  ),
  Assignment(
    id: 'a3',
    title: 'Physics Lab: Motion',
    className: '10C',
    subject: 'Physics',
    dueDate: '2024-06-02',
    submittedCount: 13,
    totalCount: 18,
    status: AssignmentStatus.overdue,
    description: 'Lab report on the experiment conducted in class.',
    instructions: 'Follow standard format. Include data tables.',
    attachedInfo: 'Lab handout distributed in class.',
    teacherNotes: null,
  ),
  Assignment(
    id: 'a4',
    title: 'Urdu Spelling Quiz',
    className: '7A',
    subject: 'Urdu',
    dueDate: '2024-06-08',
    submittedCount: 0,
    totalCount: 19,
    status: AssignmentStatus.active,
    description: 'Prepare for the spelling quiz of week 8.',
    instructions: 'Revise all vocabulary from chapter 4.',
    attachedInfo: null,
    teacherNotes: null,
  ),
];

// =========================
//   MAIN SCREEN WIDGET
// =========================
class TeacherAssignmentsScreen extends StatefulWidget {
  const TeacherAssignmentsScreen({Key? key}) : super(key: key);

  @override
  State<TeacherAssignmentsScreen> createState() =>
      _TeacherAssignmentsScreenState();
}

class _TeacherAssignmentsScreenState extends State<TeacherAssignmentsScreen> {
  // Filter selection state
  String _selectedFilter = 'All';

  // Dummy assignment data is static above

  // Filter logic
  List<Assignment> get filteredAssignments {
    if (_selectedFilter == 'All') return dummyAssignments;
    switch (_selectedFilter) {
      case 'Active':
        return dummyAssignments
            .where((a) => a.status == AssignmentStatus.active)
            .toList();
      case 'Submitted':
        return dummyAssignments
            .where((a) => a.status == AssignmentStatus.submitted)
            .toList();
      case 'Reviewed':
        return dummyAssignments
            .where((a) => a.status == AssignmentStatus.reviewed)
            .toList();
      case 'Overdue':
        return dummyAssignments
            .where((a) => a.status == AssignmentStatus.overdue)
            .toList();
      default:
        return dummyAssignments;
    }
  }

  // ============== BUILD ==============
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        backgroundColor: kPrimaryDarkBlue,
        elevation: 1.4,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.maybePop(context),
        ),
        centerTitle: true,
        title: const Text(
          "Assignments",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 20,
            letterSpacing: 0.2,
            overflow: TextOverflow.ellipsis,
          ),
          maxLines: 1,
        ),
      ),
      body: SingleChildScrollView(
        // --------- VERTICAL ONLY, for full safety ---------
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // -------- SECTION 1: SUMMARY --------
              _AssignmentSummaryCard(assignments: dummyAssignments),
              const SizedBox(height: 20),

              // -------- SECTION 2: FILTER CHIPS --------
              _AssignmentFilterBar(
                selected: _selectedFilter,
                onSelected: (value) {
                  setState(() => _selectedFilter = value);
                },
              ),
              const SizedBox(height: 18),

              // -------- SECTION 3: ASSIGNMENT LIST --------
              // Cards in a safe vertical Column (overflows wrapped, ListView shrinkWrap not required)
              filteredAssignments.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(top: 32),
                      child: Center(
                        child: Text(
                          "No assignments found for selected filter.",
                          style: TextStyle(
                              color: kTextDarkBlue.withOpacity(0.6),
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              overflow: TextOverflow.ellipsis),
                          maxLines: 1,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredAssignments.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (ctx, i) => Padding(
                        padding: const EdgeInsets.only(bottom: 17.0),
                        child: _AssignmentCard(
                          assignment: filteredAssignments[i],
                        ),
                      ),
                    ),

              // -------- SECTION 6: CREATE ASSIGNMENT CTA --------
              const SizedBox(height: 40),
              _CreateAssignmentCTAButton(
                onPressed: () {
                  // TODO: Implement navigation to create assignment
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Create New Assignment tapped!"),
                      backgroundColor: kAccentOrange,
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

// =======================
// SECTION 1: SUMMARY CARD
// =======================
class _AssignmentSummaryCard extends StatelessWidget {
  final List<Assignment> assignments;
  const _AssignmentSummaryCard({required this.assignments, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Count stats (safe for empty): displayed stats are int (avoid overflows)
    int total = assignments.length;
    int active = assignments
        .where((a) => a.status == AssignmentStatus.active)
        .length;
    int reviewed = assignments
        .where((a) => a.status == AssignmentStatus.reviewed)
        .length;
    int submitted = assignments
        .where((a) => a.submittedCount > 0)
        .length;
    int pendingReviews = assignments
        .where((a) =>
            a.status == AssignmentStatus.submitted ||
            (a.submittedCount > 0 && a.status != AssignmentStatus.reviewed))
        .length;

    // No fixed width anywhere
    return Material(
      color: Colors.white,
      elevation: 2.2,
      shadowColor: kAccentOrange.withOpacity(0.11),
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 23, horizontal: 17),
        child: Wrap(
          spacing: 28,
          runSpacing: 20,
          alignment: WrapAlignment.spaceBetween,
          children: [
            _SummaryStat(
                icon: Icons.library_books_rounded,
                label: "Total",
                value: total.toString(),
                accent: true),
            _SummaryStat(
                icon: Icons.check_circle_outline,
                label: "Active",
                value: active.toString()),
            _SummaryStat(
                icon: Icons.assignment_turned_in,
                label: "Submitted",
                value: submitted.toString()),
            _SummaryStat(
                icon: Icons.rate_review_rounded,
                label: "Pending\nReviews",
                value: pendingReviews.toString()),
          ],
        ),
      ),
    );
  }
}

class _SummaryStat extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool accent;
  const _SummaryStat({
    required this.icon,
    required this.label,
    required this.value,
    this.accent = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Safe, text-wraps, icon uses accent only if accent==true
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            color: accent ? kAccentOrange : kPrimaryDarkBlue.withOpacity(0.09),
            shape: BoxShape.circle,
          ),
          padding: const EdgeInsets.all(10),
          child: Icon(
            icon,
            color: accent ? Colors.white : kAccentOrange,
            size: 23,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            color: kTextDarkBlue,
            fontSize: 20,
            fontWeight: FontWeight.w700,
            overflow: TextOverflow.ellipsis,
          ),
          maxLines: 1,
        ),
        const SizedBox(height: 1.5),
        Text(
          label,
          style: TextStyle(
            color: kTextDarkBlue.withOpacity(0.72),
            fontWeight: FontWeight.w500,
            fontSize: 13.6,
            overflow: TextOverflow.ellipsis,
            height: 1.15,
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
        ),
      ],
    );
  }
}

// =======================
// SECTION 2: FILTER BAR
// =======================
class _AssignmentFilterBar extends StatelessWidget {
  final String selected;
  final void Function(String) onSelected;
  static const filters = [
    'All',
    'Active',
    'Submitted',
    'Reviewed',
    'Overdue',
  ];

  const _AssignmentFilterBar({
    required this.selected,
    required this.onSelected,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use Wrap for perfect overflow safety.
    return Wrap(
      spacing: 10,
      runSpacing: 11,
      children: filters
          .map(
            (f) => ChoiceChip(
              label: Text(
                f,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: selected == f ? Colors.white : kTextDarkBlue,
                  fontWeight: FontWeight.w600,
                ),
              ),
              selected: selected == f,
              selectedColor: kAccentOrange,
              backgroundColor: Colors.white,
              side: selected == f
                  ? null
                  : const BorderSide(
                      color: kPrimaryDarkBlue, width: 1.2),
              labelPadding: const EdgeInsets.symmetric(horizontal: 13),
              onSelected: (_) => onSelected(f),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              // No fixed width/height.
            ),
          )
          .toList(),
    );
  }
}

// =======================
// SECTION 3/5: CARD & EXPANDABLE
// =======================
class _AssignmentCard extends StatefulWidget {
  final Assignment assignment;
  const _AssignmentCard({required this.assignment, Key? key}) : super(key: key);

  @override
  State<_AssignmentCard> createState() => _AssignmentCardState();
}

class _AssignmentCardState extends State<_AssignmentCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final a = widget.assignment;
    Color statusColor;
    String statusText;
    switch (a.status) {
      case AssignmentStatus.active:
        statusColor = kAccentOrange;
        statusText = 'Active';
        break;
      case AssignmentStatus.submitted:
        statusColor = kPrimaryDarkBlue;
        statusText = 'Submitted';
        break;
      case AssignmentStatus.reviewed:
        statusColor = kPrimaryDarkBlue.withOpacity(0.7);
        statusText = 'Reviewed';
        break;
      case AssignmentStatus.overdue:
        statusColor = Colors.red.shade700;
        statusText = 'Overdue';
        break;
    }

    return Material(
      elevation: 2.6,
      shadowColor: kAccentOrange.withOpacity(0.13),
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Main Row: Title + Status Chip
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title (expandable for overflow safety)
                Expanded(
                  child: Text(
                    a.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: kTextDarkBlue,
                      fontWeight: FontWeight.w700,
                      fontSize: 17.2,
                      letterSpacing: 0.03,
                    ),
                  ),
                ),
                const SizedBox(width: 7),
                _AssignmentStatusChip(
                  status: statusText,
                  color: statusColor,
                ),
              ],
            ),

            const SizedBox(height: 8),
            // Sub info: Class/subject, due, submissions
            Wrap(
              spacing: 13,
              runSpacing: 5,
              children: [
                _CardInfoIcon(
                  icon: Icons.class_,
                  text: "${a.className}, ${a.subject}",
                ),
                _CardInfoIcon(
                  icon: Icons.event,
                  text: "Due: ${a.dueDate}",
                ),
                _CardInfoIcon(
                  icon: Icons.people,
                  text: "${a.submittedCount}/${a.totalCount} submitted",
                ),
              ],
            ),

            const SizedBox(height: 11),
            // -------- SECTION 4: ACTION BUTTONS --------
            _AssignmentCardActions(),

            const SizedBox(height: 6),
            // -------- SECTION 5: EXPANDABLE DETAILS --------
            Theme(
              // Theme override for ExpansionTile color/arrow
              data: ThemeData(
                dividerColor: Colors.transparent,
              ),
              child: ExpansionTile(
                initiallyExpanded: _expanded,
                onExpansionChanged: (v) => setState(() => _expanded = v),
                collapsedIconColor: kAccentOrange,
                iconColor: kAccentOrange,
                tilePadding: EdgeInsets.zero,
                childrenPadding:
                    const EdgeInsets.only(left: 3, right: 3, bottom: 6),
                title: Text(
                  'Details',
                  style: TextStyle(
                    color: kTextDarkBlue.withOpacity(0.84),
                    fontWeight: FontWeight.w600,
                    fontSize: 14.4,
                    overflow: TextOverflow.ellipsis,
                  ),
                  maxLines: 1,
                ),
                children: [
                  _DetailRow(label: "Description", value: a.description),
                  _DetailRow(label: "Instructions", value: a.instructions),
                  if (a.attachedInfo != null)
                    _DetailRow(label: "Attached Info", value: a.attachedInfo!),
                  if (a.teacherNotes != null)
                    _DetailRow(label: "Teacher Notes", value: a.teacherNotes!),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Card colored status chip
class _AssignmentStatusChip extends StatelessWidget {
  final String status;
  final Color color;
  const _AssignmentStatusChip(
      {required this.status, required this.color, Key? key})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        border: Border.all(color: color, width: 1.1),
        borderRadius: BorderRadius.circular(17),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w700,
          fontSize: 12.5,
          overflow: TextOverflow.ellipsis,
        ),
        maxLines: 1,
      ),
    );
  }
}

class _CardInfoIcon extends StatelessWidget {
  final IconData icon;
  final String text;
  const _CardInfoIcon({required this.icon, required this.text, Key? key})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: kAccentOrange, size: 17),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            text,
            style: TextStyle(
              color: kTextDarkBlue.withOpacity(0.86),
              fontSize: 13.1,
              overflow: TextOverflow.ellipsis,
            ),
            maxLines: 1,
          ),
        ),
      ],
    );
  }
}

class _AssignmentCardActions extends StatelessWidget {
  const _AssignmentCardActions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use Wrap for safe overflow
    return Padding(
      padding: const EdgeInsets.only(top: 0),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          _ActionButton(
            label: 'View Submissions',
            icon: Icons.visibility_outlined,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("View Submissions tapped!"),
                  backgroundColor: kAccentOrange,
                ),
              );
            },
          ),
          _ActionButton(
            label: 'Grade',
            icon: Icons.grade_outlined,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Grade tapped!"),
                  backgroundColor: kAccentOrange,
                ),
              );
            },
          ),
          _ActionButton(
            label: 'Edit Assignment',
            icon: Icons.edit_outlined,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Edit Assignment tapped!"),
                  backgroundColor: kAccentOrange,
                ),
              );
            },
          ),
          _ActionButton(
            label: 'Extend Deadline',
            icon: Icons.update_outlined,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Extend Deadline tapped!"),
                  backgroundColor: kAccentOrange,
                ),
              );
            },
            accent: true,
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool accent;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.onTap,
    this.accent = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: accent ? kAccentOrange : kPrimaryDarkBlue.withOpacity(0.07),
      borderRadius: BorderRadius.circular(9),
      child: InkWell(
        borderRadius: BorderRadius.circular(9),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 18,
                color: accent ? Colors.white : kAccentOrange,
              ),
              const SizedBox(width: 5),
              Text(
                label,
                style: TextStyle(
                  color: accent ? Colors.white : kTextDarkBlue,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  overflow: TextOverflow.ellipsis,
                ),
                maxLines: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ===================================
// Expanding detail - info rows
// ===================================
class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  const _DetailRow({required this.label, required this.value, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Extra safe with no fixed height
      padding: const EdgeInsets.symmetric(vertical: 1.5, horizontal: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label: ",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: kPrimaryDarkBlue.withOpacity(0.77),
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: kTextDarkBlue,
                fontWeight: FontWeight.w500,
                fontSize: 13,
                overflow: TextOverflow.ellipsis,
              ),
              maxLines: 4,
            ),
          ),
        ],
      ),
    );
  }
}

// =======================
// SECTION 6: CREATE CTA
// =======================
class _CreateAssignmentCTAButton extends StatelessWidget {
  final VoidCallback onPressed;
  const _CreateAssignmentCTAButton({Key? key, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Full width, but safety via ConstrainedBox and no fixed height.
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.add, color: Colors.white, size: 23),
            label: const Text(
              "Create New Assignment",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                letterSpacing: 0.1,
                fontSize: 16.2,
                color: Colors.white,
              ),
            ),
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: kAccentOrange,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(13),
              ),
              padding: const EdgeInsets.symmetric(vertical: 15),
              elevation: 2,
              textStyle: const TextStyle(fontWeight: FontWeight.w700),
              shadowColor: kAccentOrange.withOpacity(0.18),
            ),
          ),
        ),
      ),
    );
  }
}
