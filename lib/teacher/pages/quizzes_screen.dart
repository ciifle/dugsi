import 'package:flutter/material.dart';

// ==== BRAND COLORS ====
const Color kPrimaryDarkBlue = Color(0xFF023471);
const Color kAccentOrange = Color(0xFF5AB04B);
const Color kBackground = Color(0xFFF9F9F9); // Soft offwhite
const Color kTextDarkBlue = Color(0xFF023471);

// ================================
// QUIZ MODELS + DUMMY DATA
// ================================
enum QuizStatus { active, completed, draft }

class Quiz {
  final String id;
  final String title;
  final String className;
  final String subject;
  final int totalQuestions;
  final String timeLimit; // '30 min', '1 hr' etc.
  final QuizStatus status;
  final String instructions;
  final String scoringRules;
  final String? notes;

  Quiz({
    required this.id,
    required this.title,
    required this.className,
    required this.subject,
    required this.totalQuestions,
    required this.timeLimit,
    required this.status,
    required this.instructions,
    required this.scoringRules,
    this.notes,
  });
}

final List<Quiz> dummyQuizzes = [
  Quiz(
      id: 'q1',
      title: 'Mid-Term Algebra Quiz',
      className: 'Class 9A',
      subject: 'Mathematics',
      totalQuestions: 15,
      timeLimit: '40 min',
      status: QuizStatus.active,
      instructions:
          'Answer all questions. No calculators allowed. Read each question carefully.',
      scoringRules:
          '1 mark for each correct answer. No negative marking. Partial marks for partially correct steps.',
      notes: 'Review trigonometry basics before quiz.'),
  Quiz(
      id: 'q2',
      title: 'Periodic Table Assessment',
      className: 'Class 9B',
      subject: 'Science',
      totalQuestions: 10,
      timeLimit: '25 min',
      status: QuizStatus.completed,
      instructions: 'Multiple choice format. Choose the most appropriate answer.',
      scoringRules: 'Correct = 2 marks. Incorrect = 0 marks.',
      notes: null),
  Quiz(
      id: 'q3',
      title: 'Grammar Check',
      className: 'Class 8A',
      subject: 'English',
      totalQuestions: 20,
      timeLimit: '30 min',
      status: QuizStatus.draft,
      instructions:
          'Fill in the blanks, and rewrite sentences as instructed in the questions.',
      scoringRules: 'Each correct blank = 0.5 mark. Each correct sentence = 1 mark.',
      notes: 'Remind students about subject-verb agreement rules.'),
  Quiz(
      id: 'q4',
      title: 'Geography Map Lab',
      className: 'Class 10C',
      subject: 'Geography',
      totalQuestions: 5,
      timeLimit: '20 min',
      status: QuizStatus.active,
      instructions: 'Label the map features as per instructions.',
      scoringRules: 'Each correct label = 2 marks.',
      notes: null),
  Quiz(
      id: 'q5',
      title: 'Chapter 4 Physics Quiz',
      className: 'Class 10B',
      subject: 'Physics',
      totalQuestions: 12,
      timeLimit: '35 min',
      status: QuizStatus.completed,
      instructions: 'Attempt all questions. Diagrams are not mandatory.',
      scoringRules: 'Each correct = 1 mark. No negatives.',
      notes: null),
];

// =============================================================
// MAIN SCREEN WIDGET: TeacherQuizzesScreen
// =============================================================
class TeacherQuizzesScreen extends StatefulWidget {
  const TeacherQuizzesScreen({Key? key}) : super(key: key);

  @override
  State<TeacherQuizzesScreen> createState() => _TeacherQuizzesScreenState();
}

class _TeacherQuizzesScreenState extends State<TeacherQuizzesScreen> {
  // Filter state: 'All', 'Active', 'Completed', 'Draft'
  String _selectedFilter = 'All';

  List<Quiz> get filteredQuizzes {
    switch (_selectedFilter) {
      case 'Active':
        return dummyQuizzes
            .where((q) => q.status == QuizStatus.active)
            .toList();
      case 'Completed':
        return dummyQuizzes
            .where((q) => q.status == QuizStatus.completed)
            .toList();
      case 'Draft':
        return dummyQuizzes
            .where((q) => q.status == QuizStatus.draft)
            .toList();
      default:
        return dummyQuizzes;
    }
  }

