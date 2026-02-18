import 'package:flutter/material.dart';

import 'package:kobac/services/local_auth_service.dart';
import 'package:kobac/services/dummy_school_service.dart';

// ===== Color Constants =====
const Color kDarkBlue = Color(0xFF023471);
const Color kOrange = Color(0xFF5AB04B);
const Color kBgLight = Color(0xFFF9FBFC);

// ===== Main Admin Profile Page =====
class AdminProfilePage extends StatefulWidget {
  /// Whether this page was opened from the Drawer (default: false).
  ///
  /// Navigation logic for the back arrow:
  /// - If true, returns to the Drawer (Dashboard with drawer open)
  /// - If false, returns to the previous screen (usually Dashboard)
  final bool openedFromDrawer;

  const AdminProfilePage({super.key, this.openedFromDrawer = false});

  @override
  State<AdminProfilePage> createState() => _AdminProfilePageState();
}

class _AdminProfilePageState extends State<AdminProfilePage> {
  late Future<Map<String, String>?> _adminDataFuture;
  String? _errorMessage;

  Future<Map<String, String>?> _loadAdminData() async {
    final user = await LocalAuthService().getCurrentUser();

    if (user == null) {
      setState(() {
        _errorMessage = 'User not logged in';
      });
      return null;
    }

    _errorMessage = null;

    // Initialize fields from user (email fallback logic preserved)
    String adminName = user.name ?? '';
    String adminRole = user.role.toString().split('.').last;
    String adminEmail = user.email ?? user.emisNumber ?? '';
    String adminPhone = user.phone ?? '';
    String adminJoined = ''; // No info yet
    String avatarUrl = '';

    // School data: defaults
    String schoolName = '';
    String schoolEmail = '';
    String schoolPhone = '';
    String schoolAddress = '';
    String schoolLogo = '';

    // Try to load school data if user.schoolId is provided
    if (user.schoolId != null) {
      try {
        final school = await DummySchoolService().getSchoolById(
          user.schoolId!,
        );
        if (school != null) {
          schoolName = school.name ?? '';
          schoolEmail = school.email ?? '';
          schoolPhone = school.phone ?? '';
          schoolAddress = school.address ?? '';
          schoolLogo = school.logo ?? '';
          debugPrint('[AdminProfilePage] Loaded school: $schoolName');
        } else {
          debugPrint(
            '[AdminProfilePage] School not found for id=${user.schoolId}',
          );
        }
      } catch (e) {
        debugPrint('[AdminProfilePage] Error loading school: $e');
        // leave school fields as empty string per requirement
      }
    } else {
      debugPrint('[AdminProfilePage] User schoolId missing');
    }

    // For avatar, prefer the school logo if present, else fallback to previous logic (will use initials in widget)
    avatarUrl = (schoolLogo.isNotEmpty) ? schoolLogo : '';

    return {
      'name': adminName,
      'role': adminRole,
      'email': adminEmail,
      'phone': schoolPhone.isNotEmpty ? schoolPhone : adminPhone,
      'school': schoolName,
      'schoolAddress': schoolAddress,
      'joined': adminJoined,
      'avatarUrl': avatarUrl,
      // Note: no separate school email in the info panel, but available if you want to display
    };
  }

  Future<void> _refresh() async {
    setState(() {
      _adminDataFuture = _loadAdminData();
      // Reset error state on refresh
      _errorMessage = null;
    });
    await _adminDataFuture;
  }

