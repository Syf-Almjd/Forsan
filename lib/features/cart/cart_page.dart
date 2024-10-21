import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:forsan/features/shared/components.dart';
import 'package:forsan/features/cart/screens/qrcode_scanner_page.dart';
import 'package:forsan/features/cart/screens/history_cart_page.dart';
import 'package:forsan/features/cart/widgets/cart_card_widget.dart';
import 'package:forsan/state/app_data_cubit/app_cubit.dart';
import 'package:forsan/state/navigation_cubit/navi_cubit.dart';
import 'package:forsan/domain/models/order_model.dart';

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
        if (mounted) {
          setState(() {});
        }
      },
      child: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20)),
                color: Colors.amberAccent),
            padding: const EdgeInsets.all(10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () async {
                    showToast("تم نسخ رقم خدمة العملاء", SnackBarType.success,
                        context);
                    await Clipboard.setData(
                        const ClipboardData(text: "+966501510093"));
                    checkNOpenUrl("tel:+966501510093", context);
                  },
                  child: Container(
                    width: getWidth(30, context),
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
                    NaviCubit.get(context)
                        .navigate(context, const QRCodeScannerPage());
                  },
                  child: Container(
                    width: getWidth(25, context),
                    height: getHeight(8, context),
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.horizontal(
                            left: Radius.circular(10),
                            right: Radius.circular(10)),
                        color: Colors.orange),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.qr_code_scanner,
                          size: 30,
                          color: Colors.white,
                        ),
                        Text(
                          "مسح QR",
                          style: fontAlmarai(
                              fontWeight: FontWeight.w900,
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
                    width: getWidth(30, context),
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
              snapshot.data.sort((OrderModel a, OrderModel b) =>
                  b.orderDate.compareTo(a.orderDate));

              return Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) => CartCardWidget(
                    order: snapshot.data[index],
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
    );
  }
}
