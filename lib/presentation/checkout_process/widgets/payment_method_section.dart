import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../theme/app_theme.dart';
import '../checkout_process.dart';

/// Payment method selection section for checkout
class PaymentMethodSection extends StatelessWidget {
  final PaymentMethod? selectedPaymentMethod;
  final Function(PaymentMethod) onPaymentMethodSelected;
  final double orderTotal;

  const PaymentMethodSection({
    super.key,
    this.selectedPaymentMethod,
    required this.onPaymentMethodSelected,
    required this.orderTotal,
  });

  /// Format price to Indonesian Rupiah
  String _formatPrice(double price) {
    return 'Rp ${price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  @override
  Widget build(BuildContext context) {
    final paymentMethods = _getMockPaymentMethods();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Text(
            'Pilih Metode Pembayaran',
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimaryLight,
            ),
          ),

          Text(
            'Total yang harus dibayar: ${_formatPrice(orderTotal)}',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryLight,
            ),
          ),

          const SizedBox(height: 20),

          // Payment Methods
          ...paymentMethods.map((method) => _buildPaymentMethodCard(method)),

          const SizedBox(height: 20),

          // Payment Security Notice
          _buildSecurityNotice(),
        ],
      ),
    );
  }

  /// Build payment method card
  Widget _buildPaymentMethodCard(PaymentMethod method) {
    final isSelected = selectedPaymentMethod?.id == method.id;

    return Card(
      elevation: isSelected ? 4 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side:
            isSelected
                ? BorderSide(color: AppTheme.primaryLight, width: 2)
                : BorderSide.none,
      ),
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap:
            method.isAvailable ? () => onPaymentMethodSelected(method) : null,
        borderRadius: BorderRadius.circular(12),
        child: Opacity(
          opacity: method.isAvailable ? 1.0 : 0.5,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Payment Icon
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceLight,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.dividerLight),
                  ),
                  child:
                      method.iconUrl.startsWith('http')
                          ? ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: CachedNetworkImage(
                              imageUrl: method.iconUrl,
                              fit: BoxFit.contain,
                              placeholder:
                                  (context, url) => Container(
                                    color: Colors.grey[200],
                                    child: Icon(
                                      Icons.payment,
                                      color: Colors.grey,
                                    ),
                                  ),
                              errorWidget:
                                  (context, url, error) => Icon(
                                    Icons.payment,
                                    color: AppTheme.textSecondaryLight,
                                  ),
                            ),
                          )
                          : Icon(
                            _getPaymentIcon(method.type),
                            color: AppTheme.primaryLight,
                            size: 24,
                          ),
                ),

                const SizedBox(width: 16),

                // Payment Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            method.name,
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textPrimaryLight,
                            ),
                          ),

                          if (!method.isAvailable) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.errorLight.withAlpha(26),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'Tidak Tersedia',
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                  color: AppTheme.errorLight,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),

                      const SizedBox(height: 4),

                      Text(
                        _getPaymentDescription(method),
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: AppTheme.textSecondaryLight,
                        ),
                      ),

                      // Special Features
                      if (method.metadata != null &&
                          method.metadata!.isNotEmpty)
                        _buildPaymentFeatures(method.metadata!),
                    ],
                  ),
                ),

                // Selection Radio
                Radio<String>(
                  value: method.id,
                  groupValue: selectedPaymentMethod?.id,
                  onChanged:
                      method.isAvailable
                          ? (value) => onPaymentMethodSelected(method)
                          : null,
                  activeColor: AppTheme.primaryLight,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Build payment method features
  Widget _buildPaymentFeatures(Map<String, dynamic> metadata) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Wrap(
        spacing: 8,
        runSpacing: 4,
        children: [
          if (metadata['instantApproval'] == true)
            _buildFeatureChip('Persetujuan Instan', AppTheme.successLight),
          if (metadata['creditTerms'] != null)
            _buildFeatureChip(
              '${metadata['creditTerms']} hari',
              AppTheme.primaryLight,
            ),
          if (metadata['discount'] != null)
            _buildFeatureChip(
              'Diskon ${metadata['discount']}%',
              AppTheme.accentLight,
            ),
        ],
      ),
    );
  }

  /// Build feature chip
  Widget _buildFeatureChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withAlpha(26),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
    );
  }

  /// Build security notice
  Widget _buildSecurityNotice() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.successLight.withAlpha(26),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.successLight.withAlpha(77)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.security, color: AppTheme.successLight, size: 20),
              const SizedBox(width: 8),
              Text(
                'Keamanan Pembayaran',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.successLight,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Text(
            '• Semua transaksi menggunakan enkripsi SSL 256-bit\n'
            '• Autentikasi biometrik untuk konfirmasi pembayaran\n'
            '• Data pembayaran tidak disimpan di perangkat\n'
            '• Terintegrasi langsung dengan sistem POS terpercaya',
            style: GoogleFonts.inter(
              fontSize: 12,
              color: AppTheme.successLight,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  /// Get payment icon based on type
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
  String _getPaymentDescription(PaymentMethod method) {
    switch (method.type) {
      case 'bank_transfer':
        return 'Transfer bank dalam 1x24 jam setelah konfirmasi';
      case 'credit_terms':
        return 'Pembayaran dengan kredit untuk pelanggan terdaftar';
      case 'digital_wallet':
        return 'Pembayaran instan melalui dompet digital';
      case 'cash_on_delivery':
        return 'Bayar tunai saat pengiriman peralatan';
      default:
        return 'Metode pembayaran tersedia';
    }
  }

  /// Mock payment methods
  List<PaymentMethod> _getMockPaymentMethods() {
    return [
      PaymentMethod(
        id: '1',
        name: 'Transfer Bank',
        type: 'bank_transfer',
        iconUrl: 'bank_icon',
        isAvailable: true,
        metadata: {
          'banks': ['BCA', 'BNI', 'BRI', 'Mandiri'],
          'processingTime': '1-2 jam',
        },
      ),
      PaymentMethod(
        id: '2',
        name: 'Kredit 30 Hari',
        type: 'credit_terms',
        iconUrl: 'credit_icon',
        isAvailable: true,
        metadata: {
          'creditTerms': 30,
          'instantApproval': true,
          'creditLimit': 100000000,
        },
      ),
      PaymentMethod(
        id: '3',
        name: 'Kredit 60 Hari',
        type: 'credit_terms',
        iconUrl: 'credit_icon',
        isAvailable: true,
        metadata: {'creditTerms': 60, 'instantApproval': false, 'discount': 2},
      ),
      PaymentMethod(
        id: '4',
        name: 'DANA',
        type: 'digital_wallet',
        iconUrl:
            'https://images.unsplash.com/photo-1556742502-ec7c0e9f34b1?w=100',
        isAvailable: true,
        metadata: {'instantApproval': true},
      ),
      PaymentMethod(
        id: '5',
        name: 'OVO',
        type: 'digital_wallet',
        iconUrl:
            'https://images.unsplash.com/photo-1556742502-ec7c0e9f34b1?w=100',
        isAvailable: true,
        metadata: {'instantApproval': true},
      ),
      PaymentMethod(
        id: '6',
        name: 'Cash on Delivery',
        type: 'cash_on_delivery',
        iconUrl: 'cash_icon',
        isAvailable: false, // Not available for large equipment
      ),
    ];
  }
}
