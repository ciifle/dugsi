import 'package:flutter/material.dart';

// ===== BRAND COLORS =====
const Color _kPrimaryColor = Color(0xFF023471); // Dark Blue
const Color _kAccentColor = Color(0xFF5AB04B);  // Orange
const Color _kBackgroundColor = Color(0xFFF8F9FA); // Very Light Gray

class StudentProfileScreenV1 extends StatelessWidget {
  StudentProfileScreenV1({Key? key}) : super(key: key);

  // Dummy data
  final Map<String, String> student = const {
    'fullName': "Ayesha Khan",
    'studentID': "STU230017",
    'class': "10",
    'section': "B",
    'rollNumber': "21",
    'academicYear': "2023-24",
    'dob': "12 Aug 2008",
    'gender': "Female",
    'phone': "+971 55 667 8821",
    'email': "ayesha.khan@email.com",
    'schoolName': "Sunrise Model School",
    'guardianName': "Mariam Khan",
    'guardianRelation': "Mother",
    'guardianPhone': "+971 55 909 6612",
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBackgroundColor,
      appBar: AppBar(
        backgroundColor: _kPrimaryColor,
        centerTitle: true,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Student Profile",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
            overflow: TextOverflow.ellipsis,
          ),
          maxLines: 1,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _ProfileHeaderCard(student: student),
              const SizedBox(height: 22),
              _InfoCard(
                title: "Personal Info",
                data: [
                  _CardRow(label: "Date of Birth", value: student['dob'] ?? ''),
                  _CardRow(label: "Gender", value: student['gender'] ?? ''),
                  _CardRow(label: "Phone", value: student['phone'] ?? ''),
                  _CardRow(label: "Email", value: student['email'] ?? ''),
                ],
              ),
              const SizedBox(height: 16),
              _InfoCard(
                title: "Academic Info",
                data: [
                  _CardRow(label: "School", value: student['schoolName'] ?? ''),
                  _CardRow(label: "Class", value: student['class'] ?? ''),
                  _CardRow(label: "Section", value: student['section'] ?? ''),
                  _CardRow(label: "Roll Number", value: student['rollNumber'] ?? ''),
                ],
              ),
              const SizedBox(height: 16),
              _InfoCard(
                title: "Guardian Info",
                data: [
                  _CardRow(label: "Name", value: student['guardianName'] ?? ''),
                  _CardRow(label: "Relationship", value: student['guardianRelation'] ?? ''),
                  _CardRow(label: "Phone", value: student['guardianPhone'] ?? ''),
                ],
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _kAccentColor,
                    foregroundColor: Colors.white,
                    elevation: 1,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9),
                    ),
                  ),
                  child: const Text(
                    "Edit Profile",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
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

class _ProfileHeaderCard extends StatelessWidget {
  final Map<String, String> student;
  const _ProfileHeaderCard({required this.student});

  String _getInitials(String name) {
    final parts = name.trim().split(RegExp(r'\s+')).where((e) => e.isNotEmpty).toList();
    if (parts.isEmpty) return "";
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return (parts[0][0] + parts.last[0]).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final name = student['fullName'] ?? "";
    final id = student['studentID'] ?? "";
    final className = student['class'] ?? "";
    final section = student['section'] ?? "";

    return Card(
      color: Colors.white,
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.05),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 26, horizontal: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: _kPrimaryColor.withOpacity(0.07),
              child: Text(
                _getInitials(name),
                style: const TextStyle(
                  color: _kPrimaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                  overflow: TextOverflow.ellipsis,
                ),
                maxLines: 1,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              name,
              style: const TextStyle(
                color: _kPrimaryColor,
                fontWeight: FontWeight.w700,
                fontSize: 20,
                letterSpacing: 0.2,
                overflow: TextOverflow.ellipsis,
              ),
              maxLines: 1,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              "ID: $id",
              style: const TextStyle(
                color: _kPrimaryColor,
                fontWeight: FontWeight.w400,
                fontSize: 15,
                overflow: TextOverflow.ellipsis,
              ),
              maxLines: 1,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.school, size: 18, color: _kAccentColor),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    "Class $className",
                    style: const TextStyle(
                      color: _kPrimaryColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      overflow: TextOverflow.ellipsis,
                    ),
                    maxLines: 1,
                  ),
                ),
                const SizedBox(width: 12),
                Flexible(
                  child: Text(
                    "Section $section",
                    style: const TextStyle(
                      color: _kPrimaryColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
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
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final List<_CardRow> data;
  const _InfoCard({required this.title, required this.data, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 1,
      margin: EdgeInsets.zero,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 4,
                  height: 20,
                  decoration: BoxDecoration(
                    color: _kAccentColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: _kPrimaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 15.5,
                      overflow: TextOverflow.ellipsis,
                    ),
                    maxLines: 1,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...List.generate(
              data.length,
              (i) => Padding(
                padding: EdgeInsets.only(bottom: i == data.length - 1 ? 0 : 10),
                child: data[i],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CardRow extends StatelessWidget {
  final String label;
  final String value;
  const _CardRow({
    required this.label,
    required this.value,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Ensures NO overflow even for long strings or small screens.
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: 78,
            maxWidth: 110,
          ),
          child: Text(
            label,
            style: const TextStyle(
              color: _kPrimaryColor,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              overflow: TextOverflow.ellipsis,
            ),
            maxLines: 1,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: _kPrimaryColor,
              fontSize: 14,
              fontWeight: FontWeight.w400,
              overflow: TextOverflow.ellipsis,
            ),
            maxLines: 2,
          ),
        ),
      ],
    );
  }
}
