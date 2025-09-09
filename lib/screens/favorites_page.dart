import 'package:flutter/material.dart';
import '../../constants/colors.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  // Mock “menu” items
  final List<Map<String, dynamic>> _items = [
    {'id': '1', 'name': 'Veg Sandwich', 'price': 45, 'imageUrl': ''},
    {'id': '2', 'name': 'Masala Dosa', 'price': 60, 'imageUrl': ''},
    {'id': '3', 'name': 'Cold Coffee', 'price': 50, 'imageUrl': ''},
    {'id': '4', 'name': 'Chicken Roll', 'price': 70, 'imageUrl': ''},
  ];

  final Set<String> _favorites = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        title: const Text('Favorites'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: _favorites.isEmpty
                ? null
                : () => setState(() => _favorites.clear()),
            tooltip: 'Clear favorites',
          )
        ],
      ),
      body: ListView.separated(
        itemCount: _items.length,
        separatorBuilder: (_, __) => const Divider(height: 0),
        itemBuilder: (context, i) {
          final item = _items[i];
          final isFav = _favorites.contains(item['id']);
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: AppColors.primary.withOpacity(.1),
              child: const Icon(Icons.fastfood, color: AppColors.primary),
            ),
            title: Text(item['name'],
                style: const TextStyle(color: AppColors.textColor)),
            subtitle: Text('₹${item['price']}',
                style: TextStyle(color: Colors.grey.shade600)),
            trailing: IconButton(
              icon: Icon(isFav ? Icons.favorite : Icons.favorite_border,
                  color: isFav ? AppColors.primary : Colors.grey),
              onPressed: () {
                setState(() {
                  isFav
                      ? _favorites.remove(item['id'])
                      : _favorites.add(item['id']);
                });
              },
            ),
            onTap: () {
              setState(() {
                _favorites.add(item['id']);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${item['name']} added to favorites')),
              );
            },
          );
        },
      ),
    );
  }
}
