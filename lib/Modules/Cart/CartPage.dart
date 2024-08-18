import 'package:flutter/material.dart';
import 'package:forsan/Components/Components.dart';
import 'package:forsan/Cubit/Navigation/navi_cubit.dart';
import 'package:forsan/Models/OrderModel.dart';
import 'package:forsan/Modules/Cart/CartList.dart';
import 'package:forsan/Modules/Cart/HistoryCartPage.dart';
import 'package:forsan/Modules/Cart/Payment/PaymentPage.dart';

import '../../Cubit/AppDataCubit/app_cubit.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<OrderModel>? orders;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 2));
          setState(() {});
        },
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20)),
                  color: Colors.amber),
              padding: const EdgeInsets.all(10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      openUrl("tel:+966501510093");
                    },
                    child: Container(
                      width: getWidth(40, context),
                      height: getHeight(8, context),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.horizontal(
                            left: Radius.circular(100),
                            right: Radius.circular(20)),
                        color: Colors.blue.withOpacity(0.9),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.add_call,
                            size: 30,
                            color: Colors.white,
                          ),
                          Text(
                            "اتصال سريع",
                            style: fontAlmarai(
                                size: getWidth(3, context),
                                textColor: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      // showToast("اختر الطلب لدفع", SnackBarType.alert, context);
                      NaviCubit.get(context)
                          .navigate(context, const HistoryCartPage());
                      // UrlLauncher.launch('mailto:${widget.email.toString()}');
                    },
                    child: Container(
                      width: getWidth(40, context),
                      height: getHeight(8, context),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.horizontal(
                            left: Radius.circular(20),
                            right: Radius.circular(100)),
                        color: Colors.white,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.history_toggle_off,
                            size: 30,
                            color: Colors.green,
                          ),
                          Text(
                            "الطلبات القديمة",
                            style: fontAlmarai(
                                size: getWidth(3, context),
                                textColor: Colors.green),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            getCube(2, context),
            FutureBuilder(
              future: AppCubit.get(context).getOrdersData(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.data == null) {
                  return Expanded(child: Center(child: loadingAnimation()));
                }
                if ((snapshot.data).isEmpty) {
                  return Expanded(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text("لا يوجد طلبات لديك في الوقت الحالي"),
                      Container(
                        width: getWidth(50, context),
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: IconButton(
                            onPressed: () {
                              NaviCubit.get(context)
                                  .navigate(context, const HistoryCartPage());
                            },
                            icon: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'الطلبات المنجزه',
                                  style: TextStyle(color: Colors.blue),
                                ),
                                getCube(2, context),
                                const Icon(
                                  Icons.history,
                                  color: Colors.blue,
                                ),
                              ],
                            )),
                      ),
                    ],
                  ));
                }
                snapshot.data.sort((a, b) => DateTime.parse(b.orderDate)
                    .compareTo(DateTime.parse(a.orderDate)));

                return Expanded(
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) => CartList(
                      order: snapshot.data[index],
                      // Reverse the list and then access items
                      onTap: (order) {
                        NaviCubit.get(context)
                            .navigate(context, PaymentPage(order: order));
                      },
                    ),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
