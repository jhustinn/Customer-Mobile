import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProductHighlightsWidget extends StatelessWidget {
  const ProductHighlightsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> featuredProducts = [
      {
        "id": 1,
        "name": "Dental Unit Premium X1",
        "price": "Rp 45.000.000",
        "originalPrice": "Rp 50.000.000",
        "discount": "10%",
        "image":
            "https://images.pexels.com/photos/3845810/pexels-photo-3845810.jpeg?auto=compress&cs=tinysrgb&w=400",
        "isNew": true,
      },
      {
        "id": 2,
        "name": "High Speed Handpiece Pro",
        "price": "Rp 2.500.000",
        "originalPrice": "Rp 3.000.000",
        "discount": "17%",
        "image":
            "https://images.unsplash.com/photo-1609840114035-3c981b782dfe?auto=format&fit=crop&w=400&q=80",
        "isNew": false,
      },
      {
        "id": 3,
        "name": "Dental Scaler Ultrasonic",
        "price": "Rp 8.750.000",
        "originalPrice": "Rp 10.000.000",
        "discount": "12%",
        "image":
            "https://images.pixabay.com/photo/2017/10/04/09/56/laboratory-2815641_960_720.jpg",
        "isNew": true,
      },
      {
        "id": 4,
        "name": "LED Curing Light Advanced",
        "price": "Rp 1.200.000",
        "originalPrice": "Rp 1.500.000",
        "discount": "20%",
        "image":
            "https://images.pexels.com/photos/3845810/pexels-photo-3845810.jpeg?auto=compress&cs=tinysrgb&w=400",
        "isNew": false,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Produk Unggulan',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/product-catalog');
                },
                child: Text(
                  'Lihat Semua',
                  style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 2.h),
        Container(
          height: 28.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            itemCount: featuredProducts.length,
            separatorBuilder: (context, index) => SizedBox(width: 3.w),
            itemBuilder: (context, index) {
              final product = featuredProducts[index];
              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/product-detail');
                },
                child: Container(
                  width: 45.w,
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                            ),
                            child: CustomImageWidget(
                              imageUrl: product["image"],
                              width: 45.w,
                              height: 15.h,
                              fit: BoxFit.cover,
                            ),
                          ),
                          if (product["isNew"])
                            Positioned(
                              top: 1.h,
                              left: 2.w,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 2.w, vertical: 0.5.h),
                                decoration: BoxDecoration(
                                  color:
                                      AppTheme.lightTheme.colorScheme.tertiary,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  'BARU',
                                  style: AppTheme
                                      .lightTheme.textTheme.labelSmall
                                      ?.copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 8.sp,
                                  ),
                                ),
                              ),
                            ),
                          if (product["discount"] != null)
                            Positioned(
                              top: 1.h,
                              right: 2.w,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 2.w, vertical: 0.5.h),
                                decoration: BoxDecoration(
                                  color: AppTheme.lightTheme.colorScheme.error,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '-${product["discount"]}',
                                  style: AppTheme
                                      .lightTheme.textTheme.labelSmall
                                      ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 8.sp,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(3.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product["name"],
                                style: AppTheme.lightTheme.textTheme.bodyMedium
                                    ?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 1.h),
                              if (product["originalPrice"] != null) ...[
                                Text(
                                  product["originalPrice"],
                                  style: AppTheme.lightTheme.textTheme.bodySmall
                                      ?.copyWith(
                                    color: AppTheme.lightTheme.colorScheme
                                        .onSurfaceVariant,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                                SizedBox(height: 0.5.h),
                              ],
                              Text(
                                product["price"],
                                style: AppTheme.lightTheme.textTheme.titleSmall
                                    ?.copyWith(
                                  color:
                                      AppTheme.lightTheme.colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Spacer(),
                              SizedBox(
                                width: double.infinity,
                                height: 4.h,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, '/product-detail');
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppTheme
                                        .lightTheme.colorScheme.tertiary,
                                    foregroundColor: Colors.black,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: EdgeInsets.zero,
                                  ),
                                  child: Text(
                                    'Pesan',
                                    style: AppTheme
                                        .lightTheme.textTheme.labelMedium
                                        ?.copyWith(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
