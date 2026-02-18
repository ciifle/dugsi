import 'package:flutter/material.dart';
import 'package:kobac/student/pages/quiz_result_details.dart';
// Import for navigation to quiz result screen

const Color kPrimaryColor = Color(0xFF023471); // Dark Blue
const Color kAccentColor = Color(0xFF5AB04B); // Orange
const Color kBackgroundColor = Color(0xFFF8F9FA); // Very Light Gray

// Dummy Quiz Data
enum QuizStatus { upcoming, completed, missed }

class Quiz {
  final String title;
  final String subject;
  final int totalMarks;
  final int durationMinutes;
  final DateTime scheduledDateTime;
  final QuizStatus status;
  final String instructions;
  final int numberOfQuestions;
  final int passingMarks;
  final String teacherName;

  Quiz({
    required this.title,
    required this.subject,
    required this.totalMarks,
    required this.durationMinutes,
    required this.scheduledDateTime,
    required this.status,
    required this.instructions,
    required this.numberOfQuestions,
    required this.passingMarks,
    required this.teacherName,
  });
}

// Example quiz list (dummy data)
final List<Quiz> kDummyQuizzes = [
  Quiz(
    title: "Math Algebra Quiz",
    subject: "Mathematics",
    totalMarks: 20,
    durationMinutes: 30,
    scheduledDateTime: DateTime.now().add(Duration(days: 1)),
    status: QuizStatus.upcoming,
    instructions: "Answer all questions carefully. Calculators allowed.",
    numberOfQuestions: 10,
    passingMarks: 12,
    teacherName: "Mr. Smith",
  ),
  Quiz(
    title: "English Grammar Test",
    subject: "English",
    totalMarks: 15,
    durationMinutes: 25,
    scheduledDateTime: DateTime.now().subtract(Duration(days: 1)),
    status: QuizStatus.completed,
    instructions: "No hints. Check your spelling.",
    numberOfQuestions: 8,
    passingMarks: 8,
    teacherName: "Ms. Taylor",
  ),
  Quiz(
    title: "History Quiz - World War II",
    subject: "History",
    totalMarks: 25,
    durationMinutes: 40,
    scheduledDateTime: DateTime.now().subtract(Duration(days: 2)),
    status: QuizStatus.missed,
    instructions: "All questions compulsory. Write concise answers.",
    numberOfQuestions: 12,
    passingMarks: 15,
    teacherName: "Mr. Lee",
  ),
  Quiz(
    title: "Science: Plant Biology",
    subject: "Science",
    totalMarks: 18,
    durationMinutes: 20,
    scheduledDateTime: DateTime.now().add(Duration(hours: 6)),
    status: QuizStatus.upcoming,
    instructions: "Answer in your own words.",
    numberOfQuestions: 9,
    passingMarks: 10,
    teacherName: "Dr. Watson",
  ),
];

// Main Screen
class StudentQuizzesScreen extends StatefulWidget {
  const StudentQuizzesScreen({Key? key}) : super(key: key);

  @override
  State<StudentQuizzesScreen> createState() => _StudentQuizzesScreenState();
}

class _StudentQuizzesScreenState extends State<StudentQuizzesScreen> {
  String selectedFilter = 'All';

  // Safely filters quizzes based on status
  List<Quiz> getFilteredQuizzes() {
    if (selectedFilter == 'All') return List<Quiz>.from(kDummyQuizzes);
    if (selectedFilter == 'Upcoming') {
      return kDummyQuizzes.where((q) => q.status == QuizStatus.upcoming).toList();
    }
    if (selectedFilter == 'Completed') {
      return kDummyQuizzes.where((q) => q.status == QuizStatus.completed).toList();
    }
    if (selectedFilter == 'Missed') {
      return kDummyQuizzes.where((q) => q.status == QuizStatus.missed).toList();
    }
    return [];
  }

  // Quiz counts for summary
  int get totalQuizCount => kDummyQuizzes.length;
  int get upcomingQuizCount => kDummyQuizzes.where((q) => q.status == QuizStatus.upcoming).length;
  int get completedQuizCount => kDummyQuizzes.where((q) => q.status == QuizStatus.completed).length;
  int get missedQuizCount => kDummyQuizzes.where((q) => q.status == QuizStatus.missed).length;

