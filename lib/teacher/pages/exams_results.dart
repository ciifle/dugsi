import 'package:flutter/material.dart';

// =================== CONSTANTS ===================

// Brand colors
const Color kPrimaryColor = Color(0xFF023471);
const Color kAccentColor = Color(0xFF5AB04B);
const Color kBackgroundColor = Color(0xFFF8F9FA);
const Color kTextColor = Color(0xFF023471);

// UI Sizes
const double kCardRadius = 14;
const double kCardElevation = 2.5;
const double kSectionSpacing = 28;
const EdgeInsets kSectionPadding = EdgeInsets.symmetric(vertical: 18);

// ================== DATA MODELS ==================

enum TeacherExamsTab { exams, results }

class Exam {
  final String name;
  final String className;
  final String subject;
  final DateTime date;
  final String duration;
  final bool completed;
  final String syllabus;
  final String notes;
  final String remarks;

  Exam({
    required this.name,
    required this.className,
    required this.subject,
    required this.date,
    required this.duration,
    required this.completed,
    required this.syllabus,
    required this.notes,
    required this.remarks,
  });
}

class ExamResult {
  final String name;
  final String className;
  final String subject;
  final double average;
  final double passPercent;
  final bool published;
  final String syllabus;
  final String notes;
  final String remarks;

  ExamResult({
    required this.name,
    required this.className,
    required this.subject,
    required this.average,
    required this.passPercent,
    required this.published,
    required this.syllabus,
    required this.notes,
    required this.remarks,
  });
}

// ================== DUMMY DATA ===================

final List<Exam> dummyExams = [
  Exam(
    name: 'Midterm',
    className: 'Grade 8',
    subject: 'Mathematics',
    date: DateTime.now().add(Duration(days: 7)),
    duration: '90 min',
    completed: false,
    syllabus: 'Chapters 1-6',
    notes: 'Focus on algebra.',
    remarks: 'Include calculator section.',
  ),
  Exam(
    name: 'Semester Final',
    className: 'Grade 8',
    subject: 'Science',
    date: DateTime.now().subtract(Duration(days: 10)),
    duration: '120 min',
    completed: true,
    syllabus: 'Full year',
    notes: 'Diagram questions mandatory.',
    remarks: 'Split into 2 sections.',
  ),
  Exam(
    name: 'Weekly Quiz',
    className: 'Grade 7',
    subject: 'History',
    date: DateTime.now().add(Duration(days: 2)),
    duration: '30 min',
    completed: false,
    syllabus: 'World Wars',
    notes: 'Short questions.',
    remarks: 'No negative marking.',
  ),
];

final List<ExamResult> dummyResults = [
  ExamResult(
    name: 'Midterm',
    className: 'Grade 8',
    subject: 'Mathematics',
    average: 67.8,
    passPercent: 82.7,
    published: false,
    syllabus: 'Chapters 1-6',
    notes: 'Students found Q5 challenging.',
    remarks: 'Consider revision before finals.',
  ),
  ExamResult(
    name: 'Semester Final',
    className: 'Grade 8',
    subject: 'Science',
    average: 74.2,
    passPercent: 89.5,
    published: true,
    syllabus: 'Full year',
    notes: 'Practical scored well.',
    remarks: 'Continue lab sessions.',
  ),
];

// =============== MAIN SCREEN CLASS ===============

class TeacherExamsResultsScreen extends StatefulWidget {
  const TeacherExamsResultsScreen({Key? key}) : super(key: key);

  @override
  State<TeacherExamsResultsScreen> createState() => _TeacherExamsResultsScreenState();
}

