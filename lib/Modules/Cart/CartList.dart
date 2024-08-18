import 'package:flutter/material.dart';
import 'package:forsan/Components/ChooseWidget.dart';
import 'package:forsan/Components/Components.dart';
import 'package:forsan/Cubit/AppDataCubit/app_cubit.dart';
import 'package:forsan/Models/OrderModel.dart';
import 'package:forsan/generated/assets.dart';

import '../../Cubit/Navigation/navi_cubit.dart';

class CartList extends StatefulWidget {
  final OrderModel order;
  final Function onTap;
  final bool isHistory;

  const CartList(
      {super.key,
      required this.order,
      required this.onTap,
      this.isHistory = false});

  @override
  State<CartList> createState() => _CartListState();
}

class _CartListState extends State<CartList> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: InkWell(
        onTap: () {
          widget.onTap(widget.order);
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
                      onTap: () {
                        openUrl("tel:+966501510093");
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
                          Assets.assetsPrintingGif,
                          height: getHeight(10, context),
                          // "https://cdn.pixabay.com/animation/2022/07/29/03/42/03-42-11-849_512.gif"
                          // "https://mir-s3-cdn-cf.behance.net/project_modules/disp/35771931234507.564a1d2403b3a.gif"
                          // "https://icaengineeringacademy.com/wp-content/uploads/2019/01/ajax-loading-gif-transparent-background-2.gif"
                        ),
                ),
              ),
              Visibility(
                visible: !widget.isHistory,
                child: Positioned(
                  bottom: 1,
                  left: 1,
                  child: InkWell(
                      onTap: () async {
                        showLoadingDialog(context);
                        await AppCubit.get(context)
                            .deleteUserOrders(widget.order, context)
                            .then(
                          (value) {
                            NaviCubit.get(context).pop(context, forced: true);
                          },
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Icon(
                              Icons.delete_outline_outlined,
                              color: Colors.red.withOpacity(0.9),
                            ),
                            // const Text("الغاء الطلب", style: TextStyle(color: Colors.red),),
                          ],
                        ),
                      )),
                ),
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