  @override
  Widget build(BuildContext context) {
    final List<Quiz> filteredQuizzes = getFilteredQuizzes();

    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: const Text(
          'Quizzes',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            // Ensures title does not overflow
            overflow: TextOverflow.ellipsis,
            fontSize: 22,
          ),
          maxLines: 1,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0.5,
      ),
      // SAFE: Entire content wrapped in SingleChildScrollView to prevent overflow.
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section 1: Quiz Summary
              QuizSummaryCard(
                total: totalQuizCount,
                upcoming: upcomingQuizCount,
                completed: completedQuizCount,
                missed: missedQuizCount,
              ),
              const SizedBox(height: 18),
              // Section 2: Quiz Status Filter (wrap-safe)
              Text(
                "Filter by status",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: kPrimaryColor,
                  fontSize: 15,
                  overflow: TextOverflow.ellipsis,
                ),
                maxLines: 1,
              ),
              const SizedBox(height: 8),
              QuizStatusFilterChips(
                selected: selectedFilter,
                onChanged: (value) {
                  setState(() {
                    selectedFilter = value;
                  });
                },
              ),
              const SizedBox(height: 24),
              // Section 3: Quiz List (Column only)
              Text(
                "Assigned Quizzes",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: kPrimaryColor,
                  fontSize: 17,
                  overflow: TextOverflow.ellipsis,
                ),
                maxLines: 1,
              ),
              const SizedBox(height: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: filteredQuizzes.isEmpty
                  ? [
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 42),
                          child: Text(
                            "No quizzes found.",
                            style: TextStyle(
                              color: kPrimaryColor.withOpacity(0.65),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              overflow: TextOverflow.ellipsis,
                            ),
                            maxLines: 1,
                          ),
                        ),
                      )
                    ]
                  : filteredQuizzes.map((quiz) => Padding(
                      padding: const EdgeInsets.only(bottom: 18),
                      child: QuizCard(quiz: quiz),
                    )).toList(),
              ),
              // (End column, no fixed widget heights)
            ],
          ),
        ),
      ),
    );
  }
}

// ---------- WIDGETS BELOW ----------

// --- SECTION 1: QUIZ SUMMARY CARD ---
class QuizSummaryCard extends StatelessWidget {
  final int total;
  final int upcoming;
  final int completed;
  final int missed;
  const QuizSummaryCard({
    Key? key,
    required this.total,
    required this.upcoming,
    required this.completed,
    required this.missed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Each stat as a responsive column (expanded in row, never overflows)
    return Card(
      color: Colors.white,
      margin: EdgeInsets.zero,
      elevation: 1.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        child: Row(
          children: [
            _buildStat('Total', total, kPrimaryColor, false),
            _verticalDivider(),
            _buildStat('Upcoming', upcoming, kAccentColor, false),
            _verticalDivider(),
            _buildStat('Completed', completed, kPrimaryColor, false),
            _verticalDivider(),
            _buildStat('Missed', missed, kPrimaryColor, true),
          ],
        ),
      ),
    );
  }

  // Divider does not use fixed width, so is overflow-safe
  Widget _verticalDivider() => const Expanded(
        child: SizedBox.shrink(),
      );

  Widget _buildStat(String label, int count, Color color, bool faded) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$count',
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
              color: color.withOpacity(faded ? 0.45 : 1),
              overflow: TextOverflow.ellipsis,
            ),
            maxLines: 1,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: color.withOpacity(faded ? 0.45 : 0.9),
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

// --- SECTION 2: FILTER CHIPS (WRAP-SAFE) ---
class QuizStatusFilterChips extends StatelessWidget {
  final List<String> filters = const ['All', 'Upcoming', 'Completed', 'Missed'];
  final String selected;
  final ValueChanged<String> onChanged;

  QuizStatusFilterChips({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    // Uses Wrap for scroll and overflow safety
    return Wrap(
      spacing: 10,
      runSpacing: 9,
      children: filters.map((filter) {
        final bool isSelected = selected == filter;
        return ChoiceChip(
          label: Text(
            filter,
            style: TextStyle(
              color: isSelected ? Colors.white : kPrimaryColor,
              fontWeight: FontWeight.w600,
              fontSize: 14,
              overflow: TextOverflow.ellipsis,
            ),
            maxLines: 1,
          ),
          selected: isSelected,
          selectedColor: kAccentColor,
          backgroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
          side: isSelected
              ? null
              : BorderSide(color: kPrimaryColor.withOpacity(0.12), width: 1.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          onSelected: (_) => onChanged(filter),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        );
      }).toList(),
    );
  }
}

// --- SECTION 3 & 4: QUIZ CARD (EXPANDABLE) ---
// Now we need to pass the quiz to the action button so it has context for navigation
class QuizCard extends StatelessWidget {
  final Quiz quiz;
  const QuizCard({Key? key, required this.quiz}) : super(key: key);

  // Card status badge (no overflow)
  Widget _buildStatusBadge(QuizStatus status) {
    String text;
    switch (status) {
      case QuizStatus.upcoming:
        text = "Upcoming";
        break;
      case QuizStatus.completed:
        text = "Completed";
        break;
      case QuizStatus.missed:
        text = "Missed";
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 3),
      decoration: BoxDecoration(
        color: kAccentColor.withOpacity(0.93),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 13,
          overflow: TextOverflow.ellipsis,
        ),
        maxLines: 1,
      ),
    );
  }

