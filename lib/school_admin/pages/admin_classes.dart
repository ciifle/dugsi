import 'package:flutter/material.dart';
import 'package:kobac/school_admin/pages/admin_class_screen.dart';

// --- Color palette (for easy reference) ---
const Color kAccentOrange = Color(0xFF5AB04B);
const Color kDarkBlue = Color(0xFF023471);
const Color kLightGrey = Color(0xFFF5F6FA);
const Color kDividerGrey = Color(0xFFDFE2E7);
const double kCardRadius = 14;

class SchoolClass {
  final String name;
  final int studentCount;
  final String teacher;
  final String performance; // 'Excellent', 'Average', 'Needs Attention'
  final String section;
  final String academicYear;

  SchoolClass({
    required this.name,
    required this.studentCount,
    required this.teacher,
    required this.performance,
    required this.section,
    required this.academicYear,
  });
}

// Dummy data list
final List<SchoolClass> dummyClasses = [
  SchoolClass(
    name: 'Grade 7 - A',
    studentCount: 35,
    teacher: 'Mrs. Alice Johnson',
    performance: 'Excellent',
    section: 'A',
    academicYear: '2023-24',
  ),
  SchoolClass(
    name: 'Grade 8 - B',
    studentCount: 32,
    teacher: 'Mr. Ben Carter',
    performance: 'Average',
    section: 'B',
    academicYear: '2023-24',
  ),
  SchoolClass(
    name: 'Grade 9 - C',
    studentCount: 29,
    teacher: 'Ms. Mariel Wang',
    performance: 'Needs Attention',
    section: 'C',
    academicYear: '2022-23',
  ),
  SchoolClass(
    name: 'Grade 10 - A',
    studentCount: 27,
    teacher: 'Dr. Laura Simon',
    performance: 'Excellent',
    section: 'A',
    academicYear: '2022-23',
  ),
  // Add more as needed
];

// Returns orange for all badge backgrounds, but uses toned accent for clarity
Color getPerformanceColor(String performance, BuildContext context) {
  switch (performance) {
    case 'Excellent':
      return kAccentOrange.withOpacity(0.95);
    case 'Average':
      return kAccentOrange.withOpacity(0.75);
    case 'Needs Attention':
      return kAccentOrange.withOpacity(0.55);
    default:
      return kAccentOrange;
  }
}

