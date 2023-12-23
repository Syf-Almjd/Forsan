import 'package:flutter/material.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:forsan/Components/Components.dart';
import 'package:forsan/Cubit/Navigation/navi_cubit.dart';
import 'package:forsan/Models/OrderModel.dart';
import 'package:forsan/Modules/Cart/CartList.dart';
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
    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(const Duration(seconds: 2));
      },
      child: Column(
        children: [
          Material(
            color: Colors.amberAccent,
            elevation: 0,
            borderRadius:
                const BorderRadius.vertical(bottom: Radius.circular(20)),
            child: Padding(
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
                      showToast("اختر الطلب لدفع", SnackBarType.alert, context);
                      // NaviCubit.get(context).navigate(context, PaymentPage(order: ));
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
                            Icons.payment_outlined,
                            size: 30,
                            color: Colors.green,
                          ),
                          Text(
                            "الدفع والتوصيل",
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
          ),
          getCube(2, context),
          FutureBuilder(
            future: AppCubit.get(context).getOrdersData(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.data == null) {
                return Expanded(child: Center(child: loadingAnimation()));
              }
              if ((snapshot.data).isEmpty) {
                return const Expanded(
                    child: Center(child: Text("لا يوحد طلبات")));
              }
              return Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) => CartList(
                    order: snapshot.data.reversed.toList()[index],
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
    );
  }
}
