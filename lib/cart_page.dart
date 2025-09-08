import 'package:flutter/material.dart';
import 'constants/colors.dart';            // shared colors
import 'BillPage.dart';                    // Bill page sits in lib/BillPage.dart

class CartPage extends StatefulWidget {
  /// Accepts a list of items. Each item can be either:
  ///  - Map<String, dynamic>  { id, name, price, imageUrl }
  ///  - Firestore doc-like object (with .id and item['field'])
  final List<dynamic> selectedItems;

  /// Quantities keyed by the same `id` used in each cart item
  final Map<String, int> quantities;

  const CartPage({
    super.key,
    required this.selectedItems,
    required this.quantities,
  });

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late List<dynamic> _items;
  late Map<String, int> _qty;

  @override
  void initState() {
    super.initState();
    _items = List<dynamic>.from(widget.selectedItems);
    _qty   = Map<String, int>.from(widget.quantities);
  }

  // ---------- helpers to read item fields, supporting Map or Firestore doc ----------
  String _idOf(dynamic item) {
    try {
      if (item is Map) return (item['id'] ?? '').toString();
      // Firestore doc-like:
      final dynamic id = item.id;
      return id?.toString() ?? '';
    } catch (_) {
      return '';
    }
  }

  T? _field<T>(dynamic item, String key) {
    try {
      if (item is Map) return item[key] as T?;
      return (item[key] as T?);
    } catch (_) {
      return null;
    }
  }
  // -------------------------------------------------------------------------------

  double _lineTotal(dynamic item) {
    final String id = _idOf(item);
    final int q = _qty[id] ?? 1;
    final num priceNum = _field<num>(item, 'price') ?? 0;
    return priceNum.toDouble() * q;
    }

  double _grandTotal() {
    double total = 0;
    for (final it in _items) {
      total += _lineTotal(it);
    }
    return total;
  }

  void _inc(String id) {
    setState(() => _qty[id] = (_qty[id] ?? 1) + 1);
  }

  void _dec(String id) {
    setState(() {
      final current = _qty[id] ?? 1;
      if (current > 1) _qty[id] = current - 1;
    });
  }

  void _remove(String id) {
    setState(() {
      _items.removeWhere((it) => _idOf(it) == id);
      _qty.remove(id);
    });
  }

  void _proceedToBill() async {
    if (_items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cart is empty')),
      );
      return;
    }

    // Convert items to Maps for the pure-UI BillPage (works either way)
    final itemsAsMaps = _items.map<Map<String, dynamic>>((it) {
      return {
        'id'      : _idOf(it),
        'name'    : _field(it, 'name')?.toString() ?? 'Item',
        'price'   : (_field<num>(it, 'price') ?? 0),
        'imageUrl': _field(it, 'imageUrl')?.toString() ?? '',
      };
    }).toList();

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BillPage(
          cartItems: itemsAsMaps,
          quantities: _qty,
        ),
      ),
    );

    // If BillPage popped with cleared cart, update our state
    if (result is Map) {
      setState(() {
        _items = List<dynamic>.from(result['cartItems'] ?? _items);
        _qty   = Map<String, int>.from(result['quantities'] ?? _qty);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        title: const Text('Your Cart'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: _items.isEmpty
          ? const Center(
              child: Text(
                'No items in the cart',
                style: TextStyle(color: AppColors.textColor),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: _items.length,
                    itemBuilder: (context, index) {
                      final item   = _items[index];
                      final id     = _idOf(item);
                      final name   = _field(item, 'name')?.toString() ?? 'Item';
                      final num pN = _field<num>(item, 'price') ?? 0;
                      final double price = pN.toDouble();
                      final int q  = _qty[id] ?? 1;
                      final img    = _field(item, 'imageUrl')?.toString() ?? '';

                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        child: ListTile(
                          leading: img.isNotEmpty
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    img,
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => _thumbFallback(),
                                  ),
                                )
                              : _thumbFallback(),
                          title: Text(
                            name,
                            style: const TextStyle(
                              color: AppColors.textColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Text(
                            "₹${price.toStringAsFixed(2)}  •  Qty: $q",
                            style: const TextStyle(color: AppColors.textColor),
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "₹${(price * q).toStringAsFixed(2)}",
                                style: const TextStyle(
                                  color: AppColors.textColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove_circle_outline),
                                    onPressed: () => _dec(id),
                                  ),
                                  Text(q.toString()),
                                  IconButton(
                                    icon: const Icon(Icons.add_circle_outline),
                                    onPressed: () => _inc(id),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          onLongPress: () => _remove(id),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  color: AppColors.primary.withOpacity(0.08),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total: ₹${_grandTotal().toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: AppColors.textColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: _proceedToBill,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Proceed to Bill'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _thumbFallback() => Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.fastfood, color: AppColors.primary),
      );
}
