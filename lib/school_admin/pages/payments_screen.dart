import 'package:flutter/material.dart';
import 'package:kobac/school_admin/pages/payment_details_page.dart';
// Remove the duplicate or incorrect import that may cause conflicts/errors
// import 'package:kobac/school_admin/pages/payment_details_page.dart';
// Use only the correct import for your PaymentDetailsPage class:

// ---- Project Colors ----
const Color kDarkBlue = Color(0xFF023471);
const Color kOrange = Color(0xFF5AB04B);
const Color kLightGrey = Color(0xFFF6F8FA);

// ---- Dummy Payment Data ----
class Payment {
  final String studentName;
  final String studentId;
  final String feeType;
  final double amount;
  final String status;
  final DateTime date;

  const Payment({
    required this.studentName,
    required this.studentId,
    required this.feeType,
    required this.amount,
    required this.status,
    required this.date,
  });
}

final List<Payment> dummyPayments = [
  Payment(
    studentName: 'Ayaan Mohamed',
    studentId: 'STU10234',
    feeType: 'Tuition',
    amount: 1200.0,
    status: 'Paid',
    date: DateTime(2024, 6, 1),
  ),
  Payment(
    studentName: 'Zahra Ali',
    studentId: 'STU10567',
    feeType: 'Transport',
    amount: 200.0,
    status: 'Partial',
    date: DateTime(2024, 6, 2),
  ),
  Payment(
    studentName: 'Yusuf Barre',
    studentId: 'STU10987',
    feeType: 'Exam',
    amount: 150.0,
    status: 'Unpaid',
    date: DateTime(2024, 5, 28),
  ),
  Payment(
    studentName: 'Nasra Hassan',
    studentId: 'STU11022',
    feeType: 'Tuition',
    amount: 1200.0,
    status: 'Paid',
    date: DateTime(2024, 6, 1),
  ),
  Payment(
    studentName: 'Omar Ahmed',
    studentId: 'STU11211',
    feeType: 'Uniform',
    amount: 75.0,
    status: 'Paid',
    date: DateTime(2024, 5, 29),
  ),
  Payment(
    studentName: 'Layla Abdullahi',
    studentId: 'STU11234',
    feeType: 'Exam',
    amount: 150.0,
    status: 'Unpaid',
    date: DateTime(2024, 5, 25),
  ),
  Payment(
    studentName: 'Farah Yusuf',
    studentId: 'STU11289',
    feeType: 'Transport',
    amount: 200.0,
    status: 'Partial',
    date: DateTime(2024, 6, 2),
  ),
];

// ---- Payments Screen Widget ----
class PaymentsScreen extends StatelessWidget {
  const PaymentsScreen({Key? key}) : super(key: key);

  double get totalPayments =>
      dummyPayments.fold(0, (a, b) => a + b.amount);

  double get paidAmount =>
      dummyPayments
          .where((p) => p.status == 'Paid')
          .fold(0, (a, b) => a + b.amount);

