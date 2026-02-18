import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Color constants
const Color kPrimaryColor = Color(0xFF023471); // Dark Blue
const Color kAccentColor = Color(0xFF5AB04B); // Orange
const Color kBgColor = Color(0xFFF9F9F9); // Light neutral

// Attendance status enum and model
enum AttendanceStatus { present, absent, holiday }

class AttendanceRecord {
  final DateTime date;
  final AttendanceStatus status;
  final String? remarks;

  AttendanceRecord({required this.date, required this.status, this.remarks});
}

class StudentAttendanceScreen extends StatefulWidget {
  const StudentAttendanceScreen({Key? key}) : super(key: key);

  @override
  State<StudentAttendanceScreen> createState() => _StudentAttendanceScreenState();
}

class _StudentAttendanceScreenState extends State<StudentAttendanceScreen> {
  late DateTime _selectedMonth;
  late List<AttendanceRecord> _attendanceRecords;
  late List<DateTime> _availableMonths;

  @override
  void initState() {
    super.initState();
    // Only allow months including and prior to current month (up to 12 months back)
    DateTime now = DateTime.now();

    // Correction: Calculate dates by subtracting months-only logic.
    _availableMonths = [];
    for (int i = 0; i < 13; i++) {
      int year = now.year;
      int month = now.month - i;
      // Adjust year/month if month <= 0
      while (month <= 0) {
        year -= 1;
        month += 12;
      }
      _availableMonths.add(DateTime(year, month, 1));
    }

    // Make sure selectedMonth is always a value in _availableMonths
    _selectedMonth = _availableMonths.first;
    _attendanceRecords = _generateDummyAttendance(_selectedMonth);
  }

  List<AttendanceRecord> _generateDummyAttendance(DateTime month) {
    final List<AttendanceRecord> list = [];
    final daysInMonth = DateUtils.getDaysInMonth(month.year, month.month);
    for (int d = 1; d <= daysInMonth; d++) {
      final date = DateTime(month.year, month.month, d);
      if (date.weekday == DateTime.sunday) {
        list.add(AttendanceRecord(date: date, status: AttendanceStatus.holiday));
      } else if (d % 5 == 0) {
        list.add(
          AttendanceRecord(
            date: date,
            status: AttendanceStatus.absent,
            remarks: d == 10 ? "Medical leave" : null,
          ),
        );
      } else {
        list.add(AttendanceRecord(date: date, status: AttendanceStatus.present));
      }
    }
    return list;
  }

