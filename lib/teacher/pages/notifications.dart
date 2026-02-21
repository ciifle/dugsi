import 'package:flutter/material.dart';

// =============================
// COLOR CONSTANTS
// =============================
const Color kPrimaryColor = Color(0xFF023471);
const Color kAccentColor = Color(0xFF5AB04B);
const Color kBackgroundColor = Color(0xFFF4F6F8);
const Color kTextColor = Color(0xFF023471);
const double kCardRadius = 24.0;

enum NotificationType { system, classes, exams }

class TeacherNotificationsScreen extends StatefulWidget {
  @override
  State<TeacherNotificationsScreen> createState() => _TeacherNotificationsScreenState();
}

class _TeacherNotificationsScreenState extends State<TeacherNotificationsScreen> {
  // =============================
  // Dummy notification data
  // =============================
  final List<NotificationItem> _notifications = [
    NotificationItem(
      title: "System Update",
      message: "The school portal will undergo maintenance on Friday night.",
      dateTime: DateTime.now().subtract(Duration(hours: 2)),
      type: NotificationType.system,
      read: false,
    ),
    NotificationItem(
      title: "Class 9A Exam Scheduled",
      message: "Maths exam rescheduled to 20th June at 10:00 AM.",
      dateTime: DateTime.now().subtract(Duration(days: 1)),
      type: NotificationType.exams,
      read: true,
    ),
    NotificationItem(
      title: "New Message from Admin",
      message: "Please submit the grade sheets by tomorrow.",
      dateTime: DateTime.now().subtract(Duration(hours: 8)),
      type: NotificationType.system,
      read: false,
    ),
    NotificationItem(
      title: "Class Attendance",
      message: "Attendance for class 10B submitted successfully.",
      dateTime: DateTime.now().subtract(Duration(days: 2)),
      type: NotificationType.classes,
      read: true,
    ),
    NotificationItem(
      title: "Exam Reminder",
      message: "Physics practical exam for 11C tomorrow.",
      dateTime: DateTime.now().subtract(Duration(hours: 23)),
      type: NotificationType.exams,
      read: false,
    ),
    NotificationItem(
      title: "New Assignment Uploaded",
      message: "Upload the assignment for class 7A by Friday.",
      dateTime: DateTime.now().subtract(Duration(hours: 19)),
      type: NotificationType.classes,
      read: false,
    ),
  ];

  // =============================
  // Filter logic
  // =============================
  String _selectedFilter = 'All';

  List<String> filters = [
    'All', 'Classes', 'Exams', 'System'
  ];

  List<NotificationItem> get _filteredNotifications {
    switch (_selectedFilter) {
      case 'Classes':
        return _notifications.where((n) => n.type == NotificationType.classes).toList();
      case 'Exams':
        return _notifications.where((n) => n.type == NotificationType.exams).toList();
      case 'System':
        return _notifications.where((n) => n.type == NotificationType.system).toList();
      default:
        return _notifications;
    }
  }

  // =============================
  // Main Build
  // =============================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _NotificationsTopBar(onBack: () => Navigator.of(context).maybePop()),
                const SizedBox(height: 20),
                // ============================= FILTER CHIPS =============================
                Text(
                "Filter",
                style: TextStyle(
                  fontSize: 16,
                  color: kTextColor,
                  fontWeight: FontWeight.w600,
                  overflow: TextOverflow.ellipsis,
                ),
                maxLines: 1,
              ),
                const SizedBox(height: 8),
                Wrap(
                spacing: 8,
                runSpacing: 4,
                children: filters
                    .map((filter) => FilterChip(
                          label: Text(
                            filter,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: _selectedFilter == filter ? Colors.white : kTextColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          selected: _selectedFilter == filter,
                          backgroundColor: Colors.white,
                          selectedColor: kAccentColor,
                          side: BorderSide(
                            color: kPrimaryColor,
                            width: _selectedFilter == filter ? 0 : 1,
                          ),
                          onSelected: (_) {
                            setState(() {
                              _selectedFilter = filter;
                            });
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(22),
                          ),
                        ))
                    .toList(),
                ),
                const SizedBox(height: 20),
                Text(
                "Notifications",
                style: TextStyle(
                  fontSize: 18,
                  color: kPrimaryColor,
                  fontWeight: FontWeight.bold,
                  overflow: TextOverflow.ellipsis,
                ),
                maxLines: 1,
                ),
                const SizedBox(height: 12),
                ListView.builder(
                shrinkWrap: true, // MANDATORY for scroll-in-column
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _filteredNotifications.length,
                itemBuilder: (context, index) {
                  final notification = _filteredNotifications[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: NotificationCard(
                      notification: notification,
                      onMarkAsRead: () {
                        setState(() {
                          notification.read = true;
                        });
                      },
                      onDelete: () {
                        setState(() {
                          _notifications.remove(notification);
                        });
                      },
                    ),
                  );
                },
                ),
                if (_filteredNotifications.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 48),
                  child: Center(
                    child: Text(
                      "No notifications found.",
                      style: TextStyle(
                        color: kPrimaryColor.withOpacity(0.7),
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
      ),
    );
  }
}

// ============================= TOP BAR (no color, 3D back) =============================
class _NotificationsTopBar extends StatelessWidget {
  final VoidCallback onBack;

