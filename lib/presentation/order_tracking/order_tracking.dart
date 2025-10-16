import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/app_export.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_app_bar.dart';
import './widgets/delivery_tracking_widget.dart';
import './widgets/order_status_timeline.dart';

/// Order Tracking screen for B2B dental customers to monitor comprehensive order status
class OrderTracking extends StatefulWidget {
  const OrderTracking({super.key});

  @override
  State<OrderTracking> createState() => _OrderTrackingState();
}

class _OrderTrackingState extends State<OrderTracking>
    with TickerProviderStateMixin {
  late TabController _tabController;
  List<Order> orders = [];
  bool isLoading = true;
  String selectedFilter = 'Semua';

  // Order data from arguments
  String? specificOrderId;
  Map<String, dynamic>? specificOrderData;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);

    // Get specific order data from arguments if navigated from checkout success
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null) {
        specificOrderId = args['orderId'] as String?;
        specificOrderData = args['orderData'] as Map<String, dynamic>?;
      }
      _loadOrders();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /// Load orders with optional specific order from checkout
  Future<void> _loadOrders() async {
    setState(() => isLoading = true);

    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 1000));

    setState(() {
      orders = _getMockOrders();

      // If coming from checkout success, add the new order at the top
      if (specificOrderId != null && specificOrderData != null) {
        final newOrder = Order(
          id: specificOrderId!,
          customerName: 'Klinik Dental Premium',
          items: _parseOrderItems(specificOrderData!['items'] as List),
          totalAmount: specificOrderData!['total'] as double,
          orderDate: DateTime.now(),
          status: OrderStatus.pending,
          estimatedDelivery:
              specificOrderData!['estimatedDelivery'] as DateTime,
          trackingNumber:
              'CB${specificOrderId!.substring(specificOrderId!.length - 6)}',
          deliveryAddress: 'Jl. Sudirman No. 123, Jakarta Selatan',
          paymentMethod: 'Bank Transfer',
          statusHistory: [
            StatusUpdate(
              status: OrderStatus.pending,
              timestamp: DateTime.now(),
              description: 'Pesanan diterima dan menunggu konfirmasi admin',
            ),
          ],
        );

        orders.insert(0, newOrder);
      }

      isLoading = false;
    });
  }

  /// Parse order items from checkout data
  List<OrderItem> _parseOrderItems(List items) {
    return items
        .map(
          (item) => OrderItem(
            id: item['id'] as String? ?? '',
            productId: item['productId'] as String? ?? '',
            name: item['name'] as String,
            description: item['description'] as String? ?? '',
            quantity: item['quantity'] as int,
            unitPrice: item['price'] as double,
            imageUrl:
                'https://images.unsplash.com/photo-1559757148-5c350d0d3c56?w=400',
            supplierName: item['supplierName'] as String? ?? 'Unknown',
            sku: item['sku'] as String? ?? '',
          ),
        )
        .cast<OrderItem>()
        .toList();
  }

  /// Refresh order tracking information with haptic feedback
  Future<void> _refreshTracking() async {
    HapticFeedback.lightImpact();

    await _loadOrders();

    // Show refresh confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.refresh, color: AppTheme.backgroundLight, size: 16),
            const SizedBox(width: 8),
            Text('Status pesanan telah diperbarui'),
          ],
        ),
        backgroundColor: AppTheme.successLight,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// Handle order-specific actions based on current status
  void _handleOrderAction(OrderAction action) {
    switch (action) {
      case OrderAction.cancel:
        _showCancelDialog();
        break;
      case OrderAction.contactAdmin:
        _contactAdminSupport();
        break;
      case OrderAction.trackShipment:
        _showTrackingDetails();
        break;
      case OrderAction.rateOrder:
        _showRatingDialog();
        break;
      case OrderAction.reorder:
        _handleReorder();
        break;
      case OrderAction.downloadReceipt:
        _downloadReceipt();
        break;
    }
  }

  /// Show order cancellation dialog with confirmation
  void _showCancelDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              'Batalkan Pesanan',
              style: GoogleFonts.inter(fontWeight: FontWeight.w600),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Apakah Anda yakin ingin membatalkan pesanan ini?',
                  style: GoogleFonts.inter(),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.warningLight.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.warning_amber,
                        color: AppTheme.warningLight,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Pembatalan hanya dapat dilakukan dalam status Pending',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: AppTheme.warningLight,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Kembali'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.errorLight,
                ),
                onPressed: () {
                  // Handle cancellation
                  Navigator.pop(context);
                  HapticFeedback.mediumImpact();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Permintaan pembatalan telah dikirim'),
                      backgroundColor: AppTheme.errorLight,
                    ),
                  );
                },
                child: Text('Batalkan Pesanan'),
              ),
            ],
          ),
    );
  }

  /// Contact admin support for order inquiries
  void _contactAdminSupport() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppTheme.dividerLight,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Hubungi Admin',
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                _buildContactOption(
                  Icons.phone,
                  'Telepon',
                  '+62 21 1234 5678',
                  () {
                    Navigator.pop(context);
                    // Handle phone call
                  },
                ),
                _buildContactOption(
                  Icons.email,
                  'Email',
                  'support@cobradental.co.id',
                  () {
                    Navigator.pop(context);
                    // Handle email
                  },
                ),
                _buildContactOption(
                  Icons.chat,
                  'Live Chat',
                  'Chat dengan customer service',
                  () {
                    Navigator.pop(context);
                    // Handle live chat
                  },
                ),
                SizedBox(height: MediaQuery.of(context).viewInsets.bottom + 16),
              ],
            ),
          ),
    );
  }

  /// Build contact option tile
  Widget _buildContactOption(
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: AppTheme.primaryLight.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: AppTheme.primaryLight),
      ),
      title: Text(title, style: GoogleFonts.inter(fontWeight: FontWeight.w500)),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.inter(
          fontSize: 12,
          color: AppTheme.textSecondaryLight,
        ),
      ),
      trailing: Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  /// Show detailed shipment tracking with map view
  void _showTrackingDetails() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            height: MediaQuery.of(context).size.height * 0.8,
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        'Detail Pengiriman',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Order ID: ${orders.isNotEmpty ? orders[0].id : ''}',
                        style: GoogleFonts.inter(fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Kurir: Cobra Logistics',
                        style: GoogleFonts.inter(fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Estimasi Pengiriman: ${_formatDate(DateTime.now().add(const Duration(days: 2)))}',
                        style: GoogleFonts.inter(fontSize: 14),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: DeliveryTrackingWidget(
                    orderId: orders.isNotEmpty ? orders[0].id : '',
                    courierName: 'Cobra Logistics',
                    estimatedDelivery: DateTime.now().add(
                      const Duration(days: 2),
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  /// Show rating dialog for completed orders
  void _showRatingDialog() {
    int rating = 0;
    String feedback = '';

    showDialog(
      context: context,
      builder:
          (context) => StatefulBuilder(
            builder:
                (context, setStateDialog) => AlertDialog(
                  title: Text(
                    'Beri Rating Pesanan',
                    style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Bagaimana pengalaman Anda dengan pesanan ini?',
                        style: GoogleFonts.inter(),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(5, (index) {
                          return IconButton(
                            onPressed: () {
                              setStateDialog(() {
                                rating = index + 1;
                              });
                              HapticFeedback.selectionClick();
                            },
                            icon: Icon(
                              index < rating ? Icons.star : Icons.star_border,
                              color: AppTheme.accentLight,
                              size: 32,
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Berikan feedback (opsional)',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        maxLines: 3,
                        onChanged: (value) => feedback = value,
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Nanti'),
                    ),
                    ElevatedButton(
                      onPressed:
                          rating > 0
                              ? () {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Terima kasih atas rating Anda!',
                                    ),
                                    backgroundColor: AppTheme.successLight,
                                  ),
                                );
                              }
                              : null,
                      child: Text('Kirim Rating'),
                    ),
                  ],
                ),
          ),
    );
  }

  /// Handle reorder functionality
  void _handleReorder() {
    Navigator.pushNamed(context, AppRoutes.productCatalog);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Item pesanan telah ditambahkan ke keranjang'),
      ),
    );
  }

  /// Download receipt for completed orders
  void _downloadReceipt() {
    HapticFeedback.mediumImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.download, color: AppTheme.backgroundLight, size: 16),
            const SizedBox(width: 8),
            Text('Receipt berhasil diunduh'),
          ],
        ),
        backgroundColor: AppTheme.successLight,
      ),
    );
  }

  /// Show search dialog for finding specific orders
  void _showSearchDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Cari Pesanan'),
            content: TextField(
              decoration: InputDecoration(
                hintText: 'Masukkan ID pesanan atau nama produk',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (value) {
                Navigator.pop(context);
                // Implement search functionality
              },
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Batal'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cari'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Lacak Pesanan',
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Show search functionality
              _showSearchDialog();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Show specific order highlight if navigated from checkout
          if (specificOrderId != null) ...[
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.successLight.withAlpha(26),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.successLight),
              ),
              child: Row(
                children: [
                  Icon(Icons.check_circle, color: AppTheme.successLight),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pesanan Berhasil Dibuat!',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.successLight,
                          ),
                        ),
                        Text(
                          'ID Pesanan: $specificOrderId',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: AppTheme.textSecondaryLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],

          // Filter Tabs
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              labelColor: AppTheme.primaryLight,
              unselectedLabelColor: AppTheme.textSecondaryLight,
              labelStyle: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              indicatorColor: AppTheme.primaryLight,
              indicatorSize: TabBarIndicatorSize.label,
              tabs: const [
                Tab(text: 'Semua'),
                Tab(text: 'Pending'),
                Tab(text: 'Diproses'),
                Tab(text: 'Dikirim'),
                Tab(text: 'Selesai'),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Order List
          Expanded(
            child:
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : TabBarView(
                      controller: _tabController,
                      children: [
                        _buildOrdersList(_filterOrders('Semua')),
                        _buildOrdersList(_filterOrders('Pending')),
                        _buildOrdersList(_filterOrders('Approved Admin')),
                        _buildOrdersList(_filterOrders('Dikirim')),
                        _buildOrdersList(_filterOrders('Selesai')),
                      ],
                    ),
          ),
        ],
      ),
    );
  }

  /// Filter orders by status
  List<Order> _filterOrders(String filter) {
    return orders.where((order) {
      switch (filter) {
        case 'Semua':
          return true;
        case 'Pending':
          return order.status == OrderStatus.pending;
        case 'Diproses':
          return order.status == OrderStatus.processing;
        case 'Dikirim':
          return order.status == OrderStatus.shipping;
        case 'Selesai':
          return order.status == OrderStatus.completed;
        default:
          return true;
      }
    }).toList();
  }

  /// Build order list item
  Widget _buildOrdersList(List<Order> orders) {
    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            leading: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppTheme.surfaceLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl:
                      order.items.isNotEmpty
                          ? order.items[0].imageUrl
                          : 'https://images.unsplash.com/photo-1559757148-5c350d0d3c56?w=400',
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  placeholder:
                      (context, url) => Container(
                        width: 60,
                        height: 60,
                        color: AppTheme.surfaceLight,
                        child: const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                  errorWidget:
                      (context, url, error) => Container(
                        width: 60,
                        height: 60,
                        color: AppTheme.surfaceLight,
                        child: Icon(
                          Icons.image_not_supported,
                          color: AppTheme.textDisabledLight,
                        ),
                      ),
                ),
              ),
            ),
            title: Text(
              order.customerName,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ID: ${order.id}',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppTheme.textSecondaryLight,
                  ),
                ),
                Text(
                  'Total: ${_formatCurrency(order.totalAmount)}',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppTheme.textSecondaryLight,
                  ),
                ),
              ],
            ),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _getStatusColor(order.status),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                _getStatusText(order.status),
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
            onTap: () {
              // Navigate to order detail tracking
              Navigator.pushNamed(
                context,
                AppRoutes.orderDetailTracking,
                arguments: {'orderId': order.id},
              );
            },
          ),
        );
      },
    );
  }

  /// Get status color based on order status
  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return AppTheme.warningLight;
      case OrderStatus.approved:
        return AppTheme.primaryLight;
      case OrderStatus.processing:
        return const Color(0xFFFF8C00);
      case OrderStatus.shipping:
        return AppTheme.successLight;
      case OrderStatus.completed:
        return AppTheme.secondaryLight;
      case OrderStatus.cancelled:
        return AppTheme.errorLight;
    }
  }

  /// Get status text in Indonesian
  String _getStatusText(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.approved:
        return 'Disetujui Admin';
      case OrderStatus.processing:
        return 'Diproses';
      case OrderStatus.shipping:
        return 'Dikirim';
      case OrderStatus.completed:
        return 'Selesai';
      case OrderStatus.cancelled:
        return 'Dibatalkan';
    }
  }

  /// Format currency for display
  String _formatCurrency(double amount) {
    return 'Rp ${amount.toStringAsFixed(2).replaceFirst('0', '')}';
  }

  /// Format date for display
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  /// Format time for sync display
  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 1) {
      return 'Baru saja';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes} menit lalu';
    } else if (difference.inDays < 1) {
      return '${difference.inHours} jam lalu';
    } else {
      return '${difference.inDays} hari lalu';
    }
  }

  /// Mock order data for demonstration
  List<Order> _getMockOrders() {
    return [
      Order(
        id: 'ord_001',
        customerName: 'Klinik Dental Premium',
        items: [
          OrderItem(
            id: 'item_001',
            productId: 'prod_001',
            name: 'Dental Unit Chair Premium',
            description: 'Premium dental chair with advanced features',
            quantity: 1,
            unitPrice: 25000000,
            imageUrl:
                'https://images.unsplash.com/photo-1559757148-5c350d0d3c56?w=400',
            supplierName: 'Dental Supply Co.',
            sku: 'DSK-001',
          ),
          OrderItem(
            id: 'item_002',
            productId: 'prod_002',
            name: 'Autoclave Sterilizer 18L',
            description: 'High-capacity autoclave sterilizer',
            quantity: 2,
            unitPrice: 8500000,
            imageUrl:
                'https://images.unsplash.com/photo-1559757175-0eb30cd8c063?w=400',
            supplierName: 'Medical Equipment Ltd.',
            sku: 'AST-002',
          ),
        ],
        totalAmount: 45500000,
        orderDate: DateTime.now().subtract(const Duration(hours: 6)),
        status: OrderStatus.processing,
        estimatedDelivery: DateTime.now().add(const Duration(days: 3)),
        trackingNumber: 'CB123456',
        deliveryAddress: 'Jl. Sudirman No. 123, Jakarta Selatan',
        paymentMethod: 'Bank Transfer',
        statusHistory: [
          StatusUpdate(
            status: OrderStatus.pending,
            timestamp: DateTime.now().subtract(const Duration(hours: 6)),
            description: 'Pesanan diterima dan menunggu persetujuan admin',
          ),
          StatusUpdate(
            status: OrderStatus.approved,
            timestamp: DateTime.now().subtract(const Duration(hours: 4)),
            description: 'Pesanan disetujui oleh admin departemen',
          ),
          StatusUpdate(
            status: OrderStatus.processing,
            timestamp: DateTime.now().subtract(const Duration(hours: 2)),
            description: 'Pesanan sedang diproses dan disiapkan',
          ),
        ],
      ),
      Order(
        id: 'ord_002',
        customerName: 'Dental Clinic 2',
        items: [
          OrderItem(
            id: 'item_003',
            productId: 'prod_003',
            name: 'Dental Chair',
            description: 'Standard dental chair',
            quantity: 2,
            unitPrice: 15000000,
            imageUrl:
                'https://images.unsplash.com/photo-1559757148-5c350d0d3c56?w=400',
            supplierName: 'Dental Supply Co.',
            sku: 'DSK-003',
          ),
        ],
        totalAmount: 30000000,
        orderDate: DateTime.now().subtract(const Duration(days: 10)),
        status: OrderStatus.shipping,
        estimatedDelivery: DateTime.now().add(const Duration(days: 5)),
        trackingNumber: 'CB987654',
        deliveryAddress: 'Jl. Jenderal Sudirman No. 100, Jakarta Pusat',
        paymentMethod: 'Credit Card',
        statusHistory: [
          StatusUpdate(
            status: OrderStatus.pending,
            timestamp: DateTime.now().subtract(const Duration(days: 10)),
            description: 'Pesanan diterima dan menunggu persetujuan admin',
          ),
          StatusUpdate(
            status: OrderStatus.approved,
            timestamp: DateTime.now().subtract(const Duration(days: 8)),
            description: 'Pesanan disetujui oleh admin departemen',
          ),
          StatusUpdate(
            status: OrderStatus.processing,
            timestamp: DateTime.now().subtract(const Duration(days: 6)),
            description: 'Pesanan sedang diproses dan disiapkan',
          ),
          StatusUpdate(
            status: OrderStatus.shipping,
            timestamp: DateTime.now().subtract(const Duration(days: 4)),
            description: 'Pesanan telah dikirim ke kurir',
          ),
        ],
      ),
    ];
  }
}

