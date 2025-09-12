import 'package:flutter/material.dart';
import '../../constants/colors.dart';

class ItemDetailPage extends StatefulWidget {
  /// expects: { id, name, price, imageUrl? }
  final Map<String, dynamic> item;
  const ItemDetailPage({super.key, required this.item});

  @override
  State<ItemDetailPage> createState() => _ItemDetailPageState();
}

class _ItemDetailPageState extends State<ItemDetailPage> {
  int _qty = 1;

  // Mock add-ons and ingredients
  final List<Map<String, dynamic>> _addons = [
    {'label': 'Extra Cheese', 'price': 15, 'selected': false},
    {'label': 'Butter',       'price': 10, 'selected': false},
    {'label': 'Chutney',      'price': 5,  'selected': false},
  ];

  final List<String> _ingredients = [
    'Bread / Base',
    'Fresh Veggies',
    'Sauces & Spices',
  ];

  final Map<String, String> _nutrition = const {
    'Calories': '320 kcal',
    'Protein':  '8 g',
    'Carbs':    '42 g',
    'Fat':      '12 g',
  };

  num get _basePrice => (widget.item['price'] as num?) ?? 0;

  num get _addonsTotal {
    num total = 0;
    for (final a in _addons) {
      if (a['selected'] == true) total += (a['price'] as num);
    }
    return total;
  }

  num get _total => (_basePrice + _addonsTotal) * _qty;

  void _onAddToCart() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Added to cart')),
    );
    // Return info so StudentMenuPage can add it (and optionally use qty/addons later)
    Navigator.pop(context, {
      'added': true,
      'item' : widget.item,
      'qty'  : _qty,
      'addons': _addons.where((a) => a['selected'] == true).toList(),
      'total': _total,
    });
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = (widget.item['imageUrl'] as String?) ?? '';
    final name     = (widget.item['name']     as String?) ?? 'Item';

    return WillPopScope(
      // If system back is pressed, just pop cleanly (no extra logic needed)
      onWillPop: () async => true,
      child: Scaffold(
        backgroundColor: AppColors.bgColor,
        appBar: AppBar(
          title: Text(name),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          actions: [
            PopupMenuButton<String>(
              onSelected: (v) {
                if (v == 'back') Navigator.pop(context);
              },
              itemBuilder: (c) => const [
                PopupMenuItem(value: 'back', child: Text('Back to Menu')),
              ],
            )
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Image
            Container(
              height: 190,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: imageUrl.isEmpty ? Colors.grey.shade300 : null,
                image: imageUrl.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(imageUrl),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: imageUrl.isEmpty
                  ? const Icon(Icons.fastfood, size: 56, color: AppColors.primary)
                  : null,
            ),
            const SizedBox(height: 16),

            // Price & Qty
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '₹${_basePrice.toString()}',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textColor,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () => setState(() {
                        if (_qty > 1) _qty--;
                      }),
                      icon: const Icon(Icons.remove_circle_outline, color: AppColors.primary),
                    ),
                    Text('$_qty',
                        style: const TextStyle(
                          fontSize: 18,
                          color: AppColors.textColor,
                        )),
                    IconButton(
                      onPressed: () => setState(() => _qty++),
                      icon: const Icon(Icons.add_circle_outline, color: AppColors.primary),
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(height: 8),

            Text(
              name,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.textColor,
              ),
            ),

            const SizedBox(height: 16),
            const Text('Ingredients',
                style: TextStyle(
                    fontWeight: FontWeight.w600, color: AppColors.textColor)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: _ingredients
                  .map((ing) => Chip(
                        label: Text(ing),
                        backgroundColor: AppColors.primary.withOpacity(.08),
                        side: BorderSide.none,
                      ))
                  .toList(),
            ),

            const SizedBox(height: 16),
            const Text('Nutrition',
                style: TextStyle(
                    fontWeight: FontWeight.w600, color: AppColors.textColor)),
            const SizedBox(height: 8),
            ..._nutrition.entries.map(
              (e) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(e.key, style: TextStyle(color: Colors.grey.shade700)),
                    Text(e.value,
                        style: const TextStyle(color: AppColors.textColor)),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),
            const Text('Add-ons',
                style: TextStyle(
                    fontWeight: FontWeight.w600, color: AppColors.textColor)),
            const SizedBox(height: 8),
            ..._addons.map((a) {
              return CheckboxListTile(
                value: a['selected'] as bool,
                onChanged: (v) => setState(() => a['selected'] = v ?? false),
                title: Text(a['label'],
                    style: const TextStyle(color: AppColors.textColor)),
                subtitle: Text('₹${a['price']}',
                    style: TextStyle(color: Colors.grey.shade600)),
                activeColor: AppColors.primary,
              );
            }),

            const SizedBox(height: 90),
          ],
        ),

        // Bottom bar
        bottomNavigationBar: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(color: Colors.black12.withOpacity(.06)),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total: ₹${_total.toString()}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: AppColors.textColor,
                  )),
              Row(
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _onAddToCart,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Add to Cart'),
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
