import 'package:flutter/material.dart';
import 'subject_details_page.dart';

// Color palette
const Color kDarkBlue = Color(0xFF023471);
const Color kOrange = Color(0xFF5AB04B);
const Color kLightGrey = Color(0xFFF8F9FA);

class SubjectsScreen extends StatelessWidget {
  const SubjectsScreen({Key? key}) : super(key: key);

  // Dummy subject data for demonstration
  static final List<Subject> _subjects = [
    Subject(
      name: "Mathematics",
      code: "MATH101",
      assignedClass: "Grade 10",
      teacher: "Mr. Alan Turing",
      isActive: true,
    ),
    Subject(
      name: "Physics",
      code: "PHY102",
      assignedClass: "Grade 11",
      teacher: "Ms. Marie Curie",
      isActive: true,
    ),
    Subject(
      name: "History",
      code: "HIS103",
      assignedClass: "Grade 9",
      teacher: "Mr. Nelson Mandela",
      isActive: false,
    ),
    Subject(
      name: "Chemistry",
      code: "CHEM104",
      assignedClass: "Grade 10",
      teacher: "Dr. Rosalind Franklin",
      isActive: true,
    ),
    Subject(
      name: "English",
      code: "ENG105",
      assignedClass: "Grade 8",
      teacher: "Ms. Maya Angelou",
      isActive: true,
    ),
    Subject(
      name: "Art",
      code: "ART106",
      assignedClass: "Grade 7",
      teacher: "Mr. Pablo Picasso",
      isActive: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kLightGrey,
      appBar: AppBar(
        backgroundColor: kDarkBlue,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: true,
        iconTheme: const IconThemeData(color: Colors.white), // White back arrow
        title: const Text(
          "Subjects",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle, color: kOrange, size: 28),
            tooltip: "Add Subject",
            onPressed: () {
              // Placeholder for Add Subject
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Add Subject tapped!'),
                  backgroundColor: kDarkBlue,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SubjectListView(
          subjects: _subjects,
        ),
      ),
    );
  }
}

///
/// Subject list view with smooth scrolling, overflow prevention,
/// and search built-in (optional for minimal version).
///
class SubjectListView extends StatelessWidget {
  final List<Subject> subjects;

  const SubjectListView({
    required this.subjects,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (subjects.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(18.0),
          child: Text(
            "No subjects available.",
            style: TextStyle(
              color: kDarkBlue,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),
      );
    }
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      itemCount: subjects.length,
      separatorBuilder: (_, __) => const SizedBox(height: 14),
      itemBuilder: (context, index) {
        final subject = subjects[index];
        return SubjectTile(
          subject: subject,
          onTap: () {
            // Navigate to SubjectDetailsPage
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => SubjectDetailsPage(),
              ),
            );
          },
        );
      },
    );
  }
}

///
/// SubjectTile: Flat, modern, minimal subject card
/// - Prevents overflow and wraps long text
/// - Rounded corners, soft shadow or border, clean padding
///
class SubjectTile extends StatelessWidget {
  final Subject subject;
  final VoidCallback onTap;

  const SubjectTile({
    Key? key,
    required this.subject,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Responsive width (to support smallest screens)
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: kDarkBlue.withOpacity(0.07),
              width: 1.1,
            ),
            boxShadow: [
              BoxShadow(
                color: kDarkBlue.withOpacity(0.05),
                blurRadius: 6,
                offset: const Offset(0, 1.5),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Orange indicator icon
              Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child: Icon(
                  Icons.circle,
                  color: kOrange,
                  size: 13,
                ),
              ),
              const SizedBox(width: 12),
              // Subject information
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Subject name (bold dark blue)
                    Text(
                      subject.name,
                      style: const TextStyle(
                        color: kDarkBlue,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        height: 1.14,
                        letterSpacing: 0.05,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    // Subject code
                    Text(
                      subject.code,
                      style: TextStyle(
                        color: kDarkBlue.withOpacity(0.7),
                        fontSize: 13.5,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.08,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 10),
                    // Row for classroom and teacher
                    Wrap(
                      spacing: 16,
                      runSpacing: 2,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.class_, color: kOrange, size: 16),
                            const SizedBox(width: 5),
                            ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 120),
                              child: Text(
                                subject.assignedClass,
                                style: const TextStyle(
                                  color: kDarkBlue,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.person, color: kOrange, size: 16),
                            const SizedBox(width: 5),
                            ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 140),
                              child: Text(
                                subject.teacher,
                                style: const TextStyle(
                                  color: kDarkBlue,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Right-chevron (orange)
              Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 8),
                child: Icon(
                  Icons.chevron_right,
                  color: kOrange,
                  size: 27,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

///
/// Dummy Subject data model
///
class Subject {
  final String name;
  final String code;
  final String assignedClass;
  final String teacher;
  final bool isActive;

  Subject({
    required this.name,
    required this.code,
    required this.assignedClass,
    required this.teacher,
    required this.isActive,
  });
}