/// Order status enum
enum OrderStatus {
  pending,
  approved,
  processing,
  shipping,
  completed,
  cancelled,
}

/// Order action enum
enum OrderAction {
  cancel,
  contactAdmin,
  trackShipment,
  rateOrder,
  reorder,
  downloadReceipt,
}

/// Order data model
class OrderData {
  final String id;
  final String orderNumber;
  final DateTime orderDate;
  final OrderStatus status;
  final double totalAmount;
  final List<OrderItem> items;
  final List<StatusHistoryItem> statusHistory;
  final String shippingAddress;
  final DateTime? estimatedDelivery;

  const OrderData({
    required this.id,
    required this.orderNumber,
    required this.orderDate,
    required this.status,
    required this.totalAmount,
    required this.items,
    required this.statusHistory,
    required this.shippingAddress,
    this.estimatedDelivery,
  });
}

/// Order item model
class OrderItem {
  final String id;
  final String productId;
  final String name;
  final String description;
  final int quantity;
  final double unitPrice;
  final String imageUrl;
  final String supplierName;
  final String sku;

  const OrderItem({
    required this.id,
    required this.productId,
    required this.name,
    required this.description,
    required this.quantity,
    required this.unitPrice,
    required this.imageUrl,
    required this.supplierName,
    required this.sku,
  });

  double get totalPrice => unitPrice * quantity;
}

/// Status history item model
class StatusHistoryItem {
  final OrderStatus status;
  final DateTime timestamp;
  final String description;

  const StatusHistoryItem({
    required this.status,
    required this.timestamp,
    required this.description,
  });
}

/// Order model
class Order {
  final String id;
  final String customerName;
  final List<OrderItem> items;
  final double totalAmount;
  final DateTime orderDate;
  final OrderStatus status;
  final DateTime? estimatedDelivery;
  final String trackingNumber;
  final String deliveryAddress;
  final String paymentMethod;
  final List<StatusUpdate> statusHistory;

  const Order({
    required this.id,
    required this.customerName,
    required this.items,
    required this.totalAmount,
    required this.orderDate,
    required this.status,
    this.estimatedDelivery,
    required this.trackingNumber,
    required this.deliveryAddress,
    required this.paymentMethod,
    required this.statusHistory,
  });
}

/// Status update model
class StatusUpdate {
  final OrderStatus status;
  final DateTime timestamp;
  final String description;

  const StatusUpdate({
    required this.status,
    required this.timestamp,
    required this.description,
  });
}
