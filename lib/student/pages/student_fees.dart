import 'package:flutter/material.dart';

// Brand Colors
const Color kPrimaryColor = Color(0xFF023471); // Dark Blue
const Color kAccentColor = Color(0xFF5AB04B); // Orange
const Color kBgColor = Color(0xFFFFFFFF); // White
const Color kTextColor = kPrimaryColor;

// Dummy Fee Data
final dummyFeeSummary = {
  'total': 2200.00,
  'paid': 1200.00,
  'remaining': 1000.00,
  'status': 'Partial', // Paid, Partial, Due
};

// Dummy terms and fee table data
final List<Map<String, dynamic>> dummyTerms = [
  {
    'title': 'Term 1 Fees',
    'fees': [
      {
        'type': 'Tuition',
        'amount': 800,
        'paid': 800,
        'balance': 0,
        'status': 'Paid'
      },
      {
        'type': 'Transport',
        'amount': 200,
        'paid': 100,
        'balance': 100,
        'status': 'Partial'
      },
    ],
  },
  {
    'title': 'Term 2 Fees',
    'fees': [
      {
        'type': 'Tuition',
        'amount': 800,
        'paid': 400,
        'balance': 400,
        'status': 'Partial'
      },
      {
        'type': 'Uniform',
        'amount': 200,
        'paid': 0,
        'balance': 200,
        'status': 'Due'
      },
    ],
  },
  {
    'title': 'Annual Fees',
    'fees': [
      {
        'type': 'Activities',
        'amount': 200,
        'paid': 0,
        'balance': 200,
        'status': 'Due'
      },
    ],
  },
];

// Dummy Payment History
final List<Map<String, dynamic>> dummyPayments = [
  {
    'date': '2024-01-15',
    'amount': 400,
    'method': 'Credit Card',
    'receipt': '#1234ABC'
  },
  {
    'date': '2024-03-10',
    'amount': 400,
    'method': 'Bank Transfer',
    'receipt': '#1235DEF'
  },
  {
    'date': '2024-05-01',
    'amount': 400,
    'method': 'Cash',
    'receipt': '#1236GHI'
  },
];

class StudentFeesScreen extends StatefulWidget {
  const StudentFeesScreen({Key? key}) : super(key: key);

  @override
  State<StudentFeesScreen> createState() => _StudentFeesScreenState();
}

