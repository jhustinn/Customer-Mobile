import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PromoCarouselWidget extends StatefulWidget {
  final List<Map<String, dynamic>> promoList;
  final Function(Map<String, dynamic>) onPromoTap;

  const PromoCarouselWidget({
    super.key,
    required this.promoList,
    required this.onPromoTap,
  });

  @override
  State<PromoCarouselWidget> createState() => _PromoCarouselWidgetState();
}

class _PromoCarouselWidgetState extends State<PromoCarouselWidget> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.85);
    _startAutoAdvance();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoAdvance() {
    if (widget.promoList.isNotEmpty) {
      Future.delayed(Duration(seconds: 4), () {
        if (mounted && widget.promoList.isNotEmpty) {
          final nextIndex = (_currentIndex + 1) % widget.promoList.length;
          _pageController.animateToPage(
            nextIndex,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
          _startAutoAdvance();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (widget.promoList.isEmpty) {
      return Container(
        height: 20.h,
        margin: EdgeInsets.symmetric(horizontal: 5.w),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconWidget(
                iconName: 'local_offer',
                color: colorScheme.onSurfaceVariant,
                size: 32,
              ),
              SizedBox(height: 1.h),
              Text(
                'Tidak ada promo tersedia',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        Container(
          height: 20.h,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemCount: widget.promoList.length,
            itemBuilder: (context, index) {
              final promo = widget.promoList[index];
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 2.w),
                child: _buildPromoCard(promo, theme, colorScheme),
              );
            },
          ),
        ),
        SizedBox(height: 1.5.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.promoList.length,
            (index) => AnimatedContainer(
              duration: Duration(milliseconds: 300),
              margin: EdgeInsets.symmetric(horizontal: 1.w),
              height: 0.8.h,
              width: _currentIndex == index ? 6.w : 2.w,
              decoration: BoxDecoration(
                color: _currentIndex == index
                    ? colorScheme.primary
                    : colorScheme.outline.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPromoCard(
      Map<String, dynamic> promo, ThemeData theme, ColorScheme colorScheme) {
    final String discount = (promo['discount'] as String?) ?? '';
    final String title = (promo['title'] as String?) ?? '';
    final String description = (promo['description'] as String?) ?? '';
    final String imageUrl = (promo['imageUrl'] as String?) ?? '';
    final String validUntil = (promo['validUntil'] as String?) ?? '';
    final bool isActive = (promo['isActive'] as bool?) ?? true;

    return GestureDetector(
      onTap: isActive ? () => widget.onPromoTap(promo) : null,
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: EdgeInsets.all(4.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (discount.isNotEmpty) ...[
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 2.w, vertical: 0.5.h),
                              decoration: BoxDecoration(
                                color: AppTheme.lightTheme.colorScheme.tertiary,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                discount,
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: AppTheme
                                      .lightTheme.colorScheme.onTertiary,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 10.sp,
                                ),
                              ),
                            ),
                            SizedBox(height: 1.h),
                          ],
                          Text(
                            title,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 13.sp,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (description.isNotEmpty) ...[
                            SizedBox(height: 0.5.h),
                            Text(
                              description,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                                fontSize: 10.sp,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                          if (validUntil.isNotEmpty) ...[
                            SizedBox(height: 1.h),
                            Row(
                              children: [
                                CustomIconWidget(
                                  iconName: 'schedule',
                                  color: colorScheme.onSurfaceVariant,
                                  size: 12,
                                ),
                                SizedBox(width: 1.w),
                                Text(
                                  'Berlaku hingga $validUntil',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                    fontSize: 9.sp,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      height: double.infinity,
                      child: imageUrl.isNotEmpty
                          ? CustomImageWidget(
                              imageUrl: imageUrl,
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                            )
                          : Container(
                              color: colorScheme.surfaceContainerHighest,
                              child: Center(
                                child: CustomIconWidget(
                                  iconName: 'image',
                                  color: colorScheme.onSurfaceVariant,
                                  size: 32,
                                ),
                              ),
                            ),
                    ),
                  ),
                ],
              ),
              if (!isActive)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Promo Berakhir',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 11.sp,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
