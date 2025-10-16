import 'package:cobra_customer_app/widgets/custom_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import './widgets/balance_card_widget.dart';
import './widgets/credit_summary_widget.dart';
import './widgets/invoice_card_widget.dart';
import './widgets/quick_actions_widget.dart';
import './widgets/transaction_item_widget.dart';

class FinanceDashboard extends StatefulWidget {
  const FinanceDashboard({super.key});

  @override
  State<FinanceDashboard> createState() => _FinanceDashboardState();
}

class _FinanceDashboardState extends State<FinanceDashboard> {
  bool _isLoading = false;
  int _currentBottomIndex = 2; // Finance tab active

  // Mock data for finance dashboard
  final double _accountBalance = 15750000.0;
  final double _creditLimit = 50000000.0;
  final double _usedCredit = 12500000.0;

  final List<Map<String, dynamic>> _outstandingInvoices = [
    {
      'id': 'INV-2024-001',
      'supplier': 'PT Dental Equipment Indonesia',
      'invoiceNumber': 'INV-2024-001',
      'amount': 2500000.0,
      'dueDate': DateTime.now().add(Duration(days: 3)),
      'status': 'due_soon',
    },
    {
      'id': 'INV-2024-002',
      'supplier': 'CV Alat Medis Jaya',
      'invoiceNumber': 'INV-2024-002',
      'amount': 1750000.0,
      'dueDate': DateTime.now().subtract(Duration(days: 2)),
      'status': 'overdue',
    },
    {
      'id': 'INV-2024-003',
      'supplier': 'PT Cobra Dental Indonesia',
      'invoiceNumber': 'INV-2024-003',
      'amount': 3200000.0,
      'dueDate': DateTime.now().add(Duration(days: 15)),
      'status': 'pending',
    },
    {
      'id': 'INV-2024-004',
      'supplier': 'Dental Supply Center',
      'invoiceNumber': 'INV-2024-004',
      'amount': 950000.0,
      'dueDate': DateTime.now().subtract(Duration(days: 30)),
      'status': 'paid',
    },
  ];

  final List<Map<String, dynamic>> _recentTransactions = [
    {
      'id': 'TXN-001',
      'type': 'payment',
      'description': 'Pembayaran Invoice INV-2024-005',
      'amount': -1500000.0,
      'date': DateTime.now().subtract(Duration(hours: 2)),
      'status': 'completed',
    },
    {
      'id': 'TXN-002',
      'type': 'credit',
      'description': 'Penambahan Limit Kredit',
      'amount': 5000000.0,
      'date': DateTime.now().subtract(Duration(days: 1)),
      'status': 'completed',
    },
    {
      'id': 'TXN-003',
      'type': 'purchase',
      'description': 'Pembelian Dental Unit - Model X200',
      'amount': -8500000.0,
      'date': DateTime.now().subtract(Duration(days: 2)),
      'status': 'completed',
    },
    {
      'id': 'TXN-004',
      'type': 'refund',
      'description': 'Refund Produk Cacat - Handpiece',
      'amount': 750000.0,
      'date': DateTime.now().subtract(Duration(days: 3)),
      'status': 'completed',
    },
    {
      'id': 'TXN-005',
      'type': 'invoice',
      'description': 'Invoice Baru - Scaling Kit',
      'amount': -2200000.0,
      'date': DateTime.now().subtract(Duration(days: 4)),
      'status': 'pending',
    },
  ];

  Future<void> _refreshData() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(Duration(seconds: 1));

