import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import './widgets/cart_item_card.dart';
import './widgets/empty_cart_widget.dart';
import './widgets/order_summary_widget.dart';
import './widgets/promo_code_widget.dart';

/// Shopping Cart screen for B2B dental customers to review and manage selected products
class ShoppingCart extends StatefulWidget {
  const ShoppingCart({super.key});

  @override
  State<ShoppingCart> createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart>
    with TickerProviderStateMixin {
  late AnimationController _refreshController;
  List<CartItem> cartItems = [];
  bool isLoading = false;
  String? promoCode;
  double promoDiscount = 0.0;

  @override
  void initState() {
    super.initState();
    _refreshController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _loadCartItems();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  /// Load cart items from storage/API
  Future<void> _loadCartItems() async {
    setState(() => isLoading = true);

    // Simulate API call - replace with actual cart service
    await Future.delayed(const Duration(milliseconds: 800));

    setState(() {
      cartItems = _getMockCartItems();
      isLoading = false;
    });
  }

  /// Refresh cart data from server
  Future<void> _refreshCart() async {
    _refreshController.forward();
    await _loadCartItems();
    _refreshController.reverse();

    if (mounted) {
      HapticFeedback.lightImpact();
    }
  }

  /// Update item quantity with haptic feedback
  void _updateQuantity(String itemId, int newQuantity) {
    if (newQuantity <= 0) {
      _removeItem(itemId);
      return;
    }

    setState(() {
      final index = cartItems.indexWhere((item) => item.id == itemId);
      if (index != -1) {
        cartItems[index] = cartItems[index].copyWith(quantity: newQuantity);
      }
    });

    // Haptic feedback for quantity changes
    HapticFeedback.selectionClick();
  }

  /// Remove item with confirmation dialog
  void _removeItem(String itemId) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              'Hapus Item',
              style: GoogleFonts.inter(fontWeight: FontWeight.w600),
            ),
            content: Text(
              'Apakah Anda yakin ingin menghapus item ini dari keranjang?',
              style: GoogleFonts.inter(),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Batal'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    cartItems.removeWhere((item) => item.id == itemId);
                  });
                  Navigator.pop(context);
                  HapticFeedback.mediumImpact();
                },
                child: Text('Hapus'),
              ),
            ],
          ),
    );
  }

  /// Move item to wishlist
  void _moveToWishlist(String itemId) {
    final item = cartItems.firstWhere((item) => item.id == itemId);

    setState(() {
      cartItems.removeWhere((item) => item.id == itemId);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item.name} dipindahkan ke wishlist'),
        action: SnackBarAction(
          label: 'Lihat',
          onPressed: () {
            // Navigate to wishlist
          },
        ),
      ),
    );
  }

  /// Apply promo code with validation
  void _applyPromoCode(String code) {
    // Simulate promo code validation
    setState(() {
      if (code.toUpperCase() == 'DENTAL10') {
        promoCode = code;
        promoDiscount = _calculateSubtotal() * 0.1; // 10% discount
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Kode promo berhasil diterapkan!'),
            backgroundColor: AppTheme.successLight,
          ),
        );
      } else {
        promoCode = null;
        promoDiscount = 0.0;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Kode promo tidak valid'),
            backgroundColor: AppTheme.errorLight,
          ),
        );
      }
    });
  }

  /// Calculate subtotal before discounts
  double _calculateSubtotal() {
    return cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));
  }

  /// Calculate tax amount
  double _calculateTax() {
    final subtotal = _calculateSubtotal() - promoDiscount;
    return subtotal * 0.11; // 11% PPN
  }

  /// Calculate estimated shipping
  double _calculateShipping() {
    return cartItems.isEmpty ? 0.0 : 25000.0; // Flat rate shipping
  }

  /// Calculate total amount
  double _calculateTotal() {
    return _calculateSubtotal() -
        promoDiscount +
        _calculateTax() +
        _calculateShipping();
  }

  /// Navigate to checkout
  void _proceedToCheckout() {
    if (cartItems.isEmpty) return;

    Navigator.pushNamed(
      context,
      AppRoutes.checkoutProcess,
      arguments: {
        'cartItems': cartItems,
        'promoCode': promoCode,
        'promoDiscount': promoDiscount,
        'subtotal': _calculateSubtotal(),
        'tax': _calculateTax(),
        'shipping': _calculateShipping(),
        'total': _calculateTotal(),
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Keranjang Belanja',
        actions: [
          if (cartItems.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.accentLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${cartItems.length}',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  color: Colors.black,
                ),
              ),
            ),
        ],
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : cartItems.isEmpty
              ? EmptyCartWidget(
                onContinueShopping: () {
                  Navigator.pushNamed(context, AppRoutes.productCatalog);
                },
              )
              : Column(
                children: [
                  // Cart Items List
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: _refreshCart,
                      child: ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: cartItems.length + 1, // +1 for promo code
                        separatorBuilder:
                            (context, index) => const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          if (index == cartItems.length) {
                            return PromoCodeWidget(
                              appliedPromoCode: promoCode,
                              onApplyPromo: _applyPromoCode,
                            );
                          }

                          final item = cartItems[index];
                          return CartItemCard(
                            item: item,
                            onQuantityChanged:
                                (quantity) =>
                                    _updateQuantity(item.id, quantity),
                            onRemove: () => _removeItem(item.id),
                            onMoveToWishlist: () => _moveToWishlist(item.id),
                          );
                        },
                      ),
                    ),
                  ),

                  // Order Summary and Checkout
                  OrderSummaryWidget(
                    subtotal: _calculateSubtotal(),
                    promoDiscount: promoDiscount,
                    tax: _calculateTax(),
                    shipping: _calculateShipping(),
                    total: _calculateTotal(),
                    onCheckout: _proceedToCheckout,
                  ),
                ],
              ),
    );
  }

  /// Mock cart items for demonstration
  List<CartItem> _getMockCartItems() {
    return [
      CartItem(
        id: '1',
        name: 'Dental Unit Chair Premium',
        description: 'High-quality dental chair with LED light',
        price: 25000000,
        quantity: 1,
        imageUrl:
            'https://images.unsplash.com/photo-1559757148-5c350d0d3c56?w=400',
        supplierName: 'Cobra Medical Equipment',
        availability: 'In Stock',
        sku: 'DUC-PREM-001',
      ),
      CartItem(
        id: '2',
        name: 'Autoclave Sterilizer 18L',
        description: 'Professional autoclave for dental instruments',
        price: 8500000,
        quantity: 2,
        imageUrl:
            'https://images.unsplash.com/photo-1559757175-0eb30cd8c063?w=400',
        supplierName: 'Sterilization Pro',
        availability: 'Low Stock',
        sku: 'AUT-18L-002',
      ),
      CartItem(
        id: '3',
        name: 'Digital X-Ray Sensor',
        description: 'High-resolution digital dental X-ray sensor',
        price: 12000000,
        quantity: 1,
        imageUrl:
            'https://images.unsplash.com/photo-1559757176-4d3c2e2f41c7?w=400',
        supplierName: 'Digital Dental Solutions',
        availability: 'In Stock',
        sku: 'DXR-SENS-003',
      ),
    ];
  }
}

/// Cart item data model
class CartItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final int quantity;
  final String imageUrl;
  final String supplierName;
  final String availability;
  final String sku;

  const CartItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.quantity,
    required this.imageUrl,
    required this.supplierName,
    required this.availability,
    required this.sku,
  });

  CartItem copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    int? quantity,
    String? imageUrl,
    String? supplierName,
    String? availability,
    String? sku,
  }) {
    return CartItem(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      imageUrl: imageUrl ?? this.imageUrl,
      supplierName: supplierName ?? this.supplierName,
      availability: availability ?? this.availability,
      sku: sku ?? this.sku,
    );
  }
}
