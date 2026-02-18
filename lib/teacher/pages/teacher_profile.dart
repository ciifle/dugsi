import 'package:flutter/material.dart';

// =======================
//  BRAND COLORS (STRICT)
// =======================
const Color kPrimaryColor = Color(0xFF023471); // Dark Blue
const Color kAccentColor = Color(0xFF5AB04B); // Orange
const Color kBGColor = Color(0xFFF8F9FA); // Very Light Gray
const Color kTextColor = Color(0xFF023471);

// =======================
//  TEACHER PROFILE SCREEN
// =======================

class TeacherProfileScreen extends StatelessWidget {
  TeacherProfileScreen({Key? key}) : super(key: key);

  // Dummy teacher data (for demo only)
  final Map<String, dynamic> teacher = const {
    'name': 'Imran Yusuf',
    'role': 'Mathematics Teacher',
    'employeeId': 'EMP-14059',
    'email': 'imran.yusuf@example.com',
    'phone': '+92 301 4455127',
    'gender': 'Male',
    'doj': '14 Feb 2018',
    'subjects': ['Mathematics', 'Statistics', 'Physics'],
    'classes': ['9A', '10A', '11B'],
    'experience': '8 Years',
    'qualification': 'M.Sc (Mathematics)',
    'address': 'House #14, H Block, Model Town, Lahore, Pakistan',
    'notes':
        'Professional educator with a passion for student success and constant improvement. Loves integrating technology in mathematics teaching.',
    'emergency': '502-009-8001 (Wife: Sara Yusuf)',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBGColor,
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        elevation: 0.8,
        automaticallyImplyLeading: true,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'My Profile',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 20,
            letterSpacing: 0.3,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          // Overflow prevention: vertical scroll.
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _ProfileHeader(teacher: teacher),
                const SizedBox(height: 22),
                _InfoSectionCard(
                  title: "Basic Information",
                  children: [
                    _ProfileInfoRow(
                      icon: Icons.email_outlined,
                      label: "Email",
                      value: teacher['email'] ?? '',
                    ),
                    _ProfileInfoRow(
                      icon: Icons.phone_outlined,
                      label: "Phone",
                      value: teacher['phone'] ?? '',
                    ),
                    _ProfileInfoRow(
                      icon: Icons.person_outline,
                      label: "Gender",
                      value: teacher['gender'] ?? '',
                    ),
                    _ProfileInfoRow(
                      icon: Icons.calendar_month_outlined,
                      label: "Date of Joining",
                      value: teacher['doj'] ?? '',
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                _InfoSectionCard(
                  title: "Professional Details",
                  children: [
                    _ProfileInfoWrapRow(
                      icon: Icons.book_outlined,
                      label: "Subjects",
                      items: (teacher['subjects'] as List<dynamic>?)
                              ?.map((e) => e.toString())
                              .toList() ??
                          [],
                    ),
                    _ProfileInfoWrapRow(
                      icon: Icons.class_outlined,
                      label: "Classes Assigned",
                      items: (teacher['classes'] as List<dynamic>?)
                              ?.map((e) => e.toString())
                              .toList() ??
                          [],
                    ),
                    _ProfileInfoRow(
                      icon: Icons.timelapse_outlined,
                      label: "Experience",
                      value: teacher['experience'] ?? '',
                    ),
                    _ProfileInfoRow(
                      icon: Icons.school_outlined,
                      label: "Qualification",
                      value: teacher['qualification'] ?? '',
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                _AccountActionsSection(),
                const SizedBox(height: 18),
                _ExpandableDetailsSection(
                  address: teacher['address'] ?? '',
                  notes: teacher['notes'] ?? '',
                  emergency: teacher['emergency'] ?? '',
                ),
                const SizedBox(height: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//==============================
// PROFILE HEADER (always safe)
//==============================
class _ProfileHeader extends StatelessWidget {
  final Map<String, dynamic> teacher;
  const _ProfileHeader({required this.teacher});

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    String first = parts.isNotEmpty ? parts.first[0] : '';
    String last = parts.length > 1 ? parts.last[0] : '';
    return (first + last).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    // Always wrap text, never overflow
    return Padding(
      padding: const EdgeInsets.only(bottom: 2.0),
      child: Material(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(22),
          bottomRight: Radius.circular(22),
        ),
        elevation: 3,
        shadowColor: kPrimaryColor.withOpacity(0.09),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Profile Picture/Initials
              CircleAvatar(
                radius: 38,
                backgroundColor: kPrimaryColor.withOpacity(0.09),
                child: Text(
                  _getInitials(teacher['name'] ?? ''),
                  style: const TextStyle(
                    fontSize: 32,
                    color: kPrimaryColor,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                teacher['name'] ?? '',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: kPrimaryColor,
                  fontSize: 20.5,
                  letterSpacing: 0.1,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 5),
              Text(
                teacher['role'] ?? '',
                style: const TextStyle(
                  color: kAccentColor,
                  fontSize: 15.8,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 3),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.badge_outlined, color: kAccentColor, size: 18),
                  const SizedBox(width: 5),
                  Text(
                    teacher['employeeId'] ?? '',
                    style: const TextStyle(
                      color: kPrimaryColor,
                      fontSize: 14.2,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.3,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              const SizedBox(height: 13),
              // Accent divider (orange)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 3, width: 34,
                    decoration: BoxDecoration(
                      color: kAccentColor.withOpacity(0.78),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =========================
// REUSABLE INFO SECTION CARD
// =========================
class _InfoSectionCard extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _InfoSectionCard({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 1.2,
      borderRadius: BorderRadius.circular(14),
      shadowColor: kPrimaryColor.withOpacity(0.04),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: kPrimaryColor,
                fontWeight: FontWeight.w700,
                fontSize: 15.8,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 10),
            ...children,
          ],
        ),
      ),
    );
  }
}

// =============
// ROW: LABEL+VALUE+ICON (Overflow Safe)
// =============
class _ProfileInfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _ProfileInfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    // Overflow prevention: make value take expanded
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 19, color: kAccentColor),
          const SizedBox(width: 9),
          Text(
            "$label:",
            style: const TextStyle(
              color: kPrimaryColor,
              fontWeight: FontWeight.w600,
              fontSize: 14.8,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(width: 9),
          // Expanded: ensures value wraps, avoids overflow
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: kTextColor,
                fontSize: 14.3,
                fontWeight: FontWeight.normal,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

// ================
// Wrap Row: List Items (Overflow Safe)
// ================
class _ProfileInfoWrapRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final List<String> items;
  const _ProfileInfoWrapRow({
    required this.icon,
    required this.label,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    // Overflow prevention: Wrap automatically
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 19, color: kAccentColor),
          const SizedBox(width: 9),
          Text(
            "$label:",
            style: const TextStyle(
              color: kPrimaryColor,
              fontWeight: FontWeight.w600,
              fontSize: 14.7,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(width: 5),
          // Expanded wrap for flexible items
          Expanded(
            child: Wrap(
              spacing: 7,
              runSpacing: 4,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: items
                  .map((item) => Container(
                        padding: const EdgeInsets.symmetric(vertical: 2.5, horizontal: 10),
                        decoration: BoxDecoration(
                          color: kAccentColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          item,
                          style: const TextStyle(
                            color: kAccentColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 13.3,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

// =====================
// ACCOUNT ACTIONS
// =====================
class _AccountActionsSection extends StatelessWidget {
  _AccountActionsSection({Key? key}) : super(key: key);

  final List<_AccountActionItem> actions = const [
    _AccountActionItem(
      icon: Icons.edit_outlined,
      label: 'Edit Profile',
    ),
    _AccountActionItem(
      icon: Icons.lock_outline,
      label: 'Change Password',
    ),
    _AccountActionItem(
      icon: Icons.settings_outlined,
      label: 'Settings',
    ),
    _AccountActionItem(
      icon: Icons.logout,
      label: 'Logout',
      warn: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      elevation: 1.2,
      shadowColor: kPrimaryColor.withOpacity(0.04),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: actions
              .map((a) => _AccountActionTile(
                    icon: a.icon,
                    label: a.label,
                    warn: a.warn,
                  ))
              .toList(),
        ),
      ),
    );
  }
}

class _AccountActionItem {
  final IconData icon;
  final String label;
  final bool warn;
  const _AccountActionItem({
    required this.icon,
    required this.label,
    this.warn = false,
  });
}

class _AccountActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool warn;
  const _AccountActionTile({
    required this.icon,
    required this.label,
    this.warn = false,
  });

  @override
  Widget build(BuildContext context) {
    // Overflow safe: No fixed height, wrap label
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(9),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 8),
        child: Row(
          children: [
            Icon(
              icon,
              size: 21,
              color: warn ? kAccentColor : kAccentColor,
            ),
            const SizedBox(width: 11),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: warn ? kAccentColor : kPrimaryColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: kPrimaryColor.withOpacity(0.40),
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}

// ===========================
// EXPANDABLE SECTION
// ===========================
class _ExpandableDetailsSection extends StatelessWidget {
  final String address;
  final String notes;
  final String emergency;
  const _ExpandableDetailsSection({
    required this.address,
    required this.notes,
    required this.emergency,
  });

  @override
  Widget build(BuildContext context) {
    // Overflow safety: No fixed heights, single ExpansionTile per info
    return Material(
      color: Colors.white,
      elevation: 1.2,
      borderRadius: BorderRadius.circular(14),
      shadowColor: kPrimaryColor.withOpacity(0.04),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
        child: Column(
          children: [
            ExpansionTile(
              tilePadding: const EdgeInsets.symmetric(horizontal: 13),
              leading: const Icon(Icons.location_on_outlined, color: kAccentColor),
              title: const Text(
                "Address",
                style: TextStyle(
                  color: kPrimaryColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 15.6,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 6.0, right: 12, bottom: 13, top: 3),
                    child: Text(
                      address,
                      style: const TextStyle(
                        color: kTextColor,
                        fontSize: 14,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                )
              ],
            ),
            const Divider(height: 1, color: kBGColor),
            ExpansionTile(
              tilePadding: const EdgeInsets.symmetric(horizontal: 13),
              leading: const Icon(Icons.info_outline, color: kAccentColor),
              title: const Text(
                "Notes",
                style: TextStyle(
                  color: kPrimaryColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 15.6,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 6.0, right: 12, bottom: 13, top: 3),
                    child: Text(
                      notes,
                      style: const TextStyle(
                        color: kTextColor,
                        fontSize: 14,
                      ),
                      maxLines: 6,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                )
              ],
            ),
            const Divider(height: 1, color: kBGColor),
            ExpansionTile(
              tilePadding: const EdgeInsets.symmetric(horizontal: 13),
              leading: const Icon(Icons.contact_emergency_outlined, color: kAccentColor),
              title: const Text(
                "Emergency Contact",
                style: TextStyle(
                  color: kPrimaryColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 15.6,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 6.0, right: 12, bottom: 13, top: 3),
                    child: Text(
                      emergency,
                      style: const TextStyle(
                        color: kTextColor,
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