    setState(() {
      _isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Data keuangan berhasil diperbarui'),
        backgroundColor: AppTheme.successLight,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _handlePayInvoice() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Fitur pembayaran invoice akan segera tersedia'),
        backgroundColor: AppTheme.lightTheme.primaryColor,
      ),
    );
  }

  void _handleViewCredit() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 60.h,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              margin: EdgeInsets.symmetric(vertical: 2.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Text(
                'Detail Kredit',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
              ),
            ),
            SizedBox(height: 2.h),
            Expanded(
              child: SingleChildScrollView(
                child: CreditSummaryWidget(
                  creditLimit: _creditLimit,
                  usedCredit: _usedCredit,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleTransactionHistory() {
    Navigator.pushNamed(context, '/transaction-history');
  }

  void _handleDownloadStatements() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Mengunduh laporan keuangan...'),
        backgroundColor: AppTheme.successLight,
      ),
    );
  }

  void _handleInvoicePayment(String invoiceId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Konfirmasi Pembayaran'),
        content: Text('Apakah Anda yakin ingin membayar invoice ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Pembayaran berhasil diproses'),
                  backgroundColor: AppTheme.successLight,
                ),
              );
            },
            child: Text('Bayar'),
          ),
        ],
      ),
    );
  }

  void _handleTransactionLongPress(Map<String, dynamic> transaction) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: CustomIconWidget(
                iconName: 'category',
                color: AppTheme.lightTheme.primaryColor,
                size: 24,
              ),
              title: Text('Kategorikan Transaksi'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text('Fitur kategorisasi akan segera tersedia')),
                );
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'receipt',
                color: AppTheme.lightTheme.primaryColor,
                size: 24,
              ),
              title: Text('Lihat Detail'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text('Detail transaksi akan segera tersedia')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Keuangan',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: _refreshData,
            icon: _isLoading
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppTheme.lightTheme.primaryColor,
                      ),
                    ),
                  )
                : CustomIconWidget(
                    iconName: 'refresh',
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    size: 24,
                  ),
          ),
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/profile-and-settings');
            },
            icon: CustomIconWidget(
              iconName: 'account_circle',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        color: AppTheme.lightTheme.primaryColor,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Balance Card
              // BalanceCardWidget(
              //   balance: _accountBalance,
              //   onToggleVisibility: () {
              //     // Handle balance visibility toggle
              //   },
              // ),

              SizedBox(height: 2.h),

              // Quick Actions
              QuickActionsWidget(
                onPayInvoice: _handlePayInvoice,
                onViewCredit: _handleViewCredit,
                onTransactionHistory: _handleTransactionHistory,
                onDownloadStatements: _handleDownloadStatements,
              ),

              SizedBox(height: 3.h),

              // Credit Summary
              CreditSummaryWidget(
                creditLimit: _creditLimit,
                usedCredit: _usedCredit,
              ),

              SizedBox(height: 3.h),

              // Outstanding Invoices Section
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Invoice Tertunggak',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/invoice-list');
                      },
                      child: Text(
                        'Lihat Semua',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.lightTheme.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Outstanding Invoices List
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _outstandingInvoices.take(3).length,
                itemBuilder: (context, index) {
                  final invoice = _outstandingInvoices[index];
                  return InvoiceCardWidget(
                    invoice: invoice,
                    onPayTap: () => _handleInvoicePayment(invoice['id']),
                    onViewDetails: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content:
                                Text('Detail invoice akan segera tersedia')),
                      );
                    },
                    onDownloadPdf: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Mengunduh PDF invoice...')),
                      );
                    },
                    onSetReminder: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Reminder berhasil diatur')),
                      );
                    },
                  );
                },
              ),

              SizedBox(height: 3.h),

              // Recent Transactions Section
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Transaksi Terbaru',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                      ),
                    ),
                    TextButton(
                      onPressed: _handleTransactionHistory,
                      child: Text(
                        'Lihat Semua',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.lightTheme.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Recent Transactions List
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _recentTransactions.take(5).length,
                itemBuilder: (context, index) {
                  final transaction = _recentTransactions[index];
                  return TransactionItemWidget(
                    transaction: transaction,
                    onLongPress: () => _handleTransactionLongPress(transaction),
                  );
                },
              ),

              SizedBox(height: 10.h), // Bottom padding for navigation
            ],
          ),
        ),
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   currentIndex: _currentBottomIndex,
      //   onTap: (index) {
      //     setState(() {
      //       _currentBottomIndex = index;
      //     });

      //     switch (index) {
      //       case 0:
      //         Navigator.pushNamed(context, '/home-dashboard');
      //         break;
      //       case 1:
      //         Navigator.pushNamed(context, '/product-catalog');
      //         break;
      //       case 2:
      //         // Already on Finance Dashboard
      //         break;
      //       case 3:
      //         Navigator.pushNamed(context, '/promo-and-membership');
      //         break;
      //       case 4:
      //         Navigator.pushNamed(context, '/profile-and-settings');
      //         break;
      //     }
      //   },
      //   type: BottomNavigationBarType.fixed,
      //   backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      //   selectedItemColor: AppTheme.lightTheme.primaryColor,
      //   unselectedItemColor: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
      //   selectedLabelStyle: TextStyle(
      //     fontSize: 12.sp,
      //     fontWeight: FontWeight.w500,
      //   ),
      //   unselectedLabelStyle: TextStyle(
      //     fontSize: 12.sp,
      //     fontWeight: FontWeight.w400,
      //   ),
      //   items: [
      //     BottomNavigationBarItem(
      //       icon: CustomIconWidget(
      //         iconName: 'dashboard',
      //         color: _currentBottomIndex == 0
      //             ? AppTheme.lightTheme.primaryColor
      //             : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
      //         size: 24,
      //       ),
      //       label: 'Beranda',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: CustomIconWidget(
      //         iconName: 'inventory_2',
      //         color: _currentBottomIndex == 1
      //             ? AppTheme.lightTheme.primaryColor
      //             : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
      //         size: 24,
      //       ),
      //       label: 'Katalog',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: CustomIconWidget(
      //         iconName: 'account_balance_wallet',
      //         color: _currentBottomIndex == 2
      //             ? AppTheme.lightTheme.primaryColor
      //             : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
      //         size: 24,
      //       ),
      //       label: 'Keuangan',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: CustomIconWidget(
      //         iconName: 'card_membership',
      //         color: _currentBottomIndex == 3
      //             ? AppTheme.lightTheme.primaryColor
      //             : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
      //         size: 24,
      //       ),
      //       label: 'Promo',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: CustomIconWidget(
      //         iconName: 'person',
      //         color: _currentBottomIndex == 4
      //             ? AppTheme.lightTheme.primaryColor
      //             : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
      //         size: 24,
      //       ),
      //       label: 'Profil',
      //     ),
      //   ],
      // ),
    bottomNavigationBar: CustomBottomBar(
        currentIndex: 2,
        onTap: (index) {
          // Handle navigation tap
        },
      ),
    );
  }
}
