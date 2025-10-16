import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FilterBottomSheetWidget extends StatefulWidget {
  final Map<String, dynamic> currentFilters;
  final Function(Map<String, dynamic>) onFiltersApplied;

  const FilterBottomSheetWidget({
    super.key,
    required this.currentFilters,
    required this.onFiltersApplied,
  });

  @override
  State<FilterBottomSheetWidget> createState() =>
      _FilterBottomSheetWidgetState();
}

class _FilterBottomSheetWidgetState extends State<FilterBottomSheetWidget> {
  late Map<String, dynamic> _filters;

  final List<String> _categories = [
    'Dental Chairs',
    'Instruments',
    'Imaging Equipment',
    'Sterilization',
    'Consumables',
    'Laboratory Equipment',
  ];

  final List<String> _brands = [
    'Sirona',
    'KaVo',
    'Planmeca',
    'Dentsply',
    'NSK',
    'W&H',
    'Bien-Air',
    'Ivoclar',
  ];

  final List<String> _availability = [
    'In Stock',
    'Pre-Order',
    'Coming Soon',
  ];

  @override
  void initState() {
    super.initState();
    _filters = Map<String, dynamic>.from(widget.currentFilters);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      height: 85.h,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: colorScheme.outline.withValues(alpha: 0.2),
                ),
              ),
            ),
            child: Row(
              children: [
                Text(
                  'Filter Produk',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Spacer(),
                TextButton(
                  onPressed: _clearAllFilters,
                  child: Text(
                    'Hapus Semua',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: AppTheme.primaryLight,
                    ),
                  ),
                ),
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

          // Filter Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category Filter
                  _buildFilterSection(
                    'Kategori',
                    _categories,
                    'categories',
                    true,
                  ),

                  SizedBox(height: 4.h),

                  // Price Range Filter
                  _buildPriceRangeSection(),

                  SizedBox(height: 4.h),

                  // Brand Filter
                  _buildFilterSection(
                    'Merek',
                    _brands,
                    'brands',
                    true,
                  ),

                  SizedBox(height: 4.h),

                  // Availability Filter
                  _buildFilterSection(
                    'Ketersediaan',
                    _availability,
                    'availability',
                    false,
                  ),
                ],
              ),
            ),
          ),

          // Apply Button
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: colorScheme.outline.withValues(alpha: 0.2),
                ),
              ),
            ),
            child: SizedBox(
              width: double.infinity,
              height: 6.h,
              child: ElevatedButton(
                onPressed: _applyFilters,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryLight,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Terapkan Filter',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection(
    String title,
    List<String> options,
    String filterKey,
    bool isMultiSelect,
  ) {
    return ExpansionTile(
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
      ),
      initiallyExpanded: true,
      children: options.map((option) {
        final isSelected = isMultiSelect
            ? (_filters[filterKey] as List<String>? ?? []).contains(option)
            : _filters[filterKey] == option;

        return CheckboxListTile(
          title: Text(option),
          value: isSelected,
          onChanged: (bool? value) {
            setState(() {
              if (isMultiSelect) {
                final currentList =
                    (_filters[filterKey] as List<String>? ?? []);
                if (value == true) {
                  if (!currentList.contains(option)) {
                    _filters[filterKey] = [...currentList, option];
                  }
                } else {
                  _filters[filterKey] =
                      currentList.where((item) => item != option).toList();
                }
              } else {
                _filters[filterKey] = value == true ? option : null;
              }
            });
          },
          controlAffinity: ListTileControlAffinity.leading,
        );
      }).toList(),
    );
  }

  Widget _buildPriceRangeSection() {
    final theme = Theme.of(context);
    final minPrice = (_filters['minPrice'] as double?) ?? 0.0;
    final maxPrice = (_filters['maxPrice'] as double?) ?? 100000000.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Rentang Harga',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),

        Row(
          children: [
            Expanded(
              child: TextFormField(
                initialValue: minPrice > 0 ? minPrice.toInt().toString() : '',
                decoration: InputDecoration(
                  labelText: 'Harga Minimum',
                  prefixText: 'Rp ',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  final price = double.tryParse(value) ?? 0.0;
                  setState(() {
                    _filters['minPrice'] = price;
                  });
                },
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: TextFormField(
                initialValue:
                    maxPrice < 100000000 ? maxPrice.toInt().toString() : '',
                decoration: InputDecoration(
                  labelText: 'Harga Maksimum',
                  prefixText: 'Rp ',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  final price = double.tryParse(value) ?? 100000000.0;
                  setState(() {
                    _filters['maxPrice'] = price;
                  });
                },
              ),
            ),
          ],
        ),

        SizedBox(height: 2.h),

        // Quick price options
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: [
            _buildPriceChip('< Rp 1 Juta', 0, 1000000),
            _buildPriceChip('Rp 1-5 Juta', 1000000, 5000000),
            _buildPriceChip('Rp 5-10 Juta', 5000000, 10000000),
            _buildPriceChip('> Rp 10 Juta', 10000000, 100000000),
          ],
        ),
      ],
    );
  }

  Widget _buildPriceChip(String label, double min, double max) {
    final isSelected = (_filters['minPrice'] as double?) == min &&
        (_filters['maxPrice'] as double?) == max;

    return GestureDetector(
      onTap: () {
        setState(() {
          _filters['minPrice'] = min;
          _filters['maxPrice'] = max;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primaryLight.withValues(alpha: 0.1)
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppTheme.primaryLight
                : Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
          ),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: isSelected
                    ? AppTheme.primaryLight
                    : Theme.of(context).colorScheme.onSurfaceVariant,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
        ),
      ),
    );
  }

  void _clearAllFilters() {
    setState(() {
      _filters.clear();
    });
  }

  void _applyFilters() {
    widget.onFiltersApplied(_filters);
    Navigator.pop(context);
  }
}
