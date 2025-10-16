import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class MembershipLevelsWidget extends StatelessWidget {
  final String? currentLevel;

  const MembershipLevelsWidget({super.key, this.currentLevel});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final List<Map<String, dynamic>> membershipLevels = [
      {
        'level': 'Silver',
        'minPoints': 0,
        'maxPoints': 5000,
        'nextTier': 'Gold',
        'gradient': [Color(0xFF9E9E9E), Color(0xFFBDBDBD)],
        'icon': 'star',
        'benefits': [
          {
            'title': 'Diskon Eksklusif hingga 5%',
            'description': 'Dapatkan diskon khusus untuk produk pilihan',
          },
          {
            'title': 'Gratis Ongkir untuk Pembelian di atas Rp 1.000.000',
            'description': 'Nikmati pengiriman gratis untuk pembelian minimal',
          },
          {
            'title': 'Newsletter Eksklusif',
            'description': 'Informasi produk terbaru dan promo spesial',
          },
        ],
      },
      {
        'level': 'Gold',
        'minPoints': 5000,
        'maxPoints': 15000,
        'nextTier': 'Platinum',
        'gradient': [Color(0xFFFFB300), Color(0xFFFFC107)],
        'icon': 'star',
        'benefits': [
          {
            'title': 'Diskon Eksklusif hingga 15%',
            'description':
                'Dapatkan diskon khusus untuk produk pilihan setiap bulan',
          },
          {
            'title': 'Gratis Ongkir untuk Pembelian di atas Rp 500.000',
            'description': 'Nikmati pengiriman gratis ke seluruh Indonesia',
          },
          {
            'title': 'Akses Early Bird Sale',
            'description': 'Belanja lebih dulu sebelum promo dibuka untuk umum',
          },
          {
            'title': 'Customer Service Prioritas',
            'description': 'Layanan pelanggan khusus dengan respon lebih cepat',
          },
          {
            'title': 'Cashback Poin 2x Lipat',
            'description':
                'Dapatkan poin reward dua kali lebih banyak setiap transaksi',
          },
        ],
      },
      {
        'level': 'Platinum',
        'minPoints': 15000,
        'maxPoints': null,
        'nextTier': null,
        'gradient': [Color(0xFF8E44AD), Color(0xFF9B59B6)],
        'icon': 'diamond',
        'benefits': [
          {
            'title': 'Diskon Eksklusif hingga 25%',
            'description': 'Dapatkan diskon maksimal untuk semua produk',
          },
          {
            'title': 'Gratis Ongkir Tanpa Minimum',
            'description': 'Pengiriman gratis untuk semua pembelian',
          },
          {
            'title': 'Akses VIP Sale',
            'description': 'Belanja eksklusif dengan stok terbatas',
          },
          {
            'title': 'Dedicated Account Manager',
            'description': 'Personal assistant untuk kebutuhan dental Anda',
          },
          {
            'title': 'Cashback Poin 5x Lipat',
            'description': 'Bonus poin maksimal untuk setiap transaksi',
          },
          {
            'title': 'Priority Support 24/7',
            'description': 'Dukungan prioritas kapan saja Anda membutuhkan',
          },
        ],
      },
    ];

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
          child: Row(
            children: [
              Text(
                'Membership Levels',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 16.sp,
                ),
              ),
              Spacer(),
              Text(
                'Current: ${currentLevel ?? 'Silver'}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 1.h),
        SizedBox(
          height: 25.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            itemCount: membershipLevels.length,
            itemBuilder: (context, index) {
              final level = membershipLevels[index];
              final bool isCurrentLevel =
                  level['level'] == (currentLevel ?? 'Silver');

              return Container(
                width: 70.w,
                margin: EdgeInsets.only(right: 4.w),
                child: _buildMembershipCard(context, level, isCurrentLevel),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMembershipCard(
    BuildContext context,
    Map<String, dynamic> level,
    bool isCurrentLevel,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final String levelName = level['level'] as String;
    final int minPoints = level['minPoints'] as int;
    final int? maxPoints = level['maxPoints'] as int?;
    final String? nextTier = level['nextTier'] as String?;
    final List<Color> gradientColors = level['gradient'] as List<Color>;
    final String iconName = level['icon'] as String;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: gradientColors.first.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
        border:
            isCurrentLevel ? Border.all(color: Colors.white, width: 2) : null,
      ),
      child: Stack(
        children: [
          if (isCurrentLevel)
            Positioned(
              top: 3.w,
              right: 3.w,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'AKTIF',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: gradientColors.first,
                    fontWeight: FontWeight.w700,
                    fontSize: 8.sp,
                  ),
                ),
              ),
            ),
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: iconName,
                      color: Colors.white,
                      size: 24,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      levelName,
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 18.sp,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 1.h),
                Text(
                  'Minimum Points',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 10.sp,
                  ),
                ),
                Text(
                  '${minPoints.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}${maxPoints != null ? ' - ${maxPoints.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}' : '+'} Poin',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14.sp,
                  ),
                ),
                if (nextTier != null) ...[
                  SizedBox(height: 1.h),
                  Text(
                    'Next Level: $nextTier',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 10.sp,
                    ),
                  ),
                ] else ...[
                  SizedBox(height: 1.h),
                  Text(
                    'Level Tertinggi',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 10.sp,
                    ),
                  ),
                ],
                Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      _showBenefitsDialog(context, level);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white.withValues(alpha: 0.2),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: EdgeInsets.symmetric(vertical: 1.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(
                          color: Colors.white.withValues(alpha: 0.5),
                        ),
                      ),
                    ),
                    child: Text(
                      'Lihat Benefit',
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 11.sp,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showBenefitsDialog(BuildContext context, Map<String, dynamic> level) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final List<Map<String, dynamic>> benefits =
        (level['benefits'] as List?)?.cast<Map<String, dynamic>>() ?? [];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            constraints: BoxConstraints(maxHeight: 70.h, maxWidth: 85.w),
            padding: EdgeInsets.all(4.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: level['icon'] as String,
                          color: (level['gradient'] as List<Color>).first,
                          size: 20,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          'Benefit ${level['level']}',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 16.sp,
                          ),
                        ),
                      ],
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
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: benefits.length,
                    separatorBuilder:
                        (context, index) => SizedBox(height: 1.5.h),
                    itemBuilder: (context, index) {
                      final benefit = benefits[index];
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 0.5.h),
                            child: CustomIconWidget(
                              iconName: 'check_circle',
                              color: (level['gradient'] as List<Color>).first,
                              size: 16,
                            ),
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  (benefit['title'] as String?) ?? '',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12.sp,
                                  ),
                                ),
                                if (benefit['description'] != null) ...[
                                  SizedBox(height: 0.5.h),
                                  Text(
                                    (benefit['description'] as String?) ?? '',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: colorScheme.onSurfaceVariant,
                                      fontSize: 11.sp,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                SizedBox(height: 2.h),
                if (level['level'] != currentLevel) ...[
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        _showUpgradeInfo(context, level);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            (level['gradient'] as List<Color>).first,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 1.5.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Upgrade ke ${level['level']}',
                        style: theme.textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  void _showUpgradeInfo(BuildContext context, Map<String, dynamic> level) {
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
            padding: EdgeInsets.all(4.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomIconWidget(
                  iconName: 'info',
                  color: (level['gradient'] as List<Color>).first,
                  size: 48,
                ),
                SizedBox(height: 2.h),
                Text(
                  'Upgrade ke ${level['level']}',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 16.sp,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 1.h),
                Text(
                  'Kumpulkan minimal ${(level['minPoints'] as int).toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')} poin untuk naik ke level ${level['level']}.\n\nBelanja lebih banyak untuk mendapatkan poin dan nikmati benefit eksklusif!',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 12.sp,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 3.h),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 1.5.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Nanti',
                          style: theme.textTheme.labelLarge?.copyWith(
                            fontSize: 12.sp,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          // Navigate to product catalog to start shopping
                          Navigator.pushNamed(context, '/product-catalog');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              (level['gradient'] as List<Color>).first,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 1.5.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Belanja Sekarang',
                          style: theme.textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 12.sp,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