  String _formattedDate(DateTime dt) =>
      "${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}, "
      "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: EdgeInsets.zero,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      shadowColor: kPrimaryColor.withOpacity(0.08),
      child: Padding(
        padding: const EdgeInsets.all(14),
        // Using Column ONLY for content (required)
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and details (Expanded inside Row is mandatory)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        quiz.title,
                        style: TextStyle(
                          color: kPrimaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          overflow: TextOverflow.ellipsis,
                        ),
                        maxLines: 1,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        quiz.subject,
                        style: TextStyle(
                          color: kPrimaryColor.withOpacity(0.71),
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          overflow: TextOverflow.ellipsis,
                        ),
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
                // Status badge (overflow-safe)
                _buildStatusBadge(quiz.status),
              ],
            ),
            const SizedBox(height: 10),
            // Info row (marks, duration, date/time)
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                _InfoChip(
                  icon: Icons.score,
                  text: "${quiz.totalMarks} marks",
                ),
                _InfoChip(
                  icon: Icons.timer,
                  text: "${quiz.durationMinutes} min",
                ),
                _InfoChip(
                  icon: Icons.calendar_today,
                  text: _formattedDate(quiz.scheduledDateTime),
                ),
              ],
            ),
            const SizedBox(height: 14),
            // ExpansionTile: quiz details
            _QuizExpansionDetails(quiz: quiz),
            const SizedBox(height: 10),
            // SECTION 5: ACTION BUTTON
            Row(
              children: [
                Expanded(
                  child: _QuizActionButton(
                    status: quiz.status,
                    quiz: quiz,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// QUIZ ACTION BUTTON
class _QuizActionButton extends StatelessWidget {
  final QuizStatus status;
  final Quiz quiz;
  const _QuizActionButton({required this.status, required this.quiz});

  @override
  Widget build(BuildContext context) {
    String label;
    bool enabled;
    VoidCallback? onTap;
    switch (status) {
      case QuizStatus.upcoming:
        label = "Start Quiz";
        enabled = true;
        onTap = () {
          // TODO: Implement Start Quiz navigation here
        };
        break;
      case QuizStatus.completed:
        label = "View Result";
        enabled = true;
        onTap = () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => StudentQuizResultScreen(),
            ),
          );
        };
        break;
      case QuizStatus.missed:
        label = "Missed";
        enabled = false;
        onTap = null;
        break;
    }

    return TextButton(
      onPressed: enabled ? onTap : null,
      style: TextButton.styleFrom(
        backgroundColor: enabled ? kAccentColor : kAccentColor.withOpacity(0.43),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(9),
        ),
        foregroundColor: Colors.white,
        // button text doesn't overflow
        padding: const EdgeInsets.symmetric(vertical: 11),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 15,
          overflow: TextOverflow.ellipsis,
        ),
        maxLines: 1,
      ),
    );
  }
}

// Info "chip" (not interactive, only shows quiz meta)
class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoChip({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    // No fixed width, always responsive and overflow-safe
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: kPrimaryColor.withOpacity(0.045),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: kPrimaryColor.withOpacity(0.65)),
          const SizedBox(width: 5),
          Text(
            text,
            style: TextStyle(
              color: kPrimaryColor.withOpacity(0.87),
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

// QUIZ EXPANSION DETAILS (ExpansionTile, no custom animation)
class _QuizExpansionDetails extends StatelessWidget {
  final Quiz quiz;
  const _QuizExpansionDetails({required this.quiz});

  @override
  Widget build(BuildContext context) {
    return Theme(
      // Remove divider color for ExpansionTile in Card
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 0),
        childrenPadding: const EdgeInsets.only(left: 6, right: 6, bottom: 3),
        title: Text(
          "View Details",
          style: TextStyle(
            color: kAccentColor,
            fontSize: 15,
            fontWeight: FontWeight.w600,
            overflow: TextOverflow.ellipsis,
          ),
          maxLines: 1,
        ),
        // Use shrinkWrap and No scroll physics for expansion body (overflow safe)
        children: [
          QuizDetailsContent(quiz: quiz),
        ],
      ),
    );
  }
}

class QuizDetailsContent extends StatelessWidget {
  final Quiz quiz;
  const QuizDetailsContent({Key? key, required this.quiz}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Overflow safe: uses Column for content display, never fixed heights!
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _quizDetailRow(Icons.menu_book, "Instructions:", quiz.instructions),
          const SizedBox(height: 4),
          _quizDetailRow(Icons.help_outline, "Questions:", "${quiz.numberOfQuestions}"),
          const SizedBox(height: 4),
          _quizDetailRow(Icons.check_circle_outline, "Passing Marks:", "${quiz.passingMarks}"),
          const SizedBox(height: 4),
          _quizDetailRow(Icons.person, "Teacher:", quiz.teacherName),
        ],
      ),
    );
  }

  Widget _quizDetailRow(IconData icon, String label, String value) {
    // Responsive, never overflows due to maxLines and Expanded in Row
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: kPrimaryColor.withOpacity(0.7), size: 17),
        const SizedBox(width: 7),
        // Column inside Row with Expanded for overflow safety
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: kPrimaryColor.withOpacity(0.74),
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                  overflow: TextOverflow.ellipsis,
                ),
                maxLines: 1,
              ),
              Text(
                value,
                style: TextStyle(
                  color: kPrimaryColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  overflow: TextOverflow.ellipsis,
                ),
                maxLines: 3, // several lines for longer instructions
              ),
            ],
          ),
        ),
      ],
    );
  }
}

