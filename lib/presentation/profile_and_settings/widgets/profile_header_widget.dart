import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProfileHeaderWidget extends StatelessWidget {
  final Map<String, dynamic> userProfile;
  final VoidCallback onEditPressed;

  const ProfileHeaderWidget({
    super.key,
    required this.userProfile,
    required this.onEditPressed,
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
        children: [
          Row(
            children: [
              // Profile Photo
              Container(
                width: 16.w,
                height: 16.w,
                decoration: BoxDecoration(
                  color:
                      AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8.w),
                  border: Border.all(
                    color:
                        AppTheme.lightTheme.primaryColor.withValues(alpha: 0.2),
                    width: 2,
                  ),
                ),
                child: userProfile["profilePhoto"] != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8.w),
                        child: CustomImageWidget(
                          imageUrl: userProfile["profilePhoto"] as String,
                          width: 16.w,
                          height: 16.w,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Center(
                        child: CustomIconWidget(
                          iconName: 'person',
                          color: AppTheme.lightTheme.primaryColor,
                          size: 6.w,
                        ),
                      ),
              ),
              SizedBox(width: 4.w),
              // Company Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userProfile["companyName"] as String? ??
                          "PT Dental Clinic",
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      userProfile["ownerName"] as String? ?? "Dr. Ahmad Wijaya",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 1.h),
                    // Membership Badge
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 3.w, vertical: 0.5.h),
                      decoration: BoxDecoration(
                        color: _getMembershipColor(
                            userProfile["membershipTier"] as String? ?? "Gold"),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        "${userProfile["membershipTier"] as String? ?? "Gold"} Member",
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Edit Button
              IconButton(
                onPressed: onEditPressed,
                icon: CustomIconWidget(
                  iconName: 'edit',
                  color: AppTheme.lightTheme.primaryColor,
                  size: 5.w,
                ),
                style: IconButton.styleFrom(
                  backgroundColor:
                      AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getMembershipColor(String tier) {
    switch (tier.toLowerCase()) {
      case 'platinum':
        return Color(0xFF9C27B0);
      case 'gold':
        return Color(0xFFFF9800);
      case 'silver':
        return Color(0xFF607D8B);
      default:
        return AppTheme.lightTheme.primaryColor;
    }
  }
}
