import 'package:flutter/material.dart';

// ==== BRAND COLORS ====
const Color kPrimaryDarkBlue = Color(0xFF023471);
const Color kAccentOrange = Color(0xFF5AB04B);
const Color kBackground = Color(0xFFF9F9F9);
const Color kTextDarkBlue = Color(0xFF023471);

class TeacherNoticesScreen extends StatefulWidget {
  const TeacherNoticesScreen({Key? key}) : super(key: key);

  @override
  State<TeacherNoticesScreen> createState() => _TeacherNoticesScreenState();
}

enum NoticeStatus { active, draft, expired }

class Notice {
  final String id;
  final String title;
  final String description;
  final String fullContent;
  final String targetAudience;
  final String createdDate;
  final NoticeStatus status;
  final String? attachedInfo;
  final String? notes;
  final String type; // general, class, exam

  Notice({
    required this.id,
    required this.title,
    required this.description,
    required this.fullContent,
    required this.targetAudience,
    required this.createdDate,
    required this.status,
    this.attachedInfo,
    this.notes,
    required this.type,
  });
}

// Dummy sample notices. Unsafe mutability is avoided, only used for view.
final List<Notice> dummyNotices = [
  Notice(
    id: 'n1',
    title: 'PTM Announcement',
    description: 'Parent Teacher Meeting scheduled for 5th Jun.',
    fullContent: 'Dear Parents, You are requested to attend the PTM on June 5th at 10AM in the school auditorium.',
    targetAudience: 'All Students',
    createdDate: '2024-05-22',
    status: NoticeStatus.active,
    type: 'general',
    attachedInfo: 'PTM Agenda: Curriculum updates, feedback, Q&A.',
    notes: null,
  ),
  Notice(
    id: 'n2',
    title: 'Test Reminder',
    description: 'Class 8B Math test on Thursday.',
    fullContent: 'This is to remind all students of Class 8B about the Math test scheduled for Thursday.',
    targetAudience: 'Class 8B',
    createdDate: '2024-05-20',
    status: NoticeStatus.draft,
    type: 'class',
    attachedInfo: null,
    notes: 'Draft. Edit before sending.',
  ),
  Notice(
    id: 'n3',
    title: 'Science Exam Guidelines',
    description: 'Important rules for mid-term Science exams.',
    fullContent: 'Students must carry their own stationery. No electronic devices allowed.',
    targetAudience: 'All Students',
    createdDate: '2024-05-15',
    status: NoticeStatus.expired,
    type: 'exam',
    attachedInfo: null,
    notes: null,
  ),
  Notice(
    id: 'n4',
    title: 'Assembly Timing Change',
    description: 'Morning assembly to start 15min early.',
    fullContent: 'Assembly will begin at 8:15AM, effective next week, for all classes.',
    targetAudience: 'All Students',
    createdDate: '2024-05-17',
    status: NoticeStatus.active,
    type: 'general',
    attachedInfo: 'Be present on time. Latecomers will be noted.',
    notes: null,
  ),
];

// For UI filter logic. Only local state allowed.
const List<_NoticeFilter> _filters = [
  _NoticeFilter(label: "All", value: "all"),
  _NoticeFilter(label: "Class Notices", value: "class"),
  _NoticeFilter(label: "Exam Notices", value: "exam"),
  _NoticeFilter(label: "General Notices", value: "general"),
];

class _TeacherNoticesScreenState extends State<TeacherNoticesScreen> {
  String _selectedFilter = "all";

  List<Notice> get _filteredNotices {
    if (_selectedFilter == "all") {
      return dummyNotices;
    } else {
      return dummyNotices.where((n) => n.type == _selectedFilter).toList();
    }
  }

