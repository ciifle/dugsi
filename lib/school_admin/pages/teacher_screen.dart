import 'package:flutter/material.dart';
import 'package:kobac/school_admin/pages/mesaage_screen.dart';

// Project color constants
const Color kDarkBlue = Color(0xFF023471);
const Color kOrange = Color(0xFF5AB04B);
const Color kBackground = Color(0xFFF6F8FA);

class TeacherDetailsPage extends StatelessWidget {
  TeacherDetailsPage({Key? key}) : super(key: key);

  // Dummy teacher data
  final Map<String, dynamic> teacher = {
    'avatar':
        'https://randomuser.me/api/portraits/men/31.jpg',
    'name': 'Mr. David Miller',
    'subject': 'Mathematics',
    'status': 'Active',
    'email': 'david.miller@school.edu',
    'phone': '+1 555 321 0001',
    'address': '412 Maple Ave, Springfield',
    'experience': 9,
    'classes': ['Grade 9A', 'Grade 10B', 'Grade 12C'],
    'notes': 'Enthusiastic and well-experienced with digital platforms.',
    'adminRemarks':
        'Outstanding classroom discipline. Needs to update student records more frequently.'
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        backgroundColor: kDarkBlue,
        elevation: 2,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(
          'Teacher Details',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.8,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: kOrange),
            onPressed: () {
              // Edit action stub
            },
            tooltip: 'Edit Teacher',
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Profile Section
              _ProfileCard(teacher: teacher),
              SizedBox(height: 24),

              // Details Section
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
                margin: EdgeInsets.zero,
                color: Colors.white,
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InfoRow(
                        icon: Icons.email_outlined,
                        label: "Email",
                        value: teacher['email'],
                      ),
                      Divider(height: 24, color: Colors.grey[200]),
                      InfoRow(
                        icon: Icons.phone,
                        label: "Phone",
                        value: teacher['phone'],
                      ),
                      Divider(height: 24, color: Colors.grey[200]),
                      InfoRow(
                        icon: Icons.location_on_outlined,
                        label: "Address",
                        value: teacher['address'],
                      ),
                      Divider(height: 24, color: Colors.grey[200]),
                      InfoRow(
                        icon: Icons.timelapse,
                        label: "Years of Experience",
                        value: '${teacher['experience']} years',
                      ),
                      Divider(height: 24, color: Colors.grey[200]),
                      InfoRow(
                        icon: Icons.class_,
                        label: "Assigned Classes",
                        value: (teacher['classes'] as List<String>).join(', '),
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 28),

              // Redesigned Action Buttons
              Center(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 20,
                  runSpacing: 10,
                  children: [
                    _BetterActionButton(
                      icon: Icons.call,
                      label: "Call Teacher",
                      onPressed: () {
                        // Call action (stub)
                      },
                    ),
                    _BetterActionButton(
                      icon: Icons.message,
                      label: "Message",
                      onPressed: () {
                        // Navigate to external MessageScreen when tapped
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => MessageScreen(), // Assumes MessageScreen defined elsewhere
                          ),
                        );
                      },
                    ),
                    _BetterActionButton(
                      icon: Icons.assignment_ind,
                      label: "Assign Class",
                      onPressed: () {
                        // Assign class (stub)
                      },
                    ),
                  ],
                ),
              ),

              // Optional Notes Section
              SizedBox(height: 32),
              if (teacher['notes'] != null && (teacher['notes'] as String).isNotEmpty)
                Card(
                  color: Colors.white,
                  margin: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(18, 18, 18, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Notes",
                          style: TextStyle(
                            color: kDarkBlue,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.1,
                          ),
                        ),
                        SizedBox(height: 7),
                        Text(
                          teacher['notes'],
                          style: TextStyle(
                            color: kDarkBlue.withOpacity(0.9),
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              if (teacher['adminRemarks'] != null &&
                  (teacher['adminRemarks'] as String).isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Card(
                    color: Colors.white,
                    margin: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(18, 18, 18, 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Admin Remarks",
                            style: TextStyle(
                              color: kDarkBlue,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.1,
                            ),
                          ),
                          SizedBox(height: 7),
                          Text(
                            teacher['adminRemarks'],
                            style: TextStyle(
                              color: kDarkBlue.withOpacity(0.9),
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

/// Profile Card displaying avatar, name, subject, and status badge
class _ProfileCard extends StatelessWidget {
  final Map<String, dynamic> teacher;
  const _ProfileCard({required this.teacher});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 26, horizontal: 18),
        child: Row(
          children: [
            // Avatar
            _NetworkCircleAvatar(
              imageUrl: teacher['avatar'],
              radius: 38,
            ),
            SizedBox(width: 22),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    teacher['name'],
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: kDarkBlue,
                      letterSpacing: 0.2,
                    ),
                  ),
                  SizedBox(height: 7),
                  Row(
                    children: [
                      Icon(
                        Icons.book_outlined,
                        size: 18,
                        color: kOrange,
                      ),
                      SizedBox(width: 5),
                      Flexible(
                        child: Text(
                          teacher['subject'],
                          style: TextStyle(
                            color: kDarkBlue.withOpacity(0.92),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 13),
                  _StatusBadge(
                    status: teacher['status'],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Custom avatar widget with error and placeholder handling
class _NetworkCircleAvatar extends StatelessWidget {
  final String imageUrl;
  final double radius;

  const _NetworkCircleAvatar({required this.imageUrl, this.radius = 38});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: kOrange.withOpacity(0.1),
      child: ClipOval(
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          width: radius * 2,
          height: radius * 2,
          errorBuilder: (context, error, stackTrace) => Icon(
            Icons.person,
            size: radius * 1.4,
            color: kOrange,
          ),
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return SizedBox(
              width: radius * 2,
              height: radius * 2,
              child: Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2.6,
                  valueColor: AlwaysStoppedAnimation<Color>(kOrange),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Status badge: Orange if active, grey if inactive
class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    bool isActive = status.toLowerCase() == 'active';
    Color badgeColor = isActive ? kOrange : Colors.grey[400]!;
    String badgeText = isActive ? "Active" : "Inactive";

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.13),
        border: Border.all(color: badgeColor, width: 1.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isActive ? Icons.check_circle : Icons.remove_circle_outline,
            color: badgeColor,
            size: 17,
          ),
          SizedBox(width: 5),
          Text(
            badgeText,
            style: TextStyle(
              color: badgeColor,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}

/// Reusable row for info display with icon, label, and value
class InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final int maxLines;

  const InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment:
          maxLines > 1 ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        Icon(icon, color: kOrange, size: 22),
        SizedBox(width: 13),
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: TextStyle(
              color: kDarkBlue.withOpacity(0.92),
              fontWeight: FontWeight.w600,
              fontSize: 15.8,
              letterSpacing: 0.05,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: kDarkBlue,
              fontWeight: FontWeight.w400,
              fontSize: 16,
            ),
          ),
        )
      ],
    );
  }
}

/// Redesigned Action Button to match modern, visually appealing styles
class _BetterActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const _BetterActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        splashColor: kOrange.withOpacity(0.17),
        highlightColor: kOrange.withOpacity(0.13),
        onTap: onPressed,
        child: Container(
          constraints: BoxConstraints(
            minWidth: 110,
            maxWidth: 148,
            minHeight: 48,
          ),
          padding: EdgeInsets.symmetric(vertical: 11, horizontal: 16),
          decoration: BoxDecoration(
            color: kOrange,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: kOrange.withOpacity(0.11),
                blurRadius: 9,
                offset: Offset(0, 5),
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 2,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white, size: 21),
              SizedBox(width: 10),
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15.8,
                    letterSpacing: 0.1,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
