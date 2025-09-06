import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'cart_page.dart';

class StudentMenuPage extends StatefulWidget {
  const StudentMenuPage({super.key});

  @override
  _StudentMenuPageState createState() => _StudentMenuPageState();
}

class _StudentMenuPageState extends State<StudentMenuPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<QueryDocumentSnapshot> cartItems = [];
  Map<String, int> quantities = {}; // track quantity per item

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void addToCart(QueryDocumentSnapshot item) {
    bool exists = cartItems.any((cartItem) => cartItem.id == item.id);

    if (exists) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${item['name']} is already in the cart")),
      );
    } else {
      setState(() {
        cartItems.add(item);
        quantities[item.id] = 1;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${item['name']} added to cart")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Canteen Menu"),
        backgroundColor: Colors.orange,
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: "Breakfast"),
            Tab(text: "Lunch"),
            Tab(text: "Snacks"),
          ],
        ),
        actions: [
      Stack(
        alignment: Alignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Colors.white),
            onPressed: () {
              if (cartItems.isEmpty) {
                // Show snackbar for empty cart
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("No items in the cart!"),
                    duration: Duration(seconds: 2),
                  ),
                );
              } else {
                // Navigate to cart
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CartPage(
                      selectedItems: cartItems,
                      quantities: quantities,
                    ),
                  ),
                ).then((result) {
                  if (result != null) {
                    setState(() {
                      cartItems = List<QueryDocumentSnapshot>.from(result['cartItems']);
                      quantities = Map<String, int>.from(result['quantities']);
                    });
                  }
                });
              }
            },
          ),
          if (cartItems.isNotEmpty)
            Positioned(
              right: 8,
              top: 8,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  cartItems.length.toString(),
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
        ],
      ),
    ],
  ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildMenuList("Breakfast"),
          _buildMenuList("Lunch"),
          _buildMenuList("Snacks"),
        ],
      ),
    );
  }

  Widget _buildMenuList(String category) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('menu_items')
          .where('category', isEqualTo: category)
          .where('available', isEqualTo: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final items = snapshot.data!.docs;

        if (items.isEmpty) {
          return Center(
            child: Text("No $category items available",
                style: const TextStyle(fontSize: 18)),
          );
        }

        return ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            var item = items[index];
            String? imageUrl = item['imageUrl'];

            return Card(
              margin: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  (imageUrl != null && imageUrl.isNotEmpty)
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            imageUrl,
                            height: 150,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                              height: 150,
                              width: double.infinity,
                              color: Colors.grey.shade300,
                              child: const Icon(Icons.fastfood,
                                  size: 50, color: Colors.orange),
                            ),
                          ),
                        )
                      : Container(
                          height: 150,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(8)),
                          child: const Icon(Icons.fastfood,
                              size: 50, color: Colors.orange),
                        ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item['name'],
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold)),
                            Text("₹${item['price']}",
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.grey)),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () => addToCart(item),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text("Add"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
