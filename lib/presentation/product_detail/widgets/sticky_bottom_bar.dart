import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import './quantity_selector.dart';

class StickyBottomBar extends StatefulWidget {
  final String price;
  final VoidCallback onAddToCart;
  final VoidCallback onBuyNow;

  const StickyBottomBar({
    super.key,
    required this.price,
    required this.onAddToCart,
    required this.onBuyNow,
  });

  @override
  State<StickyBottomBar> createState() => _StickyBottomBarState();
}

class _StickyBottomBarState extends State<StickyBottomBar> {
  int _quantity = 1;

  void _onQuantityChanged(int quantity) {
    setState(() {
      _quantity = quantity;
    });
  }

  void _onBuyNowPressed() {
    // Haptic feedback for iOS
    HapticFeedback.lightImpact();

    // Navigate directly to checkout process with selected product and quantity
    Navigator.pushNamed(
      context,
      AppRoutes.checkoutProcess,
      arguments: {
        'product': {
          'name': 'Dental Unit Chair Premium DU-3000',
          'price': widget.price,
          'image':
              'https://images.unsplash.com/photo-1629909613654-28e377c37b09?w=800&h=600&fit=crop',
        },
        'quantity': _quantity,
        'directCheckout': true,
      },
    );
  }

  void _onAddToCartPressed() {
    // Haptic feedback for iOS
    HapticFeedback.selectionClick();

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Produk ditambahkan ke keranjang ($_quantity item)'),
        backgroundColor: AppTheme.successLight,
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'Lihat Keranjang',
          textColor: Colors.white,
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.shoppingCart);
          },
        ),
      ),
    );

    // Call original callback
    widget.onAddToCart();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Quantity and Price Row
              Row(
                children: [
                  // Quantity Selector
                  QuantitySelector(
                    initialQuantity: _quantity,
                    onQuantityChanged: _onQuantityChanged,
                  ),

                  Spacer(),

                  // Total Price
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Total',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      Text(
                        _calculateTotalPrice(),
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppTheme.primaryLight,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              SizedBox(height: 2.h),

              // Action Buttons
              Row(
                children: [
                  // Add to Cart Button
                  Expanded(
                    flex: 2,
                    child: SizedBox(
                      height: 6.h,
                      child: OutlinedButton.icon(
                        onPressed: _onAddToCartPressed,
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: AppTheme.primaryLight,
                            width: 1.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: CustomIconWidget(
                          iconName: 'shopping_cart_outlined',
                          color: AppTheme.primaryLight,
                          size: 20,
                        ),
                        label: Text(
                          'Keranjang',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.primaryLight,
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: 3.w),

                  // Buy Now Button
                  Expanded(
                    flex: 3,
                    child: SizedBox(
                      height: 6.h,
                      child: ElevatedButton.icon(
                        onPressed: _onBuyNowPressed,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.accentLight,
                          foregroundColor: Colors.black,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: CustomIconWidget(
                          iconName: 'flash_on',
                          color: Colors.black,
                          size: 20,
                        ),
                        label: Text(
                          'Pesan Sekarang',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _calculateTotalPrice() {
    // Extract numeric value from price string (assuming format like "Rp 1.500.000")
    String priceString = widget.price.replaceAll(RegExp(r'[^\d]'), '');
    if (priceString.isEmpty) return widget.price;

    int price = int.tryParse(priceString) ?? 0;
    int total = price * _quantity;

    // Format back to Indonesian currency format
    String totalString = total.toString();
    String formatted = '';

    for (int i = totalString.length - 1, count = 0; i >= 0; i--, count++) {
      if (count > 0 && count % 3 == 0) {
        formatted = '.$formatted';
      }
      formatted = totalString[i] + formatted;
    }

    return 'Rp $formatted';
  }
}
