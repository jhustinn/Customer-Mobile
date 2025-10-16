import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/app_export.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_app_bar.dart';
import '../order_tracking/order_tracking.dart';
import './widgets/delivery_info_widget.dart';
import './widgets/invoice_details_widget.dart';
import './widgets/order_actions_widget.dart';
import './widgets/order_progress_timeline_widget.dart';
import './widgets/payment_status_widget.dart';

/// Order Detail Tracking screen provides comprehensive invoice status monitoring
/// for individual B2B dental orders through mobile-optimized interface
class OrderDetailTracking extends StatefulWidget {
  const OrderDetailTracking({super.key});

  @override
  State<OrderDetailTracking> createState() => _OrderDetailTrackingState();
}

class _OrderDetailTrackingState extends State<OrderDetailTracking>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  OrderDetailData? orderData;
  bool isLoading = true;
  String? orderId;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();

    // Get order ID from route arguments
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null) {
        orderId = args['orderId'] as String?;
      }
      _loadOrderDetails();
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  /// Initialize pulse animation for active status
  void _initializeAnimations() {
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _pulseController.repeat(reverse: true);
  }

  /// Load comprehensive order details with invoice status
  Future<void> _loadOrderDetails() async {
    setState(() => isLoading = true);

    // Simulate API call with realistic delay
    await Future.delayed(const Duration(milliseconds: 1200));

    setState(() {
      orderData = _getMockOrderDetails();
      isLoading = false;
    });
  }

  /// Refresh tracking data with pull-to-refresh
  Future<void> _refreshTrackingData() async {
    HapticFeedback.lightImpact();
    await _loadOrderDetails();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.refresh, color: AppTheme.backgroundLight, size: 16),
              const SizedBox(width: 8),
              Text('Data tracking telah diperbarui'),
            ],
          ),
          backgroundColor: AppTheme.successLight,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Detail Lacak Pesanan', centerTitle: true),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : orderData == null
              ? _buildErrorState()
              : RefreshIndicator(
                onRefresh: _refreshTrackingData,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Order Header Information
                      _buildOrderHeader(),

                      const SizedBox(height: 24),

                      // Visual Progress Timeline
                      OrderProgressTimelineWidget(
                        currentStatus: orderData!.currentStatus,
                        statusHistory: orderData!.statusHistory,
                        pulseAnimation: _pulseAnimation,
                      ),

                      const SizedBox(height: 24),

                      // Invoice Details Section
                      InvoiceDetailsWidget(
                        items: orderData!.items,
                        subtotal: orderData!.subtotal,
                        tax: orderData!.tax,
                        total: orderData!.totalAmount,
                        supplierInfo: orderData!.supplierInfo,
                      ),

                      const SizedBox(height: 24),

                      // Payment Status Section
                      PaymentStatusWidget(
                        invoiceAmount: orderData!.totalAmount,
                        paymentMethod: orderData!.paymentMethod,
                        dueDate: orderData!.dueDate,
                        outstandingBalance: orderData!.outstandingBalance,
                        isPaid: orderData!.isPaid,
                      ),

                      const SizedBox(height: 24),

                      // Delivery Information
                      if (orderData!.currentStatus.index >=
                          OrderDetailStatus.shipped.index)
                        DeliveryInfoWidget(
                          trackingNumber: orderData!.trackingNumber,
                          carrier: orderData!.carrier,
                          estimatedArrival: orderData!.estimatedArrival,
                          deliveryAddress: orderData!.deliveryAddress,
                        ),

                      const SizedBox(height: 24),

                      // Action Buttons based on current status
                      OrderActionsWidget(
                        currentStatus: orderData!.currentStatus,
                        orderId: orderData!.id,
                        onAction: _handleOrderAction,
                      ),

                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
    );
  }

  /// Build order header with basic information
  Widget _buildOrderHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.backgroundLight,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Order #${orderData!.orderNumber}',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _getStatusColor(orderData!.currentStatus),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _getStatusText(orderData!.currentStatus),
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Icon(
                Icons.calendar_today_outlined,
                size: 16,
                color: AppTheme.textSecondaryLight,
              ),
              const SizedBox(width: 6),
              Text(
                'Tanggal: ${_formatDate(orderData!.orderDate)}',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppTheme.textSecondaryLight,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Row(
            children: [
              Icon(
                Icons.business_outlined,
                size: 16,
                color: AppTheme.textSecondaryLight,
              ),
              const SizedBox(width: 6),
              Text(
                orderData!.customerBusinessName,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppTheme.textSecondaryLight,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Build error state when order data cannot be loaded
  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: AppTheme.errorLight),
          const SizedBox(height: 16),
          Text(
            'Gagal memuat detail pesanan',
            style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            'Pastikan koneksi internet Anda stabil',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppTheme.textSecondaryLight,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _loadOrderDetails,
            child: Text('Coba Lagi'),
          ),
        ],
      ),
    );
  }

  /// Handle order-specific actions based on current status
  void _handleOrderAction(OrderDetailAction action) {
    switch (action) {
      case OrderDetailAction.cancelOrder:
        _showCancelOrderDialog();
        break;
      case OrderDetailAction.contactAdmin:
        _showContactAdminOptions();
        break;
      case OrderDetailAction.trackShipment:
        _openShipmentTracking();
        break;
      case OrderDetailAction.downloadInvoice:
        _downloadInvoice();
        break;
      case OrderDetailAction.payNow:
        _proceedToPayment();
        break;
      case OrderDetailAction.contactSupplier:
        _contactSupplier();
        break;
    }
  }

  /// Show order cancellation dialog
  void _showCancelOrderDialog() {
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
                          'Pembatalan pesanan akan dikonfirmasi oleh admin dalam 1x24 jam.',
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
                  Navigator.pop(context);
                  HapticFeedback.mediumImpact();
                  _processCancellation();
                },
                child: Text('Batalkan Pesanan'),
              ),
            ],
          ),
    );
  }

  /// Process order cancellation
  void _processCancellation() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: AppTheme.backgroundLight, size: 16),
            const SizedBox(width: 8),
            Text('Permintaan pembatalan telah dikirim ke admin'),
          ],
        ),
        backgroundColor: AppTheme.warningLight,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// Show contact admin options
  void _showContactAdminOptions() {
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
                  () => Navigator.pop(context),
                ),
                _buildContactOption(
                  Icons.email,
                  'Email',
                  'admin@cobradental.co.id',
                  () => Navigator.pop(context),
                ),
                _buildContactOption(
                  Icons.chat,
                  'Live Chat',
                  'Chat dengan customer service',
                  () => Navigator.pop(context),
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

  /// Open shipment tracking with real-time updates
  void _openShipmentTracking() {
    Navigator.pushNamed(
      context,
      '/shipment-tracking', // Would need to create this route
      arguments: {
        'trackingNumber': orderData!.trackingNumber,
        'carrier': orderData!.carrier,
      },
    );
  }

  /// Download invoice functionality
  void _downloadInvoice() {
    HapticFeedback.mediumImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.download, color: AppTheme.backgroundLight, size: 16),
            const SizedBox(width: 8),
            Text('Invoice sedang diunduh...'),
          ],
        ),
        backgroundColor: AppTheme.successLight,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// Proceed to payment for outstanding balance
  void _proceedToPayment() {
    Navigator.pushNamed(
      context,
      '/payment', // Would need to create this route
      arguments: {
        'orderId': orderData!.id,
        'amount': orderData!.outstandingBalance,
      },
    );
  }

  /// Contact supplier directly
  void _contactSupplier() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Menghubungi ${orderData!.supplierInfo.name}...'),
        backgroundColor: AppTheme.primaryLight,
      ),
    );
  }

  /// Get status color based on order status
  Color _getStatusColor(OrderDetailStatus status) {
    switch (status) {
      case OrderDetailStatus.pending:
        return AppTheme.warningLight;
      case OrderDetailStatus.approved:
        return AppTheme.primaryLight;
      case OrderDetailStatus.processing:
        return const Color(0xFFFF8C00);
      case OrderDetailStatus.shipped:
        return AppTheme.successLight;
      case OrderDetailStatus.completed:
        return AppTheme.secondaryLight;
    }
  }

  /// Get status text in Indonesian
  String _getStatusText(OrderDetailStatus status) {
    switch (status) {
      case OrderDetailStatus.pending:
        return 'Pending';
      case OrderDetailStatus.approved:
        return 'Disetujui Admin';
      case OrderDetailStatus.processing:
        return 'Diproses';
      case OrderDetailStatus.shipped:
        return 'Dikirim';
      case OrderDetailStatus.completed:
        return 'Selesai';
    }
  }

  /// Format date for display
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  /// Mock order details data
  OrderDetailData _getMockOrderDetails() {
    return OrderDetailData(
      id: orderId ?? 'ord_001',
      orderNumber: 'CB2024-001234',
      orderDate: DateTime.now().subtract(const Duration(days: 2)),
      customerBusinessName: 'Klinik Dental Premium Jakarta',
      currentStatus: OrderDetailStatus.processing,
      items: [
        OrderDetailItem(
          id: 'item_001',
          name: 'Dental Unit Chair Premium',
          description: 'Premium dental chair dengan fitur canggih',
          quantity: 1,
          unitPrice: 25000000,
          imageUrl:
              'https://images.unsplash.com/photo-1559757148-5c350d0d3c56?w=400',
          sku: 'DUC-P001',
        ),
        OrderDetailItem(
          id: 'item_002',
          name: 'Autoclave Sterilizer 18L',
          description: 'Autoclave sterilizer kapasitas besar',
          quantity: 2,
          unitPrice: 8500000,
          imageUrl:
              'https://images.unsplash.com/photo-1559757175-0eb30cd8c063?w=400',
          sku: 'AS-18L001',
        ),
      ],
      subtotal: 42000000,
      tax: 4200000,
      totalAmount: 46200000,
      paymentMethod: 'Bank Transfer',
      dueDate: DateTime.now().add(const Duration(days: 30)),
      outstandingBalance: 46200000,
      isPaid: false,
      trackingNumber: 'CB123456789',
      carrier: 'Cobra Logistics',
      estimatedArrival: DateTime.now().add(const Duration(days: 3)),
      deliveryAddress: 'Jl. Sudirman No. 123, Jakarta Selatan 12190',
      supplierInfo: SupplierInfo(
        name: 'PT Dental Supply Indonesia',
        contact: '+62 21 5678 9012',
        email: 'info@dentalsupply.co.id',
      ),
      statusHistory: [
        StatusHistoryDetail(
          status: OrderDetailStatus.pending,
          timestamp: DateTime.now().subtract(const Duration(days: 2)),
          description:
              'Pesanan diterima dan menunggu konfirmasi admin departemen',
        ),
        StatusHistoryDetail(
          status: OrderDetailStatus.approved,
          timestamp: DateTime.now().subtract(const Duration(days: 1)),
          description:
              'Pesanan disetujui oleh admin dan diteruskan ke supplier',
        ),
        StatusHistoryDetail(
          status: OrderDetailStatus.processing,
          timestamp: DateTime.now().subtract(const Duration(hours: 8)),
          description: 'Pesanan sedang diproses dan disiapkan untuk pengiriman',
        ),
      ],
    );
  }
}

