import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

/// Payment status widget showing invoice amount, payment method, due dates, and outstanding balances
class PaymentStatusWidget extends StatelessWidget {
  final double invoiceAmount;
  final String paymentMethod;
  final DateTime dueDate;
  final double outstandingBalance;
  final bool isPaid;

  const PaymentStatusWidget({
    super.key,
    required this.invoiceAmount,
    required this.paymentMethod,
    required this.dueDate,
    required this.outstandingBalance,
    required this.isPaid,
  });

  @override
  Widget build(BuildContext context) {
    final isOverdue = DateTime.now().isAfter(dueDate) && !isPaid;
    final daysUntilDue = dueDate.difference(DateTime.now()).inDays;

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
                'Status Pembayaran',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _getPaymentStatusColor(),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  _getPaymentStatusText(),
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Payment details
          _buildPaymentDetailRow(
            'Total Invoice',
            _formatCurrency(invoiceAmount),
            Icons.receipt_long,
          ),

          const SizedBox(height: 12),

          _buildPaymentDetailRow(
            'Metode Pembayaran',
            paymentMethod,
            Icons.payment,
          ),

          const SizedBox(height: 12),

          _buildPaymentDetailRow(
            'Jatuh Tempo',
            _formatDate(dueDate),
            Icons.calendar_today,
            subtitle: _getDueDateSubtitle(daysUntilDue, isOverdue),
            subtitleColor: isOverdue ? AppTheme.errorLight : null,
          ),

          if (!isPaid) ...[
            const SizedBox(height: 12),

            _buildPaymentDetailRow(
              'Sisa Tagihan',
              _formatCurrency(outstandingBalance),
              Icons.account_balance_wallet,
              isHighlighted: true,
            ),

            const SizedBox(height: 20),

            // Payment action button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Handle payment action
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isOverdue ? AppTheme.errorLight : AppTheme.primaryLight,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.payment, color: Colors.white, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Bayar Sekarang',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ] else ...[
            const SizedBox(height: 16),

            // Payment success indicator
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.successLight.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.successLight.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: AppTheme.successLight,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pembayaran Berhasil',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.successLight,
                          ),
                        ),
                        Text(
                          'Invoice telah dibayar lunas',
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

          // Additional payment info
          if (isOverdue && !isPaid) ...[
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.errorLight.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.errorLight.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.warning_amber,
                    color: AppTheme.errorLight,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Pembayaran telah melewati jatuh tempo. Segera lakukan pembayaran untuk menghindari penalti.',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppTheme.errorLight,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Build payment detail row with icon and optional subtitle
  Widget _buildPaymentDetailRow(
    String label,
    String value,
    IconData icon, {
    String? subtitle,
    Color? subtitleColor,
    bool isHighlighted = false,
  }) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color:
                isHighlighted
                    ? AppTheme.primaryLight.withValues(alpha: 0.1)
                    : AppTheme.surfaceLight,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 16,
            color:
                isHighlighted
                    ? AppTheme.primaryLight
                    : AppTheme.textSecondaryLight,
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: AppTheme.textSecondaryLight,
                ),
              ),

              const SizedBox(height: 2),

              Text(
                value,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: isHighlighted ? FontWeight.w600 : FontWeight.w500,
                  color:
                      isHighlighted
                          ? AppTheme.primaryLight
                          : AppTheme.textPrimaryLight,
                ),
              ),

              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: subtitleColor ?? AppTheme.textSecondaryLight,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  /// Get payment status color
  Color _getPaymentStatusColor() {
    if (isPaid) {
      return AppTheme.successLight;
    } else if (DateTime.now().isAfter(dueDate)) {
      return AppTheme.errorLight;
    } else {
      return AppTheme.warningLight;
    }
  }

  /// Get payment status text
  String _getPaymentStatusText() {
    if (isPaid) {
      return 'Lunas';
    } else if (DateTime.now().isAfter(dueDate)) {
      return 'Terlambat';
    } else {
      return 'Belum Bayar';
    }
  }

  /// Get due date subtitle with contextual information
  String _getDueDateSubtitle(int daysUntilDue, bool isOverdue) {
    if (isOverdue) {
      final daysPastDue = -daysUntilDue;
      return 'Terlambat $daysPastDue hari';
    } else if (daysUntilDue == 0) {
      return 'Jatuh tempo hari ini';
    } else if (daysUntilDue == 1) {
      return 'Jatuh tempo besok';
    } else if (daysUntilDue <= 7) {
      return '$daysUntilDue hari lagi';
    } else {
      return '${(daysUntilDue / 7).floor()} minggu lagi';
    }
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

  /// Format date for display
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
