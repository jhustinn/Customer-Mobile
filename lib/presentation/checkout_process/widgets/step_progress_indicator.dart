import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

/// Step progress indicator widget for checkout wizard
class StepProgressIndicator extends StatelessWidget {
  final int currentStep;
  final List<String> stepLabels;

  const StepProgressIndicator({
    super.key,
    required this.currentStep,
    required this.stepLabels,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: AppTheme.backgroundLight,
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            offset: const Offset(0, 2),
            blurRadius: 4,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        children: List.generate(
          stepLabels.length,
          (index) => Expanded(
            child: Row(
              children: [
                // Step Circle
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color:
                              index <= currentStep
                                  ? AppTheme.primaryLight
                                  : AppTheme.surfaceLight,
                          borderRadius: BorderRadius.circular(16),
                          border:
                              index <= currentStep
                                  ? null
                                  : Border.all(
                                    color: AppTheme.dividerLight,
                                    width: 2,
                                  ),
                        ),
                        child: Center(
                          child:
                              index < currentStep
                                  ? Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 16,
                                  )
                                  : Text(
                                    '${index + 1}',
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color:
                                          index == currentStep
                                              ? Colors.white
                                              : AppTheme.textSecondaryLight,
                                    ),
                                  ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Step Label
                      Text(
                        stepLabels[index],
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight:
                              index <= currentStep
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                          color:
                              index <= currentStep
                                  ? AppTheme.primaryLight
                                  : AppTheme.textSecondaryLight,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                // Progress Line
                if (index < stepLabels.length - 1)
                  Container(
                    height: 2,
                    width: 24,
                    margin: const EdgeInsets.only(bottom: 24),
                    decoration: BoxDecoration(
                      color:
                          index < currentStep
                              ? AppTheme.primaryLight
                              : AppTheme.dividerLight,
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
