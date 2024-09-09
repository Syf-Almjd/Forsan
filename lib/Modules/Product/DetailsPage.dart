import 'package:flutter/material.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';

import '../../Components/Components.dart';
import '../../Cubit/AppDataCubit/app_cubit.dart';
import '../../Cubit/Navigation/navi_cubit.dart';
import '../../Models/OrderModel.dart';
import '../../Models/ProductModel.dart';

class DetailsPage extends StatefulWidget {
  final ProductModel product;

  const DetailsPage({
    super.key,
    required this.product,
  });

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  var selectedCard = 'التقييم';

  late String generatedCode;

  @override
  Widget build(BuildContext context) {
    generatedCode = generateCode();
    return Scaffold(
        backgroundColor: Colors.amberAccent,
        appBar: appCustomBar("المنتج", context),
        body: ListView(physics: const ClampingScrollPhysics(), children: [
          Stack(children: [
            Container(
                height: MediaQuery.of(context).size.height - 82.0,
                width: MediaQuery.of(context).size.width,
                color: Colors.transparent),
            Positioned(
                top: 75.0,
                child: Container(
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(45.0),
                          topRight: Radius.circular(45.0),
                        ),
                        color: Colors.white),
                    height: MediaQuery.of(context).size.height - 100.0,
                    width: MediaQuery.of(context).size.width)),
            Positioned(
                top: 30.0,
                left: (MediaQuery.of(context).size.width / 2) - 100.0,
                child: Hero(
                    tag: widget.product.productImgID,
                    child: SizedBox(
                        height: 200.0,
                        width: 200.0,
                        child: previewDetailsImage(
                            widget.product.productImgID, context)))),
            Positioned(
              top: 250.0,
              left: 25.0,
              right: 25.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: Text(widget.product.productTitle,
                        style: const TextStyle(
                            fontSize: 22.0, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center),
                  ),
                  const SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "ريال ${widget.product.productPrice} ",
                        style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.green.withOpacity(0.5)),
                      ),
                      Text(
                        ":السعر  ",
                        style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.black.withOpacity(0.5)),
                      ),
                      Container(height: 25.0, color: Colors.grey, width: 1.0),
                      InkWell(
                        onTap: () {
                          // checkNOpenUrl(widget.product.productDescription);
                          // showToast(
                          //     "Click the back Button to go back", ,context);
                        },
                        child: Container(
                          width: getWidth(40, context),
                          height: getHeight(5, context),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(17.0),
                              color: Colors.amberAccent),
                          child: InkWell(
                            onTap: () async {
                              showToast("تمت الاضافة للسلة",
                                  SnackBarType.success, context);

                              NaviCubit.get(context).pop(context);

                              await productItemToOrder(
                                  widget.product, generatedCode);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                const Text("إضافة للسلة",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 15.0)),
                                Container(
                                  height: 25.0,
                                  width: 25.0,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(7.0),
                                      color: Colors.white),
                                  child: const Center(
                                    child: Icon(
                                      Icons.add,
                                      color: Colors.amberAccent,
                                      size: 20.0,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30.0),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Column(
                        children: [
                          Text(
                            "الوصف: ${widget.product.productDescription}",
                            style: const TextStyle(
                                color: Colors.blueGrey, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: getHeight(20, context),
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildInfoCard(
                            'التقييم', "لا يوجد بعد", 'قم بالشراء لتقييم'),
                        const SizedBox(width: 10.0),
                        _buildInfoCard('الترشيح منا', "نعم", 'متوفر في المحل'),
                        const SizedBox(width: 10.0),
                        _buildInfoCard('الضمان', "متوفر", 'لمدة 3 ايام'),
                        const SizedBox(width: 10.0),
                        _buildInfoCard(
                            'سرعة الانتهاء', "عادية", 'حصري مع فرسان'),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ])
        ]));
  }

  Widget _buildInfoCard(String cardTitle, String info, String unit) {
    return InkWell(
        onTap: () {
          selectCard(cardTitle);
        },
        child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeIn,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: cardTitle == selectedCard ? Colors.yellow : Colors.white,
              border: Border.all(
                  color: cardTitle == selectedCard
                      ? Colors.transparent
                      : Colors.grey.withOpacity(0.3),
                  style: BorderStyle.solid,
                  width: 0.75),
            ),
            height: 130.0,
            width: 130.0,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, left: 15.0),
                    child: Text(cardTitle,
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 12.0,
                          color: cardTitle == selectedCard
                              ? Colors.white
                              : Colors.grey.withOpacity(0.7),
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, bottom: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(info,
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 14.0,
                                color: cardTitle == selectedCard
                                    ? Colors.white
                                    : Colors.black,
                                fontWeight: FontWeight.bold)),
                        Text(unit,
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 12.0,
                              color: cardTitle == selectedCard
                                  ? Colors.white
                                  : Colors.black,
                            ))
                      ],
                    ),
                  )
                ])));
  }

  productItemToOrder(ProductModel productData, generatedCode) async {
    var user = await AppCubit.get(context).getLocalUserData();

    var orderData = OrderModel(
        orderId: generatedCode,
        orderUser: user.userID,
        orderUserName: user.name,
        orderFile: productData.productImgID,
        orderTitle: productData.productTitle,
        orderPrice: productData.productPrice,
        orderColor: "",
        orderDiscount: "",
        orderSize: "",
        orderPadding: "",
        orderPaper: "",
        orderDate: DateTime.now().toLocal(),
        orderDescription: productData.productDescription,
        orderStatus: "لم يدفع",
        orderType: 'product',
        orderPackaging: '');
    await AppCubit.get(context).uploadUserOrders(orderData, context);
  }

  selectCard(cardTitle) {
    setState(() {
      selectedCard = cardTitle;
    });
  }
}
