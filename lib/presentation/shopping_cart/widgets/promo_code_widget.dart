import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

/// Promo code input widget with validation and application
class PromoCodeWidget extends StatefulWidget {
  final String? appliedPromoCode;
  final Function(String) onApplyPromo;

  const PromoCodeWidget({
    super.key,
    this.appliedPromoCode,
    required this.onApplyPromo,
  });

  @override
  State<PromoCodeWidget> createState() => _PromoCodeWidgetState();
}

class _PromoCodeWidgetState extends State<PromoCodeWidget> {
  final TextEditingController _promoController = TextEditingController();
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    if (widget.appliedPromoCode != null) {
      _promoController.text = widget.appliedPromoCode!;
      _isExpanded = true;
    }
  }

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  void _applyPromoCode() {
    if (_promoController.text.trim().isNotEmpty) {
      widget.onApplyPromo(_promoController.text.trim());
    }
  }

  void _removePromoCode() {
    _promoController.clear();
    widget.onApplyPromo('');
  }

  @override
  Widget build(BuildContext context) {
    final hasAppliedPromo =
        widget.appliedPromoCode != null && widget.appliedPromoCode!.isNotEmpty;

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        child: Column(
          children: [
            // Header
            InkWell(
              onTap: () => setState(() => _isExpanded = !_isExpanded),
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color:
                            hasAppliedPromo
                                ? AppTheme.successLight.withAlpha(26)
                                : AppTheme.accentLight.withAlpha(26),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        hasAppliedPromo
                            ? Icons.discount
                            : Icons.local_offer_outlined,
                        color:
                            hasAppliedPromo
                                ? AppTheme.successLight
                                : AppTheme.primaryLight,
                        size: 20,
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            hasAppliedPromo
                                ? 'Kode Promo Diterapkan'
                                : 'Punya Kode Promo?',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color:
                                  hasAppliedPromo
                                      ? AppTheme.successLight
                                      : AppTheme.textPrimaryLight,
                            ),
                          ),

                          if (hasAppliedPromo) ...[
                            const SizedBox(height: 4),
                            Text(
                              'Kode: ${widget.appliedPromoCode}',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: AppTheme.textSecondaryLight,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ] else ...[
                            const SizedBox(height: 2),
                            Text(
                              'Hemat lebih banyak dengan promo',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: AppTheme.textSecondaryLight,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),

                    // Expand/Collapse Icon
                    Icon(
                      _isExpanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: AppTheme.textSecondaryLight,
                    ),
                  ],
                ),
              ),
            ),

            // Promo Code Input (Expanded)
            AnimatedCrossFade(
              firstChild: const SizedBox.shrink(),
              secondChild: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Column(
                  children: [
                    // Divider
                    Container(
                      height: 1,
                      color: AppTheme.dividerLight,
                      margin: const EdgeInsets.only(bottom: 16),
                    ),

                    if (hasAppliedPromo) ...[
                      // Applied Promo Display
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTheme.successLight.withAlpha(26),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppTheme.successLight.withAlpha(77),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: AppTheme.successLight,
                              size: 20,
                            ),

                            const SizedBox(width: 8),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Promo berhasil diterapkan!',
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.successLight,
                                    ),
                                  ),
                                  Text(
                                    'Anda mendapat diskon 10%',
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: AppTheme.successLight,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            TextButton(
                              onPressed: _removePromoCode,
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                minimumSize: const Size(0, 0),
                              ),
                              child: Text(
                                'Hapus',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: AppTheme.errorLight,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ] else ...[
                      // Promo Code Input
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _promoController,
                              textCapitalization: TextCapitalization.characters,
                              decoration: InputDecoration(
                                hintText: 'Masukkan kode promo',
                                hintStyle: GoogleFonts.inter(
                                  color: AppTheme.textDisabledLight,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: AppTheme.dividerLight,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: AppTheme.dividerLight,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: AppTheme.primaryLight,
                                    width: 2,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 12,
                                ),
                              ),
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                              onSubmitted: (_) => _applyPromoCode(),
                            ),
                          ),

                          const SizedBox(width: 12),

                          ElevatedButton(
                            onPressed: _applyPromoCode,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primaryLight,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              'Gunakan',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // Example Promo Codes
                      Wrap(
                        spacing: 8,
                        children: [
                          _buildExamplePromo('DENTAL10'),
                          _buildExamplePromo('WELCOME5'),
                          _buildExamplePromo('BULK15'),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              crossFadeState:
                  _isExpanded
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 300),
            ),
          ],
        ),
      ),
    );
  }

  /// Build example promo code chip
  Widget _buildExamplePromo(String code) {
    return GestureDetector(
      onTap: () {
        _promoController.text = code;
        _applyPromoCode();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: AppTheme.accentLight.withAlpha(26),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: AppTheme.accentLight.withAlpha(77)),
        ),
        child: Text(
          code,
          style: GoogleFonts.inter(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: AppTheme.primaryLight,
          ),
        ),
      ),
    );
  }
}