import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import '../../order_tracking/order_tracking.dart';
import '../order_detail_tracking.dart';

/// Invoice details widget showing itemized dental equipment with supplier information
class InvoiceDetailsWidget extends StatelessWidget {
  final List<OrderDetailItem> items;
  final double subtotal;
  final double tax;
  final double total;
  final SupplierInfo supplierInfo;

  const InvoiceDetailsWidget({
    super.key,
    required this.items,
    required this.subtotal,
    required this.tax,
    required this.total,
    required this.supplierInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Order Summary Section
        Container(
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
              Text(
                'Ringkasan Pesanan',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 16),

              // Item list
              ...items.map((item) => _buildOrderItem(item)),

              const Divider(height: 32),

              // Order totals
              _buildTotalRow('Subtotal', subtotal, false),
              const SizedBox(height: 8),
              _buildTotalRow('Pajak (PPN 11%)', tax, false),
              const SizedBox(height: 12),
              _buildTotalRow('Total', total, true),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Supplier Information Card
        Container(
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
              Text(
                'Informasi Supplier',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryLight.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.business,
                      color: AppTheme.primaryLight,
                      size: 24,
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          supplierInfo.name,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Row(
                          children: [
                            Icon(
                              Icons.phone,
                              size: 14,
                              color: AppTheme.textSecondaryLight,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              supplierInfo.contact,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: AppTheme.textSecondaryLight,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 2),

                        Row(
                          children: [
                            Icon(
                              Icons.email,
                              size: 14,
                              color: AppTheme.textSecondaryLight,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              supplierInfo.email,
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

                  IconButton(
                    onPressed: () {
                      // Contact supplier functionality
                    },
                    icon: Icon(Icons.phone, color: AppTheme.primaryLight),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Build individual order item row
  Widget _buildOrderItem(OrderDetailItem item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product image
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: AppTheme.surfaceLight,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: item.imageUrl,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                placeholder:
                    (context, url) => Container(
                      color: AppTheme.surfaceLight,
                      child: Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppTheme.primaryLight,
                        ),
                      ),
                    ),
                errorWidget:
                    (context, url, error) => Container(
                      color: AppTheme.surfaceLight,
                      child: Icon(
                        Icons.image_not_supported,
                        color: AppTheme.textDisabledLight,
                        size: 24,
                      ),
                    ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Product details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 4),

                Text(
                  item.description,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppTheme.textSecondaryLight,
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 8),

                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceLight,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'SKU: ${item.sku}',
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          color: AppTheme.textSecondaryLight,
                        ),
                      ),
                    ),

                    const Spacer(),

                    Text(
                      'Qty: ${item.quantity}',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // Price information
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _formatCurrency(item.unitPrice),
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: AppTheme.textSecondaryLight,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                _formatCurrency(item.totalPrice),
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
    );
  }

  /// Build total row for order summary
  Widget _buildTotalRow(String label, double amount, bool isTotal) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.w600 : FontWeight.w400,
            color:
                isTotal
                    ? AppTheme.textPrimaryLight
                    : AppTheme.textSecondaryLight,
          ),
        ),
        Text(
          _formatCurrency(amount),
          style: GoogleFonts.inter(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.w600 : FontWeight.w500,
            color: isTotal ? AppTheme.primaryLight : AppTheme.textPrimaryLight,
          ),
        ),
      ],
    );
  }

  /// Format currency for display in IDR
  String _formatCurrency(double amount) {
    if (amount >= 1000000000) {
      return 'Rp ${(amount / 1000000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000000) {
      return 'Rp ${(amount / 1000000).toStringAsFixed(1)}jt';
    } else if (amount >= 1000) {
      return 'Rp ${(amount / 1000).toStringAsFixed(0)}rb';
    } else {
      return 'Rp ${amount.toStringAsFixed(0)}';
    }
  }
}
