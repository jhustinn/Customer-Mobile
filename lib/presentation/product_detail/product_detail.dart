import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/product_image_gallery.dart';
import './widgets/product_info_section.dart';
import './widgets/product_tabs_section.dart';
import './widgets/related_products_section.dart';
import './widgets/sticky_bottom_bar.dart';

class ProductDetail extends StatefulWidget {
  const ProductDetail({super.key});

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  final ScrollController _scrollController = ScrollController();
  bool _showStickyBar = false;

  // Mock product data
  final Map<String, dynamic> productData = {
    "id": 1,
    "name": "Dental Unit Chair Premium DU-3000",
    "price": "Rp 125.000.000",
    "originalPrice": "Rp 150.000.000",
    "discount": 17,
    "rating": 4.8,
    "reviewCount": 24,
    "images": [
      "https://images.unsplash.com/photo-1629909613654-28e377c37b09?w=800&h=600&fit=crop",
      "https://images.unsplash.com/photo-1581594693702-fbdc51b2763b?w=800&h=600&fit=crop",
      "https://images.unsplash.com/photo-1576091160399-112ba8d25d1f?w=800&h=600&fit=crop",
      "https://images.unsplash.com/photo-1559757148-5c350d0d3c56?w=800&h=600&fit=crop",
    ],
    "description":
        """Unit dental chair premium dengan teknologi terdepan untuk klinik gigi modern. Dilengkapi dengan sistem hidrolik yang halus, kontrol elektronik yang presisi, dan desain ergonomis yang memberikan kenyamanan maksimal bagi dokter dan pasien.

Fitur unggulan meliputi lampu LED dengan intensitas cahaya yang dapat disesuaikan, sistem suction yang powerful, dan water spray dengan kontrol suhu otomatis. Kursi dapat diatur dalam berbagai posisi dengan mudah menggunakan kontrol panel yang intuitif.

Material berkualitas tinggi dengan lapisan anti-bakteri memastikan kebersihan dan daya tahan jangka panjang. Cocok untuk berbagai prosedur dental mulai dari pemeriksaan rutin hingga perawatan kompleks.""",
    "specifications": [
      {"label": "Dimensi", "value": "180 x 120 x 85 cm"},
      {"label": "Berat", "value": "280 kg"},
      {"label": "Voltase", "value": "220V / 50Hz"},
      {"label": "Daya", "value": "2200W"},
      {"label": "Sistem Hidrolik", "value": "Elektro-hidrolik"},
      {"label": "Lampu", "value": "LED 50.000 lux"},
      {"label": "Water System", "value": "Automatic water control"},
      {"label": "Suction", "value": "Dual suction system"},
      {"label": "Material", "value": "Stainless steel + PU leather"},
      {"label": "Garansi", "value": "3 tahun"},
    ],
    "reviews": [
      {
        "customerName": "Dr. Ahmad Santoso",
        "rating": 5,
        "date": "15 Sep 2024",
        "comment":
            "Unit dental chair yang sangat berkualitas. Pasien merasa nyaman dan kontrol yang mudah digunakan. Investasi yang sangat worth it untuk klinik."
      },
      {
        "customerName": "Dr. Sari Indrawati",
        "rating": 5,
        "date": "08 Sep 2024",
        "comment":
            "Kualitas premium dengan harga yang kompetitif. Sistem hidrolik sangat halus dan lampu LED memberikan pencahayaan yang sempurna untuk prosedur."
      },
      {
        "customerName": "Dr. Budi Prasetyo",
        "rating": 4,
        "date": "02 Sep 2024",
        "comment":
            "Produk bagus dengan fitur lengkap. Instalasi mudah dan tim support sangat membantu. Hanya perlu waktu adaptasi untuk menggunakan semua fitur."
      },
    ],
  };