  const _NotificationsTopBar({required this.onBack});

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
                  BoxShadow(color: kPrimaryColor.withOpacity(0.1), blurRadius: 12, offset: const Offset(0, 4)),
                ],
              ),
              child: Icon(Icons.arrow_back_rounded, color: kPrimaryColor, size: 24),
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Text(
              'Notifications',
              style: TextStyle(color: kTextColor, fontWeight: FontWeight.bold, fontSize: 20),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================= Data Model =============================
class NotificationItem {
  final String title;
  final String message;
  final DateTime dateTime;
  final NotificationType type;
  bool read;
  NotificationItem({
    required this.title,
    required this.message,
    required this.dateTime,
    required this.type,
    this.read = false,
  });
}

// =============================
// Notification Card Widget
// =============================
class NotificationCard extends StatelessWidget {
  final NotificationItem notification;
  final VoidCallback onMarkAsRead;
  final VoidCallback onDelete;

  const NotificationCard({
    required this.notification,
    required this.onMarkAsRead,
    required this.onDelete,
    Key? key,
  }) : super(key: key);

  IconData getIcon(NotificationType type) {
    switch (type) {
      case NotificationType.system:
        return Icons.settings;
      case NotificationType.classes:
        return Icons.class_;
      case NotificationType.exams:
        return Icons.assignment_turned_in_rounded;
      default:
        return Icons.notifications_none;
    }
  }

  String getTypeLabel(NotificationType type) {
    switch (type) {
      case NotificationType.system:
        return "System";
      case NotificationType.classes:
        return "Class";
      case NotificationType.exams:
        return "Exam";
      default:
        return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(kCardRadius),
        onTap: notification.read ? null : onMarkAsRead,
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(kCardRadius),
            boxShadow: [
              BoxShadow(color: kPrimaryColor.withOpacity(0.1), blurRadius: 16, offset: const Offset(0, 6)),
              BoxShadow(color: kPrimaryColor.withOpacity(0.06), blurRadius: 32, offset: const Offset(0, 12)),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER: Icon, Title, Unread badge
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: _typeIconBg(notification.type),
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: kPrimaryColor.withOpacity(0.12), blurRadius: 8, offset: const Offset(0, 3))],
                    ),
                    child: Icon(
                      getIcon(notification.type),
                          color: Colors.white,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Title + date
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Notification title
                        Text(
                          notification.title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: kTextColor,
                            overflow: TextOverflow.ellipsis,
                          ),
                          maxLines: 1,
                        ),
                        SizedBox(height: 2),
                        // Date/time
                        Text(
                          _formatDate(notification.dateTime),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                            overflow: TextOverflow.ellipsis,
                          ),
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                  if (!notification.read)
                    Padding(
                      padding: EdgeInsets.only(left: 6, top: 2),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: kAccentColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          "NEW",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.ellipsis,
                          ),
                          maxLines: 1,
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: 10),
              // Message (wraps text for safety)
              Text(
                notification.message,
                style: TextStyle(
                  fontSize: 14,
                  color: kTextColor.withOpacity(0.85),
                  overflow: TextOverflow.ellipsis,
                ),
                maxLines: 3,
              ),
              SizedBox(height: 12),
              // Type label badge (not prominent)
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: kPrimaryColor.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      getTypeLabel(notification.type),
                      style: TextStyle(
                        fontSize: 11,
                        color: kPrimaryColor,
                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              // =============================
              // SECTION 3: NOTIFICATION ACTIONS
              // =============================
              Wrap(
                spacing: 10,
                runSpacing: 6,
                children: [
                  if (!notification.read)
                    TextButton.icon(
                      style: TextButton.styleFrom(
                        foregroundColor: kAccentColor,
                        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        textStyle: TextStyle(fontSize: 13),
                        minimumSize: Size(0, 0),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      icon: Icon(Icons.check_circle_outline, size: 18),
                      label: Text(
                        "Mark as Read",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onPressed: onMarkAsRead,
                    ),
                  TextButton.icon(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.grey[600],
                      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      textStyle: TextStyle(fontSize: 13),
                      minimumSize: Size(0, 0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    icon: Icon(Icons.delete_outline, size: 18),
                    label: Text(
                      "Delete",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onPressed: onDelete,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Utilities
  String _formatDate(DateTime dt) {
    // Simple pretty format: "20 Jun, 10:11 AM"
    final d = dt;
    String day = d.day.toString().padLeft(2, '0');
    String month = _monthShort(d.month);
    String hour = d.hour > 12 ? (d.hour - 12).toString() : d.hour == 0 ? '12' : d.hour.toString();
    String minute = d.minute.toString().padLeft(2, '0');
    String ampm = d.hour >= 12 ? 'PM' : 'AM';
    return "$day $month, $hour:$minute $ampm";
  }

  String _monthShort(int m) {
    const ms = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return ms[(m - 1).clamp(0, 11)];
  }

  Color _typeIconBg(NotificationType t) {
    // distinct but on-brand, not too harsh
    switch (t) {
      case NotificationType.system:
        return kPrimaryColor;
      case NotificationType.classes:
        return kAccentColor.withOpacity(0.85);
      case NotificationType.exams:
        return kPrimaryColor.withOpacity(0.5);
      default:
        return Colors.grey[300]!;
    }
  }
}

