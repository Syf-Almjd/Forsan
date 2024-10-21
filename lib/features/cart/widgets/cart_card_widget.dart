import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:forsan/domain/models/order_model.dart';
import 'package:forsan/features/shared/components.dart';
import 'package:forsan/core/utils/managers/app_assets.dart';
import 'package:forsan/features/cart/screens/order_info_page.dart';
import 'package:forsan/features/cart/screens/payment/payment_page.dart';
import 'package:forsan/features/cart/screens/payment/order_receipt.dart';
import 'package:forsan/features/home_screen/widgets/choose_file_widget.dart';
import 'package:forsan/state/app_data_cubit/app_cubit.dart';
import 'package:forsan/state/navigation_cubit/navi_cubit.dart';

class CartCardWidget extends StatefulWidget {
  final OrderModel order;
  final bool isHistory;
  final VoidCallback onTap;

  const CartCardWidget(
      {super.key,
      required this.order,
      required this.onTap,
      this.isHistory = false});

  @override
  State<CartCardWidget> createState() => _CartCardWidgetState();
}

class _CartCardWidgetState extends State<CartCardWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: InkWell(
        onTap: () {
          if (widget.order.orderStatus == "لم يدفع") {
            NaviCubit.get(context)
                .navigate(context, PaymentPage(order: widget.order));
            return;
          } else {
            NaviCubit.get(context)
                .navigate(context, OrderInfoPage(order: widget.order));
          }
        },
        child: Container(
          width: getWidth(100, context),
          height: getHeight(20, context),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.black.withOpacity(0.6))),
          child: Stack(
            children: [
              Positioned(
                top: 10.0,
                left: 10.0,
                child: Row(
                  children: [
                    InkWell(
                      onTap: () async {
                        showToast("تم نسخ رقم خدمة العملاء",
                            SnackBarType.success, context);
                        await Clipboard.setData(
                            const ClipboardData(text: "+966501510093"));
                        checkNOpenUrl("tel:+966501510093", context);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        height: getHeight(4, context),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: Colors.blue),
                          // color: Colors.lightGreen.withOpacity(0.4),
                        ),
                        child: FittedBox(
                          child: Icon(
                            Icons.call_outlined,
                            color: Colors.blue.withOpacity(0.9),
                          ),
                        ),
                      ),
                    ),
                    getCube(2, context),
                    Container(
                      padding: const EdgeInsets.all(10),
                      height: getHeight(4, context),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Colors.greenAccent),
                        // color: Colors.lightGreen.withOpacity(0.4),
                      ),
                      child: FittedBox(
                        fit: BoxFit.contain,
                        // Ensure the text fits within the container
                        child: Text(
                          widget.order.orderStatus,
                          style: const TextStyle(color: Colors.green),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: (widget.order.orderType == "product")
                      ? SizedBox(
                          height: getHeight(8, context),
                          child: previewProductImage(
                              widget.order.orderFile, context))
                      : Image.asset(
                          AppAssets.assetsPrintingGif,
                          height: getHeight(10, context),
                        ),
                ),
              ),
              Positioned(
                bottom: 1,
                left: 1,
                child: InkWell(
                    onTap: () async {
                      if (widget.isHistory) {
                        NaviCubit.get(context).navigate(context,
                            OrderReceiptPage(orderModel: widget.order));
                        return;
                      }
                      showLoadingDialog(context);
                      await AppCubit.get(context)
                          .deleteUserOrders(widget.order, context)
                          .then(
                        (value) {
                          NaviCubit.get(context).pop(context, forced: true);
                        },
                      );
                      widget.onTap();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Icon(
                            widget.isHistory
                                ? Icons.receipt_long_outlined
                                : Icons.delete_outline_outlined,
                            color: widget.isHistory
                                ? Colors.blue.withOpacity(0.9)
                                : Colors.red.withOpacity(0.9),
                          ),
                          // const Text("الغاء الطلب", style: TextStyle(color: Colors.red),),
                        ],
                      ),
                    )),
              ),
              Positioned(
                  top: 20,
                  right: 20,
                  child: SizedBox(
                    width: getWidth(50, context),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        FittedBox(
                          fit: BoxFit.contain,
                          child: Text(widget.order.orderTitle,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        getCube(1, context),
                        const Text(
                          ":التفاصيل",
                          style: TextStyle(),
                          textAlign: TextAlign.left,
                        ),
                        getCube(1, context),
                        Text(
                          widget.order.orderDescription,
                          maxLines: 2,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 10,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  )),
              Positioned(
                  bottom: 10,
                  right: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                          "السعر: ${widget.order.orderPrice.isEmpty ? "غير محدد" : widget.order.orderPrice}"),
                      getCube(1, context),
                      Text("${widget.order.orderId} :رقم الطلب"),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
