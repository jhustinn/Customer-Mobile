import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class NotificationFilterTabsWidget extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onFilterChanged;
  final int allCount;
  final int paymentCount;
  final int orderCount;
  final int promotionCount;

  const NotificationFilterTabsWidget({
    Key? key,
    required this.selectedIndex,
    required this.onFilterChanged,
    required this.allCount,
    required this.paymentCount,
    required this.orderCount,
    required this.promotionCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final filters = [
      FilterTab(
        title: 'Semua',
        count: allCount,
        icon: Icons.notifications_outlined,
      ),
      FilterTab(
        title: 'Pembayaran',
        count: paymentCount,
        icon: Icons.payment_outlined,
      ),
      FilterTab(
        title: 'Pesanan',
        count: orderCount,
        icon: Icons.shopping_bag_outlined,
      ),
      FilterTab(
        title: 'Promosi',
        count: promotionCount,
        icon: Icons.local_offer_outlined,
      ),
    ];

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.backgroundLight,
        border: Border(
          bottom: BorderSide(
            color: AppTheme.dividerLight,
            width: 1.0,
          ),
        ),
      ),
      child: Row(
        children: List.generate(
          filters.length,
          (index) => Expanded(
            child: GestureDetector(
              onTap: () => onFilterChanged(index),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 1.w),
                padding: EdgeInsets.symmetric(vertical: 2.h),
                decoration: BoxDecoration(
                  color: selectedIndex == index
                      ? AppTheme.primaryLight
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(
                    color: selectedIndex == index
                        ? AppTheme.primaryLight
                        : AppTheme.dividerLight,
                    width: 1.0,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      filters[index].icon,
                      size: 20.sp,
                      color: selectedIndex == index
                          ? AppTheme.backgroundLight
                          : AppTheme.textSecondaryLight,
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      filters[index].title,
                      style: GoogleFonts.inter(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w500,
                        color: selectedIndex == index
                            ? AppTheme.backgroundLight
                            : AppTheme.textSecondaryLight,
                      ),
                    ),
                    if (filters[index].count > 0) ...[
                      SizedBox(height: 0.5.h),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 1.5.w,
                          vertical: 0.2.h,
                        ),
                        decoration: BoxDecoration(
                          color: selectedIndex == index
                              ? AppTheme.accentLight
                              : AppTheme.primaryLight,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Text(
                          '${filters[index].count}',
                          style: GoogleFonts.inter(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w600,
                            color: selectedIndex == index
                                ? AppTheme.textPrimaryLight
                                : AppTheme.backgroundLight,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class FilterTab {
  final String title;
  final int count;
  final IconData icon;

  const FilterTab({
    required this.title,
    required this.count,
    required this.icon,
  });
}