  // Counts for summary card
  int get _totalCount => dummyNotices.length;
  int get _activeCount => dummyNotices.where((n) => n.status == NoticeStatus.active).length;
  int get _draftCount => dummyNotices.where((n) => n.status == NoticeStatus.draft).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        backgroundColor: kPrimaryDarkBlue,
        elevation: 2,
        centerTitle: true,
        // Ensures proper color contrast, and positioning.
        title: const Text(
          'Notices',
          maxLines: 1, // overflow-protected
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 20,
            letterSpacing: 0.2,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        // Wrapping ENTIRE body in SingleChildScrollView, as per overflow-prevention mandate.
        child: SingleChildScrollView(
          // No horizontal scrollbars, only vertical.
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- SECTION 1: SUMMARY CARD ---
                _NoticeSummaryCard(
                  total: _totalCount,
                  active: _activeCount,
                  draft: _draftCount,
                ),
                const SizedBox(height: 20),

                // --- SECTION 2: FILTER CHIPS ---
                _FilterChips(
                  filters: _filters,
                  selected: _selectedFilter,
                  onChanged: (value) {
                    setState(() => _selectedFilter = value);
                  },
                ),
                const SizedBox(height: 20),

                // --- SECTION 3: NOTICE LIST (CARDS) ---
                _filteredNotices.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 64),
                          child: Text(
                            'No notices found.',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: kTextDarkBlue.withOpacity(0.6),
                              fontSize: 16,
                            ),
                          ),
                        ),
                      )
                    : ListView.builder(
                        // MANDATORY shrinkWrap allows ListView inside scrollable. disables internal scrolling.
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _filteredNotices.length,
                        itemBuilder: (context, i) =>
                            Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: _NoticeCard(notice: _filteredNotices[i]),
                            ),
                      ),

                // --- SECTION 6: CREATE NOTICE BUTTON (always last) ---
                const SizedBox(height: 28),
                _CreateNoticeCTAButton(
                  onPressed: () {
                    // TODO: Implement create notice action.
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Create New Notice tapped!')),
                    );
                  },
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---- SECTION 1: Summary at top ----
class _NoticeSummaryCard extends StatelessWidget {
  final int total;
  final int active;
  final int draft;

