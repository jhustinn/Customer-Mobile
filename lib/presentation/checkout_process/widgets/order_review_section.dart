import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../theme/app_theme.dart';
import '../../shopping_cart/shopping_cart.dart';
import '../checkout_process.dart';

/// Order review section displaying final order details before submission
class OrderReviewSection extends StatelessWidget {
  final List<CartItem> cartItems;
  final DeliveryAddress deliveryAddress;
  final PaymentMethod paymentMethod;
  final String? promoCode;
  final double subtotal;
  final double promoDiscount;
  final double tax;
  final double shipping;
  final double total;
  final bool termsAccepted;
  final Function(bool) onTermsChanged;

  const OrderReviewSection({
    super.key,
    required this.cartItems,
    required this.deliveryAddress,
    required this.paymentMethod,
    this.promoCode,
    required this.subtotal,
    required this.promoDiscount,
    required this.tax,
    required this.shipping,
    required this.total,
    required this.termsAccepted,
    required this.onTermsChanged,
  });

  /// Format price to Indonesian Rupiah
  String _formatPrice(double price) {
    return 'Rp ${price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Text(
            'Review Pesanan',
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimaryLight,
            ),
          ),

          Text(
            'Pastikan semua detail pesanan sudah benar sebelum melanjutkan',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppTheme.textSecondaryLight,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 24),

          // Order Items
          _buildOrderItemsSection(),

          const SizedBox(height: 24),

          // Delivery Information
          _buildDeliverySection(),

          const SizedBox(height: 24),

          // Payment Information
          _buildPaymentSection(),

          const SizedBox(height: 24),

          // Price Summary
          _buildPriceSummarySection(),

          const SizedBox(height: 24),

          // Terms and Conditions
          _buildTermsSection(),

          const SizedBox(height: 24),

          // Delivery Estimation
          _buildDeliveryEstimationSection(),
        ],
      ),
    );
  }

  /// Build order items section
  Widget _buildOrderItemsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Item Pesanan',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimaryLight,
              ),
            ),

            const Spacer(),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.accentLight.withAlpha(51),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${cartItems.length} item',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryLight,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // Item List
        Container(
          decoration: BoxDecoration(
            color: AppTheme.surfaceLight,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.dividerLight),
          ),
          child: Column(
            children:
                cartItems.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;
                  final isLast = index == cartItems.length - 1;

                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border:
                          !isLast
                              ? Border(
                                bottom: BorderSide(
                                  color: AppTheme.dividerLight,
                                ),
                              )
                              : null,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Product Image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: CachedNetworkImage(
                            imageUrl: item.imageUrl,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            placeholder:
                                (context, url) => Container(
                                  width: 50,
                                  height: 50,
                                  color: Colors.grey[200],
                                  child: Icon(Icons.image, color: Colors.grey),
                                ),
                            errorWidget:
                                (context, url, error) => Container(
                                  width: 50,
                                  height: 50,
                                  color: Colors.grey[200],
                                  child: Icon(
                                    Icons.image_not_supported,
                                    color: Colors.grey,
                                  ),
                                ),
                          ),
                        ),

                        const SizedBox(width: 12),

                        // Product Details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.name,
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),

                              const SizedBox(height: 4),

                              Text(
                                'SKU: ${item.sku}',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: AppTheme.textSecondaryLight,
                                ),
                              ),

                              const SizedBox(height: 6),

                              Row(
                                children: [
                                  Text(
                                    '${item.quantity}x',
                                    style: GoogleFonts.inter(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),

                                  const SizedBox(width: 4),

                                  Text(
                                    _formatPrice(item.price),
                                    style: GoogleFonts.inter(
                                      fontSize: 13,
                                      color: AppTheme.textSecondaryLight,
                                    ),
                                  ),

                                  const Spacer(),

                                  Text(
                                    _formatPrice(item.price * item.quantity),
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.primaryLight,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
          ),
        ),
      ],
    );
  }

  /// Build delivery section
  Widget _buildDeliverySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Alamat Pengiriman',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimaryLight,
          ),
        ),

        const SizedBox(height: 12),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.surfaceLight,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.dividerLight),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                deliveryAddress.businessName,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                deliveryAddress.fullAddress,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: AppTheme.textSecondaryLight,
                  height: 1.3,
                ),
              ),

              const SizedBox(height: 6),

              Row(
                children: [
                  Text(
                    '${deliveryAddress.city} ${deliveryAddress.postalCode}',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppTheme.textSecondaryLight,
                    ),
                  ),

                  const SizedBox(width: 12),

                  Text(
                    deliveryAddress.phoneNumber,
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
      ],
    );
  }

  /// Build payment section
  Widget _buildPaymentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Metode Pembayaran',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimaryLight,
          ),
        ),

        const SizedBox(height: 12),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.surfaceLight,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.dividerLight),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppTheme.backgroundLight,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: AppTheme.dividerLight),
                ),
                child: Icon(
                  _getPaymentIcon(paymentMethod.type),
                  color: AppTheme.primaryLight,
                  size: 20,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      paymentMethod.name,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 2),

                    Text(
                      _getPaymentDescription(paymentMethod.type),
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
    );
  }

  /// Build price summary section
  Widget _buildPriceSummarySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ringkasan Pembayaran',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimaryLight,
          ),
        ),

        const SizedBox(height: 12),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.surfaceLight,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.dividerLight),
          ),
          child: Column(
            children: [
              _buildPriceSummaryRow('Subtotal', subtotal),

              if (promoDiscount > 0) ...[
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Diskon Promo',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: AppTheme.successLight,
                          ),
                        ),
                        if (promoCode != null) ...[
                          const SizedBox(width: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.successLight.withAlpha(26),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              promoCode!,
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: AppTheme.successLight,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    Text(
                      '-${_formatPrice(promoDiscount)}',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.successLight,
                      ),
                    ),
                  ],
                ),
              ],

              const SizedBox(height: 8),
              _buildPriceSummaryRow('PPN (11%)', tax),

              const SizedBox(height: 8),
              _buildPriceSummaryRow('Ongkos Kirim', shipping),

              const SizedBox(height: 12),
              Container(height: 1, color: AppTheme.dividerLight),
              const SizedBox(height: 12),

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
            ],
          ),
        ),
      ],
    );
  }

  /// Build price summary row
  Widget _buildPriceSummaryRow(String label, double amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14,
            color: AppTheme.textSecondaryLight,
          ),
        ),
        Text(
          _formatPrice(amount),
          style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  /// Build terms and conditions section
  Widget _buildTermsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Syarat & Ketentuan',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimaryLight,
          ),
        ),

        const SizedBox(height: 12),

        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.surfaceLight,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.dividerLight),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CheckboxListTile(
                value: termsAccepted,
                onChanged: (bool? value) => onTermsChanged(value ?? false),
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                title: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Saya setuju dengan ',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: AppTheme.textPrimaryLight,
                        ),
                      ),
                      TextSpan(
                        text: 'syarat & ketentuan',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: AppTheme.primaryLight,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      TextSpan(
                        text: ' dan ',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: AppTheme.textPrimaryLight,
                        ),
                      ),
                      TextSpan(
                        text: 'kebijakan privasi',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: AppTheme.primaryLight,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      TextSpan(
                        text: ' Cobra Dental.',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: AppTheme.textPrimaryLight,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 8),

              Text(
                '• Pesanan akan diproses setelah pembayaran dikonfirmasi\n'
                '• Garansi berlaku sesuai dengan ketentuan masing-masing produk\n'
                '• Pengiriman peralatan besar memerlukan jadwal khusus\n'
                '• Pembatalan pesanan dapat dilakukan sebelum barang dikirim',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: AppTheme.textSecondaryLight,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Build delivery estimation section
  Widget _buildDeliveryEstimationSection() {
    final estimatedDelivery = DateTime.now().add(const Duration(days: 3));
    final formattedDate =
        '${estimatedDelivery.day}/${estimatedDelivery.month}/${estimatedDelivery.year}';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.primaryLight.withAlpha(26),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.primaryLight.withAlpha(77)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.local_shipping,
                color: AppTheme.primaryLight,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Estimasi Pengiriman',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryLight,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Text(
            'Pesanan Anda diperkirakan akan tiba pada $formattedDate',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: AppTheme.primaryLight,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            'Anda akan menerima nomor resi untuk melacak pengiriman setelah pesanan diproses.',
            style: GoogleFonts.inter(
              fontSize: 12,
              color: AppTheme.primaryLight,
            ),
          ),
        ],
      ),
    );
  }

  /// Get payment icon
  IconData _getPaymentIcon(String type) {
    switch (type) {
      case 'bank_transfer':
        return Icons.account_balance;
      case 'credit_terms':
        return Icons.credit_card;
      case 'digital_wallet':
        return Icons.account_balance_wallet;
      case 'cash_on_delivery':
        return Icons.money;
      default:
        return Icons.payment;
    }
  }

  /// Get payment description
  String _getPaymentDescription(String type) {
    switch (type) {
      case 'bank_transfer':
        return 'Transfer bank';
      case 'credit_terms':
        return 'Pembayaran kredit';
      case 'digital_wallet':
        return 'Dompet digital';
      case 'cash_on_delivery':
        return 'Bayar saat pengiriman';
      default:
        return 'Metode pembayaran';
    }
  }
}