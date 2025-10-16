import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import '../../order_tracking/order_tracking.dart';
import '../order_detail_tracking.dart';

/// Order actions widget with stage-specific buttons and haptic feedback
class OrderActionsWidget extends StatelessWidget {
  final OrderDetailStatus currentStatus;
  final String orderId;
  final Function(OrderDetailAction) onAction;

  const OrderActionsWidget({
    super.key,
    required this.currentStatus,
    required this.orderId,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.backgroundLight,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Aksi Pesanan',
            style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: 16),

          // Dynamic action buttons based on current status
          ..._buildActionButtons(context),
        ],
      ),
    );
  }

  /// Build action buttons based on current order status
  List<Widget> _buildActionButtons(BuildContext context) {
    List<Widget> buttons = [];

    switch (currentStatus) {
      case OrderDetailStatus.pending:
        buttons.addAll([
          _buildActionButton(
            context: context,
            label: 'Batalkan Pesanan',
            icon: Icons.cancel,
            color: AppTheme.errorLight,
            onPressed: () => onAction(OrderDetailAction.cancelOrder),
          ),
          const SizedBox(height: 12),
          _buildActionButton(
            context: context,
            label: 'Hubungi Admin',
            icon: Icons.support_agent,
            color: AppTheme.primaryLight,
            isOutlined: true,
            onPressed: () => onAction(OrderDetailAction.contactAdmin),
          ),
        ]);
        break;

      case OrderDetailStatus.approved:
        buttons.addAll([
          _buildActionButton(
            context: context,
            label: 'Hubungi Admin',
            icon: Icons.support_agent,
            color: AppTheme.primaryLight,
            onPressed: () => onAction(OrderDetailAction.contactAdmin),
          ),
          const SizedBox(height: 12),
          _buildActionButton(
            context: context,
            label: 'Hubungi Supplier',
            icon: Icons.business,
            color: AppTheme.secondaryLight,
            isOutlined: true,
            onPressed: () => onAction(OrderDetailAction.contactSupplier),
          ),
        ]);
        break;

      case OrderDetailStatus.processing:
        buttons.addAll([
          _buildActionButton(
            context: context,
            label: 'Hubungi Supplier',
            icon: Icons.business,
            color: AppTheme.primaryLight,
            onPressed: () => onAction(OrderDetailAction.contactSupplier),
          ),
          const SizedBox(height: 12),
          _buildActionButton(
            context: context,
            label: 'Hubungi Admin',
            icon: Icons.support_agent,
            color: AppTheme.secondaryLight,
            isOutlined: true,
            onPressed: () => onAction(OrderDetailAction.contactAdmin),
          ),
        ]);
        break;

      case OrderDetailStatus.shipped:
        buttons.addAll([
          _buildActionButton(
            context: context,
            label: 'Lacak Pengiriman',
            icon: Icons.local_shipping,
            color: AppTheme.successLight,
            onPressed: () => onAction(OrderDetailAction.trackShipment),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  context: context,
                  label: 'Hubungi Admin',
                  icon: Icons.support_agent,
                  color: AppTheme.primaryLight,
                  isOutlined: true,
                  isCompact: true,
                  onPressed: () => onAction(OrderDetailAction.contactAdmin),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionButton(
                  context: context,
                  label: 'Unduh Invoice',
                  icon: Icons.download,
                  color: AppTheme.secondaryLight,
                  isOutlined: true,
                  isCompact: true,
                  onPressed: () => onAction(OrderDetailAction.downloadInvoice),
                ),
              ),
            ],
          ),
        ]);
        break;

      case OrderDetailStatus.completed:
        buttons.addAll([
          _buildActionButton(
            context: context,
            label: 'Unduh Invoice',
            icon: Icons.download,
            color: AppTheme.primaryLight,
            onPressed: () => onAction(OrderDetailAction.downloadInvoice),
          ),
          const SizedBox(height: 12),
          _buildActionButton(
            context: context,
            label: 'Hubungi Admin',
            icon: Icons.support_agent,
            color: AppTheme.secondaryLight,
            isOutlined: true,
            onPressed: () => onAction(OrderDetailAction.contactAdmin),
          ),
        ]);
        break;
    }

    return buttons;
  }

  /// Build individual action button with styling and haptic feedback
  Widget _buildActionButton({
    required BuildContext context,
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
    bool isOutlined = false,
    bool isCompact = false,
  }) {
    return SizedBox(
      width: double.infinity,
      child:
          isOutlined
              ? OutlinedButton(
                onPressed: () {
                  // Haptic feedback for iOS
                  if (Theme.of(context).platform == TargetPlatform.iOS) {
                    // HapticFeedback.selectionClick();
                  }
                  onPressed();
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: color),
                  padding: EdgeInsets.symmetric(vertical: isCompact ? 12 : 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icon, color: color, size: isCompact ? 16 : 20),
                    const SizedBox(width: 8),
                    Text(
                      label,
                      style: GoogleFonts.inter(
                        fontSize: isCompact ? 14 : 16,
                        fontWeight: FontWeight.w500,
                        color: color,
                      ),
                    ),
                  ],
                ),
              )
              : ElevatedButton(
                onPressed: () {
                  // Haptic feedback for iOS
                  if (Theme.of(context).platform == TargetPlatform.iOS) {
                    // HapticFeedback.mediumImpact();
                  }
                  onPressed();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  padding: EdgeInsets.symmetric(vertical: isCompact ? 12 : 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: isOutlined ? 0 : 2,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icon, color: Colors.white, size: isCompact ? 16 : 20),
                    const SizedBox(width: 8),
                    Text(
                      label,
                      style: GoogleFonts.inter(
                        fontSize: isCompact ? 14 : 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}
