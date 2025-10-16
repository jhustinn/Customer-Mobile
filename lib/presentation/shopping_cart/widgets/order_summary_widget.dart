import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

/// Order summary widget displaying pricing breakdown and checkout button
class OrderSummaryWidget extends StatelessWidget {
  final double subtotal;
  final double promoDiscount;
  final double tax;
  final double shipping;
  final double total;
  final VoidCallback onCheckout;

  const OrderSummaryWidget({
    super.key,
    required this.subtotal,
    required this.promoDiscount,
    required this.tax,
    required this.shipping,
    required this.total,
    required this.onCheckout,
  });

  /// Format price to Indonesian Rupiah
  String _formatPrice(double price) {
    return 'Rp ${price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.backgroundLight,
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            offset: const Offset(0, -4),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Order Summary Header
              Text(
                'Ringkasan Pesanan',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimaryLight,
                ),
              ),

              const SizedBox(height: 16),

              // Subtotal
              _buildSummaryRow('Subtotal', subtotal),

              // Promo Discount
              if (promoDiscount > 0)
                _buildSummaryRow(
                  'Diskon Promo',
                  -promoDiscount,
                  isDiscount: true,
                ),

              const SizedBox(height: 8),

              // Tax (PPN)
              _buildSummaryRow('PPN (11%)', tax),

              // Shipping
              _buildSummaryRow('Ongkos Kirim', shipping),

              const SizedBox(height: 12),

              // Divider
              Container(height: 1, color: AppTheme.dividerLight),

              const SizedBox(height: 12),

              // Total
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimaryLight,
                    ),
                  ),
                  Text(
                    _formatPrice(total),
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.primaryLight,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Checkout Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onCheckout,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.accentLight,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.shopping_cart_checkout, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Checkout',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // Security Notice
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.security, size: 16, color: AppTheme.successLight),
                  const SizedBox(width: 6),
                  Text(
                    'Transaksi aman dan terenkripsi',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppTheme.textSecondaryLight,
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

  /// Build summary row with label and price
  Widget _buildSummaryRow(
    String label,
    double amount, {
    bool isDiscount = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color:
                  isDiscount
                      ? AppTheme.successLight
                      : AppTheme.textSecondaryLight,
            ),
          ),
          Text(
            _formatPrice(amount.abs()),
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color:
                  isDiscount
                      ? AppTheme.successLight
                      : AppTheme.textPrimaryLight,
            ),
          ),
        ],
      ),
    );
  }
}
