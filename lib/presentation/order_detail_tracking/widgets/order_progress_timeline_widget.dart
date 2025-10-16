import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import '../order_detail_tracking.dart';

/// Visual progress timeline widget with animated pulse indicators for active stages
class OrderProgressTimelineWidget extends StatelessWidget {
  final OrderDetailStatus currentStatus;
  final List<StatusHistoryDetail> statusHistory;
  final Animation<double> pulseAnimation;

  const OrderProgressTimelineWidget({
    super.key,
    required this.currentStatus,
    required this.statusHistory,
    required this.pulseAnimation,
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
            'Progress Pesanan',
            style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: 20),

          // Timeline stages
          Column(children: _buildTimelineStages()),
        ],
      ),
    );
  }

  /// Build timeline stages with five distinct phases
  List<Widget> _buildTimelineStages() {
    final stages = [
      TimelineStage(
        status: OrderDetailStatus.pending,
        title: 'Pending',
        description: 'Pesanan diterima dan menunggu konfirmasi',
        icon: Icons.schedule,
        color: AppTheme.warningLight,
      ),
      TimelineStage(
        status: OrderDetailStatus.approved,
        title: 'Disetujui Admin',
        description: 'Pesanan telah disetujui oleh admin departemen',
        icon: Icons.check_circle,
        color: AppTheme.primaryLight,
      ),
      TimelineStage(
        status: OrderDetailStatus.processing,
        title: 'Diproses',
        description: 'Pesanan sedang disiapkan oleh supplier',
        icon: Icons.settings,
        color: const Color(0xFFFF8C00),
      ),
      TimelineStage(
        status: OrderDetailStatus.shipped,
        title: 'Dikirim',
        description: 'Pesanan dalam perjalanan ke alamat tujuan',
        icon: Icons.local_shipping,
        color: AppTheme.successLight,
      ),
      TimelineStage(
        status: OrderDetailStatus.completed,
        title: 'Selesai',
        description: 'Pesanan telah diterima dan selesai',
        icon: Icons.done_all,
        color: AppTheme.secondaryLight,
      ),
    ];

    List<Widget> widgets = [];

    for (int i = 0; i < stages.length; i++) {
      final stage = stages[i];
      final isActive = stage.status.index <= currentStatus.index;
      final isCurrent = stage.status == currentStatus;
      final timestamp = _getTimestampForStatus(stage.status);

      widgets.add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Timeline indicator
            Column(
              children: [
                // Status circle
                AnimatedBuilder(
                  animation: pulseAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: isCurrent ? pulseAnimation.value : 1.0,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: isActive ? stage.color : AppTheme.dividerLight,
                          shape: BoxShape.circle,
                          boxShadow:
                              isCurrent
                                  ? [
                                    BoxShadow(
                                      color: stage.color.withValues(alpha: 0.3),
                                      blurRadius: 8,
                                      spreadRadius: 2,
                                    ),
                                  ]
                                  : null,
                        ),
                        child: Icon(
                          stage.icon,
                          color:
                              isActive
                                  ? Colors.white
                                  : AppTheme.textDisabledLight,
                          size: 20,
                        ),
                      ),
                    );
                  },
                ),

                // Connecting line (not for last item)
                if (i < stages.length - 1)
                  Container(
                    width: 2,
                    height: 40,
                    color: isActive ? stage.color : AppTheme.dividerLight,
                  ),
              ],
            ),

            const SizedBox(width: 16),

            // Stage content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        stage.title,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight:
                              isActive ? FontWeight.w600 : FontWeight.w400,
                          color:
                              isActive
                                  ? AppTheme.textPrimaryLight
                                  : AppTheme.textSecondaryLight,
                        ),
                      ),
                      if (timestamp != null)
                        Text(
                          _formatTimestamp(timestamp),
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: AppTheme.textSecondaryLight,
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  Text(
                    stage.description,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppTheme.textSecondaryLight,
                    ),
                  ),

                  // Current status additional details
                  if (isCurrent) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: stage.color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: stage.color.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: stage.color,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Status Aktif',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: stage.color,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  if (i < stages.length - 1) const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return widgets;
  }

  /// Get timestamp for specific status from history
  DateTime? _getTimestampForStatus(OrderDetailStatus status) {
    try {
      return statusHistory
          .firstWhere((history) => history.status == status)
          .timestamp;
    } catch (e) {
      return null;
    }
  }

  /// Format timestamp for display
  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays} hari lalu';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} jam lalu';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} menit lalu';
    } else {
      return 'Baru saja';
    }
  }
}

/// Timeline stage data model
class TimelineStage {
  final OrderDetailStatus status;
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  const TimelineStage({
    required this.status,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}
