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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
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
        ],
      ),
      body: _notifs.isEmpty
          ? const Center(
              child: Text('No notifications',
                  style: TextStyle(color: AppColors.textColor)))
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
                    title: Text(n['title'],
                        style: const TextStyle(color: AppColors.textColor)),
                    subtitle: Text(n['body']),
                    trailing: Text(n['time'],
                        style: TextStyle(color: Colors.grey.shade600)),
                    onTap: () => setState(() => n['read'] = true),
                  ),
                );
              },
            ),
    );
  }
}