  void _onMonthChanged(DateTime newMonth) {
    setState(() {
      _selectedMonth = DateTime(newMonth.year, newMonth.month, 1);
      _attendanceRecords = _generateDummyAttendance(_selectedMonth);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Compute summary
    final totalDays = _attendanceRecords.where((r) => r.status != AttendanceStatus.holiday).length;
    final presentDays = _attendanceRecords.where((r) => r.status == AttendanceStatus.present).length;
    final absentDays = _attendanceRecords.where((r) => r.status == AttendanceStatus.absent).length;
    final attendancePct = totalDays == 0 ? 0 : ((presentDays / totalDays) * 100).round();

    int selectedIdx = _availableMonths.indexWhere(
      (dt) => dt.year == _selectedMonth.year && dt.month == _selectedMonth.month);

    return Scaffold(
      backgroundColor: kBgColor,
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: const Text(
          'Attendance',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            overflow: TextOverflow.ellipsis,
          ),
          maxLines: 1,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 2,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: kAccentColor, width: 1.2),
                ),
                elevation: 1,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildSummaryItem('Total\nDays', '$totalDays'),
                      _buildSummaryItem('Present', '$presentDays'),
                      _buildSummaryItem('Absent', '$absentDays'),
                      _buildSummaryItem('Percent', '$attendancePct%'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // ---- MONTH SELECTOR ----
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: kPrimaryColor, size: 22),
                    onPressed: (selectedIdx < _availableMonths.length - 1)
                        ? () {
                            final prev = _availableMonths[selectedIdx + 1];
                            _onMonthChanged(prev);
                          }
                        : null,
                  ),
                  Expanded(
                    child: Center(
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<DateTime>(
                          value: _availableMonths.any((dt) =>
                                dt.year == _selectedMonth.year && dt.month == _selectedMonth.month)
                              ? _availableMonths.firstWhere((dt) =>
                                  dt.year == _selectedMonth.year && dt.month == _selectedMonth.month)
                              : _availableMonths.first,
                          menuMaxHeight: 260,
                          isDense: true,
                          style: const TextStyle(
                            color: kPrimaryColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 17,
                            overflow: TextOverflow.ellipsis,
                          ),
                          items: _availableMonths.map((date) {
                            return DropdownMenuItem<DateTime>(
                              value: date,
                              child: Text(
                                DateFormat('MMMM yyyy').format(date),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: kPrimaryColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 17,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) _onMonthChanged(val);
                          },
                          icon: const Icon(Icons.arrow_drop_down, color: kPrimaryColor),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward_ios, color: kPrimaryColor, size: 22),
                    onPressed: (selectedIdx > 0)
                        ? () {
                            final next = _availableMonths[selectedIdx - 1];
                            _onMonthChanged(next);
                          }
                        : null,
                  ),
                ],
              ),

              const SizedBox(height: 18),

              // ---- ATTENDANCE CALENDAR GRID ----
              _AttendanceCalendarGrid(
                records: _attendanceRecords,
                month: _selectedMonth,
              ),

              const SizedBox(height: 20),

              // ---- DAILY STATUS LEGEND ----
              _AttendanceLegend(),

              const SizedBox(height: 22),

              // ---- DETAILED RECORDS ----
              const Text(
                'Detailed Record',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: kPrimaryColor,
                  fontSize: 17,
                  overflow: TextOverflow.ellipsis,
                ),
                maxLines: 1,
              ),
              const SizedBox(height: 8),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _attendanceRecords.length,
                itemBuilder: (context, idx) {
                  final record = _attendanceRecords[idx];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 6.0),
                    child: ExpansionTile(
                      tilePadding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      collapsedShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: Colors.white,
                      collapsedBackgroundColor: Colors.white,
                      title: Row(
                        children: [
                          Text(
                            DateFormat('dd MMM yyyy').format(record.date),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                color: kPrimaryColor,
                                fontSize: 15),
                          ),
                          const SizedBox(width: 8),
                          _statusChip(record.status),
                        ],
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildDetailRow('Status', _statusText(record.status)),
                              if (record.remarks != null)
                                _buildDetailRow('Remarks', record.remarks!),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Attendance summary helper
Widget _buildSummaryItem(String label, String value) {
  return Column(
    children: [
      Text(
        value,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          color: kAccentColor,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      const SizedBox(height: 3),
      Text(
        label,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: kPrimaryColor,
          fontWeight: FontWeight.w500,
          fontSize: 12.5,
        ),
      ),
    ],
  );
}

/// Calendar grid (SEPARATED for clarity)
class _AttendanceCalendarGrid extends StatelessWidget {
  final List<AttendanceRecord> records;
  final DateTime month;

  const _AttendanceCalendarGrid({
    Key? key,
    required this.records,
    required this.month,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firstDayOfMonth = DateTime(month.year, month.month, 1);
    final daysInMonth = DateUtils.getDaysInMonth(month.year, month.month);

    final startWeekday = firstDayOfMonth.weekday % 7; // Sun=0, Mon=1,...
    final totalCells = daysInMonth + startWeekday;
    final rows = (totalCells / 7).ceil();

    return Card(
      color: Colors.white,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 8.0),
        child: Column(
          children: [
            // Days of the week header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(7, (i) {
                final labels = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
                return Expanded(
                  child: Center(
                    child: Text(
                      labels[i],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: kPrimaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 8),
            // Calendar grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                mainAxisSpacing: 3,
                crossAxisSpacing: 3,
                childAspectRatio: 1,
              ),
              itemCount: rows * 7,
              itemBuilder: (context, idx) {
                final dayNum = idx - startWeekday + 1;
                if (dayNum < 1 || dayNum > daysInMonth) {
                  return const SizedBox();
                }
                final AttendanceRecord record = records[dayNum - 1];
                return AspectRatio(
                  aspectRatio: 1,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(7),
                    onTap: null,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(7),
                        border: Border.all(
                          color: record.status == AttendanceStatus.absent
                              ? kAccentColor
                              : Colors.transparent,
                          width: 1,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            dayNum.toString(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: record.status == AttendanceStatus.present
                                  ? kPrimaryColor
                                  : record.status == AttendanceStatus.absent
                                      ? kAccentColor
                                      : Colors.grey.shade400,
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 3),
                          _statusDot(record.status),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusDot(AttendanceStatus status) {
    switch (status) {
      case AttendanceStatus.present:
        return Container(
          width: 12, height: 12,
          decoration: const BoxDecoration(
            color: kAccentColor,
            shape: BoxShape.circle,
          ),
        );
      case AttendanceStatus.absent:
        return Container(
          width: 12, height: 12,
          decoration: BoxDecoration(
            border: Border.all(color: kAccentColor, width: 2),
            shape: BoxShape.circle,
            color: Colors.transparent,
          ),
          child: const Icon(Icons.close, color: kAccentColor, size: 10),
        );
      case AttendanceStatus.holiday:
      default:
        return Container(
          width: 11, height: 11,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey.shade300, width: 1.2),
          ),
        );
    }
  }
}

// Attendance status chip for ExpansionTile
Widget _statusChip(AttendanceStatus status) {
  switch (status) {
    case AttendanceStatus.present:
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 1),
        decoration: BoxDecoration(
          color: kAccentColor,
          borderRadius: BorderRadius.circular(7),
        ),
        child: const Text(
          'Present',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    case AttendanceStatus.absent:
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 1),
        decoration: BoxDecoration(
          border: Border.all(color: kAccentColor, width: 1),
          borderRadius: BorderRadius.circular(7),
        ),
        child: const Text(
          'Absent',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 12,
            color: kAccentColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    case AttendanceStatus.holiday:
    default:
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 1),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(7),
        ),
        child: Text(
          'Holiday',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
  }
}

String _statusText(AttendanceStatus status) {
  switch (status) {
    case AttendanceStatus.present:
      return "Present";
    case AttendanceStatus.absent:
      return "Absent";
    case AttendanceStatus.holiday:
      return "Holiday";
  }
}

Widget _buildDetailRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 1.5),
    child: Row(
      children: [
        Text(
          "$label: ",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: kPrimaryColor,
            fontSize: 14,
          ),
        ),
        Expanded(
          child: Text(
            value,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: kPrimaryColor,
              fontSize: 14,
            ),
          ),
        ),
      ],
    ),
  );
}

// Daily status legend
class _AttendanceLegend extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.start,
      spacing: 17,
      runSpacing: 5,
      children: [
        _legendItem(
          Colors.white,
          kAccentColor,
          solid: true,
          label: 'Present',
        ),
        _legendItem(
          Colors.white,
          kAccentColor,
          solid: false,
          label: 'Absent',
        ),
        _legendItem(
          Colors.grey.shade200,
          Colors.grey.shade300,
          solid: true,
          label: 'Holiday',
        ),
      ],
    );
  }

  Widget _legendItem(Color color, Color borderColor, {required bool solid, required String label}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 14, height: 14,
          margin: const EdgeInsets.only(right: 6),
          decoration: BoxDecoration(
            color: solid ? borderColor : color,
            shape: BoxShape.circle,
            border: solid
                ? null
                : Border.all(color: borderColor, width: 2.2),
          ),
          child: !solid && label == 'Absent'
              ? const Icon(Icons.close, color: kAccentColor, size: 11)
              : null,
        ),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            color: kPrimaryColor,
            fontSize: 13.5,
          ),
        ),
      ],
    );
  }
}
