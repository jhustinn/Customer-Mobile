import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_bottom_bar.dart';
import './widgets/filter_bottom_sheet_widget.dart';
import './widgets/filter_chip_widget.dart';
import './widgets/product_grid_widget.dart';
import './widgets/product_list_widget.dart';
import './widgets/sort_bottom_sheet_widget.dart';

class ProductCatalog extends StatefulWidget {
  const ProductCatalog({super.key});

  @override
  State<ProductCatalog> createState() => _ProductCatalogState();
}

class _ProductCatalogState extends State<ProductCatalog> {
  final TextEditingController _searchController = TextEditingController();
  bool _isGridView = true;
  bool _isLoading = false;
  String _currentSort = 'relevance';
  Map<String, dynamic> _currentFilters = {};
  List<Map<String, dynamic>> _products = [];
  List<Map<String, dynamic>> _filteredProducts = [];

  // Mock data for dental equipment products
  final List<Map<String, dynamic>> _mockProducts = [
    {
      "id": 1,
      "name": "Dental Chair Unit Sirona C4+",
      "category": "Dental Chairs",
      "brand": "Sirona",
      "price": "Rp 125.000.000",
      "priceValue": 125000000,
      "image":
          "https://images.unsplash.com/photo-1629909613654-28e377c37b09?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "availability": "In Stock",
      "isPopular": true,
      "dateAdded": "2024-09-20",
      "description":
          "Unit dental chair premium dengan teknologi terdepan untuk kenyamanan pasien dan efisiensi dokter."
    },
    {
      "id": 2,
      "name": "Ultrasonic Scaler NSK Varios 970",
      "category": "Instruments",
      "brand": "NSK",
      "price": "Rp 8.500.000",
      "priceValue": 8500000,
      "image":
          "https://images.unsplash.com/photo-1581594693702-fbdc51b2763b?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "availability": "In Stock",
      "isPopular": false,
      "dateAdded": "2024-09-18",
      "description":
          "Ultrasonic scaler dengan teknologi piezo untuk pembersihan karang gigi yang efektif."
    },
    {
      "id": 3,
      "name": "Digital X-Ray Sensor Planmeca ProSensor",
      "category": "Imaging Equipment",
      "brand": "Planmeca",
      "price": "Rp 45.000.000",
      "priceValue": 45000000,
      "image":
          "https://images.unsplash.com/photo-1559757148-5c350d0d3c56?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "availability": "Pre-Order",
      "isPopular": true,
      "dateAdded": "2024-09-22",
      "description":
          "Sensor digital X-ray dengan resolusi tinggi untuk diagnosis yang akurat."
    },
    {
      "id": 4,
      "name": "Autoclave Sterilizer W&H Lisa 522",
      "category": "Sterilization",
      "brand": "W&H",
      "price": "Rp 35.000.000",
      "priceValue": 35000000,
      "image":
          "https://images.unsplash.com/photo-1576091160399-112ba8d25d1f?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "availability": "In Stock",
      "isPopular": false,
      "dateAdded": "2024-09-15",
      "description":
          "Autoclave sterilizer dengan teknologi vacuum untuk sterilisasi instrumen yang sempurna."
    },
    {
      "id": 5,
      "name": "High Speed Handpiece KaVo 8000B",
      "category": "Instruments",
      "brand": "KaVo",
      "price": "Rp 12.000.000",
      "priceValue": 12000000,
      "image":
          "https://images.unsplash.com/photo-1606811841689-23dfddce3e95?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "availability": "In Stock",
      "isPopular": true,
      "dateAdded": "2024-09-19",
      "description":
          "Handpiece berkecepatan tinggi dengan teknologi ceramic bearing untuk performa optimal."
    },
    {
      "id": 6,
      "name": "LED Curing Light Ivoclar BluePhase Style",
      "category": "Instruments",
      "brand": "Ivoclar",
      "price": "Rp 6.500.000",
      "priceValue": 6500000,
      "image":
          "https://images.unsplash.com/photo-1551601651-2a8555f1a136?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "availability": "In Stock",
      "isPopular": false,
      "dateAdded": "2024-09-17",
      "description":
          "LED curing light dengan intensitas cahaya optimal untuk polymerisasi komposit."
    },
    {
      "id": 7,
      "name": "Dental Compressor Dürr Tornado 1",
      "category": "Laboratory Equipment",
      "brand": "Dürr",
      "price": "Rp 18.000.000",
      "priceValue": 18000000,
      "image":
          "https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "availability": "Coming Soon",
      "isPopular": false,
      "dateAdded": "2024-09-21",
      "description":
          "Kompresor dental dengan teknologi oil-free untuk udara bersih dan kering."
    },
    {
      "id": 8,
      "name": "Composite Kit Dentsply Ceram.X",
      "category": "Consumables",
      "brand": "Dentsply",
      "price": "Rp 2.500.000",
      "priceValue": 2500000,
      "image":
          "https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "availability": "In Stock",
      "isPopular": true,
      "dateAdded": "2024-09-16",
      "description":
          "Kit komposit dengan berbagai shade untuk restorasi estetik yang natural."
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeProducts();
  }

  void _initializeProducts() {
    setState(() {
      _products = List.from(_mockProducts);
      _filteredProducts = List.from(_products);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            // Sticky Header with improved spacing
            Container(
              color: colorScheme.surface,
              padding: EdgeInsets.fromLTRB(4.w, 3.h, 4.w, 2.h),
              child: Column(
                children: [
                  // Search Bar and View Toggle
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 6.h,
                          decoration: BoxDecoration(
                            color: colorScheme.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: colorScheme.outline.withValues(alpha: 0.3),
                            ),
                          ),
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: 'Cari produk dental...',
                              prefixIcon: Padding(
                                padding: EdgeInsets.all(3.w),
                                child: CustomIconWidget(
                                  iconName: 'search',
                                  color: colorScheme.onSurfaceVariant,
                                  size: 20,
                                ),
                              ),
                              suffixIcon: IconButton(
                                onPressed: _showFilterBottomSheet,
                                icon: CustomIconWidget(
                                  iconName: 'filter_list',
                                  color: _hasActiveFilters()
                                      ? AppTheme.primaryLight
                                      : colorScheme.onSurfaceVariant,
                                  size: 20,
                                ),
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 4.w,
                                vertical: 2.h,
                              ),
                            ),
                            onChanged: _onSearchChanged,
                          ),
                        ),
                      ),

                      SizedBox(width: 4.w),

                      // View Toggle Button
                      Container(
                        height: 6.h,
                        width: 6.h,
                        decoration: BoxDecoration(
                          color: colorScheme.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: colorScheme.outline.withValues(alpha: 0.3),
                          ),
                        ),
                        child: IconButton(
                          onPressed: _toggleView,
                          icon: CustomIconWidget(
                            iconName: _isGridView ? 'view_list' : 'grid_view',
                            color: AppTheme.primaryLight,
                            size: 24,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Filter Chips with improved spacing
                  if (_hasActiveFilters()) ...[
                    SizedBox(height: 2.5.h),
                    _buildFilterChips(),
                    SizedBox(height: 1.h),
                  ],
                ],
              ),
            ),

            // Divider between header and content
            Container(
              height: 1,
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    colorScheme.outline.withValues(alpha: 0),
                    colorScheme.outline.withValues(alpha: 0.1),
                    colorScheme.outline.withValues(alpha: 0),
                  ],
                ),
              ),
            ),

            SizedBox(height: 1.h),

            // Product List/Grid
            Expanded(
              child: RefreshIndicator(
                onRefresh: _onRefresh,
                child: _filteredProducts.isEmpty && !_isLoading
                    ? _buildEmptyState()
                    : _isGridView
                        ? ProductGridWidget(
                            products: _filteredProducts,
                            isLoading: _isLoading,
                            onLoadMore: _loadMoreProducts,
                            onProductTap: _onProductTap,
                            onOrderTap: _onOrderTap,
                          )
                        : ProductListWidget(
                            products: _filteredProducts,
                            isLoading: _isLoading,
                            onLoadMore: _loadMoreProducts,
                            onProductTap: _onProductTap,
                            onOrderTap: _onOrderTap,
                          ),
              ),
            ),
          ],
        ),
      ),

      // Floating Sort Button with improved positioning
      floatingActionButton: Container(
        margin: EdgeInsets.only(bottom: 2.h),
        child: FloatingActionButton.extended(
          onPressed: _showSortBottomSheet,
          backgroundColor: AppTheme.accentLight,
          foregroundColor: Colors.black,
          elevation: 4,
          icon: CustomIconWidget(
            iconName: 'sort',
            color: Colors.black,
            size: 20,
          ),
          label: Text(
            'Urutkan',
            style: theme.textTheme.labelLarge?.copyWith(
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),

      bottomNavigationBar: CustomBottomBar(
        currentIndex: 1, // Catalog tab
        onTap: (index) {
          // Handle bottom navigation
        },
      ),
    );
  }

  Widget _buildFilterChips() {
    List<Widget> chips = [];

    // Category chips
    if (_currentFilters['categories'] != null) {
      final categories = _currentFilters['categories'] as List<String>;
      for (String category in categories) {
        chips.add(
          FilterChipWidget(
            label: category,
            count: _getFilterCount('categories', category),
            isSelected: true,
            onRemove: () => _removeFilter('categories', category),
          ),
        );
      }
    }

    // Brand chips
    if (_currentFilters['brands'] != null) {
      final brands = _currentFilters['brands'] as List<String>;
      for (String brand in brands) {
        chips.add(
          FilterChipWidget(
            label: brand,
            count: _getFilterCount('brands', brand),
            isSelected: true,
            onRemove: () => _removeFilter('brands', brand),
          ),
        );
      }
    }

    // Price range chip
    if (_currentFilters['minPrice'] != null ||
        _currentFilters['maxPrice'] != null) {
      final minPrice = _currentFilters['minPrice'] as double? ?? 0;
      final maxPrice = _currentFilters['maxPrice'] as double? ?? 100000000;
      String priceLabel = '';

      if (minPrice > 0 && maxPrice < 100000000) {
        priceLabel = 'Rp ${_formatPrice(minPrice)} - ${_formatPrice(maxPrice)}';
      } else if (minPrice > 0) {
        priceLabel = '> Rp ${_formatPrice(minPrice)}';
      } else if (maxPrice < 100000000) {
        priceLabel = '< Rp ${_formatPrice(maxPrice)}';
      }

      if (priceLabel.isNotEmpty) {
        chips.add(
          FilterChipWidget(
            label: priceLabel,
            count: 0,
            isSelected: true,
            onRemove: () => _removePriceFilter(),
          ),
        );
      }
    }

    // Clear all chip
    if (chips.isNotEmpty) {
      chips.add(
        GestureDetector(
          onTap: _clearAllFilters,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: AppTheme.errorLight.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppTheme.errorLight,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Hapus Semua',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: AppTheme.errorLight,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                SizedBox(width: 1.w),
                CustomIconWidget(
                  iconName: 'close',
                  color: AppTheme.errorLight,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Container(
      height: 5.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 1.w),
        itemCount: chips.length,
        separatorBuilder: (context, index) => SizedBox(width: 2.5.w),
        itemBuilder: (context, index) => chips[index],
      ),
    );
  }

  Widget _buildEmptyState() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'search_off',
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
              size: 64,
            ),
            SizedBox(height: 3.h),
            Text(
              'Produk Tidak Ditemukan',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Coba ubah kata kunci pencarian atau hapus beberapa filter untuk melihat lebih banyak produk.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.h),
            if (_hasActiveFilters())
              ElevatedButton(
                onPressed: _clearAllFilters,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryLight,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                ),
                child: Text('Hapus Semua Filter'),
              ),
          ],
        ),
      ),
    );
  }

  void _toggleView() {
    setState(() {
      _isGridView = !_isGridView;
    });
  }

  void _onSearchChanged(String query) {
    _applyFiltersAndSearch();
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheetWidget(
        currentFilters: _currentFilters,
        onFiltersApplied: (filters) {
          setState(() {
            _currentFilters = filters;
          });
          _applyFiltersAndSearch();
        },
      ),
    );
  }

  void _showSortBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => SortBottomSheetWidget(
        currentSort: _currentSort,
        onSortSelected: (sortKey) {
          setState(() {
            _currentSort = sortKey;
          });
          _applySorting();
        },
      ),
    );
  }

  void _applyFiltersAndSearch() {
    List<Map<String, dynamic>> filtered = List.from(_products);

    // Apply search filter
    final query = _searchController.text.toLowerCase();
    if (query.isNotEmpty) {
      filtered = filtered.where((product) {
        final name = (product['name'] as String).toLowerCase();
        final category = (product['category'] as String).toLowerCase();
        final brand = (product['brand'] as String).toLowerCase();
        return name.contains(query) ||
            category.contains(query) ||
            brand.contains(query);
      }).toList();
    }

    // Apply category filter
    if (_currentFilters['categories'] != null) {
      final categories = _currentFilters['categories'] as List<String>;
      if (categories.isNotEmpty) {
        filtered = filtered
            .where((product) => categories.contains(product['category']))
            .toList();
      }
    }

    // Apply brand filter
    if (_currentFilters['brands'] != null) {
      final brands = _currentFilters['brands'] as List<String>;
      if (brands.isNotEmpty) {
        filtered = filtered
            .where((product) => brands.contains(product['brand']))
            .toList();
      }
    }

    // Apply price filter
    if (_currentFilters['minPrice'] != null ||
        _currentFilters['maxPrice'] != null) {
      final minPrice = _currentFilters['minPrice'] as double? ?? 0;
      final maxPrice =
          _currentFilters['maxPrice'] as double? ?? double.infinity;

      filtered = filtered.where((product) {
        final price = product['priceValue'] as int;
        return price >= minPrice && price <= maxPrice;
      }).toList();
    }

    // Apply availability filter
    if (_currentFilters['availability'] != null) {
      final availability = _currentFilters['availability'] as String;
      filtered = filtered
          .where((product) => product['availability'] == availability)
          .toList();
    }

    setState(() {
      _filteredProducts = filtered;
    });

    _applySorting();
  }

  void _applySorting() {
    List<Map<String, dynamic>> sorted = List.from(_filteredProducts);

    switch (_currentSort) {
      case 'price_low':
        sorted.sort((a, b) =>
            (a['priceValue'] as int).compareTo(b['priceValue'] as int));
        break;
      case 'price_high':
        sorted.sort((a, b) =>
            (b['priceValue'] as int).compareTo(a['priceValue'] as int));
        break;
      case 'newest':
        sorted.sort((a, b) =>
            (b['dateAdded'] as String).compareTo(a['dateAdded'] as String));
        break;
      case 'popular':
        sorted.sort((a, b) {
          final aPopular = a['isPopular'] as bool ? 1 : 0;
          final bPopular = b['isPopular'] as bool ? 1 : 0;
          return bPopular.compareTo(aPopular);
        });
        break;
      case 'name_asc':
        sorted.sort(
            (a, b) => (a['name'] as String).compareTo(b['name'] as String));
        break;
      case 'name_desc':
        sorted.sort(
            (a, b) => (b['name'] as String).compareTo(a['name'] as String));
        break;
      case 'relevance':
      default:
        // Keep current order for relevance
        break;
    }

    setState(() {
      _filteredProducts = sorted;
    });
  }

  Future<void> _onRefresh() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate network delay
    await Future.delayed(Duration(seconds: 1));

    _initializeProducts();
    _applyFiltersAndSearch();

    setState(() {
      _isLoading = false;
    });
  }

  void _loadMoreProducts() {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    // Simulate loading more products
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  void _onProductTap(Map<String, dynamic> product) {
    Navigator.pushNamed(
      context,
      '/product-detail',
      arguments: product,
    );
  }

  void _onOrderTap(Map<String, dynamic> product) {
    // Handle order functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Menambahkan ${product['name']} ke keranjang...'),
        backgroundColor: AppTheme.successLight,
      ),
    );
  }

  bool _hasActiveFilters() {
    return _currentFilters.isNotEmpty;
  }

  int _getFilterCount(String filterType, String value) {
    return _products.where((product) => product[filterType] == value).length;
  }

  void _removeFilter(String filterType, String value) {
    setState(() {
      if (_currentFilters[filterType] != null) {
        final currentList = _currentFilters[filterType] as List<String>;
        currentList.remove(value);
        if (currentList.isEmpty) {
          _currentFilters.remove(filterType);
        }
      }
    });
    _applyFiltersAndSearch();
  }

  void _removePriceFilter() {
    setState(() {
      _currentFilters.remove('minPrice');
      _currentFilters.remove('maxPrice');
    });
    _applyFiltersAndSearch();
  }

  void _clearAllFilters() {
    setState(() {
      _currentFilters.clear();
      _searchController.clear();
    });
    _applyFiltersAndSearch();
  }

  String _formatPrice(double price) {
    if (price >= 1000000) {
      return '${(price / 1000000).toStringAsFixed(0)} Juta';
    } else if (price >= 1000) {
      return '${(price / 1000).toStringAsFixed(0)} Ribu';
    } else {
      return price.toStringAsFixed(0);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