  final List<Map<String, dynamic>> relatedProducts = [
    {
      "id": 2,
      "name": "Dental X-Ray Unit Digital",
      "price": "Rp 45.000.000",
      "rating": 4.7,
      "image":
          "https://images.unsplash.com/photo-1576091160550-2173dba999ef?w=400&h=300&fit=crop",
    },
    {
      "id": 3,
      "name": "Ultrasonic Scaler Pro",
      "price": "Rp 8.500.000",
      "rating": 4.6,
      "image":
          "https://images.unsplash.com/photo-1559757175-0eb30cd8c063?w=400&h=300&fit=crop",
    },
    {
      "id": 4,
      "name": "LED Curing Light",
      "price": "Rp 3.200.000",
      "rating": 4.8,
      "image":
          "https://images.unsplash.com/photo-1576091160399-112ba8d25d1f?w=400&h=300&fit=crop",
    },
    {
      "id": 5,
      "name": "Dental Compressor Silent",
      "price": "Rp 12.000.000",
      "rating": 4.5,
      "image":
          "https://images.unsplash.com/photo-1581594693702-fbdc51b2763b?w=400&h=300&fit=crop",
    },
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // Show sticky bottom bar when scrolled past product info section
    final shouldShow = _scrollController.offset > 60.h;
    if (shouldShow != _showStickyBar) {
      setState(() {
        _showStickyBar = shouldShow;
      });
    }
  }

  void _onSharePressed() {
    HapticFeedback.selectionClick();
    // Share functionality would generate product links for B2B communication
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Link produk telah disalin ke clipboard'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _onOrderPressed() {
    HapticFeedback.lightImpact();
    // Navigate directly to checkout process with product data
    Navigator.pushNamed(
      context,
      AppRoutes.checkoutProcess,
      arguments: {
        'directCheckout': true,
        'product': {
          'id': productData['id'],
          'name': productData['name'],
          'price': productData['price'],
          'image': (productData['images'] as List).first,
        },
        'quantity': 1,
      },
    );
  }

  void _onAddToCart() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Produk ditambahkan ke keranjang'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _onBuyNow() {
    HapticFeedback.lightImpact();
    // Navigate directly to checkout process with product data and quantity
    Navigator.pushNamed(
      context,
      AppRoutes.checkoutProcess,
      arguments: {
        'product': {
          'id': productData['id'],
          'name': productData['name'],
          'price': productData['price'],
          'image': (productData['images'] as List).first,
        },
        'quantity': 1, // Default quantity, will be updated by sticky bar
        'directCheckout': true, // Flag to indicate direct checkout
      },
    );
  }

  void _onRelatedProductTap(Map<String, dynamic> product) {
    // Navigate to another product detail (would maintain catalog scroll position)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Membuka detail ${product['name']}'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              // App Bar
              SliverAppBar(
                expandedHeight: 50.h,
                pinned: true,
                backgroundColor: colorScheme.surface,
                foregroundColor: colorScheme.onSurface,
                elevation: 0,
                leading: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: CustomIconWidget(
                      iconName: 'arrow_back',
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
                actions: [
                  IconButton(
                    onPressed: _onSharePressed,
                    icon: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: CustomIconWidget(
                        iconName: 'share',
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  SizedBox(width: 2.w),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: ProductImageGallery(
                    images: (productData['images'] as List).cast<String>(),
                    productName: productData['name'] as String,
                  ),
                ),
              ),

              // Product Info Section
              SliverToBoxAdapter(
                child: ProductInfoSection(
                  productName: productData['name'] as String,
                  price: productData['price'] as String,
                  originalPrice: productData['originalPrice'] as String,
                  discount: productData['discount'] as int,
                  rating: productData['rating'] as double,
                  reviewCount: productData['reviewCount'] as int,
                  onOrderPressed: _onOrderPressed,
                ),
              ),

              // Product Tabs Section
              SliverToBoxAdapter(
                child: ProductTabsSection(
                  description: productData['description'] as String,
                  specifications: (productData['specifications'] as List)
                      .cast<Map<String, String>>(),
                  reviews: (productData['reviews'] as List)
                      .cast<Map<String, dynamic>>(),
                ),
              ),

              // Related Products Section
              SliverToBoxAdapter(
                child: RelatedProductsSection(
                  relatedProducts: relatedProducts,
                  onProductTap: _onRelatedProductTap,
                ),
              ),

              // Bottom spacing for sticky bar
              SliverToBoxAdapter(
                child: SizedBox(height: 12.h),
              ),
            ],
          ),

          // Sticky Bottom Bar
          if (_showStickyBar)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: StickyBottomBar(
                price: productData['price'] as String,
                onAddToCart: _onAddToCart,
                onBuyNow: _onBuyNow,
              ),
            ),
        ],
      ),
    );
  }
}
