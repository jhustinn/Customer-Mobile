import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import './widgets/account_details_widget.dart';
import './widgets/app_info_widget.dart';
import './widgets/app_preferences_widget.dart';
import './widgets/business_settings_widget.dart';
import './widgets/customer_service_widget.dart';
import './widgets/profile_header_widget.dart';
import './widgets/quick_access_menu_widget.dart';
import './widgets/security_settings_widget.dart';

class ProfileAndSettings extends StatefulWidget {
  const ProfileAndSettings({super.key});

  @override
  State<ProfileAndSettings> createState() => _ProfileAndSettingsState();
}

class _ProfileAndSettingsState extends State<ProfileAndSettings> {
  int _currentBottomIndex = 4; // Profile tab active

  // Mock user profile data
  final Map<String, dynamic> _userProfile = {
    "profilePhoto":
        "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=400&h=400&fit=crop&crop=face",
    "companyName": "PT Dental Care Sejahtera",
    "ownerName": "Dr. Ahmad Wijaya",
    "membershipTier": "Gold",
  };

  // Mock account details
  final Map<String, dynamic> _accountDetails = {
    "businessRegistration": "SIUP: 123456789/2023",
    "email": "ahmad.wijaya@dentalcare.co.id",
    "phoneNumber": "+62 812-3456-7890",
    "address": "Jl. Sudirman No. 123, Jakarta Pusat, DKI Jakarta 10220",
    "isVerified": true,
  };

  // Mock app preferences
  Map<String, dynamic> _appPreferences = {
    "pushNotifications": true,
    "emailNotifications": true,
    "autoSync": true,
    "dataSaver": false,
  };

  // Mock security settings
  Map<String, dynamic> _securitySettings = {
    "biometricAuth": false,
    "twoFactorAuth": false,
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: CustomAppBar(
        title: "Profil & Pengaturan",
        variant: CustomAppBarVariant.minimal,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(4.w),
        child: Column(
          children: [
            // Profile Header
            ProfileHeaderWidget(
              userProfile: _userProfile,
              onEditPressed: () => _handleEditProfile(),
            ),
            SizedBox(height: 4.h),

            // Account Details
            AccountDetailsWidget(
              accountDetails: _accountDetails,
            ),
            SizedBox(height: 4.h),

            // Quick Access Menu
            QuickAccessMenuWidget(
              onMenuTap: _handleMenuTap,
            ),
            SizedBox(height: 4.h),

            // Customer Service
            CustomerServiceWidget(),
            SizedBox(height: 4.h),

            // Business Settings
            BusinessSettingsWidget(
              onSettingTap: _handleBusinessSettingTap,
            ),
            SizedBox(height: 4.h),

            // App Preferences
            AppPreferencesWidget(
              preferences: _appPreferences,
              onPreferenceChanged: _handlePreferenceChanged,
            ),
            SizedBox(height: 4.h),

            // Security Settings
            SecuritySettingsWidget(
              securitySettings: _securitySettings,
              onSecurityChanged: _handleSecurityChanged,
            ),
            SizedBox(height: 4.h),

            // App Info
            AppInfoWidget(),
            SizedBox(height: 4.h),

            // Logout Button
            _buildLogoutButton(context),
            SizedBox(height: 2.h),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomBar(
        currentIndex: _currentBottomIndex,
        onTap: (index) {
          setState(() {
            _currentBottomIndex = index;
          });
        },
        variant: CustomBottomBarVariant.standard,
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => _showLogoutDialog(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.errorLight,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 3.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'logout',
              color: Colors.white,
              size: 5.w,
            ),
            SizedBox(width: 2.w),
            Text(
              "Keluar",
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleEditProfile() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Fitur edit profil akan segera tersedia"),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _handleMenuTap(String action) {
    String message = "";
    switch (action) {
      case "edit_profile":
        message = "Membuka halaman edit profil";
        break;
      case "change_password":
        message = "Membuka halaman ubah kata sandi";
        break;
      case "notification_settings":
        message = "Membuka pengaturan notifikasi";
        break;
      case "language_preferences":
        message = "Membuka preferensi bahasa";
        break;
      case "payment_methods":
        message = "Membuka metode pembayaran";
        break;
      default:
        message = "Fitur akan segera tersedia";
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _handleBusinessSettingTap(String action) {
    String message = "";
    switch (action) {
      case "invoice_preferences":
        message = "Membuka preferensi invoice";
        break;
      case "delivery_addresses":
        message = "Membuka alamat pengiriman";
        break;
      case "tax_information":
        message = "Membuka informasi pajak";
        break;
      default:
        message = "Fitur akan segera tersedia";
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _handlePreferenceChanged(String key, dynamic value) {
    setState(() {
      _appPreferences[key] = value;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Preferensi $key berhasil diperbarui"),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _handleSecurityChanged(String key, dynamic value) {
    setState(() {
      _securitySettings[key] = value;
    });

    String settingName = "";
    switch (key) {
      case "biometricAuth":
        settingName = "autentikasi biometrik";
        break;
      case "twoFactorAuth":
        settingName = "autentikasi dua faktor";
        break;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Pengaturan $settingName berhasil diperbarui"),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Konfirmasi Keluar"),
        content: Text("Apakah Anda yakin ingin keluar dari aplikasi?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _performLogout();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorLight,
              foregroundColor: Colors.white,
            ),
            child: Text("Keluar"),
          ),
        ],
      ),
    );
  }

  void _performLogout() {
    // Simulate logout process
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Berhasil keluar dari aplikasi"),
        duration: Duration(seconds: 2),
      ),
    );

    // Navigate to login or home
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/home-dashboard',
      (route) => false,
    );
  }
}
