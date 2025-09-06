import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'BillPage.dart';

class CartPage extends StatefulWidget {
  final List<QueryDocumentSnapshot> selectedItems;
  final Map<String, int> quantities;

  const CartPage({super.key, required this.selectedItems, required this.quantities});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late Map<String, int> quantities;

  @override
  void initState() {
    super.initState();
    quantities = Map<String, int>.from(widget.quantities);
  }

  // Intercept back button to send updated cart
  Future<bool> _onWillPop() async {
    Navigator.pop(context, {
      'cartItems': widget.selectedItems,
      'quantities': quantities,
    });
    return false;
  }

  double getTotal() {
    double total = 0;
    for (var item in widget.selectedItems) {
      final price = num.tryParse(item['price'].toString()) ?? 0;
      total += price * (quantities[item.id] ?? 1);
    }
    return total;
  }

  Future<void> placeBulkOrder() async {
    if (widget.selectedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No items in the cart!")),
      );
      return;
    }

    try {
      final batch = FirebaseFirestore.instance.batch();

      for (var item in widget.selectedItems) {
        final num price = num.tryParse(item['price'].toString()) ?? 0;
        final int qty = quantities[item.id] ?? 1;
        final docRef = FirebaseFirestore.instance.collection('orders').doc();
        batch.set(docRef, {
          'itemId': item.id,
          'itemName': item['name'],
          'price': price,
          'quantity': qty,
          'totalPrice': price * qty,
          'timestamp': Timestamp.now(),
        });
      }

      await batch.commit();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Order confirmed!")),
      );

      // Clear cart after ordering
      setState(() {
        widget.selectedItems.clear();
        quantities.clear();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to place order: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Your Cart"),
          backgroundColor: Colors.orange,
          centerTitle: true,
        ),
        body: widget.selectedItems.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.shopping_cart_outlined,
                        size: 80, color: Colors.orange),
                    const SizedBox(height: 16),
                    const Text(
                      "No items yet",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Add some delicious items from the menu",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: widget.selectedItems.length,
                      itemBuilder: (context, index) {
                        var item = widget.selectedItems[index];
                        String? imageUrl = item['imageUrl'];

                        return Card(
                          margin: const EdgeInsets.all(8),
                          child: ListTile(
                            leading: (imageUrl != null && imageUrl.isNotEmpty)
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      imageUrl,
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              Container(
                                        width: 50,
                                        height: 50,
                                        color: Colors.grey.shade300,
                                        child: const Icon(Icons.fastfood,
                                            color: Colors.orange),
                                      ),
                                    ),
                                  )
                                : Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade300,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(Icons.fastfood,
                                        color: Colors.orange),
                                  ),
                            title: Text(item['name']),
                            subtitle: Text("₹${item['price']}"),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Decrement
                                IconButton(
                                  icon: const Icon(Icons.remove),
                                  onPressed: () {
                                    setState(() {
                                      if ((quantities[item.id] ?? 1) > 1) {
                                        quantities[item.id] =
                                            (quantities[item.id] ?? 1) - 1;
                                      } else {
                                        quantities.remove(item.id);
                                        widget.selectedItems.removeAt(index);
                                      }
                                    });
                                  },
                                ),
                                Text("${quantities[item.id] ?? 0}"),
                                // Increment
                                IconButton(
                                  icon: const Icon(Icons.add),
                                  onPressed: () {
                                    setState(() {
                                      quantities[item.id] =
                                          (quantities[item.id] ?? 0) + 1;
                                    });
                                  },
                                ),
                                // Delete
                                IconButton(
                                  icon:
                                      const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    setState(() {
                                      quantities.remove(item.id);
                                      widget.selectedItems.removeAt(index);
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16),
                    color: Colors.orange.shade100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Total: ₹${getTotal()}",
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        ElevatedButton(
  onPressed: widget.selectedItems.isEmpty
      ? null
      : () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BillPage(
                cartItems: widget.selectedItems,
                quantities: quantities,
              ),
            ),
          ).then((result) {
            if (result != null) {
              setState(() {
                // Clear cart after order confirmed
                widget.selectedItems.clear();
                quantities.clear();
              });
            }
          });
        },
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.orange,
    foregroundColor: Colors.white,
  ),
  child: const Text("Confirm Order"),
),

                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
