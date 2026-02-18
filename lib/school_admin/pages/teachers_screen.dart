import 'package:flutter/material.dart';
import 'package:kobac/school_admin/pages/teacher_screen.dart';

// --- Project Color Palette ---
const Color kDarkBlue = Color(0xFF023471); // For AppBar, title, teacher names
const Color kOrange = Color(0xFF5AB04B); // For icons, highlights, accents
const Color kLightGrey = Color(0xFFF4F6FA); // For page background

// Dummy teacher data with images
class Teacher {
  final String name;
  final String subject;
  final String contact;
  final bool isActive;
  final String? imageUrl; // Made this nullable to prevent type mismatch

  const Teacher({
    required this.name,
    required this.subject,
    required this.contact,
    required this.isActive,
    this.imageUrl, // Make imageUrl optional
  });
}

final List<Teacher> _dummyTeachers = [
  Teacher(
    name: "Amina Hassan",
    subject: "Mathematics",
    contact: "amina.hassan@school.edu",
    isActive: true,
    imageUrl: "https://randomuser.me/api/portraits/women/68.jpg",
  ),
  Teacher(
    name: "Mohamed Ali",
    subject: "English Literature",
    contact: "mohamed.ali@school.edu",
    isActive: false,
    imageUrl: "https://randomuser.me/api/portraits/men/74.jpg",
  ),
  Teacher(
    name: "Fatima Nur",
    subject: "Physics",
    contact: "fatima.nur@school.edu",
    isActive: true,
    imageUrl: "https://randomuser.me/api/portraits/women/75.jpg",
  ),
  Teacher(
    name: "Liban Warsame",
    subject: "History",
    contact: "liban.warsame@school.edu",
    isActive: true,
    imageUrl: "https://randomuser.me/api/portraits/men/69.jpg",
  ),
  Teacher(
    name: "Sarah Ahmed",
    subject: "Chemistry",
    contact: "sarah.ahmed@school.edu",
    isActive: false,
    imageUrl: "https://randomuser.me/api/portraits/women/80.jpg",
  ),
];

// Main Teacher List Page
class TeacherListScreen extends StatelessWidget {
  const TeacherListScreen({super.key});

  void _onAddTeacher(BuildContext context) {
    // TODO: Implement add teacher flow
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Add Teacher tapped")),
    );
  }

  // Accept a Teacher to pass to details page
  void _openTeacherDetails(BuildContext context, Teacher teacher) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TeacherDetailsPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kLightGrey,
      appBar: AppBar(
        backgroundColor: kDarkBlue,
        elevation: 3,
        title: const Text(
          "Teachers",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
            letterSpacing: 0.1,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_alt_1),
            tooltip: "Add Teacher",
            color: kOrange,
            onPressed: () => _onAddTeacher(context),
            splashRadius: 25,
          ),
        ],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
        child: ListView.separated(
          itemCount: _dummyTeachers.length,
          separatorBuilder: (context, idx) => const SizedBox(height: 15),
          itemBuilder: (context, idx) {
            final teacher = _dummyTeachers[idx];
            // Use only InkWell (not wrapped by GestureDetector!) and assign onTap here
            return TeacherCard(
              teacher: teacher,
              onTap: () => _openTeacherDetails(context, teacher),
            );
          },
        ),
      ),
    );
  }
}

// Reusable widget for displaying teacher info card
class TeacherCard extends StatelessWidget {
  final Teacher teacher;
  final VoidCallback? onTap;
  const TeacherCard({super.key, required this.teacher, this.onTap});

  static const String defaultAvatar =
      'https://ui-avatars.com/api/?name=Teacher&background=ccc&color=888';

  @override
  Widget build(BuildContext context) {
    // Status badge
    final statusColor = teacher.isActive ? kOrange : Colors.grey[400];
    final statusText = teacher.isActive ? 'Active' : 'Inactive';

    // Use a placeholder image if imageUrl is null or empty
    final String safeImageUrl = (teacher.imageUrl != null && teacher.imageUrl!.isNotEmpty)
        ? teacher.imageUrl!
        : defaultAvatar;

    return Card(
      elevation: 5,
      color: Colors.white,
      shadowColor: kDarkBlue.withOpacity(0.08),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: onTap, // << Now handle navigation here
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile Avatar
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: kOrange.withOpacity(0.08),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: kOrange.withOpacity(0.07),
                      blurRadius: 4,
                      offset: const Offset(1, 2),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: _NetworkImageFix(url: safeImageUrl),
                ),
              ),
              const SizedBox(width: 18),
              // Flexible card middle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Teacher Name (truncate with ...)
                    Text(
                      teacher.name,
                      style: const TextStyle(
                        color: kDarkBlue,
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        letterSpacing: 0.12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    // Subject
                    Row(
                      children: [
                        const Icon(Icons.book_rounded, color: kOrange, size: 18),
                        const SizedBox(width: 5),
                        Flexible(
                          child: Text(
                            teacher.subject,
                            style: const TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                              fontSize: 15.5,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    // Contact info
                    Row(
                      children: [
                        const Icon(Icons.email_outlined, color: kOrange, size: 17),
                        const SizedBox(width: 5),
                        Flexible(
                          child: Text(
                            teacher.contact,
                            style: const TextStyle(
                              color: Colors.black54,
                              fontSize: 14.5,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              // Status badge
              Container(
                margin: const EdgeInsets.only(left: 12),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: teacher.isActive
                      ? kOrange.withOpacity(0.11)
                      : Colors.grey.withOpacity(0.13),
                  borderRadius: BorderRadius.circular(11),
                  border: Border.all(
                      color: statusColor!,
                      width: 1.2),
                ),
                child: Text(
                  statusText,
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 13.8,
                    letterSpacing: 0.1,
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

// Custom network image widget with fix for non-showing images using NetworkImage as provider
class _NetworkImageFix extends StatelessWidget {
  final String url;
  const _NetworkImageFix({required this.url});

  @override
  Widget build(BuildContext context) {
    return Image(
      image: NetworkImage(url, scale: 1.0),
      width: 56,
      height: 56,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => const Icon(
        Icons.person,
        color: kOrange,
        size: 35,
      ),
    );
  }
}
