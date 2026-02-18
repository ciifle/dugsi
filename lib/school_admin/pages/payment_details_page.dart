import 'package:flutter/material.dart';

// ---- Project Colors ----
const Color kDarkBlue = Color(0xFF023471);
const Color kOrange = Color(0xFF5AB04B);
const Color kLightGrey = Color(0xFFF6F8FA);

// ---- Dummy Payment Data Classes ----
class PaymentDetail {
  final String studentName;
  final String studentId;
  final String studentClass;
  final String feeType;
  final String status;
  final double totalAmount;
  final double paidAmount;
  final DateTime paymentDate;
  final String paymentMethod;
  final String transactionRef;
  final String receivedBy;
  final List<PaymentHistoryEntry> paymentHistory;

  PaymentDetail({
    required this.studentName,
    required this.studentId,
    required this.studentClass,
    required this.feeType,
    required this.status,
    required this.totalAmount,
    required this.paidAmount,
    required this.paymentDate,
    required this.paymentMethod,
    required this.transactionRef,
    required this.receivedBy,
    required this.paymentHistory,
  });

  double get balance => totalAmount - paidAmount;
}

class PaymentHistoryEntry {
  final DateTime date;
  final double amount;

  PaymentHistoryEntry({
    required this.date,
    required this.amount,
  });
}

// ---- Dummy Data for Demo ----
final PaymentDetail dummyPayment = PaymentDetail(
  studentName: 'Ayaan Mohamed',
  studentId: 'STU10234',
  studentClass: 'Grade 6A',
  feeType: 'Tuition',
  status: 'Partial',
  totalAmount: 1200.00,
  paidAmount: 800.00,
  paymentDate: DateTime(2024, 6, 7),
  paymentMethod: 'Mobile Money',
  transactionRef: 'MM-3244523',
  receivedBy: 'Ms. Sahra Jama',
  paymentHistory: [
    PaymentHistoryEntry(
      date: DateTime(2024, 5, 28),
      amount: 400.00,
    ),
    PaymentHistoryEntry(
      date: DateTime(2024, 6, 7),
      amount: 400.00,
    ),
  ],
);