  @override
  void initState() {
    super.initState();
    _errorMessage = null;
    _adminDataFuture = _loadAdminData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, String>?>(
      future: _adminDataFuture,
      builder: (context, snapshot) {
        final bool loading = snapshot.connectionState != ConnectionState.done;
        final Map<String, String>? adminData = snapshot.data;

        final double screenHeight = MediaQuery.of(context).size.height;

        return Scaffold(
          backgroundColor: kBgLight,
          appBar: AppBar(
            backgroundColor: kDarkBlue,
            elevation: 1.5,
            // Custom back arrow as leading widget
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              tooltip: 'Back',
              onPressed: () {
                if (widget.openedFromDrawer) {
                  Navigator.pop(context);
                } else {
                  Navigator.pop(context);
                }
              },
            ),
            iconTheme: const IconThemeData(color: Colors.white),
            title: const Text(
              'Profile',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.0,
                fontSize: 21,
              ),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.edit, color: kOrange),
                onPressed: () {}, // Edit profile
                tooltip: 'Edit Profile',
              ),
            ],
          ),
          body: SafeArea(
            child: Stack(
              children: [
                RefreshIndicator(
                  onRefresh: _refresh,
                  color: kOrange,
                  backgroundColor: Colors.white,
                  edgeOffset: 0,
                  displacement: 36,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 0,
                      vertical: 0,
                    ),
                    child: (loading)
                        ? SizedBox(height: screenHeight * 0.7)
                        : (_errorMessage != null)
                        ? SizedBox(
                            height: screenHeight * 0.7,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 32.0,
                                ),
                                child: Text(
                                  _errorMessage!,
                                  style: const TextStyle(
                                    color: kDarkBlue,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          )
                        : (adminData == null ||
                              (adminData['name']?.isEmpty ?? true))
                        ? SizedBox(
                            height: screenHeight * 0.7,
                            child: Center(
                              child: Text(
                                // This should never show because we already show error above,
                                // but it is a fallback just in case.
                                'No data found',
                                style: const TextStyle(
                                  color: kDarkBlue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const SizedBox(height: 34),
                              // Profile Header (Avatar, Name)
                              ProfileHeader(
                                name: adminData['name'] ?? '',
                                role: adminData['role'] ?? '',
                                avatarUrl: adminData['avatarUrl'] ?? '',
                              ),
                              const SizedBox(height: 30),
                              // Info List Section
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                ),
                                child: InfoSection(adminData: adminData),
                              ),
                              const SizedBox(height: 30),
                              // Quick Actions Row
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                ),
                                child: QuickActionsRow(),
                              ),
                              const SizedBox(height: 34),
                              // Account Section
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                ),
                                child: AccountSection(),
                              ),
                              // Room for bottom (ensure logout doesn't cover content)
                              const SizedBox(height: 96),
                            ],
                          ),
                  ),
                ),
                // Modern loading indicator overlay (centered, invisible to layout)
                if (loading)
                  Positioned.fill(
                    child: IgnorePointer(
                      child: Container(
                        color: Colors.transparent,
                        alignment: Alignment.center,
                        child: const SizedBox(
                          width: 54,
                          height: 54,
                          child: CircularProgressIndicator.adaptive(
                            valueColor: AlwaysStoppedAnimation<Color>(kOrange),
                            strokeWidth: 4,
                          ),
                        ),
                      ),
                    ),
                  ),
                // Logout Button fixed at the bottom
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: SafeArea(
                    top: false,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(18, 14, 18, 10),
                      child: LogoutButton(
                        onPressed: () {}, // Add actual logout logic
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// --------------- 1. ProfileHeader ---------------
class ProfileHeader extends StatelessWidget {
  final String name;
  final String role;
  final String avatarUrl;

  const ProfileHeader({
    Key? key,
    required this.name,
    required this.role,
    required this.avatarUrl,
  }) : super(key: key);

  // Helper: create initials from the name
  String _initials(String n) {
    var names = n.trim().split(' ');
    if (names.length == 1) return names[0][0].toUpperCase();
    return (names[0][0] + names.last[0]).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          // Avatar with orange thin ring
          SizedBox(
            width: 100,
            height: 100,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Thin orange ring
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: kOrange, width: 2.7),
                  ),
                ),
                // Avatar
                CircleAvatar(
                  radius: 47,
                  backgroundColor: kDarkBlue,
                  foregroundImage: (avatarUrl.isNotEmpty)
                      ? NetworkImage(avatarUrl)
                      : null,
                  child: avatarUrl.isEmpty
                      ? Text(
                          _initials(name),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 34,
                            letterSpacing: 1.2,
                          ),
                        )
                      : null,
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          // Full Name
          Text(
            name,
            style: const TextStyle(
              color: kDarkBlue,
              fontWeight: FontWeight.w700,
              fontSize: 22,
              letterSpacing: 0.01,
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 5),
          // Role
          Text(
            role,
            style: const TextStyle(
              color: kOrange,
              fontWeight: FontWeight.w600,
              fontSize: 15,
              letterSpacing: 0.05,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// --------------- 2. InfoSection ---------------
class InfoSection extends StatelessWidget {
  final Map<String, String> adminData;

  const InfoSection({Key? key, required this.adminData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[
      InfoRow(
        icon: Icons.email,
        label: 'Email',
        value: adminData['email'] ?? '',
      ),
      InfoRow(
        icon: Icons.phone,
        label: 'Phone',
        value: adminData['phone'] ?? '',
      ),
      InfoRow(
        icon: Icons.school,
        label: 'School',
        value: adminData['school'] ?? '',
      ),
      InfoRow(
        icon: Icons.location_on,
        label: 'School Address',
        value: adminData['schoolAddress'] ?? '',
      ),
      InfoRow(
        icon: Icons.calendar_today,
        label: 'Joined',
        value: adminData['joined'] ?? '',
      ),
    ];
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (int i = 0; i < rows.length; i++) ...[
            if (i != 0)
              const Divider(
                height: 1,
                thickness: 0.7,
                color: Color(0xFFE8EEFA),
              ),
            rows[i],
          ],
        ],
      ),
    );
  }
}

/// Reusable: InfoRow
class InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const InfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: kOrange, size: 22),
          const SizedBox(width: 15),
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: const TextStyle(
                color: kDarkBlue,
                fontWeight: FontWeight.w500,
                fontSize: 15.2,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 5,
            child: Text(
              value,
              style: const TextStyle(
                color: kDarkBlue,
                fontSize: 15.2,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 3,
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

/// --------------- 3. QuickActionsRow ---------------
class QuickActionsRow extends StatelessWidget {
  const QuickActionsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ActionButton.outlined(
            icon: Icons.edit,
            text: 'Edit Profile',
            onPressed: () {},
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: ActionButton.outlined(
            icon: Icons.lock_outline,
            text: 'Change Password',
            onPressed: () {},
          ),
        ),
      ],
    );
  }
}

/// --------------- 4. Account Section ---------------
class AccountSection extends StatelessWidget {
  const AccountSection({super.key});

  @override
  Widget build(BuildContext context) {
    final items = <_AccountItemData>[
      _AccountItemData(
        icon: Icons.notifications_none,
        label: 'Notifications',
        onTap: () {},
      ),
      _AccountItemData(
        icon: Icons.security_outlined,
        label: 'Security',
        onTap: () {},
      ),
      _AccountItemData(
        icon: Icons.privacy_tip_outlined,
        label: 'Privacy',
        onTap: () {},
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Account',
          style: TextStyle(
            color: kDarkBlue,
            fontWeight: FontWeight.w700,
            fontSize: 16.8,
            letterSpacing: 0.02,
          ),
        ),
        const SizedBox(height: 14),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              for (int i = 0; i < items.length; i++) ...[
                if (i > 0)
                  const Divider(
                    height: 1,
                    thickness: 0.7,
                    color: Color(0xFFE8EEFA),
                  ),
                _AccountSettingsItem(item: items[i]),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _AccountItemData {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  _AccountItemData({
    required this.icon,
    required this.label,
    required this.onTap,
  });
}

class _AccountSettingsItem extends StatelessWidget {
  final _AccountItemData item;

  const _AccountSettingsItem({required this.item});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
      leading: Icon(item.icon, color: kOrange),
      title: Text(
        item.label,
        style: const TextStyle(
          color: kDarkBlue,
          fontWeight: FontWeight.w500,
          fontSize: 15.1,
        ),
      ),
      trailing: const Icon(Icons.chevron_right, color: kDarkBlue, size: 25),
      onTap: item.onTap,
      horizontalTitleGap: 8,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      dense: true,
      minLeadingWidth: 0,
    );
  }
}

/// --------------- 5. ActionButton (for quick actions and logout) ---------------
enum _ActionButtonType { outlined, filled }

class ActionButton extends StatelessWidget {
  final String text;
  final IconData? icon;
  final VoidCallback onPressed;
  final _ActionButtonType type;

  const ActionButton._({
    required this.text,
    required this.icon,
    required this.onPressed,
    required this.type,
    super.key,
  });

  factory ActionButton.outlined({
    required IconData icon,
    required String text,
    required VoidCallback onPressed,
  }) {
    return ActionButton._(
      icon: icon,
      text: text,
      onPressed: onPressed,
      type: _ActionButtonType.outlined,
    );
  }

  factory ActionButton.filled({
    required String text,
    required VoidCallback onPressed,
  }) {
    return ActionButton._(
      icon: null,
      text: text,
      onPressed: onPressed,
      type: _ActionButtonType.filled,
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case _ActionButtonType.outlined:
        return OutlinedButton.icon(
          icon: Icon(icon, color: kOrange, size: 20),
          label: Text(
            text,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: kOrange,
              fontSize: 15.7,
              letterSpacing: 0.02,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: kOrange, width: 2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(13),
            ),
            foregroundColor: kOrange,
            backgroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 13),
            textStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15.3,
            ),
            elevation: 0,
            splashFactory: NoSplash.splashFactory,
          ),
        );
      case _ActionButtonType.filled:
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: kOrange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(13),
              ),
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 16),
              foregroundColor: Colors.white,
              textStyle: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 17,
              ),
            ),
            child: Text(text, maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
        );
    }
  }
}

/// --------------- 6. Logout Button ---------------
class LogoutButton extends StatelessWidget {
  final VoidCallback onPressed;
  const LogoutButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ActionButton.filled(text: 'Logout', onPressed: onPressed);
  }
}

// ---- Entry Export ----
//
// To use this page, add to your routes or push:
// Navigator.push(context, MaterialPageRoute(builder: (_) => AdminProfilePage()));
//
