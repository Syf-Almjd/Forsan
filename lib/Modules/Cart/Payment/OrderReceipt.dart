import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:forsan/Components/ChooseWidget.dart';
import 'package:forsan/Components/Components.dart';
import 'package:forsan/Components/Shared/utils/managers/app_constants.dart';
import 'package:forsan/Models/OrderModel.dart';
import 'package:screenshot/screenshot.dart';

class OrderReceiptPage extends StatefulWidget {
  final OrderModel orderModel;

  OrderReceiptPage({required this.orderModel});

  @override
  _OrderReceiptPageState createState() => _OrderReceiptPageState();
}

class _OrderReceiptPageState extends State<OrderReceiptPage> {
  final ScreenshotController screenshotController = ScreenshotController();

  saveConfirmedData(OrderModel model, sendToPrint) {
    var listOfOrderDetails = [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("اللون:", style: TextStyle(fontWeight: FontWeight.w600)),
          Text(model.orderColor),
        ],
      ),
      const SizedBox(height: 5),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("الحجم:", style: TextStyle(fontWeight: FontWeight.w600)),
          Text(model.orderSize),
        ],
      ),
      const SizedBox(height: 5),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("الخصم:", style: TextStyle(fontWeight: FontWeight.w600)),
          Text(model.orderDiscount),
        ],
      ),
      const SizedBox(height: 5),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("التغليف:", style: TextStyle(fontWeight: FontWeight.w600)),
          Text(model.orderPackaging),
        ],
      ),
      const SizedBox(height: 5),
    ];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        margin: const EdgeInsets.all(20),
        decoration: !sendToPrint
            ? BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                gradient: const LinearGradient(
                  colors: [Colors.white, Colors.grey],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              )
            : const BoxDecoration(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Access MediaQuery for responsive design
            SizedBox(
              width: double.infinity,
              child: logoContainer(context),
            ),
            const SizedBox(height: 20),

            // Adjust the font size based on screen width
            Center(
              child: Text(
                "مستند تأكيد الطلب",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: MediaQuery.of(context).size.width > 600 ? 22 : 18,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),

            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal:
                      MediaQuery.of(context).size.width > 600 ? 80.0 : 20.0),
              child: Center(
                child: Wrap(
                  alignment: WrapAlignment.spaceAround,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  runAlignment: WrapAlignment.center,
                  direction: Axis.vertical,
                  children: [
                    Text(
                      "فرسان للطباعة",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        fontSize:
                            MediaQuery.of(context).size.width > 600 ? 16 : 14,
                      ),
                    ),
                    const Center(
                      child: SizedBox(
                        width: 120,
                        height: 80,
                        child: Icon(Icons.receipt_long,
                            size: 50, color: Colors.black),
                      ),
                    ),
                    Text(
                      "Forsan Services",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        fontSize:
                            MediaQuery.of(context).size.width > 600 ? 16 : 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            Text(
              "تفاصيل الطلب:",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: MediaQuery.of(context).size.width > 600 ? 18 : 16,
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal:
                      MediaQuery.of(context).size.width > 600 ? 80.0 : 20.0),
              child: Column(
                children: [
                  Text(model.orderTitle),
                  const SizedBox(height: 5),
                  Wrap(
                    children: [
                      const Text("الوصف:",
                          style: TextStyle(fontWeight: FontWeight.w600)),
                      Text(model.orderDescription,
                          maxLines: 2, overflow: TextOverflow.ellipsis),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("رقم الطلب:",
                          style: TextStyle(fontWeight: FontWeight.w600)),
                      Text(model.orderId),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("تاريخ الطلب:",
                          style: TextStyle(fontWeight: FontWeight.w600)),
                      Text(getFormatDate(model.orderDate)),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("سعر الطلب:",
                          style: TextStyle(fontWeight: FontWeight.w600)),
                      Text("${model.orderPrice} ${AppConstants.appCurrancy}"),
                    ],
                  ),
                  const SizedBox(height: 5),
                  if ("product" != model.orderType ||
                      "service" != model.orderType)
                    ...listOfOrderDetails,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("حالة الطلب:",
                          style: TextStyle(fontWeight: FontWeight.w600)),
                      Text(model.orderStatus),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            getCube(5, context),

            // Footer message
            const Center(
              child: Text(
                "لأي معلومات إضافية، يرجى الاتصال بنا. شكرًا!",
                style:
                    TextStyle(fontWeight: FontWeight.w600, color: Colors.black),
                textAlign: TextAlign.center,
              ),
            ),
            getCube(5, context),

            // Company Info Section
            Center(
              child: Wrap(
                alignment: WrapAlignment.spaceAround,
                crossAxisAlignment: WrapCrossAlignment.center,
                runAlignment: WrapAlignment.center,
                direction:
                    isDesktopSize(context) ? Axis.horizontal : Axis.vertical,
                children: [
                  Column(
                    children: [
                      Text(
                        "جدة - حي السليمانية - جوار برنتلي",
                        style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.w400,
                          fontSize:
                              MediaQuery.of(context).size.width > 600 ? 16 : 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "Jeddah, Saudi Arabia",
                        style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.w400,
                          fontSize:
                              MediaQuery.of(context).size.width > 600 ? 14 : 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  const SizedBox(width: 100),
                  Column(
                    children: [
                      Directionality(
                        textDirection: TextDirection.ltr,
                        child: Text(
                          "+966 50 569 8771",
                          style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.w400,
                            fontSize: MediaQuery.of(context).size.width > 600
                                ? 16
                                : 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "forsanpr@gmail.com",
                        style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.w400,
                          fontSize:
                              MediaQuery.of(context).size.width > 600 ? 16 : 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            getCube(10, context)
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appCustomBar("مستند الطلب", context),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              child: TextButton.icon(
                onPressed: () async {
                  await printReceipt();
                },
                icon: const Icon(Icons.receipt_long_outlined,
                    color: Colors.black),
                label: const Text(
                  'تنزيل ومشاركة الفاتورة',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: saveConfirmedData(widget.orderModel, false),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> printReceipt() async {
    if (!mounted) {
      return; // Ensure the widget is still mounted
    }
    try {
      // Size printingSize = await showOrderPrintDialog(context: context);
      showLoadingDialog(context);
      screenshotController
          .captureFromWidget(saveConfirmedData(widget.orderModel, true),
              targetSize: const Size(800, 1200), pixelRatio: 2.0)
          .then((imageBytes) {
        fromImageSavePDF(imageBytes);
      });
    } catch (error) {
      showToast("حدث خطأ: ${error.toString()}", SnackBarType.fail, context);
    } finally {
      Navigator.of(context).pop();
    }
  }
}
