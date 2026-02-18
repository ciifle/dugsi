import 'package:flutter/material.dart';

class TeacherWeeklyScheduleScreen extends StatefulWidget {
  const TeacherWeeklyScheduleScreen({Key? key}) : super(key: key);

  @override
  State<TeacherWeeklyScheduleScreen> createState() => _TeacherWeeklyScheduleScreenState();
}

class _TeacherWeeklyScheduleScreenState extends State<TeacherWeeklyScheduleScreen> {
  // Brand colors
  static const Color kPrimary = Color(0xFF023471);
  static const Color kAccent = Color(0xFF5AB04B);
  static const Color kBackground = Color(0xFFF9FAFB);
  static const Color kTextDark = Color(0xFF023471);

  final List<String> daysOfWeek = [
    'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun',
  ];

  int selectedDayIndex = DateTime.now().weekday % 7; // Monday=0, Sunday=6

  // Dummy schedule data
  final Map<String, List<Map<String, String>>> weeklySchedule = {
    'Mon': [
      {
        "class": "Grade 10-A",
        "subject": "Mathematics",
        "time": "08:00 - 09:30",
        "room": "101",
      },
      {
        "class": "Grade 11-B",
        "subject": "Algebra II",
        "time": "10:00 - 11:30",
        "room": "210",
      },
    ],
    'Tue': [
      {
        "class": "Grade 12-C",
        "subject": "Calculus",
        "time": "09:00 - 10:30",
        "room": "305",
      },
    ],
    'Wed': [
      {
        "class": "Grade 9-A",
        "subject": "Geometry",
        "time": "08:00 - 09:30",
        "room": "114",
      },
      {
        "class": "Grade 10-A",
        "subject": "Trigonometry",
        "time": "11:00 - 12:30",
        "room": "102",
      },
    ],
    'Thu': [
      {
        "class": "Grade 11-B",
        "subject": "Pre-Calculus",
        "time": "10:00 - 11:30",
        "room": "209",
      },
    ],
    'Fri': [
      {
        "class": "Grade 9-A",
        "subject": "Statistics",
        "time": "09:00 - 10:30",
        "room": "115",
      },
      {
        "class": "Grade 12-C",
        "subject": "Advanced Calculus",
        "time": "12:00 - 13:30",
        "room": "304",
      },
    ],
    'Sat': [],
    'Sun': [],
  };

  @override
  Widget build(BuildContext context) {
    final selectedDay = daysOfWeek[selectedDayIndex];
    final daySchedule = weeklySchedule[selectedDay] ?? [];

    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        title: const Text(
          'Weekly Schedule',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            overflow: TextOverflow.ellipsis,
            fontFamily: null,
          ),
          maxLines: 1,
        ),
        backgroundColor: kPrimary,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 2.0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Day selector chips
                Text(
                  "Select Day",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: kTextDark,
                    overflow: TextOverflow.ellipsis,
                  ),
                  maxLines: 1,
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    for (int i = 0; i < daysOfWeek.length; i++)
                      ChoiceChip(
                        label: Text(
                          daysOfWeek[i],
                          style: TextStyle(
                            color: selectedDayIndex == i ? Colors.white : kTextDark,
                            fontWeight: FontWeight.w500,
                            overflow: TextOverflow.ellipsis,
                          ),
                          maxLines: 1,
                        ),
                        selected: selectedDayIndex == i,
                        selectedColor: kAccent,
                        backgroundColor: Colors.white,
                        onSelected: (v) {
                          setState(() {
                            selectedDayIndex = i;
                          });
                        },
                        elevation: selectedDayIndex == i ? 2.0 : 0.0,
                        pressElevation: 0.0,
                      ),
                  ],
                ),
                const SizedBox(height: 28),
                Text(
                  "${daysOfWeek[selectedDayIndex]} Schedule",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: kTextDark,
                    overflow: TextOverflow.ellipsis,
                  ),
                  maxLines: 1,
                ),
                const SizedBox(height: 12),
                if (daySchedule.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    alignment: Alignment.center,
                    child: Text(
                      "No classes scheduled.",
                      style: TextStyle(
                        color: kTextDark.withOpacity(0.4),
                        fontSize: 15,
                        fontStyle: FontStyle.italic,
                        overflow: TextOverflow.ellipsis,
                      ),
                      maxLines: 1,
                    ),
                  ),
                if (daySchedule.isNotEmpty)
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: daySchedule.length,
                    itemBuilder: (context, idx) {
                      final c = daySchedule[idx];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: _ClassCard(
                          className: c["class"] ?? "",
                          subject: c["subject"] ?? "",
                          time: c["time"] ?? "",
                          room: c["room"] ?? "",
                          kPrimary: kPrimary,
                          kAccent: kAccent,
                          kTextDark: kTextDark,
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ClassCard extends StatelessWidget {
  final String className;
  final String subject;
  final String time;
  final String room;
  final Color kPrimary;
  final Color kAccent;
  final Color kTextDark;

  const _ClassCard({
    Key? key,
    required this.className,
    required this.subject,
    required this.time,
    required this.room,
    required this.kPrimary,
    required this.kAccent,
    required this.kTextDark,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // No fixed height/width, clean academic card with brand colors
    return Material(
      elevation: 1,
      borderRadius: BorderRadius.circular(12),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              className,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: kPrimary,
                overflow: TextOverflow.ellipsis,
              ),
              maxLines: 1,
            ),
            const SizedBox(height: 6),
            Text(
              subject,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: kAccent,
                overflow: TextOverflow.ellipsis,
              ),
              maxLines: 1,
            ),
            const SizedBox(height: 10),
            Wrap(
              alignment: WrapAlignment.start,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 24,
              runSpacing: 8,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.schedule, color: kPrimary, size: 18),
                    const SizedBox(width: 6),
                    Text(
                      time,
                      style: TextStyle(
                        color: kTextDark,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        overflow: TextOverflow.ellipsis,
                      ),
                      maxLines: 1,
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.location_on, color: kAccent, size: 18),
                    const SizedBox(width: 6),
                    Text(
                      "Room $room",
                      style: TextStyle(
                        color: kTextDark,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        overflow: TextOverflow.ellipsis,
                      ),
                      maxLines: 1,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
