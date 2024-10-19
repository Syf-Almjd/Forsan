import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  String orderId;
  String orderUser;
  String orderType;
  String orderUserName;
  String orderFile;
  String orderDiscount;
  String orderTitle;
  String orderPrice;
  String orderColor;
  String orderSize;
  String orderPadding;
  String orderPackaging;
  String orderPaper;
  String orderDescription;
  String orderStatus;
  DateTime orderDate;

  OrderModel({
    required this.orderId,
    required this.orderDate,
    required this.orderType,
    required this.orderUser,
    required this.orderUserName,
    required this.orderFile,
    required this.orderPackaging,
    required this.orderTitle,
    required this.orderPrice,
    required this.orderColor,
    required this.orderSize,
    required this.orderDiscount,
    required this.orderPadding,
    required this.orderPaper,
    required this.orderDescription,
    required this.orderStatus,
  });

  // Factory method to create an OrderModel object from a JSON map
  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      orderId: json['orderId'] ?? "",
      orderDate: (json['orderDate'] as Timestamp?)?.toDate().toLocal() ??
          DateTime.now().toLocal(),
      orderType: json['orderType'] ?? "",
      orderUser: json['orderUser'] ?? "",
      orderUserName: json['orderUserName'] ?? "",
      orderFile: json['orderFile'] ?? "",
      orderDiscount: json['orderDiscount'] ?? "",
      orderTitle: json['orderTitle'] ?? "",
      orderPrice: json['orderPrice'] ?? "",
      orderColor: json['orderColor'] ?? "",
      orderSize: json['orderSize'] ?? "",
      orderPadding: json['orderPadding'] ?? "",
      orderPackaging: json['orderPackaging'] ?? "",
      orderPaper: json['orderPaper'] ?? "",
      orderDescription: json['orderDescription'] ?? "",
      orderStatus: json['orderStatus'] ?? "",
    );
  }

  // Convert the OrderModel object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'orderDate': orderDate,
      'orderType': orderType,
      'orderUser': orderUser,
      'orderUserName': orderUserName,
      'orderFile': orderFile,
      'orderDiscount': orderDiscount,
      'orderTitle': orderTitle,
      'orderPrice': orderPrice,
      'orderColor': orderColor,
      'orderSize': orderSize,
      'orderPadding': orderPadding,
      'orderPackaging': orderPackaging,
      'orderPaper': orderPaper,
      'orderDescription': orderDescription,
      'orderStatus': orderStatus,
    };
  }
}
