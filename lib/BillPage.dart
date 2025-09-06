import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BillPage extends StatelessWidget {
  final List<QueryDocumentSnapshot> cartItems;
  final Map<String, int> quantities;

  const BillPage({super.key, required this.cartItems, required this.quantities});

  double getTotal() {
    double total = 0;
    for (var item in cartItems) {
      final price = num.tryParse(item['price'].toString()) ?? 0;
      total += price * (quantities[item.id] ?? 1);
    }
    return total;
  }

  Future<void> placeBulkOrder(BuildContext context) async {
    if (cartItems.isEmpty) return;

    final batch = FirebaseFirestore.instance.batch();

    for (var item in cartItems) {
      final price = num.tryParse(item['price'].toString()) ?? 0;
      final qty = quantities[item.id] ?? 1;
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

    // Pop back to menu with cleared cart
    Navigator.pop(context, {'cartItems': [], 'quantities': {}});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Total Bill"),
        backgroundColor: Colors.orange,
        centerTitle: true,
      ),
      body: cartItems.isEmpty
          ? const Center(child: Text("No items in the cart"))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      var item = cartItems[index];
                      final qty = quantities[item.id] ?? 1;
                      final price = num.tryParse(item['price'].toString()) ?? 0;
                      return ListTile(
  leading: (item['imageUrl'] != null && item['imageUrl'].isNotEmpty)
      ? ClipRRect(
          borderRadius: BorderRadius.circular(8), // Rounded corners
          child: Image.network(
            item['imageUrl'],
            width: 50,
            height: 50,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              width: 50,
              height: 50,
              color: Colors.grey.shade300,
              child: const Icon(Icons.fastfood, color: Colors.orange),
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
          child: const Icon(Icons.fastfood, color: Colors.orange),
        ),
  title: Text(item['name']),
  subtitle: Text("₹$price × $qty"),
  trailing: Text("₹${price * qty}"),
  

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
                        onPressed: () => placeBulkOrder(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
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
}
