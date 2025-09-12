import 'package:flutter/material.dart';
import '../../constants/colors.dart';

class CouponsPage extends StatefulWidget {
  const CouponsPage({super.key});

  @override
  State<CouponsPage> createState() => _CouponsPageState();
}

class _CouponsPageState extends State<CouponsPage> {
  final List<Map<String, dynamic>> _coupons = [
    {
      'code': 'WELCOME10',
      'desc': '10% off on your first order',
      'min': 100,
      'type': 'PERCENT',
      'value': 10
    },
    {
      'code': 'MEAL30',
      'desc': 'Flat ₹30 off on orders above ₹199',
      'min': 199,
      'type': 'FLAT',
      'value': 30
    },
    {
      'code': 'COFFEE20',
      'desc': '20% off on beverages',
      'min': 80,
      'type': 'PERCENT',
      'value': 20
    },
  ];

  String _applied = '';

  void _goHome() {
    Navigator.pushNamedAndRemoveUntil(context, '/student-home', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        title: const Text('Coupons & Offers'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        leading: BackButton(
          onPressed: () => Navigator.pop(context), // ✅ back to previous page
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            tooltip: 'Back to Home',
            onPressed: _goHome, // ✅ jump to student home
          ),
        ],
      ),
      body: _coupons.isEmpty
          ? const Center(
              child: Text(
                'No coupons available right now',
                style: TextStyle(color: AppColors.textColor),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _coupons.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, i) {
                final c = _coupons[i];
                final selected = _applied == c['code'];

                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Text(
                      c['code'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textColor,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 6),
                        Text(
                          c['desc'],
                          style: TextStyle(color: Colors.grey.shade700),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Minimum order: ₹${c['min']}',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                    trailing: selected
                        ? const Icon(Icons.check_circle, color: AppColors.primary)
                        : ElevatedButton(
                            onPressed: () {
                              setState(() => _applied = c['code']);
                              // Return selected coupon to previous screen
                              Navigator.pop(context, c);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Apply'),
                          ),
                  ),
                );
              },
            ),
    );
  }
}