  double get outstandingAmount =>
      dummyPayments
          .where((p) => p.status != 'Paid')
          .fold(0, (a, b) => a + b.amount);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kLightGrey,
      appBar: AppBar(
        backgroundColor: kDarkBlue,
        elevation: 2,
        title: const Text(
          "Payments",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.white),
            tooltip: "Search",
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Search tapped (not implemented)")),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.filter_list, color: kOrange),
            tooltip: "Filter",
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Filter tapped (not implemented)")),
              );
            },
          ),
        ],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---- Summary Section ----
            _SummarySection(
              total: totalPayments,
              paid: paidAmount,
              outstanding: outstandingAmount,
            ),
            const SizedBox(height: 22),

            // ---- Payments List Header ----
            Text(
              "Recent Payments",
              style: TextStyle(
                color: kDarkBlue,
                fontSize: 19,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.1,
              ),
            ),
            const SizedBox(height: 12),
            // ---- Payments List ----
            // Use Expanded to fit the ListView, but ListView.separated must have no parent
            // widgets that cause unbounded height, so column is ok!
            Expanded(
              child: ListView.separated(
                itemCount: dummyPayments.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final payment = dummyPayments[index];
                  return PaymentCard(
                    payment: payment,
                    onTap: () {
                      // Navigate to new payment details page as per @payment_details_page.dart (572-576)
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => PaymentDetailsPage(),
                        ),
                      );
                    },
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

// ---- Redesigned Responsive Summary Section ----
class _SummarySection extends StatelessWidget {
  final double total, paid, outstanding;

  const _SummarySection({
    Key? key,
    required this.total,
    required this.paid,
    required this.outstanding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use LayoutBuilder for responsive horizontal/vertical layout
    return LayoutBuilder(
      builder: (context, constraints) {
        // Responsive widths
        double cardWidth;
        if (constraints.maxWidth > 900) {
          cardWidth = 260;
        } else if (constraints.maxWidth > 600) {
          cardWidth = 230;
        } else if (constraints.maxWidth > 390) {
          // Use available width - spacing for 3 cards in Wrap
          double availableWidth = constraints.maxWidth - (14 * 2);
          cardWidth = availableWidth / 3;
        } else {
          cardWidth = constraints.maxWidth;
        }

        return Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 14,
          runSpacing: 13,
          children: [
            SummaryCard(
              label: "Total Payments",
              value: "USD ${total.toStringAsFixed(2)}",
              color: kOrange,
              icon: Icons.payments,
              iconBg: kOrange.withOpacity(0.18),
              gradient: const LinearGradient(
                colors: [Color(0xFFFFD580), Color(0xFFFFF0E0)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              maxWidth: cardWidth,
            ),
            SummaryCard(
              label: "Paid Amount",
              value: "USD ${paid.toStringAsFixed(2)}",
              color: Colors.green.shade600,
              icon: Icons.check_circle,
              iconBg: Colors.greenAccent.withOpacity(0.20),
              gradient: const LinearGradient(
                colors: [Color(0xFFB1FFB0), Color(0xFFE5FEE9)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              maxWidth: cardWidth,
            ),
            SummaryCard(
              label: "Outstanding",
              value: "USD ${outstanding.toStringAsFixed(2)}",
              color: Colors.red.shade400,
              icon: Icons.warning_amber_rounded,
              iconBg: Colors.red.withOpacity(0.14),
              gradient: const LinearGradient(
                colors: [Color(0xFFFFBABA), Color(0xFFFEEAEA)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              maxWidth: cardWidth,
            ),
          ],
        );
      },
    );
  }
}

class SummaryCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;
  final Color iconBg;
  final LinearGradient gradient;
  final double? maxWidth;

  const SummaryCard({
    Key? key,
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
    required this.iconBg,
    required this.gradient,
    this.maxWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        margin: EdgeInsets.zero,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 16),
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.10),
                spreadRadius: 1,
                blurRadius: 14,
                offset: const Offset(0, 3),
              )
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: iconBg,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(14),
                child: Icon(icon, color: color, size: 32),
              ),
              const SizedBox(width: 16),
              Flexible(
                fit: FlexFit.loose,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      value,
                      style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.w900,
                        fontSize: 20,
                        letterSpacing: 0.4,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      label,
                      style: TextStyle(
                        color: kDarkBlue.withOpacity(0.92),
                        fontWeight: FontWeight.w600,
                        fontSize: 14.5,
                        letterSpacing: 0.05,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---- Payment Card Widget (Reusable) ----
class PaymentCard extends StatelessWidget {
  final Payment payment;
  final VoidCallback? onTap;

  const PaymentCard({Key? key, required this.payment, this.onTap}) : super(key: key);

  Widget _statusBadge(String status) {
    switch (status) {
      case 'Paid':
        return Container(
          decoration: BoxDecoration(
            color: kOrange,
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 6),
          child: Text(
            "Paid",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 13,
              letterSpacing: 0.2,
            ),
          ),
        );
      case 'Partial':
        return Container(
          decoration: BoxDecoration(
            color: Color(0xFFFDF4EC),
            border: Border.all(color: kOrange, width: 1.4),
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 6),
          child: Text(
            "Partial",
            style: TextStyle(
              color: kOrange,
              fontWeight: FontWeight.w700,
              fontSize: 13,
              letterSpacing: 0.2,
            ),
          ),
        );
      case 'Unpaid':
      default:
        return Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            border: Border.all(color: kOrange, width: 1),
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 6),
          child: Text(
            "Unpaid",
            style: TextStyle(
              color: kDarkBlue,
              fontWeight: FontWeight.w600,
              fontSize: 13,
              letterSpacing: 0.2,
            ),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 2.5,
          margin: EdgeInsets.zero,
          shadowColor: kDarkBlue.withOpacity(0.11),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 17, horizontal: 18),
            child: Row(
              children: [
                // --- Payment Icon ---
                Container(
                  decoration: BoxDecoration(
                    color: kDarkBlue.withOpacity(0.09),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Icon(
                    Icons.account_circle,
                    color: kDarkBlue,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 15),
                // --- Payment Details ---
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        payment.studentName,
                        style: TextStyle(
                          color: kDarkBlue,
                          fontWeight: FontWeight.w700,
                          fontSize: 16.5,
                          letterSpacing: 0.1,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 1.5),
                      Text(
                        "ID: ${payment.studentId}",
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.category,
                            size: 16,
                            color: kOrange,
                          ),
                          const SizedBox(width: 3.5),
                          Flexible(
                            child: Text(
                              payment.feeType,
                              style: TextStyle(
                                color: kDarkBlue,
                                fontWeight: FontWeight.w500,
                                fontSize: 13.5,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          const SizedBox(width: 13),
                          Icon(
                            Icons.date_range,
                            size: 15,
                            color: Colors.grey[500],
                          ),
                          const SizedBox(width: 2.5),
                          Flexible(
                            child: Text(
                              _dateString(payment.date),
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 13.2,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 9),
                // --- Amount & Status Badge ---
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "USD ${payment.amount.toStringAsFixed(2)}",
                      style: TextStyle(
                        color: kOrange,
                        fontWeight: FontWeight.bold,
                        fontSize: 15.2,
                        letterSpacing: 0.1,
                      ),
                    ),
                    const SizedBox(height: 7),
                    _statusBadge(payment.status),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _dateString(DateTime date) {
    // Example: Jun 01, 2024
    return "${_monthShort(date.month)} ${date.day.toString().padLeft(2, '0')}, ${date.year}";
  }

  String _monthShort(int month) {
    const names = [
      "Jan", "Feb", "Mar", "Apr", "May", "Jun",
      "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    ];
    return names[month - 1];
  }
}