// ---- Main Page ----
class PaymentDetailsPage extends StatelessWidget {
  const PaymentDetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    try {
      final payment = dummyPayment;

      return Scaffold(
        backgroundColor: kLightGrey,
        appBar: AppBar(
          backgroundColor: kDarkBlue,
          elevation: 2,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            "Payment Details",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.1,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit, color: kOrange),
              tooltip: "Edit or Update",
              onPressed: () {
                // Implement edit action
              },
            )
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Payment Summary Card
              _PaymentSummaryCard(payment: payment),
              const SizedBox(height: 22),
              // Payment Information Section
              _SectionTitle(title: "Payment Information"),
              Card(
                margin: const EdgeInsets.symmetric(vertical: 10),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(17),
                ),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 16),
                  child: Column(
                    children: [
                      InfoRow(
                        label: "Payment Date",
                        value: _formatDate(payment.paymentDate),
                      ),
                      const SizedBox(height: 7),
                      InfoRow(
                        label: "Method",
                        value: payment.paymentMethod,
                      ),
                      const SizedBox(height: 7),
                      InfoRow(
                        label: "Reference #",
                        value: payment.transactionRef,
                      ),
                      const SizedBox(height: 7),
                      InfoRow(
                        label: "Received By",
                        value: payment.receivedBy,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Payment History Section
              if (payment.status == "Partial" && payment.paymentHistory.isNotEmpty) ...[
                _SectionTitle(title: "Payment History"),
                Card(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  elevation: 0,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(17)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 13),
                    child: Column(
                      children: payment.paymentHistory
                          .map(
                            (history) => AmountRow(
                              left: _formatDate(history.date),
                              amount: history.amount,
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ActionButton(
                      label: "Record Payment",
                      icon: Icons.note_add_outlined,
                      onTap: () {
                        // Implement record payment feature
                      },
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: ActionButton(
                      label: "Mark as Paid",
                      icon: Icons.verified,
                      onTap: () {
                        // Implement mark as paid feature
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 13),
              ActionButton(
                label: "Download Receipt",
                icon: Icons.download_rounded,
                onTap: () {
                  // Implement download receipt
                },
                isFullWidth: true,
              ),
            ],
          ),
        ),
      );
    } catch (e, stacktrace) {
      // Fallback error screen, showing user-friendly message for any build errors/red screen
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text("Payment Details"),
          backgroundColor: kDarkBlue,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 64),
                const SizedBox(height: 20),
                const Text(
                  'Oops! Something went wrong.',
                  style: TextStyle(
                    color: kDarkBlue,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  e.toString(),
                  style: const TextStyle(
                    color: Colors.redAccent,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                TextButton.icon(
                  icon: const Icon(Icons.refresh, color: kOrange),
                  label: const Text(
                    'Retry',
                    style: TextStyle(
                      color: kOrange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    // On retry, just pop and re-enter page in most cases
                    Navigator.of(context).maybePop();
                  },
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  static String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}";
  }
}

class _PaymentSummaryCard extends StatelessWidget {
  final PaymentDetail payment;

  const _PaymentSummaryCard({Key? key, required this.payment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 7,
      shadowColor: kDarkBlue.withOpacity(0.22),
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(19)),
      margin: const EdgeInsets.symmetric(vertical: 0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Name, ID, Class, Fee type, Status Badge
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        payment.studentName,
                        style: const TextStyle(
                          fontSize: 20,
                          color: kDarkBlue,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.2,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        payment.studentId,
                        style: TextStyle(
                          color: kDarkBlue.withOpacity(0.7),
                          fontWeight: FontWeight.w500,
                          fontSize: 14.5,
                          letterSpacing: 0.01,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        payment.studentClass,
                        style: const TextStyle(
                          color: kDarkBlue,
                          fontWeight: FontWeight.w500,
                          fontSize: 15.5,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _StatusBadge(status: payment.status),
                  ],
                )
              ],
            ),
            const SizedBox(height: 13),
            // Fee Type Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InfoLabelValue(
                  label: "Fee Type",
                  value: payment.feeType,
                ),
                const SizedBox(width: 18),
                InfoLabelValue(
                  label: "Total",
                  value: "USD ${payment.totalAmount.toStringAsFixed(2)}",
                  valueColor: kOrange,
                ),
              ],
            ),
            const SizedBox(height: 11),
            // Paid & Remaining amounts
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InfoLabelValue(
                  label: "Paid",
                  value: "USD ${payment.paidAmount.toStringAsFixed(2)}",
                  valueColor: kOrange,
                ),
                InfoLabelValue(
                  label: "Remaining",
                  value: "USD ${payment.balance.toStringAsFixed(2)}",
                  valueColor: payment.balance > 0 ? Colors.red.shade400 : Colors.green,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Reusable Row for two-line label:value
class InfoLabelValue extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  const InfoLabelValue({
    Key? key,
    required this.label,
    required this.value,
    this.valueColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: kDarkBlue,
            fontWeight: FontWeight.w400,
            fontSize: 13.1,
            letterSpacing: 0.06,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            color: valueColor ?? kDarkBlue,
            fontWeight: FontWeight.w700,
            fontSize: 15.7,
            letterSpacing: 0.05,
          ),
        ),
      ],
    );
  }
}

/// Status badge used in summary card
class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    String label;
    switch (status) {
      case "Paid":
        bg = kOrange;
        fg = Colors.white;
        label = "Paid";
        break;
      case "Partial":
        bg = Colors.white;
        fg = kOrange;
        label = "Partial";
        break;
      case "Unpaid":
      default:
        bg = Colors.white;
        fg = kDarkBlue;
        label = "Unpaid";
        break;
    }
    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: status == "Partial"
              ? kOrange
              : status == "Unpaid"
                  ? kDarkBlue
                  : kOrange,
          width: 1.4,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      child: Text(
        label,
        style: TextStyle(
          color: fg,
          fontWeight: FontWeight.bold,
          fontSize: 13.5,
          letterSpacing: 0.02,
        ),
      ),
    );
  }
}

/// Section title for grouping
class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 3, bottom: 5),
      child: Text(
        title,
        style: const TextStyle(
          color: kDarkBlue,
          fontWeight: FontWeight.w800,
          fontSize: 16.5,
          letterSpacing: 0.08,
        ),
      ),
    );
  }
}

/// Reusable info row (label left, value right)
class InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const InfoRow({
    required this.label,
    required this.value,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            color: kDarkBlue.withOpacity(0.92),
            fontWeight: FontWeight.w400,
            fontSize: 15,
          ),
        ),
        const Spacer(),
        Flexible(
          flex: 3,
          child: Text(
            value,
            style: const TextStyle(
              color: kDarkBlue,
              fontWeight: FontWeight.w600,
              fontSize: 15.2,
            ),
            textAlign: TextAlign.right,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ],
    );
  }
}

/// Reusable row for showing a date/amount entry
class AmountRow extends StatelessWidget {
  final String left;
  final double amount;
  const AmountRow({required this.left, required this.amount, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(
            left,
            style: TextStyle(
              color: kDarkBlue.withOpacity(0.95),
              fontWeight: FontWeight.w500,
              fontSize: 15,
            ),
          ),
          const Spacer(),
          Text(
            "USD ${amount.toStringAsFixed(2)}",
            style: const TextStyle(
              color: kOrange,
              fontWeight: FontWeight.w700,
              fontSize: 15.7,
            ),
          ),
        ],
      ),
    );
  }
}

/// Reusable styled action button (orange + white)
class ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool isFullWidth;

  const ActionButton({
    required this.label,
    required this.icon,
    required this.onTap,
    this.isFullWidth = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      height: 48,
      child: ElevatedButton.icon(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(kOrange),
          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          elevation: MaterialStateProperty.all<double>(1.6),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(13),
            ),
          ),
        ),
        icon: Icon(icon, size: 23),
        label: Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            letterSpacing: 0.07,
          ),
        ),
        onPressed: onTap,
      ),
    );
  }
}

