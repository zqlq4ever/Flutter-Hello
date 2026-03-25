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
  MobileScannerController? controller;
  bool _hasScanned = false;

  @override
  Widget build(BuildContext context) {
    final scanArea =
        (MediaQuery.of(context).size.width < 400 || MediaQuery.of(context).size.height < 400)
            ? 250.0
            : 300.0;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Positioned.fill(
            child: MobileScanner(
              controller: MobileScannerController(
                detectionSpeed: DetectionSpeed.noDuplicates,
                facing: CameraFacing.back,
              ),
              onDetect: (capture) {
                if (_hasScanned) return;
                final barcodes = capture.barcodes;
                if (barcodes.isNotEmpty) {
                  _hasScanned = true;
                  final barcode = barcodes.first;
                  Logger.d(barcode.rawValue ?? '');
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
                  controller?.toggleTorch();
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
    controller?.dispose();
    super.dispose();
  }
}
