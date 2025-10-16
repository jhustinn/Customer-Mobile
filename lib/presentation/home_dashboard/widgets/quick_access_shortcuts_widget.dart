import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QuickAccessShortcutsWidget extends StatelessWidget {
  const QuickAccessShortcutsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> shortcuts = [
      {
        "icon": "inventory_2",
        "label": "Katalog Produk",
        "route": "/product-catalog",
        "color": AppTheme.lightTheme.colorScheme.primary,
      },
      {
        "icon": "account_balance_wallet",
        "label": "Keuangan",
        "route": "/finance-dashboard",
        "color": AppTheme.lightTheme.colorScheme.secondary,
      },
      {
        "icon": "local_offer",
        "label": "Promo",
        "route": "/promo-and-membership",
        "color": AppTheme.lightTheme.colorScheme.tertiary,
      },
      {
        "icon": "card_membership",
        "label": "Membership",
        "route": "/promo-and-membership",
        "color": AppTheme.lightTheme.colorScheme.primary,
      },
    ];

    return 
    Center(child: Container(
      width: 90.w,
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 3.w,
          mainAxisSpacing: 2.h,
          childAspectRatio: 1.2,
        ),
        itemCount: shortcuts.length,
        itemBuilder: (context, index) {
          final shortcut = shortcuts[index];
          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, shortcut["route"]);
            },
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.1),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.lightTheme.colorScheme.shadow
                        .withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 12.w,
                    height: 6.h,
                    decoration: BoxDecoration(
                      color:
                          (shortcut["color"] as Color).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: CustomIconWidget(
                        iconName: shortcut["icon"],
                        color: shortcut["color"],
                        size: 24,
                      ),
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    shortcut["label"],
                    style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    )
  );

    
  }
}
