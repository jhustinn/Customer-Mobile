import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NotificationWidget extends StatelessWidget {
  const NotificationWidget({super.key});

  void _showNotifications(BuildContext context) {
    HapticFeedback.lightImpact();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => const NotificationBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IconButton(
          onPressed: () => _showNotifications(context),
          icon: Icon(
            Icons.notifications_outlined,
            color: Theme.of(context).primaryColor,
            size: 24,
          ),
        ),

        // Notification badge
        Positioned(
          right: 8,
          top: 8,
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.error,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }
}

class NotificationBottomSheet extends StatelessWidget {
  const NotificationBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = [
      {
        'id': '1',
        'title': 'Pembayaran Kredit Jatuh Tempo',
        'message':
            'Tagihan kredit Anda sebesar Rp 2.500.000 akan jatuh tempo dalam 3 hari. Segera lakukan pembayaran untuk menghindari denda.',
        'type': 'payment',
        'time': '2 jam yang lalu',
        'isRead': false,
      },
      {
        'id': '2',
        'title': 'Kredit Disetujui',
        'message':
            'Selamat! Pengajuan kredit Anda untuk pembelian dental unit telah disetujui dengan limit Rp 15.000.000.',
        'type': 'approval',
        'time': '1 hari yang lalu',
        'isRead': false,
      },
      {
        'id': '3',
        'title': 'Promo Terbatas',
        'message':
            'Dapatkan diskon 20% untuk semua produk handpiece. Berlaku hingga akhir bulan ini.',
        'type': 'promo',
        'time': '2 hari yang lalu',
        'isRead': true,
      },
      {
        'id': '4',
        'title': 'Pengiriman Produk',
        'message':
            'Pesanan Anda dengan nomor #CR-2024-001 sedang dalam proses pengiriman dan akan tiba besok.',
        'type': 'shipping',
        'time': '3 hari yang lalu',
        'isRead': true,
      },
    ];

    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).dividerColor,
                ),
              ),
            ),
            child: Row(
              children: [
                Text(
                  'Notifikasi',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                            'Semua notifikasi telah ditandai sudah dibaca'),
                      ),
                    );
                  },
                  child: const Text('Tandai Semua'),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),

          // Notification list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return _NotificationItem(notification: notification);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationItem extends StatelessWidget {
  final Map<String, dynamic> notification;

  const _NotificationItem({
    required this.notification,
  });

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'payment':
        return Icons.payment;
      case 'approval':
        return Icons.check_circle_outline;
      case 'promo':
        return Icons.local_offer_outlined;
      case 'shipping':
        return Icons.local_shipping_outlined;
      default:
        return Icons.notifications_outlined;
    }
  }

  Color _getNotificationColor(BuildContext context, String type) {
    switch (type) {
      case 'payment':
        return Colors.orange;
      case 'approval':
        return Colors.green;
      case 'promo':
        return Theme.of(context).primaryColor;
      case 'shipping':
        return Colors.blue;
      default:
        return Theme.of(context).primaryColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isRead = notification['isRead'] as bool;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: isRead
            ? Theme.of(context).cardColor
            : Theme.of(context).primaryColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.5),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: _getNotificationColor(context, notification['type'])
                .withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            _getNotificationIcon(notification['type']),
            color: _getNotificationColor(context, notification['type']),
            size: 24,
          ),
        ),
        title: Text(
          notification['title'],
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: isRead ? FontWeight.w500 : FontWeight.w600,
              ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              notification['message'],
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.color
                        ?.withValues(alpha: 0.8),
                  ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Text(
              notification['time'],
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.color
                        ?.withValues(alpha: 0.6),
                  ),
            ),
          ],
        ),
        trailing: !isRead
            ? Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  shape: BoxShape.circle,
                ),
              )
            : null,
        onTap: () {
          HapticFeedback.lightImpact();

          // Show detailed notification
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(notification['title']),
              content: Text(notification['message']),
              actions: [
                if (notification['type'] == 'payment')
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Mengarahkan ke halaman pembayaran...'),
                        ),
                      );
                    },
                    child: const Text('Bayar Sekarang'),
                  ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Tutup'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
