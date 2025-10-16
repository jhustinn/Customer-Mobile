import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';
import '../order_tracking.dart';

/// Visual timeline widget showing order progression through different stages
class OrderStatusTimeline extends StatefulWidget {
  final OrderStatus currentStatus;
  final List<StatusHistoryItem> statusHistory;
  final AnimationController animation;

  const OrderStatusTimeline({
    super.key,
    required this.currentStatus,
    required this.statusHistory,
    required this.animation,
  });

  @override
  State<OrderStatusTimeline> createState() => _OrderStatusTimelineState();
}

class _OrderStatusTimelineState extends State<OrderStatusTimeline> {
  static const List<OrderStatus> _allStatuses = [
    OrderStatus.pending,
    OrderStatus.approved,
    OrderStatus.processing,
    OrderStatus.shipping,
    OrderStatus.completed,
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Status Pesanan',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimaryLight,
              ),
            ),
            const SizedBox(height: 16),
            Column(
              children: List.generate(_allStatuses.length, (index) {
                final status = _allStatuses[index];
                final isActive = _getStatusIndex(widget.currentStatus) >= index;
                final isCompleted =
                    _getStatusIndex(widget.currentStatus) > index;
                final historyItem =
                    widget.statusHistory
                        .where((item) => item.status == status)
                        .firstOrNull;

                return _buildTimelineItem(
                  status: status,
                  isActive: isActive,
                  isCompleted: isCompleted,
                  isLast: index == _allStatuses.length - 1,
                  historyItem: historyItem,
                  index: index,
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  /// Build individual timeline item with animation
  Widget _buildTimelineItem({
    required OrderStatus status,
    required bool isActive,
    required bool isCompleted,
    required bool isLast,
    required int index,
    StatusHistoryItem? historyItem,
  }) {
    final statusColor = _getStatusColor(status);
    final isCurrentStatus = widget.currentStatus == status;

    return AnimatedBuilder(
      animation: widget.animation,
      builder: (context, child) {
        final animationValue = widget.animation.value;
        final itemDelay = index * 0.2;
        final itemAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: widget.animation,
            curve: Interval(
              itemDelay,
              (itemDelay + 0.4).clamp(0.0, 1.0),
              curve: Curves.easeOutBack,
            ),
          ),
        );

        return Transform.scale(
          scale: 0.8 + (0.2 * itemAnimation.value),
          child: Opacity(
            opacity: itemAnimation.value,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Timeline indicator
                Column(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color:
                            isCompleted || isCurrentStatus
                                ? statusColor
                                : Colors.transparent,
                        border: Border.all(
                          color: isActive ? statusColor : AppTheme.dividerLight,
                          width: 2,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child:
                          isCompleted
                              ? Icon(
                                Icons.check,
                                color: AppTheme.onPrimaryLight,
                                size: 14,
                              )
                              : isCurrentStatus
                              ? Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: AppTheme.onPrimaryLight,
                                  shape: BoxShape.circle,
                                ),
                              )
                              : null,
                    ),
                    if (!isLast)
                      Container(
                        width: 2,
                        height: 40,
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        decoration: BoxDecoration(
                          color:
                              isCompleted ? statusColor : AppTheme.dividerLight,
                          borderRadius: BorderRadius.circular(1),
                        ),
                      ),
                  ],
                ),

                const SizedBox(width: 16),

                // Status content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              _getStatusTitle(status),
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight:
                                    isCurrentStatus
                                        ? FontWeight.w600
                                        : FontWeight.w500,
                                color:
                                    isActive
                                        ? AppTheme.textPrimaryLight
                                        : AppTheme.textSecondaryLight,
                              ),
                            ),
                          ),
                          if (historyItem != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: statusColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                _formatTimelineDate(historyItem.timestamp),
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                  color: statusColor,
                                ),
                              ),
                            ),
                        ],
                      ),
                      if (historyItem != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          historyItem.description,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: AppTheme.textSecondaryLight,
                          ),
                        ),
                      ] else if (!isActive && !isCompleted) ...[
                        const SizedBox(height: 4),
                        Text(
                          _getStatusDescription(status),
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: AppTheme.textDisabledLight,
                          ),
                        ),
                      ],
                      if (isCurrentStatus && !isCompleted) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: statusColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: statusColor.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 12,
                                height: 12,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    statusColor,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Sedang berlangsung',
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                  color: statusColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      if (!isLast) const SizedBox(height: 16),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Get status index for progression calculation
  int _getStatusIndex(OrderStatus status) {
    return _allStatuses.indexOf(status);
  }

  /// Get status color
  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return AppTheme.warningLight;
      case OrderStatus.approved:
        return AppTheme.primaryLight;
      case OrderStatus.processing:
        return const Color(0xFFFF8C00);
      case OrderStatus.shipping:
        return AppTheme.successLight;
      case OrderStatus.completed:
        return AppTheme.secondaryLight;
      case OrderStatus.cancelled:
        return AppTheme.errorLight;
    }
  }

  /// Get status title in Indonesian
  String _getStatusTitle(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 'Menunggu Persetujuan';
      case OrderStatus.approved:
        return 'Disetujui Admin';
      case OrderStatus.processing:
        return 'Sedang Diproses';
      case OrderStatus.shipping:
        return 'Dalam Pengiriman';
      case OrderStatus.completed:
        return 'Pesanan Selesai';
      case OrderStatus.cancelled:
        return 'Pesanan Dibatalkan';
    }
  }

  /// Get status description
  String _getStatusDescription(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 'Menunggu review dan persetujuan dari tim admin';
      case OrderStatus.approved:
        return 'Admin telah menyetujui pesanan Anda';
      case OrderStatus.processing:
        return 'Pesanan sedang disiapkan dan dikemas';
      case OrderStatus.shipping:
        return 'Pesanan dalam perjalanan ke alamat tujuan';
      case OrderStatus.completed:
        return 'Pesanan telah sampai dan diterima';
      case OrderStatus.cancelled:
        return 'Pesanan telah dibatalkan';
    }
  }

  /// Format timeline date for display
  String _formatTimelineDate(DateTime date) {
    return '${date.day}/${date.month} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
