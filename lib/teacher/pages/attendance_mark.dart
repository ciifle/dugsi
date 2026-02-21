import 'package:flutter/material.dart';

// ======================= BRAND COLORS =======================
const Color _kPrimaryBlue = Color(0xFF023471);
const Color _kPrimaryGreen = Color(0xFF5AB04B);
const Color _kBg = Color(0xFFF4F6F8);
const double _kRadius = 24.0;
const double _kPadding = 20.0;

class StudentAttendance {
  final String name;
  final String roll;
  StudentAttendance({required this.name, required this.roll});
}

class TeacherAttendanceScreen extends StatefulWidget {
  const TeacherAttendanceScreen({Key? key}) : super(key: key);

  @override
  State<TeacherAttendanceScreen> createState() => _TeacherAttendanceScreenState();
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

  void _submit() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Attendance saved successfully!', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: _kPrimaryGreen,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBg,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(_kPadding, 16, _kPadding, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _TopBar(title: 'Take Attendance', onBack: () => Navigator.of(context).maybePop()),
                  const SizedBox(height: 20),
                  _SessionCard(
                    className: className,
                    date: attendanceDate,
                    studentCount: students.length,
                  ),
                  const SizedBox(height: 22),
                  ...List.generate(students.length, (idx) {
                    final s = students[idx];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _StudentCard(
                        name: s.name,
                        roll: s.roll,
                        present: isPresent[idx],
                        onChanged: (val) => setState(() => isPresent[idx] = val),
                      ),
                    );
                  }),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
            _SubmitBar(onSubmit: _submit),
          ],
        ),
      ),
    );
  }
}

// ======================= TOP BAR (no color, like admin) =======================
class _TopBar extends StatelessWidget {
  final String title;
  final VoidCallback onBack;

  const _TopBar({required this.title, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          GestureDetector(
            onTap: onBack,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(color: _kPrimaryBlue.withOpacity(0.1), blurRadius: 12, offset: const Offset(0, 4)),
                ],
              ),
              child: Icon(Icons.arrow_back_rounded, color: _kPrimaryBlue, size: 24),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(color: _kPrimaryBlue, fontWeight: FontWeight.bold, fontSize: 20),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

// ======================= ELEVATED SESSION CARD =======================
class _SessionCard extends StatelessWidget {
  final String className;
  final DateTime date;
  final int studentCount;

  const _SessionCard({required this.className, required this.date, required this.studentCount});

  String get _formattedDate =>
      "${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}";

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(_kRadius),
        boxShadow: [
          BoxShadow(color: _kPrimaryBlue.withOpacity(0.12), blurRadius: 18, offset: const Offset(0, 6)),
          BoxShadow(color: _kPrimaryBlue.withOpacity(0.06), blurRadius: 36, offset: const Offset(0, 14)),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  className,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: _kPrimaryBlue,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.calendar_today_rounded, color: _kPrimaryGreen, size: 18),
                    const SizedBox(width: 8),
                    Text(_formattedDate, style: TextStyle(color: _kPrimaryBlue.withOpacity(0.85), fontSize: 14, fontWeight: FontWeight.w500)),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: _kPrimaryGreen.withOpacity(0.12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.people_rounded, color: _kPrimaryGreen, size: 20),
                const SizedBox(width: 8),
                Text(
                  "$studentCount",
                  style: const TextStyle(color: _kPrimaryGreen, fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ======================= STUDENT ROW WITH SEGMENTED PRESENT/ABSENT =======================
class _StudentCard extends StatelessWidget {
  final String name;
  final String roll;
  final bool present;
  final ValueChanged<bool> onChanged;

  const _StudentCard({required this.name, required this.roll, required this.present, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(color: _kPrimaryBlue.withOpacity(0.1), blurRadius: 14, offset: const Offset(0, 5)),
          BoxShadow(color: _kPrimaryBlue.withOpacity(0.05), blurRadius: 24, offset: const Offset(0, 10)),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: _kPrimaryBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [BoxShadow(color: _kPrimaryBlue.withOpacity(0.06), blurRadius: 6, offset: const Offset(0, 2))],
            ),
            alignment: Alignment.center,
            child: Text(
              roll,
              style: const TextStyle(fontWeight: FontWeight.bold, color: _kPrimaryBlue, fontSize: 16),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: _kPrimaryBlue),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          _SegmentControl(present: present, onChanged: onChanged),
        ],
      ),
    );
  }
}

class _SegmentControl extends StatelessWidget {
  final bool present;
  final ValueChanged<bool> onChanged;

  const _SegmentControl({required this.present, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _kPrimaryBlue.withOpacity(0.06),
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _SegmentChip(
            label: 'Present',
            selected: present,
            isGreen: true,
            onTap: () => onChanged(true),
          ),
          _SegmentChip(
            label: 'Absent',
            selected: !present,
            isGreen: false,
            onTap: () => onChanged(false),
          ),
        ],
      ),
    );
  }
}

class _SegmentChip extends StatelessWidget {
  final String label;
  final bool selected;
  final bool isGreen;
  final VoidCallback onTap;

  const _SegmentChip({required this.label, required this.selected, required this.isGreen, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = isGreen ? _kPrimaryGreen : Colors.redAccent;
    return Material(
      color: selected ? color : Colors.transparent,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : _kPrimaryBlue.withOpacity(0.8),
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}

// ======================= STICKY BOTTOM SUBMIT (GREEN GRADIENT) =======================
class _SubmitBar extends StatelessWidget {
  final VoidCallback onSubmit;

  const _SubmitBar({required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(_kPadding, 16, _kPadding, 16 + MediaQuery.of(context).padding.bottom),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: _kPrimaryBlue.withOpacity(0.06), blurRadius: 12, offset: const Offset(0, -4)),
        ],
      ),
      child: Material(
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: onSubmit,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                colors: [_kPrimaryGreen, Color(0xFF4A9E3E)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(color: _kPrimaryGreen.withOpacity(0.35), blurRadius: 12, offset: const Offset(0, 4)),
              ],
            ),
            child: const Text(
              "Save Attendance",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