  // ============== BUILD ==============
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        backgroundColor: kPrimaryDarkBlue,
        centerTitle: true,
        elevation: 1.5,
        title: const Text(
          "Quizzes",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.15,
            fontSize: 20,
            overflow: TextOverflow.ellipsis,
          ),
          maxLines: 1,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.maybePop(context),
        ),
      ),
      // ====== BODY WRAPPED IN SAFE SCROLL CONTAINER ======
      body: SingleChildScrollView(
        // Prevents ALL vertical space/column overflow
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ---- SECTION 1: QUIZ SUMMARY CARD ----
              _QuizSummaryCard(quizzes: dummyQuizzes),
              const SizedBox(height: 22),

              // ---- SECTION 2: QUIZ FILTER BAR ----
              _QuizFilterBar(
                selected: _selectedFilter,
                onSelected: (val) {
                  setState(() => _selectedFilter = val);
                },
              ),
              const SizedBox(height: 20),

              // ---- SECTION 3: QUIZ LIST ----
              filteredQuizzes.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(top: 40.0, bottom: 30),
                      child: Center(
                        child: Text(
                          "No quizzes found for selected filter.",
                          style: TextStyle(
                            color: kTextDarkBlue.withOpacity(0.7),
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            overflow: TextOverflow.ellipsis,
                          ),
                          maxLines: 1,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredQuizzes.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (ctx, i) => Padding(
                        padding: const EdgeInsets.only(bottom: 18.0),
                        child: _QuizCard(quiz: filteredQuizzes[i]),
                      ),
                    ),

              // ---- SECTION 6: CREATE QUIZ CTA ----
              const SizedBox(height: 38),
              _CreateQuizCTAButton(
                onPressed: () {
                  // TODO: Implement navigation to quiz creation
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Create Quiz tapped!"),
                      backgroundColor: kAccentOrange,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
              const SizedBox(height: 22),
            ],
          ),
        ),
      ),
    );
  }
}

// =====================================================================
// SECTION 1: Quiz Summary Card (Total / Active / Completed Tallies)
// =====================================================================
class _QuizSummaryCard extends StatelessWidget {
  final List<Quiz> quizzes;
  const _QuizSummaryCard({required this.quizzes, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final total = quizzes.length;
    final active = quizzes.where((q) => q.status == QuizStatus.active).length;
    final completed = quizzes.where((q) => q.status == QuizStatus.completed).length;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 550),
        child: Card(
          margin: EdgeInsets.zero,
          elevation: 2.3,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Total Quizzes
                _SummaryCol(
                  icon: Icons.library_books_outlined,
                  label: "Total",
                  value: total.toString(),
                  color: kPrimaryDarkBlue,
                  accent: false,
                ),
                // Orange divider
                Container(
                  height: 35,
                  width: 1.2,
                  color: kAccentOrange.withOpacity(0.45),
                ),
                // Active Quizzes
                _SummaryCol(
                  icon: Icons.flash_on,
                  label: "Active",
                  value: active.toString(),
                  color: kAccentOrange,
                  accent: true,
                ),
                // Orange divider
                Container(
                  height: 35,
                  width: 1.2,
                  color: kAccentOrange.withOpacity(0.45),
                ),
                // Completed
                _SummaryCol(
                  icon: Icons.check_circle_outline,
                  label: "Completed",
                  value: completed.toString(),
                  color: kPrimaryDarkBlue,
                  accent: false,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SummaryCol extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final bool accent;

  const _SummaryCol({
    Key? key,
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    this.accent = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          backgroundColor:
              accent ? kAccentOrange.withOpacity(0.17) : kPrimaryDarkBlue.withOpacity(0.09),
          radius: 18,
          child: Icon(icon, size: 22, color: color),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w800,
            fontSize: 18,
            letterSpacing: 0.1,
            overflow: TextOverflow.ellipsis,
          ),
          maxLines: 1,
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            color: kTextDarkBlue.withOpacity(0.68),
            fontWeight: FontWeight.w600,
            fontSize: 13.5,
            overflow: TextOverflow.ellipsis,
            letterSpacing: 0.03,
          ),
          maxLines: 1,
        ),
      ],
    );
  }
}

// ====================================================================
// SECTION 2: Filter Chips (All / Active / Completed / Draft)
// ====================================================================
class _QuizFilterBar extends StatelessWidget {
  final String selected;
  final Function(String) onSelected;
  static const filters = ['All', 'Active', 'Completed', 'Draft'];

