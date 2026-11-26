import 'package:flutter/material.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:forsan/features/shared/components.dart';
import 'package:forsan/features/cart/screens/payment/order_receipt.dart';
import 'package:forsan/features/home_screen/widgets/choose_file_widget.dart';
import 'package:forsan/state/app_data_cubit/app_cubit.dart';
import 'package:forsan/state/navigation_cubit/navi_cubit.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRCodeScannerPage extends StatefulWidget {
  const QRCodeScannerPage({super.key});

  @override
  QRCodeScannerPageState createState() => QRCodeScannerPageState();
}

class QRCodeScannerPageState extends State<QRCodeScannerPage> {
  bool isChecked = false;

  final MobileScannerController _controller =
      MobileScannerController(facing: CameraFacing.back);
  String scannedData = "لا يوجد كود...";

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appCustomBar("مسح الكود", context),
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: MobileScanner(
              controller: _controller,
              onDetect: _onDetect,
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.flashlight_on_outlined,
                      size: 50,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      setState(() {
                        _controller.toggleTorch();
                      });
                    },
                  ),
                  Text(
                    scannedData,
                    style: const TextStyle(color: Colors.black),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.cameraswitch_outlined,
                      size: 50,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      _controller.switchCamera();
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void toggleCamera() {
    _controller.switchCamera();
  }

  Future<void> _onDetect(BarcodeCapture capture) async {
    final code =
        capture.barcodes.isEmpty ? null : capture.barcodes.first.rawValue;
    if (code == null || code.isEmpty) return;
    setState(() {
      scannedData = code;
    });
    if (isChecked == false) {
      isChecked = true;
      if (mounted) {
        await checkNnavigate(context, code);
      }
    }
  }
}

checkNnavigate(context, data) async {
  showLoadingDialog(context);
  var profile = await AppCubit.get(context).getLocalUserData();
  var order = await AppCubit.get(context).getOrderById(profile.userID, data);
  Navigator.pop(context);
  if (order != null) {
    NaviCubit.get(context)
        .navigate(context, OrderReceiptPage(orderModel: order));
  } else {
    showToast('لم يتم العثور على الطلب', SnackBarType.fail, context);
  }
}
