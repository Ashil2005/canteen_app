import 'package:flutter/material.dart';
import '../../constants/colors.dart';

class ItemDetailPage extends StatefulWidget {
  final Map<String, dynamic> item; // expects: {name, price, imageUrl?}
  const ItemDetailPage({super.key, required this.item});

  @override
  State<ItemDetailPage> createState() => _ItemDetailPageState();
}

class _ItemDetailPageState extends State<ItemDetailPage> {
  int _qty = 1;

  // Mock add-ons and ingredients
  final List<Map<String, dynamic>> _addons = [
    {'label': 'Extra Cheese', 'price': 15, 'selected': false},
    {'label': 'Butter', 'price': 10, 'selected': false},
    {'label': 'Chutney', 'price': 5, 'selected': false},
  ];

  final List<String> _ingredients = [
    'Bread / Base',
    'Fresh Veggies',
    'Sauces & Spices',
  ];

  final Map<String, String> _nutrition = const {
    'Calories': '320 kcal',
    'Protein': '8 g',
    'Carbs': '42 g',
    'Fat': '12 g',
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

  @override
  Widget build(BuildContext context) {
    final imageUrl = (widget.item['imageUrl'] as String?) ?? '';

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        title: Text(widget.item['name'] ?? 'Item'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
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
                      image: NetworkImage(imageUrl), fit: BoxFit.cover)
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
              Text('₹$_basePrice',
                  style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textColor)),
              Row(
                children: [
                  IconButton(
                    onPressed: () => setState(() {
                      if (_qty > 1) _qty--;
                    }),
                    icon: const Icon(Icons.remove_circle_outline),
                  ),
                  Text('$_qty',
                      style: const TextStyle(
                          fontSize: 18, color: AppColors.textColor)),
                  IconButton(
                    onPressed: () => setState(() => _qty++),
                    icon: const Icon(Icons.add_circle_outline),
                  ),
                ],
              )
            ],
          ),
          const SizedBox(height: 8),
          Text(widget.item['name'] ?? '',
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textColor)),

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
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          border:
              Border(top: BorderSide(color: Colors.black12.withOpacity(.06))),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Total: ₹$_total',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Added to cart')),
                );
                Navigator.pop(context, {
                  'qty': _qty,
                  'addons':
                      _addons.where((a) => a['selected'] == true).toList(),
                  'total': _total,
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text('Add to Cart'),
            )
          ],
        ),
      ),
    );
  }
}
