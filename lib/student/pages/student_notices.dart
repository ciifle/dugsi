import 'package:flutter/material.dart';

// BRAND COLORS
const Color kDarkBlue = Color(0xFF023471);
const Color kOrange = Color(0xFF5AB04B);
const Color kBackground = Color(0xFFF6F7FB);

class StudentNoticesScreen extends StatefulWidget {
  const StudentNoticesScreen({Key? key}) : super(key: key);

  @override
  State<StudentNoticesScreen> createState() => _StudentNoticesScreenState();
}

// Dummy Notice Data
class Notice {
  final String title;
  final String description;
  final DateTime date;
  final String category;

  Notice({
    required this.title,
    required this.description,
    required this.date,
    required this.category,
  });
}

final List<Notice> kDummyNotices = [
  Notice(
    title: "School Closed: National Holiday",
    description:
        "The school will remain closed on Monday, 24th June due to a national holiday. All scheduled classes and activities are cancelled. Please make sure to complete any pending assignments and enjoy your break!",
    date: DateTime(2024, 6, 20),
    category: "Important",
  ),
  Notice(
    title: "Midterm Exam Schedule Released",
    description:
        "The Midterm Examination schedule has been uploaded to the Student Portal. Check exam dates, timings, and instructions. Carry your ID card for all exams.",
    date: DateTime(2024, 6, 18),
    category: "Exam",
  ),
  Notice(
    title: "Inter-house Debate Competition",
    description:
        "Students interested in the Inter-house Debate Competition are required to register by Friday. Preliminary rounds start next week. For details, contact Ms. Carter.",
    date: DateTime(2024, 6, 16),
    category: "General",
  ),
  Notice(
    title: "Science Fair Projects Submission",
    description:
        "All science fair project reports must be submitted by 29th June. Late submissions will not be accepted. Please ensure your name and class are clearly mentioned.",
    date: DateTime(2024, 6, 14),
    category: "Important",
  ),
  Notice(
    title: "Workshop: Exam Stress Management",
    description:
        "Join the wellness workshop on stress management for exams. Open to grades 9-12. Venue: AV Hall, Date: 21st June, Time: 2pm - 4pm.",
    date: DateTime(2024, 6, 13),
    category: "General",
  ),
  Notice(
    title: "Mathematics Final Exam Venue Change",
    description:
        "The venue for the Mathematics final exam has changed from Room B102 to the Main Auditorium due to ongoing renovations. Please check your seat number before the exam.",
    date: DateTime(2024, 6, 11),
    category: "Exam",
  ),
];

// Valid categories
const List<String> kNoticeCategories = [
  "All",
  "Important",
  "Exam",
  "General",
];

class _StudentNoticesScreenState extends State<StudentNoticesScreen> {
  String _selectedCategory = "All";

  List<Notice> get _filteredNotices {
    if (_selectedCategory == "All") return kDummyNotices;
    return kDummyNotices
        .where((n) => n.category == _selectedCategory)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        backgroundColor: kDarkBlue,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Notices",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            overflow: TextOverflow.ellipsis,
            fontSize: 22,
          ),
          maxLines: 1,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // SECTION 1: NOTICE FILTER (WRAP CHIPS)
              Text(
                "Filter by Category",
                style: TextStyle(
                  color: kDarkBlue,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  overflow: TextOverflow.ellipsis,
                ),
                maxLines: 1,
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                children: kNoticeCategories.map((cat) {
                  final bool isSelected = (_selectedCategory == cat);
                  return ChoiceChip(
                    label: Text(
                      cat,
                      style: TextStyle(
                        color: isSelected ? Colors.white : kDarkBlue,
                        fontWeight: FontWeight.w600,
                        letterSpacing: .2,
                        fontSize: 14,
                        overflow: TextOverflow.ellipsis,
                      ),
                      maxLines: 1,
                    ),
                    selected: isSelected,
                    onSelected: (_) {
                      setState(() => _selectedCategory = cat);
                    },
                    selectedColor: kOrange,
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: isSelected ? kOrange : kDarkBlue.withOpacity(0.12),
                        width: 1.4,
                      ),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    elevation: isSelected ? 3 : 0,
                  );
                }).toList(),
              ),

              const SizedBox(height: 24),

              // SECTION 2 + 3: NOTICE LIST AS CARDS + EXPANSIONTILE DETAILS
              Column(
                children: _filteredNotices.map((notice) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 18.0),
                    child: _NoticeCard(notice: notice),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NoticeCard extends StatelessWidget {
  final Notice notice;
  const _NoticeCard({required this.notice});

  Color get _badgeColor {
    switch (notice.category) {
      case "Important":
        return kOrange;
      case "Exam":
        return kDarkBlue;
      case "General":
      default:
        return Colors.grey.shade600;
    }
  }

  @override
  Widget build(BuildContext context) {
    final String readableDate =
        "${notice.date.day}/${notice.date.month}/${notice.date.year}";
    return Card(
      color: Colors.white,
      surfaceTintColor: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: Colors.grey.withOpacity(0.10), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title + Category Badge + Date
            Wrap(
              spacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                // Title
                SizedBox(
                  width: MediaQuery.of(context).size.width - 110,
                  child: Text(
                    notice.title,
                    style: TextStyle(
                      color: kDarkBlue,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      overflow: TextOverflow.ellipsis,
                    ),
                    maxLines: 1,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                  decoration: BoxDecoration(
                    color: _badgeColor.withOpacity(0.09),
                    border: Border.all(color: _badgeColor, width: 1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    notice.category,
                    style: TextStyle(
                      color: _badgeColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      overflow: TextOverflow.ellipsis,
                    ),
                    maxLines: 1,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.calendar_today, size: 15, color: Colors.grey),
                    const SizedBox(width: 3),
                    Text(
                      readableDate,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        overflow: TextOverflow.ellipsis,
                      ),
                      maxLines: 1,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Short preview (first 65 chars or first sentence)
            Text(
              _shortPreview(notice.description),
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                overflow: TextOverflow.ellipsis,
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 4),
            // Section 3: Details (ExpansionTile)
            _NoticeExpansion(
              description: notice.description,
            ),
          ],
        ),
      ),
    );
  }

  String _shortPreview(String desc) {
    // Use first sentence (till first dot), or 65 chars
    if (desc.contains('.')) {
      String firstSentence = desc.split('.').first.trim();
      if (firstSentence.isNotEmpty &&
          firstSentence.length <= 65 &&
          firstSentence.length > 12) {
        return firstSentence + ".";
      }
    }
    return desc.length > 65
        ? desc.substring(0, 63).trimRight() + "…"
        : desc;
  }
}

class _NoticeExpansion extends StatelessWidget {
  final String description;
  const _NoticeExpansion({required this.description});

  @override
  Widget build(BuildContext context) {
    // Only show expansion if description is long
    final bool isLong = description.length > 90;
    if (!isLong) {
      // Don't show ExpansionTile for very short text
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.only(top: 2),
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        title: Row(
          children: [
            Icon(Icons.attachment, color: kDarkBlue.withOpacity(.72), size: 21),
            const SizedBox(width: 6),
            const Text(
              "Full Details",
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF312F4A),
                  fontSize: 14,
                  overflow: TextOverflow.ellipsis),
              maxLines: 1,
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 2, right: 2, bottom: 10, top: 0),
            child: Text(
              description,
              style: const TextStyle(
                color: Color(0xFF292929),
                fontSize: 14.8,
                height: 1.5,
                fontWeight: FontWeight.w400,
                overflow: TextOverflow.ellipsis,
              ),
              maxLines: 10,
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }
}
