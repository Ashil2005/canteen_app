import 'package:flutter/material.dart';
import '../../constants/colors.dart';

class BillPage extends StatelessWidget {
  /// Each item should look like:
  /// { 'id': 'unique', 'name': 'Item name', 'price': 120, 'imageUrl': '...' }
  final List<Map<String, dynamic>> cartItems;

  /// Quantities keyed by the same `id` used in each cart item.
  final Map<String, int> quantities;

  const BillPage({
    super.key,
    required this.cartItems,
    required this.quantities,
  });

  double getTotal() {
    double total = 0;
    for (final item in cartItems) {
      final String id = (item['id'] ?? '').toString();
      final num price = (item['price'] as num?) ?? 0;
      final int qty = quantities[id] ?? 1;
      total += price.toDouble() * qty;
    }
    return total;
  }

  void placeBulkOrder(BuildContext context) {
    if (cartItems.isEmpty) return;

    // Frontend-only: just show success and pop back with cleared cart.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("✅ Order confirmed!")),
    );

    Navigator.pop(context, {
      'cartItems': <Map<String, dynamic>>[],
      'quantities': <String, int>{},
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        title: const Text("Total Bill"),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: cartItems.isEmpty
          ? const Center(
              child: Text(
                "No items in the cart",
                style: TextStyle(color: AppColors.textColor),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      final String id = (item['id'] ?? '$index').toString();
                      final String name = (item['name'] ?? 'Item').toString();
                      final num priceNum = (item['price'] as num?) ?? 0;
                      final double price = priceNum.toDouble();
                      final int qty = quantities[id] ?? 1;
                      final String imageUrl =
                          (item['imageUrl'] ?? '').toString();

                      return ListTile(
                        leading: imageUrl.isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  imageUrl,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => _fallbackThumb(),
                                ),
                              )
                            : _fallbackThumb(),
                        title: Text(
                          name,
                          style: const TextStyle(
                            color: AppColors.textColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                          "₹$price × $qty",
                          style:
                              const TextStyle(color: AppColors.textColor),
                        ),
                        trailing: Text(
                          "₹${(price * qty).toStringAsFixed(2)}",
                          style: const TextStyle(
                            color: AppColors.textColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  color: AppColors.primary.withOpacity(0.08),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total: ₹${getTotal().toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textColor,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => placeBulkOrder(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text("Make Payment"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _fallbackThumb() => Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.fastfood, color: AppColors.primary),
      );
}
