enum NotificationType {
  payment,
  order,
  promotion,
}

class NotificationModel {
  final String id;
  final String title;
  final String message;
  final NotificationType type;
  final DateTime timestamp;
  bool isRead;

  // Payment specific fields
  final double? amount;
  final String? invoiceNumber;
  final DateTime? dueDate;

  // Order specific fields
  final String? orderNumber;
  final String? productName;
  final String? productImage;
  final String? trackingNumber;

  // Promotion specific fields
  final int? discountPercentage;
  final double? cashbackAmount;
  final double? minimumPurchase;
  final DateTime? expiryDate;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.timestamp,
    this.isRead = false,
    this.amount,
    this.invoiceNumber,
    this.dueDate,
    this.orderNumber,
    this.productName,
    this.productImage,
    this.trackingNumber,
    this.discountPercentage,
    this.cashbackAmount,
    this.minimumPurchase,
    this.expiryDate,
  });

  NotificationModel copyWith({
    String? id,
    String? title,
    String? message,
    NotificationType? type,
    DateTime? timestamp,
    bool? isRead,
    double? amount,
    String? invoiceNumber,
    DateTime? dueDate,
    String? orderNumber,
    String? productName,
    String? productImage,
    String? trackingNumber,
    int? discountPercentage,
    double? cashbackAmount,
    double? minimumPurchase,
    DateTime? expiryDate,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      amount: amount ?? this.amount,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      dueDate: dueDate ?? this.dueDate,
      orderNumber: orderNumber ?? this.orderNumber,
      productName: productName ?? this.productName,
      productImage: productImage ?? this.productImage,
      trackingNumber: trackingNumber ?? this.trackingNumber,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      cashbackAmount: cashbackAmount ?? this.cashbackAmount,
      minimumPurchase: minimumPurchase ?? this.minimumPurchase,
      expiryDate: expiryDate ?? this.expiryDate,
    );
  }
}