class _TeacherExamsResultsScreenState extends State<TeacherExamsResultsScreen> {
  TeacherExamsTab _tab = TeacherExamsTab.exams;
  // --- OVERVIEW CALCULATIONS ---
  int get _totalExams => dummyExams.length;
  int get _upcomingExams =>
      dummyExams.where((e) => !e.completed && e.date.isAfter(DateTime.now())).length;
  int get _completedExams => dummyExams.where((e) => e.completed).length;
  int get _publishedResults =>
      dummyResults.where((r) => r.published).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        elevation: 1,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Exams & Results',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.white,
            letterSpacing: 0.1,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: SafeArea(
        // Prevents overflow by allowing vertical scrolling at all times
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Section 1: Overview Card
                _ExamResultsOverviewCard(
                  totalExams: _totalExams,
                  upcomingExams: _upcomingExams,
                  completedExams: _completedExams,
                  publishedResults: _publishedResults,
                ),
                const SizedBox(height: kSectionSpacing),
                // Section 2: Toggle/Tabs
                _ExamsResultsToggle(
                  selected: _tab,
                  onChanged: (tab) {
                    setState(() => _tab = tab);
                  },
                ),
                const SizedBox(height: 18),
                // Section 3 & 5: List (with shrinkWrap, overflow protection)
                if (_tab == TeacherExamsTab.exams)
                  _ExamsListSection(
                    exams: dummyExams,
                  ),
                if (_tab == TeacherExamsTab.results)
                  _ResultsListSection(
                    results: dummyResults,
                  ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ================= OVERRVIEW CARD =================

class _ExamResultsOverviewCard extends StatelessWidget {
  final int totalExams;
  final int upcomingExams;
  final int completedExams;
  final int publishedResults;

  const _ExamResultsOverviewCard({
    required this.totalExams,
    required this.upcomingExams,
    required this.completedExams,
    required this.publishedResults,
  });

  Widget _buildOverviewItem(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String label,
    required int value,
    bool showDivider = false,
  }) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            backgroundColor: iconColor.withOpacity(0.13),
            child: Icon(
              icon,
              color: iconColor,
              size: 26,
            ),
            radius: 24,
          ),
          const SizedBox(height: 7),
          Text(
            value.toString(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: kTextColor,
              fontWeight: FontWeight.w700,
              fontSize: 21,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: kTextColor,
              fontSize: 13.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _verticalDivider() => Container(
        width: 1,
        height: 48,
        margin: const EdgeInsets.symmetric(horizontal: 10),
        color: kAccentColor.withOpacity(0.27),
      );

  @override
  Widget build(BuildContext context) {
    // All Wrapped in Card to ensure shadow/rounded appearance
    return Card(
      elevation: kCardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kCardRadius),
      ),
      color: Colors.white,
      shadowColor: kPrimaryColor.withOpacity(0.09),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 8),
        // Use Wrap instead of Row to prevent OVERFLOW
        child: Wrap(
          alignment: WrapAlignment.spaceEvenly,
          runSpacing: 14,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width / 4.5,
              child: _buildOverviewItem(
                context,
                icon: Icons.menu_book_outlined,
                iconColor: kPrimaryColor,
                label: 'Total',
                value: totalExams,
              ),
            ),
            _verticalDivider(),
            SizedBox(
              width: MediaQuery.of(context).size.width / 4.5,
              child: _buildOverviewItem(
                context,
                icon: Icons.access_time,
                iconColor: kAccentColor,
                label: 'Upcoming',
                value: upcomingExams,
              ),
            ),
            _verticalDivider(),
            SizedBox(
              width: MediaQuery.of(context).size.width / 4.6,
              child: _buildOverviewItem(
                context,
                icon: Icons.check_circle,
                iconColor: kPrimaryColor,
                label: 'Completed',
                value: completedExams,
              ),
            ),
            _verticalDivider(),
            SizedBox(
              width: MediaQuery.of(context).size.width / 4.6,
              child: _buildOverviewItem(
                context,
                icon: Icons.poll_outlined,
                iconColor: kAccentColor,
                label: 'Published',
                value: publishedResults,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== TOGGLE =====================

class _ExamsResultsToggle extends StatelessWidget {
  final TeacherExamsTab selected;
  final ValueChanged<TeacherExamsTab> onChanged;

  const _ExamsResultsToggle({
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    // Use Wrap for overflow safety on small screens
    return Wrap(
      spacing: 12,
      children: [
        _ToggleButton(
          text: 'Exams',
          selected: selected == TeacherExamsTab.exams,
          onTap: () => onChanged(TeacherExamsTab.exams),
        ),
        _ToggleButton(
          text: 'Results',
          selected: selected == TeacherExamsTab.results,
          onTap: () => onChanged(TeacherExamsTab.results),
        ),
      ],
    );
  }
}

class _ToggleButton extends StatelessWidget {
  final String text;
  final bool selected;
  final VoidCallback onTap;

  const _ToggleButton({
    required this.text,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? kAccentColor : Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(23),
        side: selected
            ? BorderSide(color: kAccentColor, width: 2)
            : BorderSide(color: kPrimaryColor, width: 1.2),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(23),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: selected ? Colors.white : kTextColor,
              fontWeight: FontWeight.bold,
              fontSize: 16.5,
              letterSpacing: 0.1,
            ),
          ),
        ),
      ),
    );
  }
}

// ================ EXAMS LIST SECTION ================

class _ExamsListSection extends StatelessWidget {
  final List<Exam> exams;

  const _ExamsListSection({required this.exams});

  @override
  Widget build(BuildContext context) {
    if (exams.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Center(
          child: Text(
            'No exams to display',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: kPrimaryColor,
              fontSize: 16,
            ),
          ),
        ),
      );
    }
    // Prevent overflow with shrinkWrap+NeverScrollable
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: exams.length,
      separatorBuilder: (_, __) => const SizedBox(height: 14),
      itemBuilder: (context, idx) {
        final exam = exams[idx];
        return _ExamCard(exam: exam);
      },
    );
  }
}