/// Order detail status enum with comprehensive B2B workflow
enum OrderDetailStatus { pending, approved, processing, shipped, completed }

/// Order detail action enum
enum OrderDetailAction {
  cancelOrder,
  contactAdmin,
  trackShipment,
  downloadInvoice,
  payNow,
  contactSupplier,
}

/// Comprehensive order detail data model
class OrderDetailData {
  final String id;
  final String orderNumber;
  final DateTime orderDate;
  final String customerBusinessName;
  final OrderDetailStatus currentStatus;
  final List<OrderDetailItem> items;
  final double subtotal;
  final double tax;
  final double totalAmount;
  final String paymentMethod;
  final DateTime dueDate;
  final double outstandingBalance;
  final bool isPaid;
  final String trackingNumber;
  final String carrier;
  final DateTime estimatedArrival;
  final String deliveryAddress;
  final SupplierInfo supplierInfo;
  final List<StatusHistoryDetail> statusHistory;

  const OrderDetailData({
    required this.id,
    required this.orderNumber,
    required this.orderDate,
    required this.customerBusinessName,
    required this.currentStatus,
    required this.items,
    required this.subtotal,
    required this.tax,
    required this.totalAmount,
    required this.paymentMethod,
    required this.dueDate,
    required this.outstandingBalance,
    required this.isPaid,
    required this.trackingNumber,
    required this.carrier,
    required this.estimatedArrival,
    required this.deliveryAddress,
    required this.supplierInfo,
    required this.statusHistory,
  });
}

/// Order detail item model
class OrderDetailItem {
  final String id;
  final String name;
  final String description;
  final int quantity;
  final double unitPrice;
  final String imageUrl;
  final String sku;

  const OrderDetailItem({
    required this.id,
    required this.name,
    required this.description,
    required this.quantity,
    required this.unitPrice,
    required this.imageUrl,
    required this.sku,
  });

  double get totalPrice => unitPrice * quantity;
}

/// Supplier information model
class SupplierInfo {
  final String name;
  final String contact;
  final String email;

  const SupplierInfo({
    required this.name,
    required this.contact,
    required this.email,
  });
}

/// Status history detail model
class StatusHistoryDetail {
  final OrderDetailStatus status;
  final DateTime timestamp;
  final String description;

  const StatusHistoryDetail({
    required this.status,
    required this.timestamp,
    required this.description,
  });
}