  const _QuizFilterBar({
    Key? key,
    required this.selected,
    required this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Ensures chips always wrap and never overflow horizontally
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Wrap(
        spacing: 10,
        runSpacing: 8,
        children: filters
            .map(
              (f) => ChoiceChip(
                label: Text(
                  f,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: selected == f ? Colors.white : kPrimaryDarkBlue,
                    fontWeight: FontWeight.w700,
                    fontSize: 13.5,
                  ),
                ),
                selected: selected == f,
                backgroundColor: Colors.white,
                selectedColor: kAccentOrange,
                side: BorderSide(
                  color: selected == f ? Colors.transparent : kPrimaryDarkBlue.withOpacity(0.23),
                  width: 1.0,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(17),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 5),
                onSelected: (val) {
                  if (!val) return;
                  onSelected(f);
                },
              ),
            )
            .toList(),
      ),
    );
  }
}

// ====================================================================
// SECTION 3: Quiz Card List (Card + ExpansionTile)
// ====================================================================
class _QuizCard extends StatelessWidget {
  final Quiz quiz;
  const _QuizCard({required this.quiz, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Safe card with shadow, no fixed width/height
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 540),
        child: Card(
          elevation: 2.0,
          color: Colors.white,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ---- TITLE & STATUS CHIP ----
                Row(
                  children: [
                    // Title (never overflow)
                    Expanded(
                      child: Text(
                        quiz.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: kTextDarkBlue,
                          fontWeight: FontWeight.w800,
                          fontSize: 16.5,
                          letterSpacing: 0.05,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    _QuizStatusChip(status: quiz.status),
                  ],
                ),
                const SizedBox(height: 7),

                // ---- Class / Subject / Questions / Time (Row) ----
                Wrap(
                  spacing: 13,
                  runSpacing: 6,
                  children: [
                    _InfoChip(
                      icon: Icons.class_outlined,
                      label: quiz.className,
                    ),
                    _InfoChip(
                      icon: Icons.menu_book_outlined,
                      label: quiz.subject,
                    ),
                    _InfoChip(
                      icon: Icons.format_list_numbered,
                      label: "${quiz.totalQuestions} Qn",
                    ),
                    _InfoChip(
                      icon: Icons.timer,
                      label: quiz.timeLimit,
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // ---- ACTION BUTTONS (safe in Wrap) ----
                _QuizCardActions(
                  onViewQuestions: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: kAccentOrange,
                        content: Text('View Questions tapped'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  onEditQuiz: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: kAccentOrange,
                        content: Text('Edit Quiz tapped'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  onAssign: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: kAccentOrange,
                        content: Text('Assign to Class tapped'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  onResults: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: kAccentOrange,
                        content: Text('Results tapped'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),

                // ---- EXPANDABLE DETAILS ----
                _QuizExpandableDetails(
                  instructions: quiz.instructions,
                  scoringRules: quiz.scoringRules,
                  notes: quiz.notes,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ====================================================================
// CARD STATUS CHIP
// ====================================================================
class _QuizStatusChip extends StatelessWidget {
  final QuizStatus status;
  const _QuizStatusChip({required this.status, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String label;
    Color textColor = kPrimaryDarkBlue;
    Color bgColor;

    switch (status) {
      case QuizStatus.active:
        label = 'Active';
        textColor = Colors.white;
        bgColor = kAccentOrange;
        break;
      case QuizStatus.completed:
        label = 'Completed';
        textColor = kPrimaryDarkBlue;
        bgColor = kAccentOrange.withOpacity(0.18);
        break;
      case QuizStatus.draft:
        label = 'Draft';
        textColor = kPrimaryDarkBlue;
        bgColor = kPrimaryDarkBlue.withOpacity(0.09);
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: status == QuizStatus.draft
            ? Border.all(color: kPrimaryDarkBlue.withOpacity(0.14), width: 1.0)
            : null,
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w700,
          fontSize: 13.2,
        ),
      ),
    );
  }
}

// ====================================================================
// INFO "CHIP" (class, subject, etc.)
// ====================================================================
class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 120),
      margin: const EdgeInsets.only(bottom: 1),
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: kPrimaryDarkBlue.withOpacity(0.08),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: kAccentOrange.withOpacity(0.85)),
          const SizedBox(width: 5.5),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: kPrimaryDarkBlue,
                fontWeight: FontWeight.w700,
                fontSize: 12.7,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ====================================================================
// QUIZ CARD ACTION BUTTONS (All inside Wrap, no overflow)
// ====================================================================
class _QuizCardActions extends StatelessWidget {
  final VoidCallback onViewQuestions;
  final VoidCallback onEditQuiz;
  final VoidCallback onAssign;
  final VoidCallback onResults;

  const _QuizCardActions({
    required this.onViewQuestions,
    required this.onEditQuiz,
    required this.onAssign,
    required this.onResults,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Wrap prevents horizontal overflows!
    return Padding(
      padding: const EdgeInsets.only(top: 6, bottom: 1),
      child: Wrap(
        spacing: 8,
        runSpacing: 7,
        children: [
          _ActionButton(
            label: 'View Questions',
            icon: Icons.list_alt,
            onTap: onViewQuestions,
          ),
          _ActionButton(
            label: 'Edit Quiz',
            icon: Icons.edit_outlined,
            onTap: onEditQuiz,
          ),
          _ActionButton(
            label: 'Assign to Class',
            icon: Icons.assignment_return,
            accent: true,
            onTap: onAssign,
          ),
          _ActionButton(
            label: 'Results',
            icon: Icons.bar_chart_outlined,
            onTap: onResults,
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
    return ElevatedButton.icon(
      icon: Icon(
        icon,
        size: 19,
        color: accent ? Colors.white : kAccentOrange,
      ),
      label: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontWeight: FontWeight.w700,
          color: accent ? Colors.white : kPrimaryDarkBlue,
          fontSize: 13.3,
        ),
      ),
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: accent ? kAccentOrange : Colors.white,
        foregroundColor: accent ? Colors.white : kPrimaryDarkBlue,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(11),
          side: accent
              ? BorderSide.none
              : BorderSide(color: kAccentOrange.withOpacity(0.44), width: 1.1),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        minimumSize: Size.zero, // remove any min width/height constraints
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shadowColor: Colors.transparent,
      ),
    );
  }
}

// =====================================================================
// SECTION 5: EXPANDABLE DETAILS (ExpansionTile, no fixed height)
// =====================================================================
class _QuizExpandableDetails extends StatelessWidget {
  final String instructions;
  final String scoringRules;
  final String? notes;

  const _QuizExpandableDetails({
    required this.instructions,
    required this.scoringRules,
    this.notes,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ExpansionTile never overflows vertically due to natural wrapping
    return Theme(
      // Remove ExpansionTile top/bottom padding for cleaner look
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent,
        visualDensity: VisualDensity.compact,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        childrenPadding: EdgeInsets.zero,
        collapsedIconColor: kAccentOrange,
        iconColor: kAccentOrange,
        title: Text(
          "Details",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: kAccentOrange,
            fontWeight: FontWeight.w700,
            fontSize: 14.3,
            letterSpacing: 0.1,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 7, top: 1, left: 2, right: 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _DetailRow(
                  title: "Instructions",
                  content: instructions,
                  icon: Icons.info_outline,
                ),
                _DetailRow(
                  title: "Scoring Rules",
                  content: scoringRules,
                  icon: Icons.rule_folder_outlined,
                ),
                if ((notes ?? '').trim().isNotEmpty)
                  _DetailRow(
                    title: "Notes",
                    content: notes!,
                    icon: Icons.note_alt_outlined,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String title;
  final String content;
  final IconData icon;

  const _DetailRow({
    required this.title,
    required this.content,
    required this.icon,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Always uses vertical arrangement, text wraps freely
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.5, left: 2, right: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Icon(icon, color: kPrimaryDarkBlue.withOpacity(0.85), size: 19),
          ),
          const SizedBox(width: 9),
          // Expanded content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: kPrimaryDarkBlue,
                    fontSize: 13.2,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  content,
                  maxLines: 6,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: kPrimaryDarkBlue,
                    fontSize: 12.7,
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

// =====================================================================
// SECTION 6: CREATE QUIZ BUTTON (Safe, scrollable placement)
// =====================================================================
class _CreateQuizCTAButton extends StatelessWidget {
  final VoidCallback onPressed;
  const _CreateQuizCTAButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Button is inside SingleChildScrollView, so always visible.
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.add, color: Colors.white, size: 23),
            label: const Text(
              "Create New Quiz",
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
