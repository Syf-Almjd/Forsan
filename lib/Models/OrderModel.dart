class OrderModel {
  String orderId;
  String orderUser;
  String orderType;
  String orderFile;
  String orderTitle;
  String orderPrice;
  String orderColor;
  String orderSize;
  String orderPadding;
  String orderPaper;
  String orderDescription;
  String orderStatus;

  OrderModel({
    required this.orderId,
    required this.orderType,
    required this.orderUser,
    required this.orderFile,
    required this.orderTitle,
    required this.orderPrice,
    required this.orderColor,
    required this.orderSize,
    required this.orderPadding,
    required this.orderPaper,
    required this.orderDescription,
    required this.orderStatus,
  });

  // Factory method to create an Order object from a JSON map
  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      orderId: json['orderId'],
      orderFile: json['orderFile'],
      orderTitle: json['orderTitle'],
      orderPrice: json['orderPrice'],
      orderColor: json['orderColor'],
      orderSize: json['orderSize'],
      orderPadding: json['orderPadding'],
      orderPaper: json['orderPaper'],
      orderDescription: json['orderDescription'],
      orderStatus: json['orderStatus'],
      orderUser: json['orderUser'],
      orderType: json['orderType'],
    );
  }

  // Convert the Order object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'orderFile': orderFile,
      'orderTitle': orderTitle,
      'orderPrice': orderPrice,
      'orderColor': orderColor,
      'orderType': orderType,
      'orderSize': orderSize,
      'orderPadding': orderPadding,
      'orderPaper': orderPaper,
      'orderStatus': orderStatus,
      'orderUser': orderUser,
      'orderDescription': orderDescription,
    };
  }
}
