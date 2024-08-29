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
  String orderDate;

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

  // Factory method to create an Order object from a JSON map
  factory OrderModel.fromJson(Map<String, dynamic> json) {
    try {
      return OrderModel(
        orderId: json['orderId'] ?? "",
        orderDate: json['orderDate'] ?? "",
        orderFile: json['orderFile'] ?? "",
        orderDiscount: json['orderDiscount'] ?? "",
        orderTitle: json['orderTitle'] ?? "",
        orderUserName: json['orderUserName'] ?? "",
        orderPrice: json['orderPrice'] ?? "",
        orderColor: json['orderColor'] ?? "",
        orderPackaging: json['orderPackaging'] ?? "",
        orderSize: json['orderSize'] ?? "",
        orderPadding: json['orderPadding'] ?? "",
        orderPaper: json['orderPaper'] ?? "",
        orderDescription: json['orderDescription'] ?? "",
        orderStatus: json['orderStatus'] ?? "",
        orderUser: json['orderUser'] ?? "",
        orderType: json['orderType'] ?? "",
      );
    } catch (e) {
      return OrderModel(
        orderColor: json['orderColor'] ?? "",
        orderDescription: json['orderDescription'] ?? "",
        orderFile: json['orderFile'] ?? "",
        orderId: json['orderId'] ?? "",
        orderPadding: json['orderPadding'] ?? "",
        orderPaper: json['orderPaper'] ?? "",
        orderPrice: json['orderPrice'] ?? "",
        orderSize: json['orderSize'] ?? "",
        orderStatus: json['orderStatus'] ?? "",
        orderTitle: json['orderTitle'] ?? "",
        orderType: json['orderType'] ?? "",
        orderUser: json['orderUser'] ?? "",
        orderDate: 'هذا الطلب من برنامج قديم',
        orderDiscount: '',
        orderUserName: '',
        orderPackaging: '',
      );
    }
  }

  // Convert the Order object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'orderFile': orderFile,
      'orderDate': orderDate,
      'orderTitle': orderTitle,
      'orderPrice': orderPrice,
      'orderDiscount': orderDiscount,
      'orderColor': orderColor,
      'orderType': orderType,
      'orderPackaging': orderPackaging,
      'orderSize': orderSize,
      'orderPadding': orderPadding,
      'orderPaper': orderPaper,
      'orderStatus': orderStatus,
      'orderUserName': orderUserName,
      'orderUser': orderUser,
      'orderDescription': orderDescription,
    };
  }
}
