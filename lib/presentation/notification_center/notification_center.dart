import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './models/notification_model.dart';
import './widgets/notification_filter_tabs_widget.dart';
import './widgets/notification_list_widget.dart';

class NotificationCenter extends StatefulWidget {
  const NotificationCenter({Key? key}) : super(key: key);

  @override
  State<NotificationCenter> createState() => _NotificationCenterState();
}

class _NotificationCenterState extends State<NotificationCenter>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedFilterIndex = 0;
  List<NotificationModel> _allNotifications = [];
  List<NotificationModel> _filteredNotifications = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _generateDummyNotifications();
    _filterNotifications();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _generateDummyNotifications() {
    _allNotifications = [
      // Credit Payment Notifications
      NotificationModel(
        id: '1',
        title: 'Pembayaran Kredit Jatuh Tempo',
        message:
            'Pembayaran kredit untuk invoice #INV2025-001 sebesar Rp 15.750.000 akan jatuh tempo pada 28 Januari 2025. Segera lakukan pembayaran untuk menghindari denda keterlambatan.',
        type: NotificationType.payment,
        timestamp: DateTime.now().subtract(Duration(hours: 2)),
        isRead: false,
        amount: 15750000,
        dueDate: DateTime(2025, 1, 28),
        invoiceNumber: 'INV2025-001',
      ),

      NotificationModel(
        id: '2',
        title: 'Reminder Pembayaran Kredit',
        message:
            'Pembayaran kredit untuk invoice #INV2025-003 sebesar Rp 8.500.000 akan jatuh tempo dalam 3 hari (31 Januari 2025). Silakan persiapkan pembayaran Anda.',
        type: NotificationType.payment,
        timestamp: DateTime.now().subtract(Duration(hours: 6)),
        isRead: false,
        amount: 8500000,
        dueDate: DateTime(2025, 1, 31),
        invoiceNumber: 'INV2025-003',
      ),

      NotificationModel(
        id: '3',
        title: 'Pembayaran Kredit Berhasil',
        message:
            'Pembayaran kredit untuk invoice #INV2024-129 sebesar Rp 12.250.000 telah berhasil diproses. Terima kasih atas pembayaran tepat waktu Anda.',
        type: NotificationType.payment,
        timestamp: DateTime.now().subtract(Duration(days: 1)),
        isRead: true,
        amount: 12250000,
        invoiceNumber: 'INV2024-129',
      ),

      NotificationModel(
        id: '4',
        title: 'Kredit Limit Tersedia',
        message:
            'Selamat! Limit kredit Anda telah ditingkatkan menjadi Rp 50.000.000. Manfaatkan fasilitas kredit untuk pembelian peralatan dental terbaru.',
        type: NotificationType.payment,
        timestamp: DateTime.now().subtract(Duration(days: 2)),
        isRead: false,
        amount: 50000000,
      ),

      // Order Status Notifications
      NotificationModel(
        id: '5',
        title: 'Pesanan Sedang Diproses',
        message:
            'Pesanan #ORD2025-045 untuk Dental Unit Chair telah diterima dan sedang diproses. Estimasi pengiriman 3-5 hari kerja.',
        type: NotificationType.order,
        timestamp: DateTime.now().subtract(Duration(hours: 4)),
        isRead: false,
        orderNumber: 'ORD2025-045',
        productName: 'Dental Unit Chair',
        productImage:
            'https://images.pexels.com/photos/6812439/pexels-photo-6812439.jpeg',
      ),

      NotificationModel(
        id: '6',
        title: 'Pesanan Dalam Pengiriman',
        message:
            'Pesanan #ORD2025-042 untuk Ultrasonic Scaler sedang dalam perjalanan. Nomor resi: JNE123456789. Estimasi tiba besok.',
        type: NotificationType.order,
        timestamp: DateTime.now().subtract(Duration(days: 1)),
        isRead: true,
        orderNumber: 'ORD2025-042',
        productName: 'Ultrasonic Scaler',
        productImage:
            'https://images.pexels.com/photos/6812542/pexels-photo-6812542.jpeg',
        trackingNumber: 'JNE123456789',
      ),

      // Promotional Notifications
      NotificationModel(
        id: '7',
        title: 'Flash Sale 30% OFF!',
        message:
            'Jangan lewatkan Flash Sale spesial untuk seluruh koleksi Dental Handpiece. Diskon hingga 30% berlaku hingga 30 Januari 2025.',
        type: NotificationType.promotion,
        timestamp: DateTime.now().subtract(Duration(hours: 8)),
        isRead: false,
        discountPercentage: 30,
        expiryDate: DateTime(2025, 1, 30),
      ),

      NotificationModel(
        id: '8',
        title: 'Program Cashback Spesial',
        message:
            'Dapatkan cashback hingga Rp 2.000.000 untuk pembelian dental equipment di atas Rp 20.000.000. Program berlaku sampai akhir bulan!',
        type: NotificationType.promotion,
        timestamp: DateTime.now().subtract(Duration(days: 3)),
        isRead: false,
        cashbackAmount: 2000000,
        minimumPurchase: 20000000,
        expiryDate: DateTime(2025, 1, 31),
      ),
    ];
  }

  void _filterNotifications() {
    setState(() {
      switch (_selectedFilterIndex) {
        case 0: // All
          _filteredNotifications = List.from(_allNotifications);
          break;
        case 1: // Payments
          _filteredNotifications = _allNotifications
              .where((n) => n.type == NotificationType.payment)
              .toList();
          break;
        case 2: // Orders
          _filteredNotifications = _allNotifications
              .where((n) => n.type == NotificationType.order)
              .toList();
          break;
        case 3: // Promotions
          _filteredNotifications = _allNotifications
              .where((n) => n.type == NotificationType.promotion)
              .toList();
          break;
      }

      // Sort by timestamp (newest first)
      _filteredNotifications.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    });
  }

  void _onFilterChanged(int index) {
    setState(() {
      _selectedFilterIndex = index;
    });
    _filterNotifications();
  }

  void _markAllAsRead() {
    setState(() {
      for (var notification in _allNotifications) {
        notification.isRead = true;
      }
    });
    _filterNotifications();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Semua notifikasi telah ditandai sebagai telah dibaca'),
        backgroundColor: AppTheme.successLight,
      ),
    );
  }

  void _onNotificationTap(NotificationModel notification) {
    if (!notification.isRead) {
      setState(() {
        notification.isRead = true;
      });
      _filterNotifications();
    }

    // Handle different notification types
    switch (notification.type) {
      case NotificationType.payment:
        _showPaymentDialog(notification);
        break;
      case NotificationType.order:
        _showOrderDialog(notification);
        break;
      case NotificationType.promotion:
        _showPromotionDialog(notification);
        break;
    }
  }

  void _showPaymentDialog(NotificationModel notification) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Detail Pembayaran',
          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (notification.invoiceNumber != null) ...[
              Text('Invoice: ${notification.invoiceNumber}'),
              SizedBox(height: 1.h),
            ],
            if (notification.amount != null) ...[
              Text('Jumlah: ${_formatCurrency(notification.amount!)}'),
              SizedBox(height: 1.h),
            ],
            if (notification.dueDate != null) ...[
              Text('Jatuh Tempo: ${_formatDate(notification.dueDate!)}'),
              SizedBox(height: 1.h),
            ],
            Text(notification.message),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Tutup'),
          ),
          if (notification.dueDate != null &&
              notification.dueDate!.isAfter(DateTime.now()))
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Mengarahkan ke halaman pembayaran...'),
                    backgroundColor: AppTheme.primaryLight,
                  ),
                );
              },
              child: Text('Bayar Sekarang'),
            ),
        ],
      ),
    );
  }

  void _showOrderDialog(NotificationModel notification) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Detail Pesanan',
          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (notification.orderNumber != null) ...[
              Text('Nomor Pesanan: ${notification.orderNumber}'),
              SizedBox(height: 1.h),
            ],
            if (notification.productName != null) ...[
              Text('Produk: ${notification.productName}'),
              SizedBox(height: 1.h),
            ],
            if (notification.trackingNumber != null) ...[
              Text('Nomor Resi: ${notification.trackingNumber}'),
              SizedBox(height: 1.h),
            ],
            Text(notification.message),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Tutup'),
          ),
          if (notification.trackingNumber != null)
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Melacak paket...'),
                    backgroundColor: AppTheme.primaryLight,
                  ),
                );
              },
              child: Text('Lacak Paket'),
            ),
        ],
      ),
    );
  }

  void _showPromotionDialog(NotificationModel notification) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Detail Promosi',
          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (notification.discountPercentage != null) ...[
              Text('Diskon: ${notification.discountPercentage}%'),
              SizedBox(height: 1.h),
            ],
            if (notification.cashbackAmount != null) ...[
              Text(
                  'Cashback: ${_formatCurrency(notification.cashbackAmount!)}'),
              SizedBox(height: 1.h),
            ],
            if (notification.minimumPurchase != null) ...[
              Text(
                  'Min. Pembelian: ${_formatCurrency(notification.minimumPurchase!)}'),
              SizedBox(height: 1.h),
            ],
            if (notification.expiryDate != null) ...[
              Text('Berlaku Sampai: ${_formatDate(notification.expiryDate!)}'),
              SizedBox(height: 1.h),
            ],
            Text(notification.message),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Tutup'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRoutes.productCatalog);
            },
            child: Text('Belanja Sekarang'),
          ),
        ],
      ),
    );
  }

  String _formatCurrency(double amount) {
    return 'Rp ${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: Text('Notifikasi'),
        actions: [
          IconButton(
            icon: Icon(Icons.mark_email_read_outlined),
            onPressed: _markAllAsRead,
            tooltip: 'Tandai Semua Sebagai Dibaca',
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Tabs
          NotificationFilterTabsWidget(
            selectedIndex: _selectedFilterIndex,
            onFilterChanged: _onFilterChanged,
            allCount: _allNotifications.length,
            paymentCount: _allNotifications
                .where((n) => n.type == NotificationType.payment)
                .length,
            orderCount: _allNotifications
                .where((n) => n.type == NotificationType.order)
                .length,
            promotionCount: _allNotifications
                .where((n) => n.type == NotificationType.promotion)
                .length,
          ),

          // Notifications List
          Expanded(
            child: _filteredNotifications.isEmpty
                ? _buildEmptyState()
                : NotificationListWidget(
                    notifications: _filteredNotifications,
                    onNotificationTap: _onNotificationTap,
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none_outlined,
            size: 64.sp,
            color: AppTheme.textDisabledLight,
          ),
          SizedBox(height: 2.h),
          Text(
            'Tidak ada notifikasi',
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: AppTheme.textSecondaryLight,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Semua notifikasi akan muncul di sini',
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: AppTheme.textDisabledLight,
            ),
          ),
        ],
      ),
    );
  }
}
