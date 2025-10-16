import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SortBottomSheetWidget extends StatelessWidget {
  final String currentSort;
  final Function(String) onSortSelected;

  const SortBottomSheetWidget({
    super.key,
    required this.currentSort,
    required this.onSortSelected,
  });

  static const List<Map<String, String>> _sortOptions = [
    {
      'key': 'relevance',
      'label': 'Relevansi',
      'description': 'Paling sesuai dengan pencarian'
    },
    {
      'key': 'price_low',
      'label': 'Harga: Rendah ke Tinggi',
      'description': 'Produk termurah dulu'
    },
    {
      'key': 'price_high',
      'label': 'Harga: Tinggi ke Rendah',
      'description': 'Produk termahal dulu'
    },
    {'key': 'newest', 'label': 'Terbaru', 'description': 'Produk terbaru dulu'},
    {
      'key': 'popular',
      'label': 'Terpopuler',
      'description': 'Paling banyak dipesan'
    },
    {
      'key': 'name_asc',
      'label': 'Nama: A-Z',
      'description': 'Urutan alfabetis'
    },
    {
      'key': 'name_desc',
      'label': 'Nama: Z-A',
      'description': 'Urutan alfabetis terbalik'
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            margin: EdgeInsets.only(top: 2.h),
            width: 10.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: colorScheme.outline.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                Text(
                  'Urutkan Berdasarkan',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: CustomIconWidget(
                    iconName: 'close',
                    color: colorScheme.onSurfaceVariant,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),

          // Sort Options
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: _sortOptions.length,
            separatorBuilder: (context, index) => Divider(
              height: 1,
              color: colorScheme.outline.withValues(alpha: 0.1),
            ),
            itemBuilder: (context, index) {
              final option = _sortOptions[index];
              final isSelected = currentSort == option['key'];

              return ListTile(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                title: Text(
                  option['label']!,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected
                        ? AppTheme.primaryLight
                        : colorScheme.onSurface,
                  ),
                ),
                subtitle: Text(
                  option['description']!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                trailing: isSelected
                    ? CustomIconWidget(
                        iconName: 'check_circle',
                        color: AppTheme.primaryLight,
                        size: 24,
                      )
                    : null,
                onTap: () {
                  onSortSelected(option['key']!);
                  Navigator.pop(context);
                },
              );
            },
          ),

          SizedBox(height: 4.h),
        ],
      ),
    );
  }
}
