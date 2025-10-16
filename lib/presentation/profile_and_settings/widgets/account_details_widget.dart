import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AccountDetailsWidget extends StatelessWidget {
  final Map<String, dynamic> accountDetails;

  const AccountDetailsWidget({
    super.key,
    required this.accountDetails,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Detail Akun",
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 3.h),
          _buildDetailItem(
            context,
            "Registrasi Bisnis",
            accountDetails["businessRegistration"] as String? ??
                "SIUP: 123456789/2023",
            'business',
            false,
          ),
          SizedBox(height: 2.h),
          _buildDetailItem(
            context,
            "Email",
            accountDetails["email"] as String? ??
                "ahmad.wijaya@dentalclinic.co.id",
            'email',
            true,
          ),
          SizedBox(height: 2.h),
          _buildDetailItem(
            context,
            "Nomor Telepon",
            accountDetails["phoneNumber"] as String? ?? "+62 812-3456-7890",
            'phone',
            true,
          ),
          SizedBox(height: 2.h),
          _buildDetailItem(
            context,
            "Alamat",
            accountDetails["address"] as String? ??
                "Jl. Sudirman No. 123, Jakarta Pusat, DKI Jakarta 10220",
            'location_on',
            true,
          ),
          SizedBox(height: 2.h),
          _buildVerificationStatus(context),
        ],
      ),
    );
  }

  Widget _buildDetailItem(
    BuildContext context,
    String label,
    String value,
    String iconName,
    bool canCopy,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onLongPress: canCopy ? () => _copyToClipboard(context, value) : null,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 8.w,
            height: 8.w,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: iconName,
                color: AppTheme.lightTheme.primaryColor,
                size: 4.w,
              ),
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  value,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (canCopy)
            GestureDetector(
              onTap: () => _copyToClipboard(context, value),
              child: Container(
                padding: EdgeInsets.all(1.w),
                child: CustomIconWidget(
                  iconName: 'content_copy',
                  color: colorScheme.onSurfaceVariant,
                  size: 4.w,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildVerificationStatus(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isVerified = accountDetails["isVerified"] as bool? ?? true;

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: isVerified
            ? AppTheme.successLight.withValues(alpha: 0.1)
            : AppTheme.warningLight.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isVerified
              ? AppTheme.successLight.withValues(alpha: 0.3)
              : AppTheme.warningLight.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: isVerified ? 'verified' : 'warning',
            color: isVerified ? AppTheme.successLight : AppTheme.warningLight,
            size: 4.w,
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: Text(
              isVerified ? "Akun Terverifikasi" : "Menunggu Verifikasi",
              style: theme.textTheme.bodySmall?.copyWith(
                color:
                    isVerified ? AppTheme.successLight : AppTheme.warningLight,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Disalin ke clipboard"),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
