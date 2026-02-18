import 'package:flutter/material.dart';
import 'package:kobac/school_admin/pages/admin_students.dart';
import 'package:kobac/school_admin/pages/admin_classes.dart'; // <-- Add this import for classes page
import 'package:kobac/school_admin/pages/mesaage_screen.dart';
import 'package:kobac/school_admin/pages/notifications_page.dart';
import 'package:kobac/school_admin/pages/payments_screen.dart';
import 'package:kobac/school_admin/pages/teachers_screen.dart';
import 'package:kobac/school_admin/widgets/drawer_widget.dart';
import 'package:kobac/shared/services/school_service.dart';
import 'package:kobac/shared/services/auth_service.dart';

class SchoolAdminScreen extends StatefulWidget {
  const SchoolAdminScreen({Key? key}) : super(key: key);

  @override
  State<SchoolAdminScreen> createState() => _SchoolAdminScreenState();
}

class _SchoolAdminScreenState extends State<SchoolAdminScreen> {
  int? _studentCount;
  int? _teacherCount;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadCounts();
  }

  Future<void> _loadCounts() async {
    final user = await AuthService().getCurrentUser();
    if (user != null && user.role == 'SCHOOL_ADMIN') {
      final studentCount = await SchoolService().getStudentCount();
      final teacherCount = await SchoolService().getTeacherCount();
      setState(() {
        _studentCount = studentCount;
        _teacherCount = teacherCount;
        _loading = false;
      });
    } else {
      setState(() {
        _loading = false;
        _studentCount = null;
        _teacherCount = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const blue = Color(0xFF2563EB);
    const green = Color(0xFF22B07D);
    const yellow = Color(0xFFFC9B03);
    const red = Color(0xFFFD415B);

    const borderRadius = BorderRadius.all(Radius.circular(20));
    const statIconSize = 46.0;

    Widget statIcon(IconData icon, {Color? color}) {
      return Container(
        width: statIconSize,
        height: statIconSize,
        decoration: BoxDecoration(
          color: color?.withOpacity(0.12) ?? Colors.grey.withOpacity(0.10),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color ?? blue, size: 28),
      );
    }

    Widget statsCard({
      required Widget icon,
      required String label,
      Color? borderColor,
      VoidCallback? onTap,
    }) {
      return InkWell(
        borderRadius: borderRadius,
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: borderRadius,
            border: borderColor != null
                ? Border.all(color: borderColor, width: 2)
                : null,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 12,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              icon,
              const SizedBox(height: 12),
              Text(
                label,
                style: const TextStyle(
                  color: Color(0xFF1A1A1A),
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    // Wrap with InkWell to make messages clickable
    Widget messageCard({
      required String name,
      required String message,
      required String time,
      required String avatarUrl,
      int unreadCount = 0,
      bool unread = false,
      required VoidCallback? onTap,
    }) {
      return InkWell(
        borderRadius: borderRadius,
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 7),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: borderRadius,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Defensive for unreachable image url, fallback to initials/avatar
              CircleAvatar(
                radius: 26,
                backgroundColor: const Color(0xFFD9E6FB),
                backgroundImage: NetworkImage(avatarUrl),
                onBackgroundImageError: (_, __) {}, // Hide errors, fallback color
                child: avatarUrl.isEmpty
                    ? Text(
                        name.isNotEmpty
                            ? name
                                .trim()
                                .split(" ")
                                .map((w) => w[0])
                                .take(2)
                                .join()
                                .toUpperCase()
                            : "?",
                        style: const TextStyle(
                          color: Color(0xFF2563EB),
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1A1A),
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      message,
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF8291AA),
                        fontSize: 13.5,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    time,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      color: unread ? blue : const Color(0xFFBCC1CD),
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (unreadCount > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: blue,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '$unreadCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    final List<Map<String, dynamic>> messages = [
      {
        "name": "Osman Ahmed",
        "message":
            "I kindly request one day of leave. Please approve my request.",
        "time": "1 min",
        "avatarUrl": "https://randomuser.me/api/portraits/men/32.jpg",
        "unreadCount": 3,
        "unread": true,
      },
      {
        "name": "Fatima Musa",
        "message": "Can you reschedule the teachers' meeting to next week?",
        "time": "4 min",
        "avatarUrl": "https://randomuser.me/api/portraits/women/66.jpg",
        "unreadCount": 1,
        "unread": true,
      },
      {
        "name": "Abdulrahman Ismail",
        "message":
            "Please check the attached payment receipt for my son's tuition.",
        "time": "10 min",
        "avatarUrl": "https://randomuser.me/api/portraits/men/81.jpg",
        "unreadCount": 0,
        "unread": false,
      },
      {
        "name": "Farah Bello",
        "message": "Will there be school transport available tomorrow?",
        "time": "20 min",
        "avatarUrl": "https://randomuser.me/api/portraits/women/42.jpg",
        "unreadCount": 2,
        "unread": true,
      },
      {
        "name": "Yusuf Ibrahim",
        "message": "Kindly note my address has changed for correspondence.",
        "time": "35 min",
        "avatarUrl": "https://randomuser.me/api/portraits/men/58.jpg",
        "unreadCount": 0,
        "unread": false,
      },
      {
        "name": "Aisha Idris",
        "message": "Thank you for your prompt response regarding my query.",
        "time": "1 hr",
        "avatarUrl": "https://randomuser.me/api/portraits/women/21.jpg",
        "unreadCount": 0,
        "unread": false,
      },
    ];

    String getStudentLabel() {
      if (_loading || _studentCount == null) {
        return 'Students';
      }
      return 'Students (${_studentCount!})';
    }

    String getTeacherLabel() {
      if (_loading || _teacherCount == null) {
        return 'Teachers';
      }
      return 'Teachers (${_teacherCount!})';
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        drawer: const AppDrawer(),
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Fixed Custom App Bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Custom App Bar Row
                    Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Builder(
                            builder: (context) => IconButton(
                              onPressed: () {
                                Scaffold.of(context).openDrawer();
                              },
                              icon: const Icon(
                                Icons.menu,
                                size: 28,
                                color: Color(0xFF1A1A1A),
                              ),
                              splashRadius: 24,
                              tooltip: "Menu",
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const NotificationsPage(),
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.notifications_none,
                              size: 26,
                              color: Color(0xFF1A1A1A),
                            ),
                            splashRadius: 24,
                            tooltip: "Notifications",
                          ),
                        ],
                      ),
                    ),
                    // Page Title
                    const Padding(
                      padding: EdgeInsets.only(top: 4, bottom: 18),
                      child: Text(
                        "Dashboard",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 26,
                          color: Color(0xFF1A1A1A),
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Statistics Grid
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              sliver: SliverToBoxAdapter(
                child: GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  mainAxisSpacing: 17,
                  crossAxisSpacing: 17,
                  childAspectRatio: 1.16,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    statsCard(
                      icon: statIcon(Icons.school, color: blue),
                      label: getStudentLabel(),
                      borderColor: blue, // Blue border
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const AdminStudentsScreen(),
                          ),
                        );
                      },
                    ),
                    statsCard(
                      icon: statIcon(
                        Icons.person_rounded,
                        color: green,
                      ),
                      label: getTeacherLabel(),
                      borderColor: green, // Green border
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const TeacherListScreen(),
                          ),
                        );
                      },
                    ),
                    statsCard(
                      icon: statIcon(
                        Icons.class_,
                        color: yellow,
                      ),
                      label: "Classes (1,234)",
                      borderColor: yellow, // Yellow border
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const AdminClassesPage(),
                          ),
                        );
                      },
                    ),
                    statsCard(
                      icon: statIcon(
                        Icons.payments,
                        color: red,
                      ),
                      label: "Payments",
                      borderColor: red, // Red border
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const PaymentsScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            // Messages Section Title
            SliverPadding(
              padding: const EdgeInsets.only(
                left: 18,
                right: 18,
                top: 30,
                bottom: 10,
              ),
              sliver: SliverToBoxAdapter(
                child: const Text(
                  "Messages",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 19,
                    color: Color(0xFF16213E),
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
            // Message Cards List (now clickable)
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final m = messages[index];
                  return messageCard(
                    name: m['name'],
                    message: m['message'],
                    time: m['time'],
                    avatarUrl: m['avatarUrl'],
                    unreadCount: m['unreadCount'],
                    unread: m['unread'] ?? false,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) => MessageScreen(
                            // Pass message data to MessageScreen 
                            name: m['name'],
                            message: m['message'],
                            time: m['time'],
                            avatarUrl: m['avatarUrl'],
                          ),
                        ),
                      );
                    },
                  );
                }, childCount: messages.length),
              ),
            ),
            SliverToBoxAdapter(child: const SizedBox(height: 16)),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          elevation: 4.0,
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => MessageScreen(),
              ),
            );
          },
          child: SizedBox(
            width: 34,
            height: 34,
            child: Icon(
              Icons.chat_bubble_outline,
              color: Color(0xFF5AB04B),
              size: 26,
            ),
          ),
        ),
      ),
    );
  }
}
