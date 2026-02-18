import 'package:flutter/material.dart';

// ----- Color Constants -----
const Color kDarkBlue = Color(0xFF023471);
const Color kOrange = Color(0xFF5AB04B);
const Color kBgLight = Color(0xFFF7F8FA);

// Dummy data for demonstration
final List<StudentMark> dummyStudentMarks = [
  StudentMark(name: "Amina Farouk", studentId: "STU1023", marks: 84),
  StudentMark(name: "Yusuf Khaled", studentId: "STU1059", marks: 77),
  StudentMark(name: "Layla Omar", studentId: "STU1091", marks: 95),
  StudentMark(name: "Ahmed Saleh", studentId: "STU0998", marks: 62),
  StudentMark(name: "Rania Mostafa", studentId: "STU1045", marks: 48),
  StudentMark(name: "Kareem Nabil", studentId: "STU1122", marks: 56),
  StudentMark(name: "Fatima Noor", studentId: "STU1087", marks: 91),
];

class StudentMark {
  String name;
  String studentId;
  int marks;

  StudentMark({required this.name, required this.studentId, required this.marks});
}

class MarksPage extends StatefulWidget {
  final String? examName;
  final String? subject;
  final String? classGrade;
  final int? totalMarks;

  const MarksPage({
    Key? key,
    this.examName,
    this.subject,
    this.classGrade,
    this.totalMarks,
  }) : super(key: key);

  @override
  State<MarksPage> createState() => _MarksPageState();
}

class _MarksPageState extends State<MarksPage> {
  List<StudentMark> studentMarks = []; // Ensure this is initialized (not late)

  // Provide safe fallback values for all possibly-null fields
  String get _examName => widget.examName ?? "Mid Term Examination";
  String get _subject => widget.subject ?? "Mathematics";
  String get _classGrade => widget.classGrade ?? "Grade 8";
  int get _totalMarks => widget.totalMarks ?? 100;

  @override
  void initState() {
    super.initState();
    studentMarks = dummyStudentMarks
        .map((s) => StudentMark(
              name: s.name,
              studentId: s.studentId,
              marks: s.marks,
            ))
        .toList();
  }

  void _saveMarks() {
    // Dummy save logic (could be replaced by real backend)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Marks saved successfully!'),
        backgroundColor: kOrange,
        duration: Duration(seconds: 1),
      ),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgLight,
      appBar: AppBar(
        backgroundColor: kDarkBlue,
        elevation: 2,
        title: const Text(
          "Student Marks",
          style: TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.of(context).maybePop(),
          tooltip: "Back",
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save_alt_rounded, color: kOrange, size: 26),
            tooltip: "Save",
            onPressed: _saveMarks,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Exam Summary Card (visually engaging)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 14),
              child: Card(
                color: Colors.white,
                elevation: 6,
                shadowColor: kDarkBlue.withOpacity(0.12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 21),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _ExamInfoRow(
                        icon: Icons.assignment_turned_in_rounded,
                        label: _examName,
                        iconColor: kOrange,
                        fontWeight: FontWeight.w700,
                        fontSize: 19,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Flexible(
                            child: _ExamInfoRow(
                              icon: Icons.menu_book_rounded,
                              label: _subject,
                              iconColor: kDarkBlue,
                              fontWeight: FontWeight.w500,
                              fontSize: 15.5,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Flexible(
                            child: _ExamInfoRow(
                              icon: Icons.class_rounded,
                              label: _classGrade,
                              iconColor: kDarkBlue,
                              fontWeight: FontWeight.w500,
                              fontSize: 15.5,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Flexible(
                            child: _ExamInfoRow(
                              icon: Icons.grade_rounded,
                              label: "${_totalMarks} marks",
                              iconColor: kDarkBlue,
                              fontWeight: FontWeight.w500,
                              fontSize: 15.5,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Marks list title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 2),
              child: Row(
                children: [
                  Text(
                    "Enter or Update Student Marks:",
                    style: TextStyle(
                      color: kDarkBlue,
                      fontWeight: FontWeight.w700,
                      fontSize: 16.4,
                      letterSpacing: 0.1,
                      shadows: [
                        Shadow(
                          blurRadius: 2,
                          color: Colors.black12,
                          offset: Offset(1, 1),
                        )
                      ]
                    ),
                  ),
                ],
              ),
            ),
            // Student Marks List with beautiful UI
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(14, 6, 14, 12),
                itemCount: studentMarks.length,
                itemBuilder: (context, idx) {
                  final student = studentMarks[idx];
                  return StudentMarkRow(
                    student: student,
                    totalMarks: _totalMarks,
                    onChanged: (newValue) {
                      setState(() {
                        student.marks = newValue;
                      });
                    },
                  );
                },
                separatorBuilder: (_, __) => const SizedBox(height: 12),
              ),
            ),
          ],
        ),
      ),
      // Save button at bottom (inside SafeArea)
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.save_rounded, color: Colors.white, size: 22),
            label: const Text(
              "Save Marks",
              style: TextStyle(fontSize: 17.5, color: Colors.white, fontWeight: FontWeight.w700),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: kOrange,
              foregroundColor: Colors.white,
              minimumSize: const Size(0, 50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              elevation: 4,
              shadowColor: kDarkBlue.withOpacity(0.18)
            ),
            onPressed: _saveMarks,
          ),
        ),
      ),
    );
  }
}

