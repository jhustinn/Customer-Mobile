import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../models/notification_model.dart';

class NotificationCardWidget extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onTap;

  const NotificationCardWidget({
    Key? key,
    required this.notification,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.horizontal,
      background: _buildDismissBackground(isSecondary: false),
      secondaryBackground: _buildDismissBackground(isSecondary: true),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          // Mark as read action
          return false; // Don't actually dismiss
        } else {
          // Delete action
          return await _showDeleteConfirmation(context);
        }
      },
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
            decoration: BoxDecoration(
              color: notification.isRead
                  ? AppTheme.backgroundLight
                  : AppTheme.surfaceLight,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Notification Icon/Image
                _buildNotificationIcon(),

                SizedBox(width: 3.w),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header with title and timestamp
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              notification.title,
                              style: GoogleFonts.inter(
                                fontSize: 14.sp,
                                fontWeight: notification.isRead
                                    ? FontWeight.w500
                                    : FontWeight.w600,
                                color: AppTheme.textPrimaryLight,
                              ),
                            ),
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            _formatTimestamp(notification.timestamp),
                            style: GoogleFonts.inter(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w400,
                              color: AppTheme.textSecondaryLight,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 1.h),

                      // Message
                      Text(
                        notification.message,
                        style: GoogleFonts.inter(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: AppTheme.textSecondaryLight,
                          height: 1.4,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),

                      // Additional content based on type
                      if (notification.type == NotificationType.payment)
                        _buildPaymentContent(),

                      if (notification.type == NotificationType.order)
                        _buildOrderContent(),

                      if (notification.type == NotificationType.promotion)
                        _buildPromotionContent(),
                    ],
                  ),
                ),

                // Unread indicator
                if (!notification.isRead)
                  Container(
                    width: 2.w,
                    height: 2.w,
                    margin: EdgeInsets.only(left: 2.w),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryLight,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationIcon() {
    IconData iconData;
    Color iconColor;
    Color backgroundColor;

    switch (notification.type) {
      case NotificationType.payment:
        iconData = Icons.payment;
        iconColor = AppTheme.backgroundLight;
        backgroundColor = AppTheme.primaryLight;
        break;
      case NotificationType.order:
        iconData = Icons.shopping_bag;
        iconColor = AppTheme.backgroundLight;
        backgroundColor = AppTheme.secondaryLight;
        break;
      case NotificationType.promotion:
        iconData = Icons.local_offer;
        iconColor = AppTheme.textPrimaryLight;
        backgroundColor = AppTheme.accentLight;
        break;
    }

    // If it's an order with product image, show the image
    if (notification.type == NotificationType.order &&
        notification.productImage != null) {
      return Container(
        width: 12.w,
        height: 12.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: AppTheme.surfaceLight,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: CachedNetworkImage(
            imageUrl: notification.productImage!,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              color: AppTheme.surfaceLight,
              child: Icon(
                iconData,
                size: 20.sp,
                color: AppTheme.textSecondaryLight,
              ),
            ),
            errorWidget: (context, url, error) => Container(
              color: backgroundColor,
              child: Icon(
                iconData,
                size: 20.sp,
                color: iconColor,
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      width: 12.w,
      height: 12.w,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Icon(
        iconData,
        size: 20.sp,
        color: iconColor,
      ),
    );
  }

  Widget _buildPaymentContent() {
    return Padding(
      padding: EdgeInsets.only(top: 1.5.h),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
        decoration: BoxDecoration(
          color: AppTheme.primaryLight.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: AppTheme.primaryLight.withValues(alpha: 0.3),
            width: 1.0,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (notification.invoiceNumber != null) ...[
                    Text(
                      'Invoice: ${notification.invoiceNumber}',
                      style: GoogleFonts.inter(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.textSecondaryLight,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                  ],
                  if (notification.amount != null) ...[
                    Text(
                      _formatCurrency(notification.amount!),
                      style: GoogleFonts.inter(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primaryLight,
                      ),
                    ),
                  ],
                  if (notification.dueDate != null) ...[
                    SizedBox(height: 0.5.h),
                    Text(
                      'Jatuh tempo: ${_formatDate(notification.dueDate!)}',
                      style: GoogleFonts.inter(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w400,
                        color: AppTheme.textSecondaryLight,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (notification.dueDate != null &&
                notification.dueDate!.isAfter(DateTime.now()))
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: AppTheme.primaryLight,
                  borderRadius: BorderRadius.circular(6.0),
                ),
                child: Text(
                  'Bayar Sekarang',
                  style: GoogleFonts.inter(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.backgroundLight,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderContent() {
    if (notification.orderNumber == null &&
        notification.trackingNumber == null) {
      return SizedBox.shrink();
    }

    return Padding(
      padding: EdgeInsets.only(top: 1.5.h),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
        decoration: BoxDecoration(
          color: AppTheme.secondaryLight.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: AppTheme.secondaryLight.withValues(alpha: 0.3),
            width: 1.0,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (notification.orderNumber != null) ...[
              Text(
                'Pesanan: ${notification.orderNumber}',
                style: GoogleFonts.inter(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.textSecondaryLight,
                ),
              ),
              SizedBox(height: 0.5.h),
            ],
            if (notification.productName != null) ...[
              Text(
                notification.productName!,
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.secondaryLight,
                ),
              ),
              SizedBox(height: 0.5.h),
            ],
            if (notification.trackingNumber != null) ...[
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Resi: ${notification.trackingNumber}',
                      style: GoogleFonts.inter(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w400,
                        color: AppTheme.textSecondaryLight,
                      ),
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                    decoration: BoxDecoration(
                      color: AppTheme.secondaryLight,
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: Text(
                      'Lacak',
                      style: GoogleFonts.inter(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.backgroundLight,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPromotionContent() {
    return Padding(
      padding: EdgeInsets.only(top: 1.5.h),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
        decoration: BoxDecoration(
          color: AppTheme.accentLight.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: AppTheme.accentLight.withValues(alpha: 0.3),
            width: 1.0,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (notification.discountPercentage != null) ...[
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 2.w, vertical: 0.5.h),
                      decoration: BoxDecoration(
                        color: AppTheme.accentLight,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Text(
                        '${notification.discountPercentage}% OFF',
                        style: GoogleFonts.inter(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimaryLight,
                        ),
                      ),
                    ),
                  ],
                  if (notification.cashbackAmount != null) ...[
                    Text(
                      'Cashback ${_formatCurrency(notification.cashbackAmount!)}',
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimaryLight,
                      ),
                    ),
                  ],
                  if (notification.expiryDate != null) ...[
                    SizedBox(height: 0.5.h),
                    Text(
                      'Berlaku sampai: ${_formatDate(notification.expiryDate!)}',
                      style: GoogleFonts.inter(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w400,
                        color: AppTheme.textSecondaryLight,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16.sp,
              color: AppTheme.textSecondaryLight,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDismissBackground({required bool isSecondary}) {
    return Container(
      color: isSecondary ? AppTheme.errorLight : AppTheme.successLight,
      child: Align(
        alignment: isSecondary ? Alignment.centerRight : Alignment.centerLeft,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isSecondary ? Icons.delete_outline : Icons.mark_email_read,
                color: AppTheme.backgroundLight,
                size: 24.sp,
              ),
              SizedBox(height: 0.5.h),
              Text(
                isSecondary ? 'Hapus' : 'Tandai Dibaca',
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.backgroundLight,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _showDeleteConfirmation(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              'Hapus Notifikasi',
              style: GoogleFonts.inter(fontWeight: FontWeight.w600),
            ),
            content: Text('Apakah Anda yakin ingin menghapus notifikasi ini?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('Batal'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.errorLight,
                ),
                child: Text('Hapus'),
              ),
            ],
          ),
        ) ??
        false;
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Baru saja';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes} menit lalu';
    } else if (difference.inDays < 1) {
      return '${difference.inHours} jam lalu';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} hari lalu';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }

  String _formatCurrency(double amount) {
    return 'Rp ${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
