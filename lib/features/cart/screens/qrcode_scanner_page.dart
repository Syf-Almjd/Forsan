import 'package:flutter/material.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:forsan/features/shared/components.dart';
import 'package:forsan/features/cart/screens/payment/order_receipt.dart';
import 'package:forsan/features/home_screen/widgets/choose_file_widget.dart';
import 'package:forsan/state/app_data_cubit/app_cubit.dart';
import 'package:forsan/state/navigation_cubit/navi_cubit.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRCodeScannerPage extends StatefulWidget {
  const QRCodeScannerPage({super.key});

  @override
  QRCodeScannerPageState createState() => QRCodeScannerPageState();
}

class QRCodeScannerPageState extends State<QRCodeScannerPage> {
  bool isChecked = false;

  late QRViewController _controller;
  final GlobalKey _qrKey = GlobalKey(debugLabel: 'QR');
  String scannedData = "لا يوجد كود...";
  CameraFacing cameraFacing = CameraFacing.back;

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
            child: QRView(
              cameraFacing: cameraFacing,
              key: _qrKey,
              onQRViewCreated: _onQRViewCreated,
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
                        _controller.toggleFlash();
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
                      _controller.flipCamera();
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
    _controller.flipCamera();
  }

  void _onQRViewCreated(QRViewController controller) {
    _controller = controller;
    _controller.scannedDataStream.listen((scanData) async {
      setState(() {
        scannedData = scanData.code!;
        isChecked = isChecked;
      });
      if (scanData.code!.isNotEmpty && isChecked == false) {
        isChecked = true;
        if (mounted) {
          await checkNnavigate(context, scanData.code!);
        }
      }
    });
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
