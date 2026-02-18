import 'package:flutter/material.dart';
import 'package:kobac/school_admin/pages/admin_classes.dart';
import 'package:kobac/school_admin/pages/admin_profile.dart';
import 'package:kobac/school_admin/pages/admin_students.dart';
import 'package:kobac/school_admin/pages/exams_page.dart';
import 'package:kobac/school_admin/pages/notices_page.dart';
import 'package:kobac/school_admin/pages/school_admin_screen.dart';
import 'package:kobac/school_admin/pages/settings_page.dart';
import 'package:kobac/school_admin/pages/subjects_screen.dart';
import 'package:kobac/shared/pages/login_screen.dart';
import 'package:kobac/services/local_auth_service.dart';


class AppDrawer extends StatelessWidget {
  static const Color drawerBackground = Colors.white; // changed to white
  static const Color accentOrange = Color(0xFF5AB04B);
  static const Color textWhite = Color(0xFF023471); // Changed for contrast on white bg
  static const Color dividerColor = Color(0x1103045E); // Primary color w/ 0.07 opacity

  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Drawer width for responsiveness and mobile overflow safety
    final double drawerWidth = MediaQuery.of(context).size.width * 0.85;

    return Drawer(
      width: drawerWidth > 340 ? 340 : drawerWidth,
      child: SafeArea(
        child: Container(
          color: drawerBackground,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                children: [
                  // Drawer header with profile info
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                    child: Material(
                      color: Colors.transparent,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const CircleAvatar(
                            radius: 30,
                            backgroundImage: AssetImage('assets/images/profile.jpg'),
                            backgroundColor: Color(0xFFF1F2F6),
                          ),
                          const SizedBox(width: 18),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'Mohamed Omar',
                                  style: TextStyle(
                                    color: textWhite,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'mohamedomar@gmail.com',
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  maxLines: 1,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(
                    color: dividerColor,
                    thickness: 1.2,
                    height: 1,
                  ),
                  // List of drawer items is scrollable/overflow-proof
                  Expanded(
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      children: [
                        _DrawerItem(
                          icon: Icons.home_rounded,
                          label: 'Home',
                          onTap: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const SchoolAdminScreen(),
                            ));
                          },
                        ),
                        _DrawerItem(
                          icon: Icons.person_rounded,
                          label: 'My Profile',
                          onTap: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => AdminProfilePage(),
                            ));
                          },
                        ),
                        _DrawerItem(
                          icon: Icons.school_rounded,
                          label: 'Teachers',
                          // Static, no onTap
                        ),
                        _DrawerItem(
                          icon: Icons.groups_rounded,
                          label: 'Students',
                          onTap: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const AdminStudentsScreen(),
                            ));
                          },
                        ),
                        _DrawerItem(
                          icon: Icons.class_rounded,
                          label: 'Classes',
                          onTap: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const AdminClassesPage(),
                            ));
                          },
                        ),
                        _DrawerItem(
                          icon: Icons.book_rounded,
                          label: 'Subjects',
                          onTap: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const SubjectsScreen(),
                            ));
                          },
                        ),
                        _DrawerItem(
                          icon: Icons.assignment_rounded,
                          label: 'Exams',
                          onTap: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const ExamsPage(),
                            ));
                          },
                        ),
                        _DrawerItem(
                          icon: Icons.notifications_rounded,
                          label: 'Notices',
                          onTap: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => NoticesPage(),
                            ));
                          },
                        ),
                        _DrawerItem(
                          icon: Icons.settings_rounded,
                          label: 'Settings',
                          onTap: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => SettingsPage(),
                            ));
                          },
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                  const Divider(
                    color: dividerColor,
                    thickness: 1.2,
                    height: 1,
                  ),
                  // Logout item is always bottom, with safe spacing
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 12, 0, 17),
                    child: _DrawerItem(
                      icon: Icons.logout_rounded,
                      label: 'Logout',
                      isLogout: true,
                      onTap: () async {
                        await LocalAuthService().logout();
                        if (!context.mounted) return;
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (_) => const LoginPage()),
                          (route) => false,
                        );
                      },
                    ),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  static const Color accentOrange = Color(0xFF5AB04B);
  static const Color textDark = Color(0xFF023471);
  static const Color tileHighlight = Color(0x29F35B04); // Orange slight opacity highlight

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool isLogout;

  const _DrawerItem({
    Key? key,
    required this.icon,
    required this.label,
    this.onTap,
    this.isLogout = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color accentColor = accentOrange;
    // Always use orange for icon color
    final Color iconColor = accentOrange;
    final Color labelColor = isLogout ? accentOrange : textDark;

    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: 4, vertical: isLogout ? 0 : 1),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 3),
          leading: Icon(
            icon,
            color: iconColor,
            size: 26,
          ),
          title: Text(
            label,
            style: TextStyle(
              color: labelColor,
              fontSize: 16,
              fontWeight: isLogout ? FontWeight.bold : FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          onTap: onTap,
          enabled: onTap != null,
          horizontalTitleGap: 14,
          minLeadingWidth: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          hoverColor: accentColor.withOpacity(0.08),
          splashColor: accentColor.withOpacity(0.10),
          focusColor: accentColor.withOpacity(0.15),
          selectedTileColor: accentColor.withOpacity(0.08),
          tileColor: Colors.transparent,
          trailing: null,
        ),
      ),
    );
  }
}
