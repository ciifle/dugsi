import 'package:flutter/material.dart';

// The main NoticesPage widget
class NoticesPage extends StatelessWidget {
  NoticesPage({Key? key}) : super(key: key);

  // Dummy notices data
  final List<Map<String, dynamic>> notices = [
    {
      'title': 'School Closed on Friday',
      'content':
          'Due to weather conditions, the school will remain closed this Friday. Please inform your respective departments.',
      'audience': 'All',
      'date': '2024-06-15',
    },
    {
      'title': 'Staff Meeting',
      'content':
          'A mandatory staff meeting will be held in the auditorium at 2pm. Attendance is required for all staff members.',
      'audience': 'Teachers',
      'date': '2024-06-12',
    },
    {
      'title': 'Sports Day Registrations',
      'content':
          'Students can register for Sports Day events at the admin office. Registrations close on June 18th.',
      'audience': 'Students',
      'date': '2024-06-10',
    },
    {
      'title': 'Bus Route Change',
      'content':
          'Bus routes 4 and 5 are changed starting next week. Kindly check the updated schedule on the school portal.',
      'audience': 'All',
      'date': '2024-06-11',
    },
  ];

  // Color constants (STRICT as per design)
  static const Color darkBlue = Color(0xFF023471);
  static const Color orange = Color(0xFF5AB04B);
  static const Color bg = Color(0xFFF8F9FB);

  // Dummy function for notice tap (for future details page)
  void _onNoticeTap(BuildContext context, Map<String, dynamic> notice) {
    // Future: Navigate to detail page
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Notice tapped: ${notice['title']}')),
    );
  }

  // Dummy function for long press (Edit/Delete)
  void _onNoticeLongPress(BuildContext context, Map<String, dynamic> notice) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.edit, color: orange),
              title: Text('Edit', style: TextStyle(color: darkBlue)),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Edit: ${notice['title']}')),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.delete, color: orange),
              title: Text('Delete', style: TextStyle(color: darkBlue)),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Delete: ${notice['title']}')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // Add Notice action (dummy)
  void _onAddNotice(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Add Notice Clicked')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: darkBlue,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white), // White back arrow
        title: const Text(
          'Notices',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: orange),
            tooltip: "Add Notice",
            onPressed: () => _onAddNotice(context),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // PAGE HEADER
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: Text(
                "Create and manage school announcements",
                style: const TextStyle(
                  fontSize: 16,
                  color: darkBlue,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 4),
            // NOTICES LIST
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                itemCount: notices.length,
                itemBuilder: (context, index) {
                  final notice = notices[index];
                  return NoticeItem(
                    title: notice['title'],
                    content: notice['content'],
                    audience: notice['audience'],
                    date: notice['date'],
                    onTap: () => _onNoticeTap(context, notice),
                    onLongPress: () =>
                        _onNoticeLongPress(context, notice),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

///
/// Reusable NoticeItem Widget
///
class NoticeItem extends StatelessWidget {
  static const Color darkBlue = Color(0xFF023471);
  static const Color orange = Color(0xFF5AB04B);

  final String title;
  final String content;
  final String audience;
  final String date;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const NoticeItem({
    Key? key,
    required this.title,
    required this.content,
    required this.audience,
    required this.date,
    this.onTap,
    this.onLongPress,
  }) : super(key: key);

  Color getAudienceColor() {
    switch (audience) {
      case 'Teachers':
        return orange.withOpacity(0.85);
      case 'Students':
        return orange.withOpacity(0.65);
      default:
        // All
        return orange.withOpacity(0.35);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Spacing between notices
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        onLongPress: onLongPress,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: darkBlue.withOpacity(0.10),
              width: 1.1,
            ),
            boxShadow: [
              BoxShadow(
                color: darkBlue.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // LEFT: ORANGE NOTICE ICON
              Padding(
                padding: const EdgeInsets.only(top: 2, right: 14),
                child: Icon(
                  Icons.campaign_outlined,
                  color: orange,
                  size: 30,
                ),
              ),
              // CENTER: TEXTS
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // TITLE
                    Text(
                      title,
                      style: const TextStyle(
                        color: darkBlue,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        height: 1.22,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    // SHORT CONTENT PREVIEW
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0, bottom: 6),
                      child: Text(
                        content,
                        style: TextStyle(
                          color: darkBlue.withOpacity(0.80),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          height: 1.30,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // AUDIENCE
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 2.5, horizontal: 9),
                      decoration: BoxDecoration(
                        color: getAudienceColor(),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        audience,
                        style: const TextStyle(
                          color: darkBlue,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // RIGHT: DATE & ACTION
              Padding(
                padding: const EdgeInsets.only(left: 10, top: 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // DATE
                    Text(
                      _formatDate(date),
                      style: TextStyle(
                        color: darkBlue.withOpacity(0.55),
                        fontSize: 11.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 18),
                    // ORANGE CHEVRON
                    Icon(Icons.chevron_right, color: orange, size: 26),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  /// Utility: Formats YYYY-MM-DD → e.g. Jun 10
  static String _formatDate(String dateString) {
    try {
      final dt = DateTime.parse(dateString);
      final months = [
        "",
        "Jan",
        "Feb",
        "Mar",
        "Apr",
        "May",
        "Jun",
        "Jul",
        "Aug",
        "Sep",
        "Oct",
        "Nov",
        "Dec"
      ];
      return "${months[dt.month]} ${dt.day}";
    } catch (_) {
      return dateString;
    }
  }
}
