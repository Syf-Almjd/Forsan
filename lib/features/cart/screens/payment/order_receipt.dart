import 'package:flutter/material.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:forsan/features/shared/components.dart';
import 'package:forsan/core/utils/managers/app_assets.dart';
import 'package:forsan/core/utils/managers/app_constants.dart';
import 'package:forsan/domain/models/order_model.dart';
import 'package:forsan/features/home_screen/widgets/choose_file_widget.dart';
import 'package:screenshot/screenshot.dart';
import 'package:syncfusion_flutter_barcodes/barcodes.dart';

class OrderReceiptPage extends StatefulWidget {
  final OrderModel orderModel;

  const OrderReceiptPage({super.key, required this.orderModel});

  @override
  _OrderReceiptPageState createState() => _OrderReceiptPageState();
}

class _OrderReceiptPageState extends State<OrderReceiptPage> {
  final ScreenshotController screenshotController = ScreenshotController();

  saveConfirmedData(OrderModel model, sendToPrint) {
    var listOfOrderDetails = [
      TableRow(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child:
                Text("اللون:", style: TextStyle(fontWeight: FontWeight.w600)),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(model.orderColor),
          ),
        ],
      ),
      TableRow(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child:
                Text("الحجم:", style: TextStyle(fontWeight: FontWeight.w600)),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(model.orderSize),
          ),
        ],
      ),
      TableRow(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child:
                Text("التغليف:", style: TextStyle(fontWeight: FontWeight.w600)),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(model.orderPackaging),
          ),
        ],
      ),
      // TableRow(
      //   children: [
      //     const Padding(
      //       padding: EdgeInsets.all(8.0),
      //       child:
      //           Text("الملف:", style: TextStyle(fontWeight: FontWeight.w600)),
      //     ),
      //     Padding(
      //       padding: const EdgeInsets.all(8.0),
      //       child: Container(
      //         height: 60,
      //         child: SfBarcodeGenerator(
      //           value: widget.orderModel.orderFile,
      //           symbology: QRCode(),
      //         ),
      //       ),
      //     ),
      //   ],
      // ),
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
            if (!sendToPrint) logoContainer(context),
            if (sendToPrint)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(50.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    width: getWidth(90, context),
                    height: getHeight(20, context),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(width: 2),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const Text(
                          "فاتورة",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 26),
                          textAlign: TextAlign.center,
                        ),
                        // QrImageView(
                        //   data: widget.orderModel.orderId,
                        //   version: QrVersions.auto,
                        //   size: 200.0,
                        // ),
                        SfBarcodeGenerator(
                          value: widget.orderModel.orderId,
                          symbology: QRCode(),
                        ),

                        const Image(
                          image: AssetImage(AppAssets.assetsForsanNoBg),
                          fit: BoxFit.contain,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "تفاصيل الطلب:",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: MediaQuery.of(context).size.width > 600 ? 18 : 16,
                  ),
                ),
                // Text(
                //   "تاريخ الاصدار : ${DateTime.now().year} - ${DateTime.now().month} - ${DateTime.now().day}",
                //   style: TextStyle(
                //     fontWeight: FontWeight.bold,
                //     color: Colors.black,
                //     fontSize: MediaQuery.of(context).size.width > 600 ? 18 : 16,
                //   ),
                // ),
              ],
            ),

            const SizedBox(height: 10),

            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal:
                      MediaQuery.of(context).size.width > 600 ? 80.0 : 20.0),
              child: Table(
                border: TableBorder.all(
                  // Adding table borders for lines
                  color: Colors.grey, // Border color
                  width: 1, // Border width
                ),
                columnWidths: const {
                  0: FlexColumnWidth(1), // First column (Label)
                  1: FlexColumnWidth(2), // Second column (Value)
                },
                children: [
                  TableRow(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("اسم المستخدم:",
                            style: TextStyle(fontWeight: FontWeight.w600)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(model.orderUserName,
                            maxLines: 1, overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("الوصف:",
                            style: TextStyle(fontWeight: FontWeight.w600)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(model.orderDescription,
                            maxLines: 2, overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ),

                  TableRow(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("تاريخ الطلب:",
                            style: TextStyle(fontWeight: FontWeight.w600)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(getFormatDate(model.orderDate)),
                      ),
                    ],
                  ),

                  // Insert listOfOrderDetails into the table here
                  if ("product" != model.orderType &&
                      "service" != model.orderType)
                    ...listOfOrderDetails,
                  TableRow(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("الخصم:",
                            style: TextStyle(fontWeight: FontWeight.w600)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(model.orderDiscount.isEmpty
                            ? ("0 ${AppConstants.appCurrancy}")
                            : "${model.orderDiscount} ${AppConstants.appCurrancy}"),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("المجموع:",
                            style: TextStyle(fontWeight: FontWeight.w800)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                            "${model.orderPrice} ${AppConstants.appCurrancy}",
                            style:
                                const TextStyle(fontWeight: FontWeight.w800)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            getCube(5, context),
            if (!sendToPrint)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50.0),
                child: SfBarcodeGenerator(
                  value: widget.orderModel.orderId,
                  symbology: QRCode(),
                ),
              ),

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
                          "0501510093",
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
                        "forsan.print@gmail.com",
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
      appBar: appCustomBar("تأكيد الطلب", context),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // SizedBox(
            //   child: TextButton.icon(
            //     onPressed: () async {
            //       await printReceipt();
            //     },
            //     icon: const Icon(Icons.print_outlined, color: Colors.black),
            //     label: const Text(
            //       'طباعة وتنزيل الفاتورة',
            //       style: TextStyle(color: Colors.black),
            //     ),
            //   ),
            // ),
            // const SizedBox(height: 20),
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
      await screenshotController
          .captureFromWidget(saveConfirmedData(widget.orderModel, true),
              targetSize: const Size(800, 1200), pixelRatio: 2.0)
          .then((imageBytes) async {
        await fromImageSavePDF(imageBytes);
      });
    } catch (error) {
      showToast("حدث خطأ: ${error.toString()}", SnackBarType.fail, context);
    } finally {
      Navigator.of(context).pop();
    }
  }
}
