import 'package:flutter/material.dart';
import 'package:canteen_app/constants/colors.dart';

// Screens in lib/screens/
import 'package:canteen_app/screens/coupons_page.dart';
import 'package:canteen_app/screens/notifications_page.dart';
import 'package:canteen_app/screens/feedback_page.dart';
import 'package:canteen_app/screens/item_detail_page.dart';
import 'package:canteen_app/order_page.dart';

// Profile lives at lib/profile_page.dart
import 'package:canteen_app/profile_page.dart';

class StudentMenuPage extends StatefulWidget {
  const StudentMenuPage({super.key});

  @override
  State<StudentMenuPage> createState() => _StudentMenuPageState();
}

/// Simple local item model
Map<String, dynamic> _item({
  required String id,
  required String name,
  required num price,
  required String category,
  String imageUrl = '',
  bool available = true,
}) =>
    {
      'id': id,
      'name': name,
      'price': price,
      'category': category,
      'imageUrl': imageUrl,
      'available': available,
    };

/// Seed data (replace with backend later)
final List<Map<String, dynamic>> _menuSeed = [
  _item(id: 'b1', name: 'Idli & Sambar', price: 30, category: 'Breakfast'),
  _item(id: 'b2', name: 'Masala Dosa', price: 45, category: 'Breakfast'),
  _item(id: 'l1', name: 'Veg Thali', price: 80, category: 'Lunch'),
  _item(id: 'l2', name: 'Chicken Biryani', price: 120, category: 'Lunch'),
  _item(id: 's1', name: 'Samosa', price: 15, category: 'Snacks'),
  _item(id: 's2', name: 'Cutlet', price: 20, category: 'Snacks'),
];

class _StudentMenuPageState extends State<StudentMenuPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  List<Map<String, dynamic>> cartItems = [];
  Map<String, int> quantities = {};

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

  void addToCart(Map<String, dynamic> item) {
    final id = item['id'] as String? ?? '';
    final exists = cartItems.any((it) => it['id'] == id);

    if (exists) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${item['name']} is already in the cart")),
      );
    } else {
      setState(() {
        cartItems.add(item);
        quantities[id] = 1;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${item['name']} added to cart")),
      );
    }
  }

  void openCart() async {
    if (cartItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No items in the cart!")),
      );
      return;
    }

    final result = await Navigator.pushNamed(
      context,
      '/cart',
      arguments: {
        'selectedItems': cartItems,
        'quantities': quantities,
      },
    );

    if (!mounted) return;
    if (result is Map) {
      setState(() {
        cartItems = List<Map<String, dynamic>>.from(result['cartItems'] ?? []);
        quantities = Map<String, int>.from(result['quantities'] ?? {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        title: const Text("Canteen Menu"),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
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
                onPressed: openCart,
              ),
              if (cartItems.isNotEmpty)
                Positioned(
                  right: 6,
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
          PopupMenuButton<String>(
            onSelected: (value) async {
              switch (value) {
                case 'coupons':
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CouponsPage()),
                  );
                  break;
                case 'notifications':
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const NotificationsPage()),
                  );
                  break;
                case 'feedback':
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const FeedbackPage()),
                  );
                  break;
                case 'profile':
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ProfilePage()),
                  );
                  break;
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'coupons', child: Text('Coupons')),
              PopupMenuItem(value: 'notifications', child: Text('Notifications')),
              PopupMenuItem(value: 'feedback', child: Text('Feedback')),
              PopupMenuItem(value: 'profile', child: Text('Profile')),
            ],
            icon: const Icon(Icons.more_vert, color: Colors.white),
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _MenuList(category: "Breakfast"),
          _MenuList(category: "Lunch"),
          _MenuList(category: "Snacks"),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: openCart,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.shopping_bag),
        label: const Text('Cart'),
      ),
    );
  }
}

class _MenuList extends StatelessWidget {
  final String category;
  const _MenuList({required this.category});

  @override
  Widget build(BuildContext context) {
    final items = _menuSeed
        .where((it) =>
            (it['category'] == category) && (it['available'] as bool? ?? true))
        .toList();

    if (items.isEmpty) {
      return Center(
        child: Text(
          "No $category items available",
          style: const TextStyle(fontSize: 18, color: AppColors.textColor),
        ),
      );
    }

    final state = context.findAncestorStateOfType<_StudentMenuPageState>()!;

    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final String imageUrl = (item['imageUrl'] as String?) ?? '';
        final String name = (item['name'] as String?) ?? 'Item';
        final num price = item['price'] as num? ?? 0;

        return Card(
          margin: const EdgeInsets.all(12),
          child: InkWell(
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ItemDetailPage(item: item),
                ),
              );
              if (result is Map && result['added'] == true) {
                state.addToCart(item);
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                imageUrl.isNotEmpty
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
                                size: 50, color: AppColors.primary),
                          ),
                        ),
                      )
                    : Container(
                        height: 150,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.fastfood,
                            size: 50, color: AppColors.primary),
                      ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textColor,
                            ),
                          ),
                          Text(
                            "₹$price",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          TextButton(
                            onPressed: () {
                              // ✅ Opens OrderPage directly
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => OrderPage(item: item),
                                ),
                              );
                            },
                            child: const Text('Order'),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () {
                              state.addToCart(item);

                              // ✅ Auto-open OrderPage right after adding
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => OrderPage(item: item),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text("Add"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
