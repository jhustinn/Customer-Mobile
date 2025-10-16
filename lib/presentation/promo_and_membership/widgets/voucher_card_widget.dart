import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class VoucherCardWidget extends StatelessWidget {
  final Map<String, dynamic> voucher;
  final VoidCallback? onTap;

  const VoucherCardWidget({
    super.key,
    required this.voucher,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final String code = (voucher['code'] as String?) ?? '';
    final String title = (voucher['title'] as String?) ?? '';
    final String discount = (voucher['discount'] as String?) ?? '';
    final String validUntil = (voucher['validUntil'] as String?) ?? '';
    final String minPurchase = (voucher['minPurchase'] as String?) ?? '';
    final bool isUsed = (voucher['isUsed'] as bool?) ?? false;
    final bool isExpired = (voucher['isExpired'] as bool?) ?? false;
    final String category = (voucher['category'] as String?) ?? 'general';

    return GestureDetector(
      onTap: onTap,
      onLongPress: () => _copyVoucherCode(context, code),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _getBorderColor(category, colorScheme, isUsed, isExpired),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.5.w, vertical: 0.8.h),
                        decoration: BoxDecoration(
                          color: _getCategoryColor(category, colorScheme)
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomIconWidget(
                              iconName: _getCategoryIcon(category),
                              color: _getCategoryColor(category, colorScheme),
                              size: 12,
                            ),
                            SizedBox(width: 1.w),
                            Text(
                              _getCategoryLabel(category),
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: _getCategoryColor(category, colorScheme),
                                fontWeight: FontWeight.w600,
                                fontSize: 9.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (isUsed || isExpired)
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 2.w, vertical: 0.5.h),
                          decoration: BoxDecoration(
                            color: colorScheme.outline.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            isExpired ? 'Kedaluwarsa' : 'Terpakai',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                              fontSize: 8.sp,
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    discount,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: _getCategoryColor(category, colorScheme),
                      fontWeight: FontWeight.w700,
                      fontSize: 18.sp,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 13.sp,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 1.5.h),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest
                          .withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: colorScheme.outline.withValues(alpha: 0.2),
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          code,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 12.sp,
                            fontFamily: 'monospace',
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _copyVoucherCode(context, code),
                          child: Container(
                            padding: EdgeInsets.all(1.w),
                            child: CustomIconWidget(
                              iconName: 'content_copy',
                              color: colorScheme.primary,
                              size: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (minPurchase.isNotEmpty) ...[
                              Text(
                                'Min. pembelian $minPurchase',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                  fontSize: 10.sp,
                                ),
                              ),
                              SizedBox(height: 0.5.h),
                            ],
                            Row(
                              children: [
                                CustomIconWidget(
                                  iconName: 'schedule',
                                  color: colorScheme.onSurfaceVariant,
                                  size: 12,
                                ),
                                SizedBox(width: 1.w),
                                Text(
                                  'Berlaku hingga $validUntil',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                    fontSize: 10.sp,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      if (!isUsed && !isExpired)
                        ElevatedButton(
                          onPressed: () => _showUsageInstructions(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                _getCategoryColor(category, colorScheme),
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                                horizontal: 4.w, vertical: 1.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'Gunakan',
                            style: theme.textTheme.labelMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 11.sp,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            if (isUsed || isExpired)
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Color _getBorderColor(
      String category, ColorScheme colorScheme, bool isUsed, bool isExpired) {
    if (isUsed || isExpired) {
      return colorScheme.outline.withValues(alpha: 0.3);
    }
    return _getCategoryColor(category, colorScheme).withValues(alpha: 0.3);
  }

  Color _getCategoryColor(String category, ColorScheme colorScheme) {
    switch (category.toLowerCase()) {
      case 'discount':
        return Color(0xFFE74C3C);
      case 'shipping':
        return Color(0xFF3498DB);
      case 'cashback':
        return Color(0xFF27AE60);
      case 'special':
        return Color(0xFF9B59B6);
      default:
        return colorScheme.primary;
    }
  }

  String _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'discount':
        return 'local_offer';
      case 'shipping':
        return 'local_shipping';
      case 'cashback':
        return 'account_balance_wallet';
      case 'special':
        return 'star';
      default:
        return 'card_giftcard';
    }
  }

  String _getCategoryLabel(String category) {
    switch (category.toLowerCase()) {
      case 'discount':
        return 'Diskon';
      case 'shipping':
        return 'Ongkir';
      case 'cashback':
        return 'Cashback';
      case 'special':
        return 'Spesial';
      default:
        return 'Voucher';
    }
  }

  void _copyVoucherCode(BuildContext context, String code) {
    if (code.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: code));
      Fluttertoast.showToast(
        msg: 'Kode voucher disalin: $code',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black87,
        textColor: Colors.white,
        fontSize: 12.sp,
      );
    }
  }

  void _showUsageInstructions(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            constraints: BoxConstraints(
              maxHeight: 60.h,
              maxWidth: 85.w,
            ),
            padding: EdgeInsets.all(4.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Cara Menggunakan Voucher',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 16.sp,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: CustomIconWidget(
                        iconName: 'close',
                        color: colorScheme.onSurface,
                        size: 20,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                _buildInstructionStep(
                  context,
                  '1',
                  'Pilih produk yang ingin dibeli',
                  'Browse katalog produk dan tambahkan ke keranjang',
                ),
                SizedBox(height: 1.5.h),
                _buildInstructionStep(
                  context,
                  '2',
                  'Masukkan kode voucher',
                  'Pada halaman checkout, masukkan kode: ${voucher['code']}',
                ),
                SizedBox(height: 1.5.h),
                _buildInstructionStep(
                  context,
                  '3',
                  'Selesaikan pembayaran',
                  'Diskon akan otomatis teraplikasi pada total pembayaran',
                ),
                SizedBox(height: 3.h),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.pushNamed(context, '/product-catalog');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      padding: EdgeInsets.symmetric(vertical: 1.5.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Mulai Belanja',
                      style: theme.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 12.sp,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInstructionStep(
      BuildContext context, String step, String title, String description) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 6.w,
          height: 6.w,
          decoration: BoxDecoration(
            color: colorScheme.primary,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              step,
              style: theme.textTheme.labelSmall?.copyWith(
                color: colorScheme.onPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 10.sp,
              ),
            ),
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 12.sp,
                ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                description,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 11.sp,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
