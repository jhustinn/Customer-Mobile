import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BiometricAuthWidget extends StatelessWidget {
  const BiometricAuthWidget({super.key});

  void _handleBiometricAuth(BuildContext context) {
    HapticFeedback.lightImpact();

    // Simulate biometric authentication
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Autentikasi Biometrik'),
        content: const Text(
            'Letakkan jari Anda pada sensor fingerprint atau gunakan Face ID'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Fitur biometric akan segera tersedia'),
                ),
              );
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                height: 1,
                color: Theme.of(context).dividerColor,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'atau',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.color
                          ?.withValues(alpha: 0.6),
                    ),
              ),
            ),
            Expanded(
              child: Container(
                height: 1,
                color: Theme.of(context).dividerColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        OutlinedButton.icon(
          onPressed: () => _handleBiometricAuth(context),
          icon: const Icon(Icons.fingerprint, size: 20),
          label: const Text('Masuk dengan Biometric'),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      ],
    );
  }
}
