import 'package:flutter/material.dart';
import '../../constants/colors.dart';

class OrderPage extends StatefulWidget {
  /// Accepts either a Map<String, dynamic> or a Firestore-like doc
  /// with `.id` and `['field']` access.
  final dynamic item;

  const OrderPage({super.key, required this.item});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  int quantity = 1;

  // --- helpers to read fields safely from Map or Firestore-like doc ---
  T? _field<T>(String key) {
    try {
      if (widget.item is Map) return (widget.item as Map)[key] as T?;
      return widget.item[key] as T?;
    } catch (_) {
      return null;
    }
  }

  String get _name => _field('name')?.toString() ?? 'Item';
  String get _imageUrl => _field('imageUrl')?.toString() ?? '';
  num get _priceNum => _field<num>('price') ?? 0;
  double get _price => _priceNum.toDouble();
  double get _total => _price * quantity;
  // --------------------------------------------------------------------

  void _confirmOrder() {
    // Pure UI feedback (no backend yet)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('✅ Order confirmed (UI only)')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        title: const Text('Order Food'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Image / placeholder
          Container(
            height: 220,
            width: double.infinity,
            decoration: BoxDecoration(
              image: _imageUrl.isNotEmpty
                  ? DecorationImage(
                      image: NetworkImage(_imageUrl),
                      fit: BoxFit.cover,
                    )
                  : null,
              color: _imageUrl.isEmpty ? Colors.grey.shade300 : null,
            ),
            child: _imageUrl.isEmpty
                ? const Icon(Icons.fastfood, size: 50, color: AppColors.primary)
                : null,
          ),

          const SizedBox(height: 20),

          // Details
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textColor,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '₹${_price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textColor,
                  ),
                ),
                const SizedBox(height: 20),

                // Quantity controls
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon:
                          const Icon(Icons.remove_circle_outline, color: AppColors.primary),
                      onPressed: () {
                        setState(() {
                          if (quantity > 1) quantity--;
                        });
                      },
                    ),
                    Text(
                      quantity.toString(),
                      style: const TextStyle(fontSize: 18, color: AppColors.textColor),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline, color: AppColors.primary),
                      onPressed: () {
                        setState(() {
                          quantity++;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),

          const Spacer(),

          // Bottom bar
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total: ₹${_total.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton(
                  onPressed: _confirmOrder,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                      vertical: 12,
                    ),
                  ),
                  child: const Text(
                    'Confirm Order',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