//----------------- REUSABLE WIDGETS ------------------------

// Exam info row for details card
class _ExamInfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color iconColor;
  final FontWeight fontWeight;
  final double fontSize;
  const _ExamInfoRow({
    required this.icon,
    required this.label,
    required this.iconColor,
    this.fontWeight = FontWeight.w500,
    this.fontSize = 14.8,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 22),
        const SizedBox(width: 9),
        Flexible(
          child: Text(
            label,
            style: TextStyle(
              color: kDarkBlue,
              fontWeight: fontWeight,
              fontSize: fontSize,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }
}

/// Row widget for a single student's marks entry
class StudentMarkRow extends StatefulWidget {
  final StudentMark student;
  final int totalMarks;
  final ValueChanged<int> onChanged;
  const StudentMarkRow({
    required this.student,
    required this.totalMarks,
    required this.onChanged,
    Key? key,
  }) : super(key: key);

  @override
  State<StudentMarkRow> createState() => _StudentMarkRowState();
}

class _StudentMarkRowState extends State<StudentMarkRow> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool hasError = false;
  
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.student.marks.toString());
    _focusNode = FocusNode();
  }

  @override
  void didUpdateWidget(covariant StudentMarkRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.student.marks.toString() != _controller.text) {
      _controller.text = widget.student.marks.toString();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  bool get isPass => widget.student.marks >= (widget.totalMarks * 0.5).ceil();

  void _onChanged(String value) {
    int? val = int.tryParse(value);
    if (val == null) {
      setState(() {
        hasError = true;
      });
      return;
    }
    if (val < 0) {
      setState(() {
        hasError = true;
      });
      widget.onChanged(0); // Optionally clamp to zero
      _controller.text = "0";
      _controller.selection = TextSelection.collapsed(offset: _controller.text.length);
      return;
    }
    if (val > widget.totalMarks) {
      setState(() {
        hasError = true;
      });
      widget.onChanged(widget.totalMarks);
      _controller.text = widget.totalMarks.toString();
      _controller.selection = TextSelection.collapsed(offset: _controller.text.length);
      return;
    }
    setState(() {
      hasError = false;
    });
    widget.onChanged(val);
  }

  @override
  Widget build(BuildContext context) {
    final student = widget.student;
    final totalMarks = widget.totalMarks;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8FA),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: kDarkBlue.withOpacity(0.045),
            blurRadius: 6,
            offset: const Offset(0,1.5),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Student info column (name + ID)
          Expanded(
            flex: 6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  student.name,
                  style: const TextStyle(
                    color: kDarkBlue,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    overflow: TextOverflow.ellipsis,
                  ),
                  maxLines: 1,
                ),
                const SizedBox(height: 2),
                Text(
                  "#${student.studentId}",
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 12.2,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          // MARKS TEXT FIELD
          Expanded(
            flex: 4,
            child: Row(
              children: [
                Container(
                  width: 64,
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: kDarkBlue,
                      fontWeight: FontWeight.bold,
                      fontSize: 15.8,
                    ),
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                      hintText: "0",
                      suffixText: "/$totalMarks",
                      suffixStyle: const TextStyle(color: Colors.grey, fontSize: 13),
                      fillColor: Colors.white,
                      filled: true,
                      errorText: hasError ? "Invalid" : null,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.transparent, width: 1.1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: kOrange, width: 2),
                      ),
                    ),
                    onChanged: (val) {
                      // Only allow numbers within limit
                      if (val.isNotEmpty) {
                        int? v = int.tryParse(val);
                        if (v != null && v > totalMarks) {
                          _controller.text = totalMarks.toString();
                          _controller.selection = TextSelection(
                            baseOffset: _controller.text.length,
                            extentOffset: _controller.text.length,
                          );
                          _onChanged(_controller.text);
                          return;
                        }
                      }
                      _onChanged(val);
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          // STATUS: Pass/Fail
          Expanded(
            flex: 3,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              decoration: BoxDecoration(
                color: isPass ? kOrange.withOpacity(0.14) : Colors.red.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: Text(
                isPass ? "Pass" : "Fail",
                style: TextStyle(
                  color: isPass ? kOrange : Colors.red[600],
                  fontWeight: FontWeight.bold,
                  fontSize: 13.5,
                  letterSpacing: 0.2,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