  const _NoticeSummaryCard({
    Key? key,
    required this.total,
    required this.active,
    required this.draft,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // No fixed heights, only padding/margin. All text overflow-safe.
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: EdgeInsets.zero,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Orange accent top line (not fixed height)
            Container(
              height: 4,
              width: double.infinity,
              decoration: BoxDecoration(
                color: kAccentOrange,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _SummaryItem(
                  icon: Icons.format_list_bulleted,
                  label: "Total",
                  value: total,
                ),
                _SummaryItem(
                  icon: Icons.campaign,
                  label: "Active",
                  value: active,
                  accent: true,
                ),
                _SummaryItem(
                  icon: Icons.edit_note,
                  label: "Draft",
                  value: draft,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int value;
  final bool accent;
  const _SummaryItem({
    Key? key,
    required this.icon,
    required this.label,
    required this.value,
    this.accent = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Ensures no overflow - icons have no fixed size, eg. Icon size is stable.
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: accent ? kAccentOrange : kPrimaryDarkBlue,
          size: 26,
        ),
        const SizedBox(height: 5),
        Text(
          '$value',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: accent ? kAccentOrange : kPrimaryDarkBlue,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: kTextDarkBlue,
            fontWeight: FontWeight.w500,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}

// ---- SECTION 2: FILTER CHIPS ----
class _FilterChips extends StatelessWidget {
  final List<_NoticeFilter> filters;
  final String selected;
  final ValueChanged<String> onChanged;

  const _FilterChips({
    Key? key,
    required this.filters,
    required this.selected,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Uses Wrap, not Row, to ensure no horizontal overflow.
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        for (var filter in filters)
          FilterChip(
            label: Text(
              filter.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: selected == filter.value ? Colors.white : kTextDarkBlue,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
            selected: selected == filter.value,
            onSelected: (_) => onChanged(filter.value),
            // Accent orange on selected, bordered otherwise. Zero fixed width.
            selectedColor: kAccentOrange,
            backgroundColor: Colors.white,
            side: selected == filter.value
                ? BorderSide.none
                : const BorderSide(color: kPrimaryDarkBlue, width: 1.3),
            showCheckmark: false,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
          ),
      ],
    );
  }
}

class _NoticeFilter {
  final String label;
  final String value;
  const _NoticeFilter({required this.label, required this.value});
}

// --- SECTION 3/4/5: Notice Cards (with expansion and actions)
class _NoticeCard extends StatefulWidget {
  final Notice notice;
  const _NoticeCard({Key? key, required this.notice}) : super(key: key);

  @override
  State<_NoticeCard> createState() => _NoticeCardState();
}

class _NoticeCardState extends State<_NoticeCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final n = widget.notice;

    // Orange border/accent for active, standard for others.
    BoxDecoration cardDecoration = BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.09),
          blurRadius: 8,
          spreadRadius: 1,
          offset: const Offset(0, 3),
        ),
      ],
      border: n.status == NoticeStatus.active
          ? Border.all(color: kAccentOrange, width: 2)
          : null,
    );
    return Container(
      decoration: cardDecoration,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          title: Text(
            n.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: kTextDarkBlue,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              n.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: kTextDarkBlue.withOpacity(0.76),
                fontWeight: FontWeight.w500,
                fontSize: 13.5,
              ),
            ),
          ),
          trailing: _StatusChip(status: n.status),
          childrenPadding: const EdgeInsets.fromLTRB(18, 0, 18, 12),
          // Prevents internal overflow. ExpansionTile never has fixed height.
          maintainState: true,
          onExpansionChanged: (exp) => setState(() => _isExpanded = exp),
          children: [
            // --- Notice expanded content ---
            if (n.fullContent.trim().isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 10, top: 4),
                child: Text(
                  n.fullContent,
                  maxLines: _isExpanded ? 10 : 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: kTextDarkBlue,
                    fontSize: 14,
                  ),
                ),
              ),
            if (n.attachedInfo?.trim().isNotEmpty ?? false)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  'Attachment: ${n.attachedInfo}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: kAccentOrange,
                    fontWeight: FontWeight.w600,
                    fontSize: 13.5,
                  ),
                ),
              ),
            if (n.notes?.trim().isNotEmpty ?? false)
              Text(
                'Note: ${n.notes}',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: kTextDarkBlue.withOpacity(0.6),
                  fontStyle: FontStyle.italic,
                  fontSize: 13,
                ),
              ),
            // Audience/date, always shown. Use Wrap to avoid overflow.
            Padding(
              padding: const EdgeInsets.only(top: 7, bottom: 3),
              child: Wrap(
                spacing: 18,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.person_outline, color: kPrimaryDarkBlue, size: 16),
                      const SizedBox(width: 6),
                      Text(
                        n.targetAudience,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: kTextDarkBlue,
                          fontWeight: FontWeight.w500,
                          fontSize: 12.5,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.calendar_today, color: kPrimaryDarkBlue, size: 16),
                      const SizedBox(width: 6),
                      Text(
                        n.createdDate,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: kTextDarkBlue.withOpacity(0.59),
                          fontSize: 12.5,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // --- ACTIONS: always at bottom of card, use Wrap to avoid overflow ---
            _NoticeCardActions(
              status: n.status,
              onView: () {
                // View action (dummy)
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('View: ${n.title}', maxLines: 1, overflow: TextOverflow.ellipsis)),
                );
              },
              onEdit: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Edit: ${n.title}', maxLines: 1, overflow: TextOverflow.ellipsis)),
                );
              },
              onPublishUnpublish: n.status == NoticeStatus.active
                  ? () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Unpublished: ${n.title}', maxLines: 1, overflow: TextOverflow.ellipsis)),
                      );
                    }
                  : () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Published: ${n.title}', maxLines: 1, overflow: TextOverflow.ellipsis)),
                      );
                    },
              onDelete: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Delete: ${n.title}', maxLines: 1, overflow: TextOverflow.ellipsis)),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// --- STATUS CHIP, for Active/Draft/Expired ---