class _ExamCard extends StatefulWidget {
  final Exam exam;
  const _ExamCard({required this.exam});

  @override
  State<_ExamCard> createState() => _ExamCardState();
}

class _ExamCardState extends State<_ExamCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final exam = widget.exam;
    // Card with ExpansionTile, NO fixed heights.
    return Card(
      elevation: kCardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kCardRadius),
      ),
      color: Colors.white,
      margin: EdgeInsets.zero,
      child: ExpansionTile(
        key: PageStorageKey('${exam.name}-${exam.className}'),
        initiallyExpanded: false,
        tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        childrenPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        onExpansionChanged: (expanded) {
          setState(() {
            _expanded = expanded;
          });
        },
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              exam.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: kTextColor,
                fontWeight: FontWeight.bold,
                fontSize: 17.2,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              '${exam.className} • ${exam.subject}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: kPrimaryColor,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 13,
              runSpacing: 7,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.access_time, size: 18, color: kPrimaryColor),
                    const SizedBox(width: 3),
                    Text(
                      '${_formatDate(exam.date)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: kTextColor,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.schedule, size: 17, color: kAccentColor),
                    const SizedBox(width: 3),
                    Text(
                      exam.duration,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: kTextColor,
                        fontSize: 13.5,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      exam.completed ? Icons.check_circle : Icons.upcoming,
                      color: exam.completed ? kPrimaryColor : kAccentColor,
                      size: 17,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      exam.completed ? 'Completed' : 'Upcoming',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: exam.completed ? kPrimaryColor : kAccentColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 13.5,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 11),
            // Section 4: Exam Actions
            _ExamActions(),
          ],
        ),

        // Section 7: Expandable details
        children: [
          _ExamResultExpansionDetails(
            syllabus: exam.syllabus,
            notes: exam.notes,
            remarks: exam.remarks,
          ),
        ],
      ),
    );
  }
}

// =========== EXAM ACTIONS (WRAP BUTTONS) ===========

class _ExamActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Wrap for overflow protection
    return Padding(
      padding: const EdgeInsets.only(top: 2),
      child: Wrap(
        spacing: 13,
        runSpacing: 7,
        alignment: WrapAlignment.start,
        children: [
          _ExamActionButton(
            icon: Icons.people_outline,
            label: 'View Students',
            onTap: () {},
          ),
          _ExamActionButton(
            icon: Icons.fact_check_outlined,
            label: 'Enter Marks',
            onTap: () {},
          ),
          _ExamActionButton(
            icon: Icons.edit_outlined,
            label: 'Edit Exam',
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class _ExamActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ExamActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Avoid fixed width. Use minimal padding.
    return Material(
      color: kAccentColor.withOpacity(0.14),
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7.5),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: kAccentColor, size: 18),
              const SizedBox(width: 6),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: kAccentColor,
                  fontSize: 13.8,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =========== RESULTS LIST SECTION ===============

class _ResultsListSection extends StatelessWidget {
  final List<ExamResult> results;

  const _ResultsListSection({required this.results});

  @override
  Widget build(BuildContext context) {
    if (results.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Center(
          child: Text(
            'No results to display',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: kPrimaryColor,
              fontSize: 16,
            ),
          ),
        ),
      );
    }
    // Prevent overflows: shrinkWrap+NeverScrollable
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: results.length,
      separatorBuilder: (_, __) => const SizedBox(height: 14),
      itemBuilder: (context, idx) {
        final result = results[idx];
        return _ResultCard(result: result);
      },
    );
  }
}

class _ResultCard extends StatefulWidget {
  final ExamResult result;
  const _ResultCard({required this.result});

  @override
  State<_ResultCard> createState() => _ResultCardState();
}

