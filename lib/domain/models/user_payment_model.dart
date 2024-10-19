class UserPaymentModel {
  final String userID;
  final String orderID;
  final String name;
  final String email;
  final String phoneNumber;
  final String code;
  final String status;
  final String amount;
  final DateTime timestamp;

  const UserPaymentModel({
    required this.userID,
    required this.orderID,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.code,
    required this.status,
    required this.amount,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'userID': userID,
        'orderID': orderID,
        'name': name,
        'email': email,
        'phoneNumber': phoneNumber,
        'code': code,
        'status': status,
        'amount': amount,
        'timestamp': timestamp.toIso8601String(),
      };

  factory UserPaymentModel.fromJson(Map<String, dynamic> json) =>
      UserPaymentModel(
        userID: json['userID'],
        orderID: json['orderID'],
        name: json['name'],
        email: json['email'],
        phoneNumber: json['phoneNumber'],
        code: json['code'],
        status: json['status'],
        amount: json['amount'],
        timestamp: DateTime.parse(json['timestamp']),
      );
}
