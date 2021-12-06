import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hello_flutter/res/colors.dart';
import 'package:hello_flutter/router/fluro_navigate_util.dart';
import 'package:hello_flutter/widgets/my_app_bar.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrCodeScannerPage extends StatefulWidget {
  const QrCodeScannerPage({Key? key}) : super(key: key);

  @override
  _QrCodeScannerPageState createState() => _QrCodeScannerPageState();
}

class _QrCodeScannerPageState extends State<QrCodeScannerPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;

  /// In order to get hot reload to work we need to pause the camera if the platform
  /// is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    } else if (Platform.isIOS) {
      controller?.resumeCamera();
    }
  }

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
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
                borderColor: ColorConst.app_main,
                borderRadius: 2,
                borderLength: 20,
                borderWidth: 5,
                cutOutSize: scanArea,
              ),
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
                  controller?.toggleFlash();
                },
              ),
            ),
          ),
          Positioned(
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

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      /// 避免扫描结果多次回调
      controller.dispose();
      NavigateUtil.goBackWithParams(context, scanData.code ?? '');
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