class _ResultCardState extends State<_ResultCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final result = widget.result;
    // Card with ExpansionTile, NO fixed heights.
    return Card(
      elevation: kCardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kCardRadius),
      ),
      color: Colors.white,
      margin: EdgeInsets.zero,
      child: ExpansionTile(
        key: PageStorageKey('${result.name}-${result.className}'),
        initiallyExpanded: false,
        tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        childrenPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        onExpansionChanged: (expanded) {
          setState(() {
            _expanded = expanded;
          });
        },
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              result.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: kTextColor,
                fontWeight: FontWeight.bold,
                fontSize: 17.2,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              '${result.className} • ${result.subject}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: kPrimaryColor,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 13,
              runSpacing: 7,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.leaderboard, size: 18, color: kPrimaryColor),
                    const SizedBox(width: 3),
                    Text(
                      'Avg: ${result.average.toStringAsFixed(1)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: kTextColor,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.percent, size: 17, color: kAccentColor),
                    const SizedBox(width: 3),
                    Text(
                      'Pass: ${result.passPercent.toStringAsFixed(1)}%',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: kTextColor,
                        fontSize: 13.5,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(result.published ? Icons.done : Icons.edit_note,
                        color: result.published ? kPrimaryColor : kAccentColor,
                        size: 17),
                    const SizedBox(width: 3),
                    Text(
                      result.published ? 'Published' : 'Draft',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: result.published ? kPrimaryColor : kAccentColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 13.5,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 11),
            // Section 6: Result Actions
            _ResultActions(
              published: result.published,
            ),
          ],
        ),
        // Section 7: Expandable details
        children: [
          _ExamResultExpansionDetails(
            syllabus: result.syllabus,
            notes: result.notes,
            remarks: result.remarks,
          ),
        ],
      ),
    );
  }
}

class _ResultActions extends StatelessWidget {
  final bool published;
  const _ResultActions({required this.published});

  @override
  Widget build(BuildContext context) {
    // Wrap for overflow protection.
    return Padding(
      padding: const EdgeInsets.only(top: 2),
      child: Wrap(
        spacing: 13,
        runSpacing: 7,
        alignment: WrapAlignment.start,
        children: [
          _ResultActionButton(
            icon: Icons.receipt_long,
            label: 'View Results',
            onTap: () {},
          ),
          _ResultActionButton(
            icon: Icons.fact_check_outlined,
            label: 'Edit Marks',
            onTap: () {},
          ),
          _ResultActionButton(
            icon: published ? Icons.undo : Icons.campaign,
            label: published ? 'Unpublish' : 'Publish',
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class _ResultActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ResultActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Avoid fixed width. Use minimal padding.
    return Material(
      color: kAccentColor.withOpacity(0.14),
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7.5),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: kAccentColor, size: 18),
              const SizedBox(width: 6),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: kAccentColor,
                  fontSize: 13.8,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ======== EXPANDABLE DETAILS (SYLLABUS, NOTES, REMARKS) =========

class _ExamResultExpansionDetails extends StatelessWidget {
  final String syllabus;
  final String notes;
  final String remarks;

  const _ExamResultExpansionDetails({
    required this.syllabus,
    required this.notes,
    required this.remarks,
  });

  @override
  Widget build(BuildContext context) {
    // Never set fixed height, expand as needed.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ExpandableDetailRow(
            icon: Icons.dashboard_customize, title: 'Syllabus', value: syllabus),
        const SizedBox(height: 7),
        _ExpandableDetailRow(
            icon: Icons.sticky_note_2_outlined, title: 'Notes', value: notes),
        const SizedBox(height: 7),
        _ExpandableDetailRow(
            icon: Icons.notes, title: 'Remarks', value: remarks),
      ],
    );
  }
}

class _ExpandableDetailRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _ExpandableDetailRow({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    // Expanded for edge cases, long text will ellipsis.
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: kPrimaryColor, size: 19),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              text: '$title: ',
              style: const TextStyle(
                color: kPrimaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 13.3,
              ),
              children: [
                TextSpan(
                  text: value,
                  style: const TextStyle(
                    color: kTextColor,
                    fontWeight: FontWeight.normal,
                    fontSize: 13.1,
                  ),
                ),
              ],
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

// ============== HELPERS =======================

String _formatDate(DateTime dt) {
  // Example: "18 Jun 2024"
  final month = [
    '',
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];
  return '${dt.day} ${month[dt.month]} ${dt.year}';
}

