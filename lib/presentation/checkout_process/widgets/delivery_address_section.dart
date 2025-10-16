import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';
import '../checkout_process.dart';

/// Delivery address selection section for checkout
class DeliveryAddressSection extends StatelessWidget {
  final DeliveryAddress? selectedAddress;
  final Function(DeliveryAddress) onAddressSelected;
  final VoidCallback onAddNewAddress;

  const DeliveryAddressSection({
    super.key,
    this.selectedAddress,
    required this.onAddressSelected,
    required this.onAddNewAddress,
  });

  @override
  Widget build(BuildContext context) {
    final addresses = _getMockAddresses();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Text(
            'Pilih Alamat Pengiriman',
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimaryLight,
            ),
          ),

          Text(
            'Pastikan alamat yang dipilih sudah benar untuk pengiriman peralatan dental',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppTheme.textSecondaryLight,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 20),

          // Address List
          ...addresses.map((address) => _buildAddressCard(address)),

          const SizedBox(height: 16),

          // Add New Address Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onAddNewAddress,
              icon: const Icon(Icons.add),
              label: Text(
                'Tambah Alamat Baru',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                side: BorderSide(color: AppTheme.primaryLight, width: 2),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Delivery Time Preferences
          _buildDeliveryTimeSection(),
        ],
      ),
    );
  }

  /// Build address card with selection state
  Widget _buildAddressCard(DeliveryAddress address) {
    final isSelected = selectedAddress?.id == address.id;

    return Card(
      elevation: isSelected ? 4 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side:
            isSelected
                ? BorderSide(color: AppTheme.primaryLight, width: 2)
                : BorderSide.none,
      ),
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => onAddressSelected(address),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with selection indicator
              Row(
                children: [
                  // Business Name and Default Label
                  Expanded(
                    child: Row(
                      children: [
                        Text(
                          address.businessName,
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimaryLight,
                          ),
                        ),

                        if (address.isDefault) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.accentLight.withAlpha(51),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'Utama',
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.primaryLight,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  // Selection Radio
                  Radio<String>(
                    value: address.id,
                    groupValue: selectedAddress?.id,
                    onChanged: (value) => onAddressSelected(address),
                    activeColor: AppTheme.primaryLight,
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Full Address
              Text(
                address.fullAddress,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppTheme.textSecondaryLight,
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 8),

              // City and Phone
              Row(
                children: [
                  Icon(
                    Icons.location_city,
                    size: 16,
                    color: AppTheme.textSecondaryLight,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${address.city} ${address.postalCode}',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppTheme.textSecondaryLight,
                    ),
                  ),

                  const SizedBox(width: 16),

                  Icon(
                    Icons.phone,
                    size: 16,
                    color: AppTheme.textSecondaryLight,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    address.phoneNumber,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppTheme.textSecondaryLight,
                    ),
                  ),
                ],
              ),

              // Action Buttons
              if (isSelected) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        // Edit address
                      },
                      icon: const Icon(Icons.edit, size: 16),
                      label: Text(
                        'Edit',
                        style: GoogleFonts.inter(fontSize: 12),
                      ),
                    ),

                    TextButton.icon(
                      onPressed: () {
                        // Delete address
                      },
                      icon: const Icon(Icons.delete_outline, size: 16),
                      label: Text(
                        'Hapus',
                        style: GoogleFonts.inter(fontSize: 12),
                      ),
                      style: TextButton.styleFrom(
                        foregroundColor: AppTheme.errorLight,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// Build delivery time preferences section
  Widget _buildDeliveryTimeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Waktu Pengiriman Preferensi',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimaryLight,
          ),
        ),

        const SizedBox(height: 12),

        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.surfaceLight,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.dividerLight),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    color: AppTheme.primaryLight,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Jam Operasional',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              Text(
                'Senin - Jumat: 08:00 - 17:00\nSabtu: 08:00 - 14:00',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: AppTheme.textSecondaryLight,
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: AppTheme.warningLight,
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Pengiriman peralatan berat memerlukan jadwal khusus',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: AppTheme.textSecondaryLight,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Mock addresses for demonstration
  List<DeliveryAddress> _getMockAddresses() {
    return [
      DeliveryAddress(
        id: '1',
        businessName: 'Dental Clinic Prima',
        fullAddress: 'Jl. Sudirman No. 123, Blok A, Lantai 2',
        city: 'Jakarta Selatan',
        postalCode: '12190',
        phoneNumber: '+62 21 1234567',
        isDefault: true,
      ),
      DeliveryAddress(
        id: '2',
        businessName: 'Dental Clinic Prima - Cabang Bekasi',
        fullAddress: 'Jl. Ahmad Yani No. 456, Ruko Medika Centre',
        city: 'Bekasi',
        postalCode: '17141',
        phoneNumber: '+62 21 7654321',
        isDefault: false,
      ),
      DeliveryAddress(
        id: '3',
        businessName: 'Warehouse - Dental Clinic Prima',
        fullAddress: 'Kawasan Industri MM2100, Blok J-8',
        city: 'Cikarang',
        postalCode: '17530',
        phoneNumber: '+62 21 8901234',
        isDefault: false,
      ),
    ];
  }
}
