import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

/// Widget for displaying detailed delivery tracking information with map view
class DeliveryTrackingWidget extends StatefulWidget {
  final String orderId;
  final String courierName;
  final DateTime estimatedDelivery;

  const DeliveryTrackingWidget({
    super.key,
    required this.orderId,
    required this.courierName,
    required this.estimatedDelivery,
  });

  @override
  State<DeliveryTrackingWidget> createState() => _DeliveryTrackingWidgetState();
}

class _DeliveryTrackingWidgetState extends State<DeliveryTrackingWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool isTracking = true;
  String currentLocation = 'Jakarta Selatan';
  double deliveryProgress = 0.7;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tracking Header
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.primaryLight,
                        AppTheme.primaryLight.withValues(alpha: 0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Icon(
                          Icons.local_shipping,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.courierName,
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Sedang dalam perjalanan',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: Colors.white.withValues(alpha: 0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.successLight,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'AKTIF',
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Progress Indicator
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Progress Pengiriman',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '${(deliveryProgress * 100).toInt()}%',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.primaryLight,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      LinearProgressIndicator(
                        value: deliveryProgress,
                        backgroundColor: AppTheme.surfaceLight,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppTheme.primaryLight,
                        ),
                        minHeight: 6,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Estimasi tiba: ${_formatEstimatedTime()}',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppTheme.textSecondaryLight,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Mock Map Area
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceLight,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppTheme.dividerLight,
                      width: 1,
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Map placeholder
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          width: double.infinity,
                          height: double.infinity,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                AppTheme.surfaceLight,
                                AppTheme.surfaceLight.withValues(alpha: 0.8),
                              ],
                            ),
                          ),
                          child: CustomPaint(
                            painter: MapPatternPainter(),
                          ),
                        ),
                      ),
                      // Delivery truck indicator
                      Positioned(
                        left: 40 + (deliveryProgress * 120),
                        top: 80,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppTheme.primaryLight,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.primaryLight
                                    .withValues(alpha: 0.3),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.local_shipping,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                      // Start point
                      Positioned(
                        left: 40,
                        top: 80,
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: AppTheme.successLight,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                      // End point
                      Positioned(
                        right: 40,
                        top: 80,
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: AppTheme.errorLight,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                      // Route line
                      Positioned(
                        left: 46,
                        top: 85,
                        child: Container(
                          width: MediaQuery.of(context).size.width - 140,
                          height: 2,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppTheme.successLight,
                                AppTheme.primaryLight,
                                AppTheme.errorLight,
                              ],
                              stops: [0.0, deliveryProgress, 1.0],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Delivery Timeline
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
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
                        'Timeline Pengiriman',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ...(_getDeliveryTimeline())
                          .map((timeline) => Container(
                                margin: const EdgeInsets.only(bottom: 16),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 12,
                                      height: 12,
                                      margin: const EdgeInsets.only(top: 4),
                                      decoration: BoxDecoration(
                                        color: timeline.isCompleted
                                            ? AppTheme.successLight
                                            : AppTheme.dividerLight,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            timeline.title,
                                            style: GoogleFonts.inter(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                              color: timeline.isCompleted
                                                  ? AppTheme.textPrimaryLight
                                                  : AppTheme.textSecondaryLight,
                                            ),
                                          ),
                                          if (timeline
                                              .description.isNotEmpty) ...[
                                            const SizedBox(height: 2),
                                            Text(
                                              timeline.description,
                                              style: GoogleFonts.inter(
                                                fontSize: 11,
                                                color:
                                                    AppTheme.textSecondaryLight,
                                              ),
                                            ),
                                          ],
                                          if (timeline.timestamp != null) ...[
                                            const SizedBox(height: 2),
                                            Text(
                                              _formatTimestamp(
                                                  timeline.timestamp!),
                                              style: GoogleFonts.inter(
                                                fontSize: 10,
                                                color:
                                                    AppTheme.textSecondaryLight,
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ))
                          .toList(),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Contact Driver Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Handle contact driver
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Menghubungi driver...'),
                          backgroundColor: AppTheme.primaryLight,
                        ),
                      );
                    },
                    icon: Icon(Icons.phone),
                    label: Text('Hubungi Driver'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryLight,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Format estimated delivery time
  String _formatEstimatedTime() {
    final now = DateTime.now();
    final difference = widget.estimatedDelivery.difference(now);

    if (difference.inDays > 0) {
      return '${difference.inDays} hari lagi';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} jam lagi';
    } else {
      return '${difference.inMinutes} menit lagi';
    }
  }

  /// Format timeline timestamp
  String _formatTimestamp(DateTime timestamp) {
    return '${timestamp.day}/${timestamp.month} ${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
  }

  /// Get delivery timeline items
  List<DeliveryTimelineItem> _getDeliveryTimeline() {
    return [
      DeliveryTimelineItem(
        title: 'Paket diambil dari toko',
        description: 'Paket telah diambil dari Cobra Dental Store',
        timestamp: DateTime.now().subtract(const Duration(hours: 4)),
        isCompleted: true,
      ),
      DeliveryTimelineItem(
        title: 'Dalam perjalanan ke hub distribusi',
        description: 'Paket sedang dalam perjalanan ke pusat distribusi',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        isCompleted: true,
      ),
      DeliveryTimelineItem(
        title: 'Sedang dalam perjalanan ke tujuan',
        description: 'Driver sedang menuju alamat pengiriman Anda',
        timestamp: null,
        isCompleted: false,
      ),
      DeliveryTimelineItem(
        title: 'Paket akan segera tiba',
        description: 'Estimasi tiba dalam ${_formatEstimatedTime()}',
        timestamp: null,
        isCompleted: false,
      ),
    ];
  }
}

/// Delivery timeline item model
class DeliveryTimelineItem {
  final String title;
  final String description;
  final DateTime? timestamp;
  final bool isCompleted;

  const DeliveryTimelineItem({
    required this.title,
    required this.description,
    this.timestamp,
    required this.isCompleted,
  });
}

/// Custom painter for map pattern background
class MapPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.dividerLight.withValues(alpha: 0.3)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    // Draw grid pattern to simulate map
    for (double i = 0; i < size.width; i += 20) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += 20) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }

    // Draw some mock roads
    final roadPaint = Paint()
      ..color = AppTheme.textSecondaryLight.withValues(alpha: 0.2)
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
      Offset(0, size.height * 0.3),
      Offset(size.width, size.height * 0.3),
      roadPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.2, 0),
      Offset(size.width * 0.2, size.height),
      roadPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.7, 0),
      Offset(size.width * 0.7, size.height),
      roadPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
