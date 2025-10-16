import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QuickActionsWidget extends StatelessWidget {
  final VoidCallback? onPayInvoice;
  final VoidCallback? onViewCredit;
  final VoidCallback? onTransactionHistory;
  final VoidCallback? onDownloadStatements;

  const QuickActionsWidget({
    super.key,
    this.onPayInvoice,
    this.onViewCredit,
    this.onTransactionHistory,
    this.onDownloadStatements,
  });

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> actions = [
      {
        'icon': 'payment',
        'title': 'Bayar Invoice',
        'subtitle': 'Pembayaran tagihan',
        'color': AppTheme.lightTheme.primaryColor,
        'onTap': onPayInvoice,
      },
      {
        'icon': 'account_balance_wallet',
        'title': 'Lihat Kredit',
        'subtitle': 'Limit & saldo kredit',
        'color': AppTheme.lightTheme.colorScheme.secondary,
        'onTap': onViewCredit,
      },
      {
        'icon': 'history',
        'title': 'Riwayat Transaksi',
        'subtitle': 'Semua transaksi',
        'color': AppTheme.warningLight,
        'onTap': onTransactionHistory,
      },
      {
        'icon': 'download',
        'title': 'Unduh Laporan',
        'subtitle': 'Statement & invoice',
        'color': AppTheme.successLight,
        'onTap': onDownloadStatements,
      },
    ];

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Aksi Cepat',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 2.h),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 3.w,
              mainAxisSpacing: 2.h,
              childAspectRatio: 1.4,
            ),
            itemCount: actions.length,
            itemBuilder: (context, index) {
              final action = actions[index];
              return GestureDetector(
                onTap: action['onTap'],
                child: Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.2),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.shadowLight
                            .withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(2.w),
                        decoration: BoxDecoration(
                          color:
                              (action['color'] as Color).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: CustomIconWidget(
                          iconName: action['icon'],
                          color: action['color'],
                          size: 24,
                        ),
                      ),
                      SizedBox(height: 1.5.h),
                      Text(
                        action['title'],
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.lightTheme.colorScheme.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        action['subtitle'],
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w400,
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}