import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminDashboard extends StatefulWidget {
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final tabs = ['Add Item', 'View Orders', 'Manage Items'];

  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController imageController = TextEditingController();
  String selectedCategory = 'Breakfast';

  Future<void> addMenuItem() async {
    if (nameController.text.isEmpty || priceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    await FirebaseFirestore.instance.collection('menu_items').add({
      'name': nameController.text,
      'category': selectedCategory,
      'price': double.tryParse(priceController.text) ?? 0,
      'imageUrl': imageController.text,
      'available': true,
    });

    nameController.clear();
    priceController.clear();
    imageController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Item added successfully")),
    );
  }

  Future<void> updateAvailability(String id, bool value) async {
    await FirebaseFirestore.instance
        .collection('menu_items')
        .doc(id)
        .update({'available': value});
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Admin Dashboard'),
          backgroundColor: Colors.orange,
          centerTitle: true,
          bottom: TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.black,
            indicatorColor: Colors.white,
            tabs: tabs.map((t) => Tab(text: t)).toList(),
          ),
        ),
        body: TabBarView(
          children: [
            // Add Item Tab
            Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: "Item Name"),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: priceController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: "Price"),
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: selectedCategory,
                      items: ['Breakfast', 'Lunch', 'Snacks']
                          .map((cat) => DropdownMenuItem(
                                value: cat,
                                child: Text(cat),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedCategory = value!;
                        });
                      },
                      decoration: const InputDecoration(labelText: "Category"),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: imageController,
                      decoration: const InputDecoration(labelText: "Image URL"),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: addMenuItem,
                      icon: const Icon(Icons.add, color: Colors.white),
                      label: const Text("Add Item", style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // View Orders Tab with timestamp
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('orders')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final orders = snapshot.data!.docs;

                if (orders.isEmpty) {
                  return const Center(
                    child: Text("No orders found.", style: TextStyle(color: Colors.grey)),
                  );
                }

                return ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    Timestamp timestamp = order['timestamp'];
                    DateTime date = timestamp.toDate();
                    String formattedDate =
                        "${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}";

                    return Card(
                      margin: const EdgeInsets.all(8),
                      child: ListTile(
                        leading: const Icon(Icons.receipt, color: Colors.orange),
                        title: Text(order['itemName'], style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Quantity: ${order['quantity']}"),
                            const SizedBox(height: 4),
                            Text("Ordered at: $formattedDate", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),

            // Manage Items Tab
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('menu_items').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final items = snapshot.data!.docs;

                if (items.isEmpty) {
                  return const Center(
                    child: Text("No menu items found.", style: TextStyle(color: Colors.grey)),
                  );
                }

                return ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return SwitchListTile(
                      title: Text(item['name']),
                      subtitle: Text("${item['category']} • ₹${item['price']}"),
                      value: item['available'],
                      onChanged: (value) {
                        updateAvailability(item.id, value);
                      },
                      activeColor: Colors.white,
                      activeTrackColor: Colors.orange,
                      inactiveThumbColor: Colors.black,
                      inactiveTrackColor: Colors.grey,
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
