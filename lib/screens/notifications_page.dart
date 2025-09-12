import 'package:flutter/material.dart';
import '../../constants/colors.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final List<Map<String, dynamic>> _notifs = [
    {
      'title': 'Order #1048',
      'body': 'Your order is being prepared.',
      'time': '2m ago',
      'read': false
    },
    {
      'title': 'Offer',
      'body': 'Use MEAL30 to get ₹30 OFF today!',
      'time': '1h ago',
      'read': true
    },
    {
      'title': 'Order #1047',
      'body': 'Your order is ready for pickup.',
      'time': '3h ago',
      'read': true
    },
  ];

  void _markAllRead() {
    setState(() {
      for (final n in _notifs) n['read'] = true;
    });
  }

  void _clearAll() {
    setState(() => _notifs.clear());
  }

  void _goHome(BuildContext context) {
    // Hard jump to student home
    Navigator.pushNamedAndRemoveUntil(context, '/student-home', (r) => false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // If user presses system back, just pop to previous screen
      onWillPop: () async {
        Navigator.pop(context);
        return false;
      },
      child: Scaffold(
        backgroundColor: AppColors.bgColor,
        appBar: AppBar(
          title: const Text('Notifications'),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context), // back to previous (student home)
          ),
          actions: [
            IconButton(
              onPressed: _markAllRead,
              icon: const Icon(Icons.done_all),
              tooltip: 'Mark all as read',
            ),
            IconButton(
              onPressed: _clearAll,
              icon: const Icon(Icons.clear_all),
              tooltip: 'Clear all',
            ),
            IconButton(
              onPressed: () => _goHome(context),
              icon: const Icon(Icons.home),
              tooltip: 'Home',
            ),
          ],
        ),
        body: _notifs.isEmpty
            ? _EmptyNotifications(onShopNow: () => _goHome(context))
            : ListView.separated(
                padding: const EdgeInsets.all(8),
                itemCount: _notifs.length,
                separatorBuilder: (_, __) => const SizedBox(height: 6),
                itemBuilder: (context, i) {
                  final n = _notifs[i];
                  final unread = !(n['read'] as bool);
                  return Card(
                    color: unread
                        ? AppColors.primary.withOpacity(.08)
                        : Colors.white,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppColors.primary.withOpacity(.15),
                        child: Icon(
                          unread
                              ? Icons.notifications_active
                              : Icons.notifications,
                          color: AppColors.primary,
                        ),
                      ),
                      title: Text(
                        n['title'],
                        style: const TextStyle(color: AppColors.textColor),
                      ),
                      subtitle: Text(
                        n['body'],
                        style: const TextStyle(color: AppColors.textColor),
                      ),
                      trailing: Text(
                        n['time'],
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                      onTap: () => setState(() => n['read'] = true),
                    ),
                  );
                },
              ),
      ),
    );
  }
}

class _EmptyNotifications extends StatelessWidget {
  final VoidCallback onShopNow;
  const _EmptyNotifications({required this.onShopNow});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.notifications_off,
                size: 80, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            const Text(
              "You're all caught up!",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.textColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "We’ll ping you when there’s a tasty update.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade700),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: onShopNow,
              icon: const Icon(Icons.storefront),
              label: const Text("Shop now"),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