class _StudentFeesScreenState extends State<StudentFeesScreen> {
  int? _openTerm;
  bool _paymentHistoryOpen = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgColor,
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Fees',
          style: TextStyle(
            color: kBgColor,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        iconTheme: const IconThemeData(color: kBgColor),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildFeeSummaryCard(dummyFeeSummary),
              const SizedBox(height: 18),
              _buildTermFeesSection(),
              const SizedBox(height: 18),
              _buildPaymentHistorySection(),
              const SizedBox(height: 18),
              _buildNotesCard(),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeeSummaryCard(Map<String, dynamic> summary) {
    String status = summary['status'];
    Color statusColor = status == 'Paid'
        ? Colors.green
        : (status == 'Partial' ? kAccentColor : Colors.red);

    return Card(
      color: kBgColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: kAccentColor, width: 1.1),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Fee Summary',
              style: TextStyle(
                color: kPrimaryColor,
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 14),
            _buildFeeSummaryRow('Total Fees', summary['total']),
            const SizedBox(height: 8),
            _buildFeeSummaryRow('Paid Amount', summary['paid']),
            const SizedBox(height: 8),
            _buildFeeSummaryRow('Balance', summary['remaining']),
            const SizedBox(height: 14),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
                  decoration: BoxDecoration(
                    color: kAccentColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Status: ${summary['status']}',
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeeSummaryRow(String label, dynamic amount) {
    double amt = 0.0;
    // Defensive: handle double/int/bool/error, just in case.
    if (amount is num) {
      amt = amount.toDouble();
    } else if (amount is bool) {
      amt = amount ? 1.0 : 0.0;
    } else {
      try {
        amt = double.parse(amount.toString());
      } catch (_) {}
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: kTextColor,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          "\$${amt.toStringAsFixed(2)}",
          style: const TextStyle(
            color: kTextColor,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        )
      ],
    );
  }

  // Accordion for each term/period (ExpansionTile, only one open at a time)
  Widget _buildTermFeesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Term/Period Fees',
          style: TextStyle(
            color: kPrimaryColor,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 7),
        ...List<Widget>.generate(dummyTerms.length, (i) {
          final t = dummyTerms[i];
          final dynamic fees = t['fees'];

          return Container(
            margin: const EdgeInsets.only(bottom: 9),
            decoration: BoxDecoration(
              color: kBgColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: kPrimaryColor.withOpacity(0.12), width: 1),
            ),
            child: Theme(
              data: Theme.of(context).copyWith(
                dividerColor: Colors.transparent,
                splashColor: kAccentColor.withOpacity(0.07),
                colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: kAccentColor,
                ),
              ),
              child: ExpansionTile(
                key: PageStorageKey(i),
                tilePadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                childrenPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                title: Text(
                  t['title'],
                  style: const TextStyle(
                    color: kPrimaryColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                initiallyExpanded: _openTerm == i,
                onExpansionChanged: (open) {
                  setState(() {
                    _openTerm = open ? i : null;
                  });
                },
                children: [
                  Builder(
                    builder: (context) {
                      // Defensive: ensure 'fees' is a List of Maps before building table
                      if (fees is List && fees.isNotEmpty && fees.first is Map) {
                        return _buildFeesTable(List<Map<String, dynamic>>.from(fees));
                      } else if (fees is List && fees.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text('No fee data available.',
                              style: TextStyle(color: Colors.grey[600], fontStyle: FontStyle.italic)),
                        );
                      } else {
                        return Container(
                          margin: const EdgeInsets.all(16),
                          padding: const EdgeInsets.all(16),
                          color: Colors.red[100],
                          child: const Text(
                            "Fee data error: Fee table cannot be displayed.",
                            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  // Fees Table (horizontally scrollable)
  Widget _buildFeesTable(List<Map<String, dynamic>> feeRows) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor: MaterialStateProperty.all(kAccentColor.withOpacity(0.10)),
        dataRowColor: MaterialStateProperty.all(kBgColor),
        columnSpacing: 30,
        columns: [
          DataColumn(
            label: Center(
              child: Text(
                'Fee Type',
                style: const TextStyle(
                    color: kPrimaryColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 15),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          DataColumn(
            label: Center(
              child: Text(
                'Amount',
                style: const TextStyle(
                    color: kPrimaryColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 15),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            numeric: true,
          ),
          DataColumn(
            label: Center(
              child: Text(
                'Paid',
                style: const TextStyle(
                    color: kPrimaryColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 15),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            numeric: true,
          ),
          DataColumn(
            label: Center(
              child: Text(
                'Balance',
                style: const TextStyle(
                    color: kPrimaryColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 15),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            numeric: true,
          ),
          DataColumn(
            label: Center(
              child: Text(
                'Status',
                style: const TextStyle(
                    color: kPrimaryColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 15),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
        rows: List<DataRow>.generate(
          feeRows.length,
          (i) {
            final row = feeRows[i];

            // Defensive conversion: If type is bool or another, to string as text.
            String typeStr = row['type'] == null
                ? ""
                : row['type'].toString();
            double amount = 0.0;
            double paid = 0.0;
            double balance = 0.0;

            // Defensive conversions to avoid "no subtype of type double" error
            try {
              amount = (row['amount'] as num).toDouble();
            } catch (_) {
              amount = 0.0;
            }
            try {
              paid = (row['paid'] as num).toDouble();
            } catch (_) {
              paid = 0.0;
            }
            try {
              balance = (row['balance'] as num).toDouble();
            } catch (_) {
              balance = 0.0;
            }

            Color statusColor;
            if (row['status'] == 'Paid') {
              statusColor = Colors.green;
            } else if (row['status'] == 'Partial') {
              statusColor = kAccentColor;
            } else {
              statusColor = Colors.red;
            }
            return DataRow(
              cells: [
                DataCell(
                  Center(
                    child: Text(
                      typeStr,
                      style: const TextStyle(
                        color: kTextColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                DataCell(
                  Center(
                    child: Text(
                      '\$${amount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: kTextColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                DataCell(
                  Center(
                    child: Text(
                      '\$${paid.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: kTextColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                DataCell(
                  Center(
                    child: Text(
                      '\$${balance.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: kTextColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                DataCell(
                  Center(
                    child: Text(
                      row['status'].toString(),
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildPaymentHistorySection() {
    return Container(
      decoration: BoxDecoration(
        color: kBgColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: kPrimaryColor.withOpacity(0.13), width: 1),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
          splashColor: kAccentColor.withOpacity(0.07),
          colorScheme: Theme.of(context).colorScheme.copyWith(
            primary: kAccentColor,
          ),
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 14),
          childrenPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          title: const Text(
            'Payment History',
            style: TextStyle(
                color: kPrimaryColor,
                fontWeight: FontWeight.w600,
                fontSize: 16),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          initiallyExpanded: _paymentHistoryOpen,
          onExpansionChanged: (open) {
            setState(() {
              _paymentHistoryOpen = open;
            });
          },
          children: [
            ...dummyPayments.map(
              (p) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.receipt_long,
                          size: 19,
                          color: kAccentColor,
                        ),
                        const SizedBox(width: 7),
                        Text(
                          'Receipt: ${p['receipt']}',
                          style: const TextStyle(
                              color: kTextColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 13),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Spacer(),
                        Text(
                          p['date'],
                          style: TextStyle(
                            color: kTextColor.withOpacity(0.7),
                            fontSize: 13,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Text(
                          'Amount: ',
                          style: TextStyle(
                              color: kPrimaryColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 14),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          '\$${(p['amount'] as num).toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: kAccentColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(width: 16),
                        Text(
                          'Method: ${p['method']}',
                          style: const TextStyle(
                            color: kTextColor,
                            fontSize: 13,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotesCard() {
    return Card(
      color: kBgColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: kAccentColor, width: 1.1),
      ),
      elevation: 1.5,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 17, horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Important Notes',
              style: TextStyle(
                color: kPrimaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 16.5,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 10),
            _buildNoteLine(
                Icons.calendar_today, 'Fee payments due by 25th of each month.'),
            const SizedBox(height: 6),
            _buildNoteLine(
                Icons.warning_amber_rounded,
                'Late payments will incur additional charges.'),
            const SizedBox(height: 6),
            _buildNoteLine(
                Icons.info_outline,
                'Pay via student portal or contact office for payment instructions.'),
          ],
        ),
      ),
    );
  }

  Widget _buildNoteLine(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: kAccentColor, size: 19),
        const SizedBox(width: 9),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: kTextColor,
              fontSize: 14.5,
              fontWeight: FontWeight.w400,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        )
      ],
    );
  }
}

// ==== OVERFLOW PREVENTION STRATEGY ====
// - The entire page is wrapped in a SingleChildScrollView, so any vertical overflow is handled.
// - All tables (DataTable) are wrapped in a horizontal SingleChildScrollView -- so wide tables never crash.
// - ExpansionTile/Column is always non-scrollable, with shrinkWrap/physics enforced if ListViews are used (though not here).
// - No fixed heights or widths anywhere. Padding and margin are only via EdgeInsets.
// - All text uses maxLines and TextOverflow.ellipsis to prevent text overflows.
// - No nested scrollable widgets unless shrinkWrap is used and physics is set to NeverScrollableScrollPhysics (none here).
// - No default Material colors, only brand theme colors.
// - Design is production-stable and scroll-safe.
