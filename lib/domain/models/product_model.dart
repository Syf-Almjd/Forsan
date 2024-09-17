class ProductModel {
  String productId;
  String productImgID;
  String productTitle;
  String productPrice;
  String productDescription;

  ProductModel({
    required this.productId,
    required this.productImgID,
    required this.productTitle,
    required this.productPrice,
    required this.productDescription,
  });

  //when you want to send data from medel to json
  Map<String, dynamic> toJson() {
    return {
      'imgID': productImgID,
      'title': productTitle,
      'price': productPrice,
      'description': productDescription,
    };
  }

  //when you want to get database data (fromjson) to model
  factory ProductModel.fromJson(String productId, Map<String, dynamic> json) {
    return ProductModel(
      productId: productId,
      productImgID: json['imgID'],
      productTitle: json['title'],
      productPrice: json['price'],
      productDescription: json['description'],
    );
  }
}
