import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

/// Delivery tracking integration widget showing real-time shipment updates
class DeliveryInfoWidget extends StatelessWidget {
  final String trackingNumber;
  final String carrier;
  final DateTime estimatedArrival;
  final String deliveryAddress;

  const DeliveryInfoWidget({
    super.key,
    required this.trackingNumber,
    required this.carrier,
    required this.estimatedArrival,
    required this.deliveryAddress,
  });

  @override
  Widget build(BuildContext context) {
    final daysUntilArrival = estimatedArrival.difference(DateTime.now()).inDays;
    final isArrivalSoon = daysUntilArrival <= 1;

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
          Row(
            children: [
              Icon(
                Icons.local_shipping,
                color: AppTheme.primaryLight,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'Informasi Pengiriman',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Tracking number and carrier
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.surfaceLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Nomor Resi',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: AppTheme.textSecondaryLight,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          trackingNumber,
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.primaryLight,
                          ),
                        ),
                      ],
                    ),

                    GestureDetector(
                      onTap: () {
                        // Copy tracking number to clipboard
                        // Clipboard.setData(ClipboardData(text: trackingNumber));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Nomor resi disalin ke clipboard'),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryLight.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.copy,
                          color: AppTheme.primaryLight,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                Row(
                  children: [
                    Icon(
                      Icons.business,
                      size: 16,
                      color: AppTheme.textSecondaryLight,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Kurir: $carrier',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: AppTheme.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Estimated arrival
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color:
                  isArrivalSoon
                      ? AppTheme.successLight.withValues(alpha: 0.1)
                      : AppTheme.primaryLight.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color:
                    isArrivalSoon
                        ? AppTheme.successLight.withValues(alpha: 0.3)
                        : AppTheme.primaryLight.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  isArrivalSoon ? Icons.schedule : Icons.access_time,
                  color:
                      isArrivalSoon
                          ? AppTheme.successLight
                          : AppTheme.primaryLight,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Estimasi Tiba',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppTheme.textSecondaryLight,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatEstimatedArrival(),
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color:
                              isArrivalSoon
                                  ? AppTheme.successLight
                                  : AppTheme.primaryLight,
                        ),
                      ),
                      if (isArrivalSoon)
                        Text(
                          'Paket akan tiba segera!',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: AppTheme.successLight,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Delivery address
          _buildInfoRow(
            Icons.location_on,
            'Alamat Pengiriman',
            deliveryAddress,
          ),

          const SizedBox(height: 20),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    // Open external tracking
                    _openExternalTracking(context);
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppTheme.primaryLight),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.track_changes,
                        color: AppTheme.primaryLight,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Lacak Pengiriman',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.primaryLight,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Contact courier
                    _contactCourier(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryLight,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.phone, color: Colors.white, size: 16),
                      const SizedBox(width: 8),
                      Text(
                        'Hubungi Kurir',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Build information row with icon, label, and value
  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: AppTheme.textSecondaryLight),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: AppTheme.textSecondaryLight,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Format estimated arrival time
  String _formatEstimatedArrival() {
    final now = DateTime.now();
    final difference = estimatedArrival.difference(now);

    if (difference.inDays > 1) {
      return '${difference.inDays} hari lagi (${_formatDate(estimatedArrival)})';
    } else if (difference.inDays == 1) {
      return 'Besok (${_formatDate(estimatedArrival)})';
    } else if (difference.inHours > 0) {
      return 'Hari ini (${difference.inHours} jam lagi)';
    } else {
      return 'Segera tiba';
    }
  }

  /// Format date for display
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  /// Open external tracking in browser or app
  void _openExternalTracking(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Membuka tracking eksternal untuk $trackingNumber'),
        backgroundColor: AppTheme.primaryLight,
      ),
    );
    // In real implementation, open external tracking URL
    // launch('https://tracking.${carrier.toLowerCase()}.com/$trackingNumber');
  }

  /// Contact courier via phone or app
  void _contactCourier(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppTheme.dividerLight,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Hubungi $carrier',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryLight.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.phone, color: AppTheme.primaryLight),
                  ),
                  title: Text('Telepon Kurir'),
                  subtitle: Text('Hubungi driver langsung'),
                  trailing: Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.pop(context);
                    // Make phone call
                  },
                ),
                ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryLight.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.chat, color: AppTheme.primaryLight),
                  ),
                  title: Text('Customer Service'),
                  subtitle: Text('Chat dengan CS $carrier'),
                  trailing: Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.pop(context);
                    // Open chat
                  },
                ),
                SizedBox(height: MediaQuery.of(context).viewInsets.bottom + 16),
              ],
            ),
          ),
    );
  }
}