// ---------- Card for a class ----------
class ClassCard extends StatelessWidget {
  final SchoolClass schoolClass;
  final VoidCallback onTap;
  const ClassCard({Key? key, required this.schoolClass, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      elevation: 6,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kCardRadius)),
      shadowColor: kDarkBlue.withOpacity(0.12),
      child: InkWell(
        borderRadius: BorderRadius.circular(kCardRadius),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 22),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Class icon in orange w/ soft background
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: kAccentOrange.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: kAccentOrange.withOpacity(0.06),
                      offset: const Offset(0,2),
                      blurRadius: 5,
                      spreadRadius: 0.2,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.class_,
                  size: 34,
                  color: kAccentOrange,
                ),
              ),
              const SizedBox(width: 22),
              // Class information
              Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name as one line
                    Text(
                      schoolClass.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: kDarkBlue,
                            fontWeight: FontWeight.w900,
                            fontSize: 21,
                            letterSpacing: 0.1,
                          ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    const SizedBox(height: 10),
                    // --- Row: Student count (left) + Teacher (right) ---
                    // Wrap with SingleChildScrollView to prevent horizontal overflow
                    LayoutBuilder(
                      builder: (context, constraints) {
                        // Prevent overflow with flexible and FittedBox
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Student count (flexible left)
                            Flexible(
                              flex: 2,
                              fit: FlexFit.tight,
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Icon(Icons.people, size: 17, color: kAccentOrange),
                                  const SizedBox(width: 4),
                                  Flexible(
                                    child: Text(
                                      '${schoolClass.studentCount} students',
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                            color: kDarkBlue.withOpacity(0.90),
                                            fontWeight: FontWeight.w500,
                                          ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 13),
                            // Teacher (flexible right)
                            Flexible(
                              flex: 3,
                              fit: FlexFit.tight,
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Icon(Icons.person, size: 17, color: kAccentOrange),
                                  const SizedBox(width: 4),
                                  Flexible(
                                    child: Text(
                                      schoolClass.teacher,
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                            color: kDarkBlue.withOpacity(0.90),
                                            fontWeight: FontWeight.w500,
                                          ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
              // Performance badge (prevent overflow with FittedBox and min width)
              Container(
                margin: const EdgeInsets.only(left: 16),
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
                constraints: BoxConstraints(
                  minWidth: 78, // Ensures the badge doesn't collapse and cause overflow
                  maxWidth: 120, // Restrict max width for small screens
                ),
                decoration: BoxDecoration(
                  color: getPerformanceColor(schoolClass.performance, context).withOpacity(0.13),
                  borderRadius: BorderRadius.circular(19),
                  border: Border.all(
                    color: kAccentOrange.withOpacity(0.40),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: kAccentOrange.withOpacity(0.06),
                      spreadRadius: 0.4,
                      blurRadius: 6,
                      offset: const Offset(0,2),
                    ),
                  ],
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.circle,
                        color: kAccentOrange,
                        size: 15.5,
                      ),
                      const SizedBox(width: 7),
                      Text(
                        schoolClass.performance,
                        style: TextStyle(
                          color: kAccentOrange,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.1,
                          fontSize: 15.2,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ],
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

// --------- Main classes list page ---------
class AdminClassesPage extends StatefulWidget {
  const AdminClassesPage({Key? key}) : super(key: key);

  @override
  State<AdminClassesPage> createState() => _AdminClassesPageState();
}

class _AdminClassesPageState extends State<AdminClassesPage> {
  String searchText = '';
  String? selectedSection;
  String? selectedYear;

  List<String> getSections() {
    final allSections = dummyClasses.map((c) => c.section).toSet().toList();
    allSections.sort();
    return allSections;
  }

  List<String> getYears() {
    final allYears = dummyClasses.map((c) => c.academicYear).toSet().toList();
    allYears.sort((a, b) => b.compareTo(a)); // Recent years first
    return allYears;
  }

  List<SchoolClass> get filteredClasses {
    return dummyClasses.where((schoolClass) {
      final searchMatch = schoolClass.name
          .toLowerCase()
          .contains(searchText.toLowerCase());
      final sectionMatch = selectedSection == null || schoolClass.section == selectedSection;
      final yearMatch = selectedYear == null || schoolClass.academicYear == selectedYear;
      return searchMatch && sectionMatch && yearMatch;
    }).toList();
  }

  void _onSearchChanged(String value) {
    setState(() {
      searchText = value;
    });
  }

  void _onSectionFilterChanged(String? value) {
    setState(() {
      selectedSection = value;
    });
  }

  void _onYearFilterChanged(String? value) {
    setState(() {
      selectedYear = value;
    });
  }

  void _onClassTapped(SchoolClass schoolClass) {
    final classInfo = ClassInfo(
      className: schoolClass.name,
      academicYear: schoolClass.academicYear,
      teacherName: schoolClass.teacher,
      totalStudents: schoolClass.studentCount,
      averageGpa: () {
        if (schoolClass.performance == "Excellent") return 3.8;
        if (schoolClass.performance == "Average") return 3.1;
        return 2.6;
      }(),
      attendancePercent: () {
        if (schoolClass.performance == "Excellent") return 96.5;
        if (schoolClass.performance == "Average") return 91.0;
        return 83.3;
      }(),
    );

    final List<Student> demoStudents = List.generate(
      schoolClass.studentCount,
      (index) => Student(
        name: "Student ${index + 1}",
        profileUrl: "https://api.dicebear.com/7.x/fun-emoji/svg?seed=${schoolClass.name.split(' ').join()}_${index + 1}",
        gpa: ((schoolClass.performance == "Excellent")
                ? (3.7 + (index % 4) * 0.1)
                : (schoolClass.performance == "Average")
                    ? (3.1 + (index % 5) * 0.08)
                    : (2.5 + (index % 7) * 0.12))
            .clamp(2.0, 4.0),
        rank: index + 1,
      ),
    );
    final List<Student> topStudents = demoStudents.take(3).toList();
    final List<Student> allStudents = demoStudents.toList();

    final List<Map<String, dynamic>> subjectPerformance = [
      {
        "subject": "Math",
        "average": schoolClass.performance == "Excellent"
            ? 91
            : schoolClass.performance == "Average"
                ? 80
                : 69,
        "topper": topStudents.isNotEmpty ? topStudents[0].name : "",
      },
      {
        "subject": "Science",
        "average": schoolClass.performance == "Excellent"
            ? 89
            : schoolClass.performance == "Average"
                ? 75
                : 68,
        "topper": topStudents.length > 1 ? topStudents[1].name : topStudents.isNotEmpty ? topStudents[0].name : "",
      },
      {
        "subject": "English",
        "average": schoolClass.performance == "Excellent"
            ? 94
            : schoolClass.performance == "Average"
                ? 84
                : 75,
        "topper": topStudents.length > 2 ? topStudents[2].name : topStudents.isNotEmpty ? topStudents[0].name : "",
      },
    ];

    final List<Map<String, dynamic>> attendanceMonthlySummary = [
      {"month": "Apr", "present": 700, "absent": 20},
      {"month": "May", "present": 710, "absent": 18},
      {"month": "Jun", "present": 690, "absent": 21},
      {"month": "Jul", "present": 710, "absent": 16},
      {"month": "Aug", "present": 718, "absent": 12},
      {"month": "Sep", "present": 690, "absent": 22},
      {"month": "Oct", "present": 698, "absent": 19},
    ];

    final List<Map<String, dynamic>> notesTimeline = [
      {
        "date": "2023-09-14",
        "note": "Parent-Teacher meeting conducted.",
      },
      {
        "date": "2023-07-31",
        "note": "Excellent group presentation by ${topStudents.isNotEmpty ? topStudents[0].name : 'N/A'}.",
      },
      {
        "date": "2023-05-18",
        "note":
            "Average monthly attendance observed. Improvement suggested.",
      },
    ];

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ClassDetailsPage(
          classInfo: classInfo,
          topStudents: topStudents,
          allStudents: allStudents,
          subjectPerformance: subjectPerformance,
          attendanceMonthlySummary: attendanceMonthlySummary,
          notesTimeline: notesTimeline,
        ),
      ),
    );
  }

  void _onAddClass() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Add Class button pressed.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sectionOptions = getSections();
    final yearOptions = getYears();

    return Scaffold(
      backgroundColor: kLightGrey,
      appBar: AppBar(
        backgroundColor: kDarkBlue,
        elevation: 3,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(18), bottomRight: Radius.circular(18))),
        title: const Text(
          'Classes',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 24,
            letterSpacing: 0.2,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white, // White arrow back
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white, // White background for the add icon
                borderRadius: BorderRadius.circular(100),
                boxShadow: [
                  BoxShadow(
                    color: kAccentOrange.withOpacity(0.14),
                    blurRadius: 7,
                    spreadRadius: 0.1,
                    offset: const Offset(0,2),
                  ),
                ],
              ),
              child: IconButton(
                icon: Icon(Icons.add, color: kAccentOrange, size: 27),
                tooltip: "Add Class",
                onPressed: _onAddClass,
                splashRadius: 24,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- Search & Filters section (polished styling) ---
            Card(
              elevation: 5,
              color: Colors.white,
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13)),
              shadowColor: kDarkBlue.withOpacity(0.07),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Search field
                        SizedBox(
                          width: 210,
                          child: TextField(
                            style: TextStyle(
                              fontSize: 16,
                              color: kDarkBlue,
                              fontWeight: FontWeight.w500,
                            ),
                            cursorColor: kAccentOrange,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.search, color: kAccentOrange, size: 22),
                              hintText: 'Search by class name',
                              hintStyle: TextStyle(
                                color: kDarkBlue.withOpacity(0.45),
                                fontWeight: FontWeight.w400,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
                              filled: false,
                            ),
                            onChanged: _onSearchChanged,
                          ),
                        ),
                        const SizedBox(width: 14),
                        // Section filter dropdown
                        DecoratedBox(
                          decoration: BoxDecoration(
                            color: kAccentOrange.withOpacity(0.09),
                            borderRadius: BorderRadius.circular(9),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: DropdownButton<String>(
                              value: selectedSection,
                              hint: Text(
                                'Section',
                                style: TextStyle(color: kDarkBlue, fontWeight: FontWeight.w500),
                              ),
                              items: [
                                DropdownMenuItem<String>(
                                  value: null,
                                  child: Text('All Sections',
                                    style: TextStyle(
                                        color: kDarkBlue,
                                        fontWeight: FontWeight.w600)),
                                ),
                                ...sectionOptions.map((section) =>
                                    DropdownMenuItem<String>(
                                      value: section,
                                      child: Text(section,
                                          style: TextStyle(
                                              color: kDarkBlue,
                                              fontWeight: FontWeight.w600)),
                                    ),
                                )
                              ],
                              icon: Icon(Icons.keyboard_arrow_down, color: kAccentOrange, size: 22),
                              onChanged: _onSectionFilterChanged,
                              elevation: 4,
                              underline: SizedBox(),
                              borderRadius: BorderRadius.circular(11),
                              dropdownColor: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Year filter dropdown
                        DecoratedBox(
                          decoration: BoxDecoration(
                            color: kAccentOrange.withOpacity(0.09),
                            borderRadius: BorderRadius.circular(9),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: DropdownButton<String>(
                              value: selectedYear,
                              hint: Text(
                                'Year',
                                style: TextStyle(color: kDarkBlue, fontWeight: FontWeight.w500),
                              ),
                              items: [
                                DropdownMenuItem<String>(
                                  value: null,
                                  child: Text('All Years',
                                      style: TextStyle(
                                        color: kDarkBlue,
                                        fontWeight: FontWeight.w600,
                                      )),
                                ),
                                ...yearOptions.map((year) =>
                                    DropdownMenuItem<String>(
                                      value: year,
                                      child: Text(year,
                                          style: TextStyle(
                                              color: kDarkBlue,
                                              fontWeight: FontWeight.w600)),
                                    ),
                                )
                              ],
                              icon: Icon(Icons.keyboard_arrow_down, color: kAccentOrange, size: 22),
                              onChanged: _onYearFilterChanged,
                              elevation: 4,
                              underline: SizedBox(),
                              borderRadius: BorderRadius.circular(11),
                              dropdownColor: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 19),
            // Divider for section separation
            Divider(
              color: kDividerGrey,
              thickness: 1.1,
              height: 4,
              indent: 0,
              endIndent: 0,
            ),
            const SizedBox(height: 7),
            // --- Class Cards Grid/List ---
            Expanded(
              child: filteredClasses.isNotEmpty
                  ? LayoutBuilder(
                    builder: (context, constraints) {
                      // Responsive: use 1 column if narrow, 2 if wide
                      final isWide = constraints.maxWidth > 700;
                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: isWide ? 2 : 1,
                          childAspectRatio: isWide ? 2.8 : 2.2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: filteredClasses.length,
                        itemBuilder: (context, index) {
                          final schoolClass = filteredClasses[index];
                          return LayoutBuilder(
                            builder: (context, cardConstraints) {
                              // Wrap with SingleChildScrollView if really narrow tile
                              if (cardConstraints.maxWidth < 320) {
                                // If very narrow, allow horizontal scroll inside the card
                                return SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: SizedBox(
                                    width: 340,
                                    child: ClassCard(
                                      schoolClass: schoolClass,
                                      onTap: () => _onClassTapped(schoolClass),
                                    ),
                                  ),
                                );
                              } else {
                                return ClassCard(
                                  schoolClass: schoolClass,
                                  onTap: () => _onClassTapped(schoolClass),
                                );
                              }
                            },
                          );
                        },
                      );
                    }
                  )
                  : Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(13),
                          boxShadow: [
                            BoxShadow(
                              color: kDarkBlue.withOpacity(0.06),
                              blurRadius: 6,
                              spreadRadius: 1,
                              offset: Offset(0,2),
                            )
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.info_outline, color: kAccentOrange, size: 26),
                            const SizedBox(width: 9),
                            Text(
                              "No classes found.",
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: kDarkBlue,
                                  fontSize: 17.3,
                                  fontWeight: FontWeight.w600
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
