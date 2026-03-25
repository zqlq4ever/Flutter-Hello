import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hello_flutter/res/colors.dart';
import 'package:hello_flutter/util/log_util.dart';
import 'package:hello_flutter/widgets/my_app_bar.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrCodeScannerPage extends StatefulWidget {
  const QrCodeScannerPage({Key? key}) : super(key: key);

  @override
  _QrCodeScannerPageState createState() => _QrCodeScannerPageState();
}

class _QrCodeScannerPageState extends State<QrCodeScannerPage> {
  late MobileScannerController controller;
  bool _hasScanned = false;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    controller = MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
      facing: CameraFacing.back,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Positioned.fill(
            child: MobileScanner(
              controller: controller,
              onDetect: (capture) async {
                if (_hasScanned || _isDisposed) return;
                final barcodes = capture.barcodes;
                if (barcodes.isNotEmpty) {
                  _hasScanned = true;
                  final barcode = barcodes.first;
                  Logger.d(barcode.rawValue ?? '');
                  // 先停止相机，避免解码错误
                  await controller.stop();
                  Get.back(result: barcode.rawValue);
                }
              },
            ),
          ),
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Center(
              child: IconButton(
                icon: const Icon(
                  Icons.highlight_outlined,
                  size: 40,
                  color: Colors.white,
                ),
                onPressed: () {
                  controller.toggleTorch();
                },
              ),
            ),
          ),
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: MyAppBar(
              backgroundColor: Colors.transparent,
              backImgColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _isDisposed = true;
    controller.dispose();
    super.dispose();
  }
}