class _StatusChip extends StatelessWidget {
  final NoticeStatus status;
  const _StatusChip({Key? key, required this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String label = '';
    Color color = kPrimaryDarkBlue;
    switch (status) {
      case NoticeStatus.active:
        label = 'Active';
        color = kAccentOrange;
        break;
      case NoticeStatus.draft:
        label = 'Draft';
        color = kPrimaryDarkBlue;
        break;
      case NoticeStatus.expired:
        label = 'Expired';
        color = kPrimaryDarkBlue.withOpacity(0.55);
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: status == NoticeStatus.active
            ? kAccentOrange.withOpacity(0.15)
            : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color, width: 1.0),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w700,
          fontSize: 13,
        ),
      ),
    );
  }
}

// ---- SECTION 4: CARD ACTION BUTTONS (always Wrap, no Row) ----
class _NoticeCardActions extends StatelessWidget {
  final NoticeStatus status;
  final VoidCallback onView;
  final VoidCallback onEdit;
  final VoidCallback onPublishUnpublish;
  final VoidCallback onDelete; // optional

  const _NoticeCardActions({
    Key? key,
    required this.status,
    required this.onView,
    required this.onEdit,
    required this.onPublishUnpublish,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // SAFE WRAP for horizontal overflow prevention.
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Wrap(
        spacing: 8,
        runSpacing: 6,
        children: [
          _ActionButton(
            label: 'View',
            icon: Icons.remove_red_eye_outlined,
            onTap: onView,
          ),
          _ActionButton(
            label: 'Edit',
            icon: Icons.edit_outlined,
            onTap: onEdit,
          ),
          _ActionButton(
            label: status == NoticeStatus.active ? 'Unpublish' : 'Publish',
            icon: status == NoticeStatus.active ? Icons.visibility_off : Icons.publish,
            accent: true,
            onTap: onPublishUnpublish,
          ),
          _ActionButton(
            label: 'Delete',
            icon: Icons.delete_outline,
            onTap: onDelete,
            danger: true,
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool accent;
  final bool danger;

  const _ActionButton({
    Key? key,
    required this.label,
    required this.icon,
    required this.onTap,
    this.accent = false,
    this.danger = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // No fixed widths. Padding only.
    return InkWell(
      borderRadius: BorderRadius.circular(19),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: accent
              ? kAccentOrange.withOpacity(0.18)
              : (danger ? Colors.red.withOpacity(0.08) : Colors.grey.shade50),
          borderRadius: BorderRadius.circular(19),
          border: Border.all(
            color: accent
                ? kAccentOrange
                : (danger ? Colors.red.shade200 : kPrimaryDarkBlue.withOpacity(0.18)),
            width: 1.0,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon,
                size: 17,
                color: accent ? kAccentOrange : (danger ? Colors.red : kPrimaryDarkBlue)),
            const SizedBox(width: 5),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: accent
                    ? kAccentOrange
                    : (danger ? Colors.red[700] : kTextDarkBlue),
                fontWeight: FontWeight.w600,
                fontSize: 13.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---- SECTION 6: CREATE NOTICE CTA (Floating full-width in scrollview) ----
class _CreateNoticeCTAButton extends StatelessWidget {
  final VoidCallback onPressed;
  const _CreateNoticeCTAButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // No fixed height/width, always full-width of parent.
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.add, color: Colors.white, size: 23),
            label: const Text(
              "Create New Notice",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                letterSpacing: 0.1,
                fontSize: 16.2,
                color: Colors.white,
              ),
            ),
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: kAccentOrange,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(13),
              ),
              padding: const EdgeInsets.symmetric(vertical: 15),
              elevation: 2,
              textStyle: const TextStyle(fontWeight: FontWeight.w700),
              shadowColor: kAccentOrange.withOpacity(0.18),
            ),
          ),
        ),
      ),
    );
  }
}


// === OVERRIDE ScrollBehavior for overflow safety in main.dart if needed ===
// END OF TeacherNoticesScreen

