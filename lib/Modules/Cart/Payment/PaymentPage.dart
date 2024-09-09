import 'package:flutter/material.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:forsan/Components/Components.dart';
import 'package:forsan/Cubit/Navigation/navi_cubit.dart';
import 'package:forsan/Modules/Cart/Payment/BankPaymentPage.dart';
import 'package:moyasar/moyasar.dart';

import '../../../Cubit/AppDataCubit/app_cubit.dart';
import '../../../Models/OrderModel.dart';

class PaymentPage extends StatefulWidget {
  final OrderModel order;
  PaymentPage({super.key, required this.order});

  final paymentConfig = PaymentConfig(
    publishableApiKey: 'غير متوفر مؤقتًا',
    amount: 100,
    description: 'غير متوفر مؤقتًا',
    metadata: {'غير متوفر مؤقتًا': 'غير متوفر مؤقتًا'},
    creditCard: CreditCardConfig(saveCard: false, manual: true),
    applePay: ApplePayConfig(
        merchantId: 'غير متوفر مؤقتًا',
        label: 'غير متوفر مؤقتًا',
        manual: true),
  );

  void onPaymentResult(result) {
    if (result is PaymentResponse) {
      switch (result.status) {
        case PaymentStatus.paid:
          // handle success.
          break;
        case PaymentStatus.failed:
          // handle failure.
          break;
        case PaymentStatus.initiated:
        // handle
        case PaymentStatus.authorized:
        // handle
        case PaymentStatus.captured:
        // handle
      }
    }
  }

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("الدفع"),
        centerTitle: true,
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          getCube(4, context),
          Text(
            "اختر طريقة الدفع",
            style: TextStyle(
              fontSize: getWidth(5, context),
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          getCube(2, context),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton(
              style: ButtonStyle(
                  shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
                  padding: const WidgetStatePropertyAll(EdgeInsets.all(20)),
                  backgroundColor:
                      WidgetStateProperty.all<Color>(Colors.green)),
              onPressed: () {
                widget.order.orderStatus = "الدفع كاش";
                AppCubit.get(context).updateUserOrders(widget.order, context);
                showToast("الدفع كاش", SnackBarType.success, context);
                NaviCubit.get(context).pop(context);
              },
              child: const Text("الدفع كاش"),
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton(
              style: ButtonStyle(
                  shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
                  padding: const WidgetStatePropertyAll(EdgeInsets.all(20)),
                  backgroundColor:
                      WidgetStateProperty.all<Color>(Colors.blueAccent)),
              onPressed: () {
                NaviCubit.get(context)
                    .navigate(context, BankPaymentPage(order: widget.order));
              },
              child: const Text("التحويل البنكي"),
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton(
              style: ButtonStyle(
                  shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
                  padding: const WidgetStatePropertyAll(EdgeInsets.all(20)),
                  backgroundColor:
                      WidgetStateProperty.all<Color>(Colors.black)),
              onPressed: () {
                ApplePay(
                  config: widget.paymentConfig,
                  onPaymentResult: () {
                    showToast("غير متوفر", SnackBarType.fail, context);
                  },
                );
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text("Apple Pay"),
                  Text(
                    "(غير متوفر مؤقتًا)",
                    style: TextStyle(
                        color: Colors.red, fontSize: getWidth(4, context)),
                  ),
                ],
              ),
            ),
          ),
          const Divider(),
          Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  FittedBox(
                      child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "(غير متوفر مؤقتًا)",
                        style: TextStyle(
                            color: Colors.red, fontSize: getWidth(4, context)),
                      ),
                      const Text(" او الدفع عن طريق البطاقة"),
                    ],
                  )),
                  getCube(5, context),
                  CreditCard(
                    locale: const Localization.ar(),
                    config: widget.paymentConfig,
                    onPaymentResult: () {
                      showToast("غير متوفر", SnackBarType.fail, context);
                    },
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
