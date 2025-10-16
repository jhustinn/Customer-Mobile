import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import '../models/notification_model.dart';
import './notification_card_widget.dart';

class NotificationListWidget extends StatelessWidget {
  final List<NotificationModel> notifications;
  final Function(NotificationModel) onNotificationTap;

  const NotificationListWidget({
    Key? key,
    required this.notifications,
    required this.onNotificationTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        // Simulate refresh
        await Future.delayed(Duration(seconds: 1));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Notifikasi telah diperbarui'),
            backgroundColor: AppTheme.successLight,
          ),
        );
      },
      child: ListView.separated(
        padding: EdgeInsets.symmetric(vertical: 2.h),
        itemCount: notifications.length,
        separatorBuilder: (context, index) => Divider(
          height: 1,
          color: AppTheme.dividerLight.withValues(alpha: 0.5),
          indent: 4.w,
          endIndent: 4.w,
        ),
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return NotificationCardWidget(
            notification: notification,
            onTap: () => onNotificationTap(notification),
          );
        },
      ),
    );
  }
}
