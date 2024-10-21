import 'package:flutter/material.dart';
import 'package:forsan/domain/models/order_model.dart';
import 'package:forsan/features/shared/components.dart';
import 'package:forsan/features/cart/widgets/cart_card_widget.dart';
import 'package:forsan/state/app_data_cubit/app_cubit.dart';
import 'package:forsan/state/navigation_cubit/navi_cubit.dart';

class HistoryCartPage extends StatefulWidget {
  const HistoryCartPage({super.key});

  @override
  State<HistoryCartPage> createState() => _HistoryCartPageState();
}

class _HistoryCartPageState extends State<HistoryCartPage> {
  List<OrderModel>? orders;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(const Duration(seconds: 2));
      },
      child: SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        checkNOpenUrl("tel:+966501510093", context);
                      },
                      child: Container(
                        width: getWidth(70, context),
                        height: getHeight(8, context),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          // left: Radius.circular(100),
                          // right: Radius.circular(20)),
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
                        NaviCubit.get(context).pop(context);
                      },
                      child: Container(
                        width: getWidth(20, context),
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
                              Icons.arrow_forward_ios_rounded,
                              size: 30,
                              color: Colors.green,
                            ),
                            Text(
                              "الرجوع",
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
                future: AppCubit.get(context).getHistoryOrdersData(),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.data == null) {
                    return Expanded(child: Center(child: loadingAnimation()));
                  }
                  if ((snapshot.data).isEmpty) {
                    return const Expanded(
                        child: Center(child: Text("لا يوجد طلبات قديمة")));
                  }
                  (snapshot.data as List<OrderModel>).sort(
                      (OrderModel a, OrderModel b) =>
                          b.orderDate.compareTo(a.orderDate));

                  return Expanded(
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) => CartCardWidget(
                        order: snapshot.data.reversed.toList()[index],
                        isHistory: true,
                        // Reverse the list and then access items
                        onTap: () {
                          setState(() {});
                        },
                      ),
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
