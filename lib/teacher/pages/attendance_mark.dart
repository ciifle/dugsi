import 'package:flutter/material.dart';

// ================== BRAND COLORS ====================
const Color kPrimaryDarkBlue = Color(0xFF023471);
const Color kAccentOrange = Color(0xFF5AB04B);
const Color kBackground = Color(0xFFF9F9F9);
const Color kTextDarkBlue = Color(0xFF023471);

// ================== DATA MODEL ======================
class StudentAttendance {
  final String name;
  final String roll;
  StudentAttendance({required this.name, required this.roll});
}

// ================== MAIN SCREEN =====================
class TeacherAttendanceScreen extends StatefulWidget {
  const TeacherAttendanceScreen({Key? key}) : super(key: key);

  @override
  State<TeacherAttendanceScreen> createState() =>
      _TeacherAttendanceScreenState();
}

class _TeacherAttendanceScreenState extends State<TeacherAttendanceScreen> {
  final String className = 'Grade 8 - A';
  final DateTime attendanceDate = DateTime.now();
  final List<StudentAttendance> students = [
    StudentAttendance(name: 'Ananya Verma', roll: '1'),
    StudentAttendance(name: 'Rohit Sharma', roll: '2'),
    StudentAttendance(name: 'Priya Gupta', roll: '3'),
    StudentAttendance(name: 'Rahul Singh', roll: '4'),
    StudentAttendance(name: 'Meera Patel', roll: '5'),
    StudentAttendance(name: 'Soham Desai', roll: '6'),
    StudentAttendance(name: 'Arjun Kumar', roll: '7'),
    StudentAttendance(name: 'Tanvi Rao', roll: '8'),
    StudentAttendance(name: 'Kabir Chhabra', roll: '9'),
    StudentAttendance(name: 'Sara Ali', roll: '10'),
    StudentAttendance(name: 'Saniya Biswas', roll: '11'),
    StudentAttendance(name: 'Vedant Naik', roll: '12'),
    StudentAttendance(name: 'Ira Menon', roll: '13'),
    StudentAttendance(name: 'Zaid Khan', roll: '14'),
    StudentAttendance(name: 'Riya Thakur', roll: '15'),
  ];

  late List<bool> isPresent;

  @override
  void initState() {
    super.initState();
    isPresent = List<bool>.filled(students.length, true);
  }

  String _formatDate(DateTime date) =>
      "${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        title: const Text(
          "Attendance Marking",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 19.5,
              color: Colors.white,
              letterSpacing: 0.2),
        ),
        centerTitle: true,
        backgroundColor: kPrimaryDarkBlue,
        elevation: 1.5,
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _HeaderCard(
                    className: className,
                    date: attendanceDate,
                    studentCount: students.length,
                  ),
                  const SizedBox(height: 22),
                  Expanded(
                    child: ListView.separated(
                      itemCount: students.length,
                      separatorBuilder: (context, idx) => const SizedBox(height: 10),
                      itemBuilder: (context, idx) {
                        final student = students[idx];
                        final present = isPresent[idx];
                        return _StudentAttendanceCard(
                          name: student.name,
                          roll: student.roll,
                          present: present,
                          onChanged: (val) {
                            setState(() => isPresent[idx] = val);
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 460),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text(
                                  'Attendance saved successfully!',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                backgroundColor: kAccentOrange,
                                duration: const Duration(seconds: 2),
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(11),
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kAccentOrange,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            textStyle: const TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 16),
                            shadowColor: kAccentOrange.withOpacity(0.16),
                          ),
                          child: const Text(
                            "Save Attendance",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Colors.white,
                                letterSpacing: 0.2,
                                fontSize: 16.4,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// ================== HEADER CARD =====================
class _HeaderCard extends StatelessWidget {
  final String className;
  final DateTime date;
  final int studentCount;
  const _HeaderCard({
    required this.className,
    required this.date,
    required this.studentCount,
    Key? key,
  }) : super(key: key);

  String get _formattedDate =>
      "${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}";

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Card(
          color: Colors.white,
          elevation: 2.5,
          shadowColor: kPrimaryDarkBlue.withOpacity(0.10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 17, horizontal: 23),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        className,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 19.4,
                          color: kPrimaryDarkBlue,
                          letterSpacing: 0.03,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today,
                              color: kAccentOrange, size: 16.5),
                          const SizedBox(width: 5),
                          Text(
                            _formattedDate,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: kTextDarkBlue,
                              fontSize: 14.2,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.01,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: kAccentOrange.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  child: Row(
                    children: [
                      const Icon(Icons.group,
                          color: kAccentOrange, size: 17.4),
                      const SizedBox(width: 5),
                      Text(
                        "Students: $studentCount",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: kAccentOrange,
                          fontWeight: FontWeight.bold,
                          fontSize: 14.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ============== STUDENT ATTENDANCE CARD ==============
class _StudentAttendanceCard extends StatelessWidget {
  final String name;
  final String roll;
  final bool present;
  final ValueChanged<bool> onChanged;
  const _StudentAttendanceCard({
    Key? key,
    required this.name,
    required this.roll,
    required this.present,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 500),
      child: Card(
        color: Colors.white,
        elevation: 1.8,
        shadowColor: kPrimaryDarkBlue.withOpacity(0.09),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: kAccentOrange.withOpacity(0.16),
                  borderRadius: BorderRadius.circular(20),
                ),
                alignment: Alignment.center,
                child: Text(
                  roll,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: kAccentOrange,
                    fontSize: 17.5,
                  ),
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16.6,
                        color: kTextDarkBlue,
                        letterSpacing: 0.01,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          present ? Icons.check_circle : Icons.cancel,
                          color: present
                              ? const Color(0xFF199E36)
                              : const Color(0xFFC8262F),
                          size: 16,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          present ? "Present" : "Absent",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13.7,
                            color: present
                                ? const Color(0xFF199E36)
                                : const Color(0xFFC8262F),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              // New: Only a single tickable Checkbox for attendance.
              Checkbox(
                value: present,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                activeColor: kAccentOrange,
                checkColor: Colors.white,
                side: BorderSide(color: kAccentOrange, width: 2),
                onChanged: (checked) {
                  if (checked != null) {
                    onChanged(checked);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
