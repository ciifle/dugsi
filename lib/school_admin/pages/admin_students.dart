import 'package:flutter/material.dart';
import 'admin_student_screen.dart';
import 'package:kobac/shared/services/school_service.dart';

// Color constants
const Color kPrimaryAccent = Color(0xFF5AB04B);
const Color kDarkBlue = Color(0xFF023471);
const Color kLightGrey = Color(0xFFF4F6FA);
const Color kDividerGrey = Color(0xFFE6EBF1);

// Use only local asset images for student avatars
const List<String> _localStudentImages = [
  'assets/student_1.jpg',
  'assets/student_2.jpg',
  'assets/student_3.jpg',
  'assets/student_4.jpg',
  'assets/student_5.jpg',
  'assets/student_6.jpg',
  'assets/student_7.jpg',
  'assets/student_8.jpg',
  'assets/student_9.jpg',
  'assets/student_10.jpg',
];

class AdminStudentsScreen extends StatefulWidget {
  const AdminStudentsScreen({Key? key}) : super(key: key);

  @override
  State<AdminStudentsScreen> createState() => _AdminStudentsScreenState();
}

class _AdminStudentsScreenState extends State<AdminStudentsScreen> {
  late Future<List<AppUser>> _studentsFuture;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _studentsFuture = _loadStudents();
  }

  Future<List<AppUser>> _loadStudents() async {
    final users = await SchoolService().getAllUsersForAdmin();
    // filter for students only
    return users.where((user) => user.role.toUpperCase() == "STUDENT").toList();
  }

  List<AppUser> _filterStudents(List<AppUser> students) {
    if (searchQuery.isEmpty) return students;
    return students
        .where((student) =>
            student.fullName.toLowerCase().contains(searchQuery.toLowerCase()) ||
            student.email.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();
  }

  // Simple mapping to always assign a local image to a student, cycling through available asset images
  String _getAvatarAsset(int index) {
    return _localStudentImages[index % _localStudentImages.length];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kLightGrey,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(65),
        child: SafeArea(
          child: Container(
            color: kDarkBlue,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white, size: 27),
                    onPressed: () => Navigator.of(context).maybePop(),
                    tooltip: 'Back',
                  ),
                ),
                const Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 0.0),
                    child: Text(
                      "Students",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        letterSpacing: 0.3,
                        shadows: [
                          Shadow(
                            color: Color(0x22000000),
                            offset: Offset(0, 1.5),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: GestureDetector(
                      onTap: () {
                        // Handle add student action here.
                      },
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: kPrimaryAccent,
                          boxShadow: [
                            BoxShadow(
                              color: kPrimaryAccent.withOpacity(0.14),
                              blurRadius: 8,
                              spreadRadius: 0.1,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 26,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        color: kLightGrey,
        child: FutureBuilder<List<AppUser>>(
          future: _studentsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Loading indicator
              return const Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 100),
                  child: CircularProgressIndicator(
                    color: kPrimaryAccent,
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              // Error state
              return Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 80.0),
                  child: Text(
                    "Failed to load students.\n${snapshot.error}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: kDarkBlue,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                ),
              );
            } else {
              List<AppUser> studentList = snapshot.data ?? [];
              studentList = _filterStudents(studentList);

              return SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 26),
                    // --- Search Bar ---
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 17),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: kDarkBlue.withOpacity(0.08),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                          border: Border.all(
                            color: kDividerGrey,
                            width: 1,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                        child: Row(
                          children: [
                            Icon(Icons.search,
                                color: kPrimaryAccent.withOpacity(0.82),
                                size: 22),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: "Search students…",
                                  hintStyle: TextStyle(
                                    color: kDarkBlue.withOpacity(0.40),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.1,
                                  ),
                                  border: InputBorder.none,
                                ),
                                style: TextStyle(
                                  color: kDarkBlue,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 17,
                                ),
                                onChanged: (val) {
                                  setState(() {
                                    searchQuery = val;
                                  });
                                },
                                cursorColor: kPrimaryAccent,
                              ),
                            ),
                            if (searchQuery.isNotEmpty)
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    searchQuery = '';
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 4),
                                  child: Icon(Icons.close,
                                      size: 20, color: kPrimaryAccent),
                                ),
                              )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    // --- Section Header with Styled Badge ---
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 19),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Student List",
                            style: TextStyle(
                              color: kDarkBlue,
                              fontWeight: FontWeight.w800,
                              fontSize: 19,
                              letterSpacing: 0.13,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 14),
                            decoration: BoxDecoration(
                              color: kPrimaryAccent.withOpacity(0.13),
                              borderRadius: BorderRadius.circular(40),
                              border: Border.all(
                                color: kPrimaryAccent.withOpacity(0.18),
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: kPrimaryAccent.withOpacity(0.09),
                                  blurRadius: 4,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.people, size: 17, color: kPrimaryAccent),
                                const SizedBox(width: 5),
                                Text(
                                  "${studentList.length}",
                                  style: TextStyle(
                                    color: kPrimaryAccent,
                                    fontSize: 15.7,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                      child: Divider(
                        color: kDividerGrey,
                        thickness: 1.2,
                        height: 0,
                      ),
                    ),
                    // --- Student List Box ---
                    if (studentList.isEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 60.0),
                        child: Text(
                          "No students found.",
                          style: TextStyle(
                            color: kDarkBlue.withOpacity(0.54),
                            fontWeight: FontWeight.w600,
                            fontSize: 17,
                          ),
                        ),
                      )
                    else
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          children: List.generate(studentList.length, (index) {
                            final student = studentList[index];
                            return Container(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: kDarkBlue.withOpacity(0.07),
                                    blurRadius: 10,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                                border: Border.all(
                                  color: kDividerGrey,
                                  width: 1.07,
                                ),
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 18, vertical: 13),
                                leading: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: kPrimaryAccent.withOpacity(0.13),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: CircleAvatar(
                                    backgroundColor: kLightGrey,
                                    radius: 27,
                                    child: ClipOval(
                                      child: Builder(
                                        builder: (context) {
                                          // Only use local assets. Show fallback if not found.
                                          return Image.asset(
                                            _getAvatarAsset(index),
                                            fit: BoxFit.cover,
                                            width: 54,
                                            height: 54,
                                            errorBuilder: (context, error, stackTrace) {
                                              return Icon(Icons.person, color: Colors.grey[400], size: 35);
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                title: Text(
                                  student.fullName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: kDarkBlue,
                                    fontSize: 17.7,
                                    letterSpacing: 0.07,
                                  ),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 3.5),
                                  child: Text(
                                    "Email: ${student.email}",
                                    style: TextStyle(
                                      color: kDarkBlue.withOpacity(0.50),
                                      fontSize: 14.4,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0.1,
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  // Just use a demo screen with one of your student entries
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //     builder: (_) => AdminStudentScreen(student: student),
                                  //   ),
                                  // );
                                },
                                trailing: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                      color: kPrimaryAccent.withOpacity(0.32),
                                      width: 1.1,
                                    ),
                                    color: kPrimaryAccent.withOpacity(0.08),
                                  ),
                                  child: IconButton(
                                    icon: Icon(Icons.arrow_forward_ios_rounded,
                                        color: kPrimaryAccent,
                                        size: 23),
                                    splashRadius: 23,
                                    tooltip: "View Student",
                                    onPressed: () {
                                      // Navigator.push(
                                      //   context,
                                      //   MaterialPageRoute(
                                      //     builder: (_) => AdminStudentScreen(student: student),
                                      //   ),
                                      // );
                                    },
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    const SizedBox(height: 24),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
