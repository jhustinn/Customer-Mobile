import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../shopping_cart/shopping_cart.dart';
import './widgets/delivery_address_section.dart';
import './widgets/order_review_section.dart';
import './widgets/order_success_widget.dart';
import './widgets/payment_method_section.dart';
import './widgets/step_progress_indicator.dart';

/// Checkout process screen with multi-step wizard for B2B dental customers
class CheckoutProcess extends StatefulWidget {
  const CheckoutProcess({super.key});

  @override
  State<CheckoutProcess> createState() => _CheckoutProcessState();
}

class _CheckoutProcessState extends State<CheckoutProcess>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _loadingController;

  int _currentStep = 0;
  bool _isSubmitting = false;
  bool _orderCompleted = false;
  String? _orderId;

  // Form data
  DeliveryAddress? _selectedAddress;
  PaymentMethod? _selectedPaymentMethod;
  bool _termsAccepted = false;

  // Order data from cart or direct purchase
  List<CartItem> cartItems = [];
  String? promoCode;
  double promoDiscount = 0.0;
  double subtotal = 0.0;
  double tax = 0.0;
  double shipping = 0.0;
  double total = 0.0;
  bool isDirectCheckout = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _loadingController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Get order data from arguments
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null) {
        _handleArguments(args);
      }
    });
  }

  /// Handle arguments from different navigation sources
  void _handleArguments(Map<String, dynamic> args) {
    setState(() {
      isDirectCheckout = args['directCheckout'] as bool? ?? false;

      if (isDirectCheckout) {
        // Handle direct checkout from product detail
        _handleDirectCheckoutArgs(args);
      } else {
        // Handle checkout from shopping cart
        _handleCartCheckoutArgs(args);
      }
    });
  }

  /// Handle direct checkout arguments from "Pesan Sekarang"
  void _handleDirectCheckoutArgs(Map<String, dynamic> args) {
    final product = args['product'] as Map<String, dynamic>?;
    final quantity = args['quantity'] as int? ?? 1;

    if (product != null) {
      // Create a cart item from the product
      final productName = product['name'] as String? ?? 'Unknown Product';
      final priceString = product['price'] as String? ?? '0';
      final imageUrl = product['image'] as String? ?? '';

      // Extract price from string (e.g., "Rp 25.000.000" -> 25000000)
      final priceNumeric = _extractPriceFromString(priceString);

      final cartItem = CartItem(
        id: 'direct_${DateTime.now().millisecondsSinceEpoch}',
        name: productName,
        description: 'Dental equipment - direct purchase',
        price: priceNumeric,
        quantity: quantity,
        imageUrl: imageUrl,
        supplierName: 'Cobra Medical Equipment',
        availability: 'In Stock',
        sku: 'DIRECT-${DateTime.now().millisecondsSinceEpoch}',
      );

      cartItems = [cartItem];

      // Calculate pricing
      subtotal = priceNumeric * quantity;
      tax = subtotal * 0.11; // 11% PPN
      shipping = 25000.0; // Flat shipping rate
      total = subtotal + tax + shipping;
    }
  }

  /// Handle cart checkout arguments
  void _handleCartCheckoutArgs(Map<String, dynamic> args) {
    cartItems = args['cartItems'] as List<CartItem>? ?? [];
    promoCode = args['promoCode'] as String?;
    promoDiscount = args['promoDiscount'] as double? ?? 0.0;
    subtotal = args['subtotal'] as double? ?? 0.0;
    tax = args['tax'] as double? ?? 0.0;
    shipping = args['shipping'] as double? ?? 0.0;
    total = args['total'] as double? ?? 0.0;
  }

  /// Extract numeric price from string format
  double _extractPriceFromString(String priceString) {
    // Remove all non-digit characters except decimal points
    String cleanPrice = priceString.replaceAll(RegExp(r'[^\d]'), '');
    return double.tryParse(cleanPrice) ?? 0.0;
  }

  @override
  void dispose() {
    _pageController.dispose();
    _loadingController.dispose();
    super.dispose();
  }

  /// Navigate to next step
  void _nextStep() {
    if (_currentStep < 2) {
      setState(() => _currentStep++);
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  /// Navigate to previous step
  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  /// Validate current step
  bool _validateCurrentStep() {
    switch (_currentStep) {
      case 0: // Delivery step
        return _selectedAddress != null;
      case 1: // Payment step
        return _selectedPaymentMethod != null;
      case 2: // Review step
        return _termsAccepted;
      default:
        return false;
    }
  }

  /// Submit order with POS integration
  Future<void> _submitOrder() async {
    if (!_validateCurrentStep()) return;

    setState(() => _isSubmitting = true);
    _loadingController.forward();

    try {
      // Simulate order submission to POS system
      final orderData = {
        'orderId': _generateOrderId(),
        'items': cartItems
            .map(
              (item) => {
                'id': item.id,
                'name': item.name,
                'sku': item.sku,
                'quantity': item.quantity,
                'price': item.price,
                'total': item.price * item.quantity,
              },
            )
            .toList(),
        'customer': {
          'businessName': _selectedAddress?.businessName,
          'address': _selectedAddress?.fullAddress,
          'phone': _selectedAddress?.phoneNumber,
        },
        'payment': {
          'method': _selectedPaymentMethod?.type,
          'provider': _selectedPaymentMethod?.name,
        },
        'pricing': {
          'subtotal': subtotal,
          'discount': promoDiscount,
          'tax': tax,
          'shipping': shipping,
          'total': total,
        },
        'promoCode': promoCode,
        'timestamp': DateTime.now().toIso8601String(),
        'status': 'pending',
      };

      // Send to external POS system
      await _sendToPosSystem(orderData);

      // Generate order ID for tracking
      _orderId = orderData['orderId'] as String;

      // Show success and biometric confirmation if available
      await _handleBiometricConfirmation();

      setState(() {
        _orderCompleted = true;
        _isSubmitting = false;
      });

      HapticFeedback.heavyImpact();
    } catch (e) {
      setState(() => _isSubmitting = false);
      _loadingController.reverse();

      _showErrorDialog('Gagal memproses pesanan. Silakan coba lagi.');
    }
  }

  /// Send order data to external POS system
  Future<void> _sendToPosSystem(Map<String, dynamic> orderData) async {
    final dio = Dio();

    try {
      // Replace with actual POS endpoint
      const String posEndpoint = String.fromEnvironment(
        'POS_API_ENDPOINT',
        defaultValue: 'https://api-pos.cobradental.co.id/orders',
      );

      final response = await dio.post(
        posEndpoint,
        data: orderData,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization':
                'Bearer ${String.fromEnvironment('POS_API_TOKEN')}',
          },
          sendTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
        ),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('POS system returned ${response.statusCode}');
      }

      print('Order successfully sent to POS: ${response.data}');
    } catch (e) {
      print('Error sending to POS: $e');
      // For demo purposes, we'll continue as if it succeeded
      // In production, handle this appropriately
      await Future.delayed(const Duration(seconds: 2));
    }
  }

  /// Handle biometric authentication for payment confirmation
  Future<void> _handleBiometricConfirmation() async {
    // Simulate biometric authentication
    await Future.delayed(const Duration(seconds: 1));

    // In a real app, integrate with local_auth package
    // final LocalAuthentication localAuth = LocalAuthentication();
    // final bool didAuthenticate = await localAuth.authenticate(
    //   localizedReason: 'Konfirmasi pembayaran dengan biometrik',
    // );
  }

  /// Generate unique order ID
  String _generateOrderId() {
    final now = DateTime.now();
    final timestamp = now.millisecondsSinceEpoch.toString();
    return 'CB${timestamp.substring(timestamp.length - 8)}';
  }

  /// Show error dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Error',
          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
        content: Text(message, style: GoogleFonts.inter()),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_orderCompleted) {
      return OrderSuccessWidget(
        orderId: _orderId!,
        total: total,
        estimatedDelivery: DateTime.now().add(const Duration(days: 3)),
        onContinueShopping: () {
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.homeDashboard,
            (route) => false,
          );
        },
        onTrackOrder: () {
          // Navigate to order tracking with order ID
          Navigator.pushReplacementNamed(
            context,
            AppRoutes.orderTracking,
            arguments: {
              'orderId': _orderId,
              'orderData': {
                'total': total,
                'status': 'pending',
                'estimatedDelivery':
                    DateTime.now().add(const Duration(days: 3)),
                'items': cartItems
                    .map((item) => {
                          'name': item.name,
                          'quantity': item.quantity,
                          'price': item.price,
                        })
                    .toList(),
              },
            },
          );
        },
      );
    }

    // Show error if no items
    if (cartItems.isEmpty) {
      return Scaffold(
        appBar: CustomAppBar(
          title: 'Checkout',
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: AppTheme.errorLight,
              ),
              const SizedBox(height: 16),
              Text(
                'Tidak ada item untuk checkout',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Silakan tambahkan produk ke keranjang terlebih dahulu.',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppTheme.textSecondaryLight,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.productCatalog,
                    (route) => false,
                  );
                },
                child: Text('Lihat Produk'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: CustomAppBar(
        title: isDirectCheckout ? 'Pemesanan Langsung' : 'Checkout',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed:
              _currentStep == 0 ? () => Navigator.pop(context) : _previousStep,
        ),
      ),
      body: Column(
        children: [
          // Step Progress Indicator
          StepProgressIndicator(
            currentStep: _currentStep,
            stepLabels: const ['Pengiriman', 'Pembayaran', 'Review'],
          ),

          // Content
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                // Step 1: Delivery Address
                DeliveryAddressSection(
                  selectedAddress: _selectedAddress,
                  onAddressSelected: (address) {
                    setState(() => _selectedAddress = address);
                  },
                  onAddNewAddress: _addNewAddress,
                ),

                // Step 2: Payment Method
                PaymentMethodSection(
                  selectedPaymentMethod: _selectedPaymentMethod,
                  onPaymentMethodSelected: (method) {
                    setState(() => _selectedPaymentMethod = method);
                  },
                  orderTotal: total,
                ),

                // Step 3: Order Review
                if (_selectedAddress != null && _selectedPaymentMethod != null)
                  OrderReviewSection(
                    cartItems: cartItems,
                    deliveryAddress: _selectedAddress!,
                    paymentMethod: _selectedPaymentMethod!,
                    promoCode: promoCode,
                    subtotal: subtotal,
                    promoDiscount: promoDiscount,
                    tax: tax,
                    shipping: shipping,
                    total: total,
                    termsAccepted: _termsAccepted,
                    onTermsChanged: (value) {
                      setState(() => _termsAccepted = value);
                    },
                  ),
              ],
            ),
          ),

          // Bottom Action Button
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                child: _isSubmitting
                    ? Container(
                        height: 56,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryLight.withAlpha(153),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation(
                                    Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Memproses Pesanan...',
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : ElevatedButton(
                        onPressed: _validateCurrentStep()
                            ? (_currentStep == 2 ? _submitOrder : _nextStep)
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.accentLight,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                        child: Text(
                          _currentStep == 2 ? 'Kirim Pesanan' : 'Lanjutkan',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Add new delivery address
  void _addNewAddress() {
    // Navigate to add address screen or show modal
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _buildAddAddressForm(),
    );
  }

  /// Build add address form
  Widget _buildAddAddressForm() {
    // This would typically be a separate widget
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Tambah Alamat Baru',
            style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 20),
          Text('Form alamat akan ditambahkan di sini'),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Tutup'),
          ),
        ],
      ),
    );
  }
}

/// Delivery address data model
class DeliveryAddress {
  final String id;
  final String businessName;
  final String fullAddress;
  final String city;
  final String postalCode;
  final String phoneNumber;
  final bool isDefault;

  const DeliveryAddress({
    required this.id,
    required this.businessName,
    required this.fullAddress,
    required this.city,
    required this.postalCode,
    required this.phoneNumber,
    this.isDefault = false,
  });
}

/// Payment method data model
class PaymentMethod {
  final String id;
  final String name;
  final String type;
  final String iconUrl;
  final bool isAvailable;
  final Map<String, dynamic>? metadata;

  const PaymentMethod({
    required this.id,
    required this.name,
    required this.type,
    required this.iconUrl,
    this.isAvailable = true,
    this.metadata,
  });
}
