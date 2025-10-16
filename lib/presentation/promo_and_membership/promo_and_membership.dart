import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/filter_chips_widget.dart';
import './widgets/membership_card_widget.dart';
import './widgets/membership_levels_widget.dart';
import './widgets/promo_carousel_widget.dart';
import './widgets/voucher_card_widget.dart';

class PromoAndMembership extends StatefulWidget {
  const PromoAndMembership({super.key});

  @override
  State<PromoAndMembership> createState() => _PromoAndMembershipState();
}

class _PromoAndMembershipState extends State<PromoAndMembership>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String _selectedFilter = 'Semua';

  final List<String> _filterOptions = [
    'Semua',
    'Diskon',
    'Ongkir',
    'Cashback',
    'Spesial',
  ];

  // Current user membership level
  final String _currentMembershipLevel = 'Gold';

  // Mock membership data
  final Map<String, dynamic> _membershipData = {
    "level": "Gold",
    "currentPoints": 8500,
    "nextTierPoints": 15000,
    "nextTier": "Platinum",
    "benefits": [
      {
        "title": "Diskon Eksklusif hingga 15%",
        "description":
            "Dapatkan diskon khusus untuk produk pilihan setiap bulan",
      },
      {
        "title": "Gratis Ongkir untuk Pembelian di atas Rp 500.000",
        "description": "Nikmati pengiriman gratis ke seluruh Indonesia",
      },
      {
        "title": "Akses Early Bird Sale",
        "description": "Belanja lebih dulu sebelum promo dibuka untuk umum",
      },
      {
        "title": "Customer Service Prioritas",
        "description": "Layanan pelanggan khusus dengan respon lebih cepat",
      },
      {
        "title": "Cashback Poin 2x Lipat",
        "description":
            "Dapatkan poin reward dua kali lebih banyak setiap transaksi",
      },
    ],
  };

  // Mock promotional data
  final List<Map<String, dynamic>> _promoList = [
    {
      "id": 1,
      "discount": "30% OFF",
      "title": "Dental Chair Terbaru",
      "description":
          "Promo spesial untuk dental chair premium dengan teknologi terdepan",
      "imageUrl":
          "https://images.pexels.com/photos/6812540/pexels-photo-6812540.jpeg?auto=compress&cs=tinysrgb&w=800",
      "validUntil": "31 Des 2024",
      "isActive": true,
      "category": "discount",
    },
    {
      "id": 2,
      "discount": "GRATIS ONGKIR",
      "title": "Peralatan Sterilisasi",
      "description":
          "Gratis ongkir untuk semua produk sterilisasi ke seluruh Indonesia",
      "imageUrl":
          "https://images.pexels.com/photos/4386467/pexels-photo-4386467.jpeg?auto=compress&cs=tinysrgb&w=800",
      "validUntil": "15 Jan 2025",
      "isActive": true,
      "category": "shipping",
    },
    {
      "id": 3,
      "discount": "CASHBACK 20%",
      "title": "Handpiece Collection",
      "description":
          "Cashback hingga 20% untuk pembelian handpiece berkualitas tinggi",
      "imageUrl":
          "https://images.pexels.com/photos/6812542/pexels-photo-6812542.jpeg?auto=compress&cs=tinysrgb&w=800",
      "validUntil": "28 Des 2024",
      "isActive": true,
      "category": "cashback",
    },
  ];

  // Mock voucher data
  final List<Map<String, dynamic>> _voucherList = [
    {
      "id": 1,
      "code": "DENTAL30",
      "title": "Diskon 30% Semua Produk",
      "discount": "Rp 500.000",
      "validUntil": "31 Des 2024",
      "minPurchase": "Rp 2.000.000",
      "category": "discount",
      "isUsed": false,
      "isExpired": false,
    },
    {
      "id": 2,
      "code": "FREEONGKIR",
      "title": "Gratis Ongkir Seluruh Indonesia",
      "discount": "Rp 150.000",
      "validUntil": "15 Jan 2025",
      "minPurchase": "Rp 1.000.000",
      "category": "shipping",
      "isUsed": false,
      "isExpired": false,
    },
    {
      "id": 3,
      "code": "CASHBACK20",
      "title": "Cashback 20% Maksimal 1 Juta",
      "discount": "Rp 1.000.000",
      "validUntil": "28 Des 2024",
      "minPurchase": "Rp 3.000.000",
      "category": "cashback",
      "isUsed": false,
      "isExpired": false,
    },
    {
      "id": 4,
      "code": "GOLDMEMBER",
      "title": "Diskon Eksklusif Member Gold",
      "discount": "Rp 750.000",
      "validUntil": "10 Jan 2025",
      "minPurchase": "Rp 2.500.000",
      "category": "special",
      "isUsed": false,
      "isExpired": false,
    },
    {
      "id": 5,
      "code": "EXPIRED2024",
      "title": "Promo Tahun Lalu",
      "discount": "Rp 300.000",
      "validUntil": "31 Des 2023",
      "minPurchase": "Rp 1.500.000",
      "category": "discount",
      "isUsed": false,
      "isExpired": true,
    },
    {
      "id": 6,
      "code": "USED2024",
      "title": "Voucher yang Sudah Digunakan",
      "discount": "Rp 200.000",
      "validUntil": "31 Des 2024",
      "minPurchase": "Rp 1.000.000",
      "category": "discount",
      "isUsed": true,
      "isExpired": false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'Promo & Membership',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 18.sp,
          ),
        ),
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/profile-and-settings');
            },
            icon: CustomIconWidget(
              iconName: 'account_circle_outlined',
              color: colorScheme.onSurface,
              size: 24,
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: colorScheme.primary,
          unselectedLabelColor: colorScheme.onSurfaceVariant,
          indicatorColor: colorScheme.primary,
          indicatorWeight: 2.0,
          labelStyle: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 14.sp,
          ),
          unselectedLabelStyle: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w400,
            fontSize: 14.sp,
          ),
          tabs: [Tab(text: 'Promo'), Tab(text: 'Voucher')],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        color: colorScheme.primary,
        child: Column(
          children: [
            // Membership Levels - Always visible
            MembershipLevelsWidget(currentLevel: _currentMembershipLevel),

            // Tab Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [_buildPromoTab(), _buildVoucherTab()],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomBar(
        currentIndex: 3, // Promo & Membership tab
        onTap: (index) {
          // Handle bottom navigation
        },
        variant: CustomBottomBarVariant.standard,
      ),
    );
  }

  Widget _buildPromoTab() {
    return SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 2.h),

          // Section Title
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: Text(
              'Promo Terbaru',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 16.sp,
              ),
            ),
          ),
          SizedBox(height: 1.5.h),

          // Promotional Carousel
          PromoCarouselWidget(
            promoList: _promoList,
            onPromoTap: _handlePromoTap,
          ),

          SizedBox(height: 3.h),

          // Browse Products CTA
          Container(
            margin: EdgeInsets.symmetric(horizontal: 5.w),
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.primaryContainer.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Jelajahi Produk Lainnya',
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 14.sp,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        'Temukan peralatan dental berkualitas dengan harga terbaik',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontSize: 11.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 3.w),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/product-catalog');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    padding: EdgeInsets.symmetric(
                      horizontal: 4.w,
                      vertical: 1.h,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Browse',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 11.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  Widget _buildVoucherTab() {
    final filteredVouchers = _getFilteredVouchers();

    return Column(
      children: [
        SizedBox(height: 1.h),

        // Filter Chips
        FilterChipsWidget(
          filters: _filterOptions,
          selectedFilter: _selectedFilter,
          onFilterSelected: (filter) {
            setState(() {
              _selectedFilter = filter;
            });
          },
        ),

        SizedBox(height: 1.h),

        // Voucher List
        Expanded(
          child:
              filteredVouchers.isEmpty
                  ? _buildEmptyVoucherState()
                  : ListView.builder(
                    physics: AlwaysScrollableScrollPhysics(),
                    itemCount: filteredVouchers.length,
                    itemBuilder: (context, index) {
                      final voucher = filteredVouchers[index];
                      return VoucherCardWidget(
                        voucher: voucher,
                        onTap: () => _handleVoucherTap(voucher),
                      );
                    },
                  ),
        ),
      ],
    );
  }

  Widget _buildEmptyVoucherState() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'card_giftcard',
              color: colorScheme.onSurfaceVariant,
              size: 64,
            ),
            SizedBox(height: 2.h),
            Text(
              'Tidak ada voucher tersedia',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 16.sp,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Voucher untuk kategori $_selectedFilter belum tersedia saat ini',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontSize: 12.sp,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/product-catalog');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.5.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Browse Produk',
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 12.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getFilteredVouchers() {
    if (_selectedFilter == 'Semua') {
      return _voucherList;
    }

    String filterCategory = _selectedFilter.toLowerCase();
    switch (filterCategory) {
      case 'diskon':
        filterCategory = 'discount';
        break;
      case 'ongkir':
        filterCategory = 'shipping';
        break;
      case 'spesial':
        filterCategory = 'special';
        break;
    }

    return _voucherList.where((voucher) {
      final category = (voucher['category'] as String?) ?? '';
      return category.toLowerCase() == filterCategory;
    }).toList();
  }

  void _handlePromoTap(Map<String, dynamic> promo) {
    // Navigate to product detail or show promo details
    final promoId = promo['id'];
    Navigator.pushNamed(
      context,
      '/product-detail',
      arguments: {'promoId': promoId},
    );
  }

  void _handleVoucherTap(Map<String, dynamic> voucher) {
    // Handle voucher tap - could show details or copy code
    final bool isUsed = (voucher['isUsed'] as bool?) ?? false;
    final bool isExpired = (voucher['isExpired'] as bool?) ?? false;

    if (!isUsed && !isExpired) {
      // Show usage instructions or navigate to product catalog
      Navigator.pushNamed(context, '/product-catalog');
    }
  }

  Future<void> _refreshData() async {
    // Simulate refresh delay
    await Future.delayed(Duration(seconds: 1));

    // In a real app, this would refresh membership data and promotions
    setState(() {
      // Refresh state if needed
    });
  }
}
