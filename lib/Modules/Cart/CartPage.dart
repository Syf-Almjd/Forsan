import 'package:flutter/material.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:forsan/Components/Components.dart';
import 'package:forsan/Models/OrderModel.dart';
import 'package:forsan/Modules/Cart/CartList.dart';

import '../../Cubit/AppDataCubit/app_cubit.dart';

class cartPage extends StatefulWidget {
  const cartPage({super.key});

  @override
  State<cartPage> createState() => _cartPageState();
}

class _cartPageState extends State<cartPage> {
  List<OrderModel>? orders;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Material(
          color: Colors.amberAccent,
          elevation: 10,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: getWidth(40, context),
                  height: getHeight(8, context),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.horizontal(
                        left: Radius.circular(100), right: Radius.circular(20)),
                    color: Colors.red,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.delete_forever_outlined,
                        size: 30,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        "مسح",
                        style: fontAlmarai(size: 8, textColor: Colors.white),
                      ),
                    ],
                  ),
                ),

                const Spacer(),
                // Text(
                //   "قائمة المشتريات",
                //   style: fontAlmarai(textColor: Colors.white),
                // ),
                // Spacer(),
                Container(
                  width: getWidth(40, context),
                  height: getHeight(8, context),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.horizontal(
                        left: Radius.circular(20), right: Radius.circular(100)),
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
                      const SizedBox(height: 3),
                      Text(
                        "الدفع والتوصيل",
                        style: fontAlmarai(size: 8, textColor: Colors.green),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        getCube(2 ,context),
        FutureBuilder(
          future: AppCubit.get(context).getOrdersData(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.data==null) {
              return Expanded(child: Center(child: loadingAnimation()));
            }
            if ((snapshot.data).isEmpty) {
              return const Expanded(child: Center(child: Text("لا يوحد طلبات")));
            }
            return Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) => cartList(
                    order: snapshot.data[index],
                    onTap: (index) {
                      showToast("item no: $index", SnackBarType.save,context);
                    },
                  ),
                ),
            );
          },
        )
      ],
    ));
  }
}
