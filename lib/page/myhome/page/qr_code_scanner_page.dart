import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hello_flutter/l10n/app_localizations.dart';
import 'package:hello_flutter/util/log_util.dart';
import 'package:hello_flutter/widgets/my_app_bar.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrCodeScannerPage extends StatefulWidget {
  const QrCodeScannerPage({Key? key}) : super(key: key);

  @override
  _QrCodeScannerPageState createState() => _QrCodeScannerPageState();
}

class _QrCodeScannerPageState extends State<QrCodeScannerPage>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  late MobileScannerController controller;
  bool _hasScanned = false;
  bool _isDisposed = false;
  late final AnimationController _scanLineController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    controller = MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
      facing: CameraFacing.back,
    );
    _scanLineController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_isDisposed) return;
    switch (state) {
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
        controller.stop();
        break;
      case AppLifecycleState.resumed:
        if (!_hasScanned) {
          controller.start();
        }
        break;
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final topPadding = MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          Positioned.fill(
            child: MobileScanner(
              controller: controller,
              onDetect: (capture) async {
                if (_hasScanned || _isDisposed) return;
                final barcodes = capture.barcodes;
                if (barcodes.isEmpty) return;

                _hasScanned = true;
                final barcode = barcodes.first;
                Logger.d(barcode.rawValue ?? '');
                // 先停止相机，避免解码错误
                await controller.stop();
                if (!mounted) return;
                Get.back(result: barcode.rawValue);
              },
            ),
          ),

          // 遮罩 + 取景框 + 扫描线
          Positioned.fill(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final size = constraints.biggest;
                final cutOutSize = math.min(size.width, size.height) * 0.62;
                final cutOutRect = Rect.fromCenter(
                  center: Offset(size.width / 2, size.height / 2),
                  width: cutOutSize,
                  height: cutOutSize,
                );
                return AnimatedBuilder(
                  animation: _scanLineController,
                  builder: (context, child) {
                    return CustomPaint(
                      painter: _ScannerOverlayPainter(
                        cutOutRect: cutOutRect,
                        scanLineProgress: _scanLineController.value,
                      ),
                      child: const SizedBox.expand(),
                    );
                  },
                );
              },
            ),
          ),

          // 顶部栏（更有层次的渐变底）
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(top: topPadding),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0x99000000),
                    Color(0x00000000),
                  ],
                ),
              ),
              child: MyAppBar(
                backgroundColor: Colors.transparent,
                backImgColor: Colors.white,
                centerTitle: l10n.scannerTitle,
              ),
            ),
          ),

          // 提示文案
          Positioned(
            left: 0,
            right: 0,
            bottom: 160,
            child: Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                margin: const EdgeInsets.symmetric(horizontal: 24),
                decoration: BoxDecoration(
                  color: const Color(0x88000000),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  l10n.scannerHint,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    height: 1.2,
                  ),
                ),
              ),
            ),
          ),

          // 底部操作栏
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              top: false,
              child: Container(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Color(0xCC000000),
                      Color(0x00000000),
                    ],
                  ),
                ),
                child: Center(
                  child: _ActionPillButton(
                    icon: Icons.flash_on_rounded,
                    label: l10n.scannerTorch,
                    onPressed: controller.toggleTorch,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _isDisposed = true;
    WidgetsBinding.instance.removeObserver(this);
    _scanLineController.dispose();
    controller.dispose();
    super.dispose();
  }
}

class _ActionPillButton extends StatelessWidget {
  const _ActionPillButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(28),
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0x1AFFFFFF),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: const Color(0x33FFFFFF)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScannerOverlayPainter extends CustomPainter {
  _ScannerOverlayPainter({
    required this.cutOutRect,
    required this.scanLineProgress,
  });

  final Rect cutOutRect;
  final double scanLineProgress;

  static const double _radius = 18;
  static const double _borderWidth = 3;
  static const double _cornerLength = 28;

  @override
  void paint(Canvas canvas, Size size) {
    // 蒙层
    final overlayPaint = Paint()..color = const Color(0x99000000);
    final fullPath = Path()..addRect(Offset.zero & size);
    final cutoutPath = Path()
      ..addRRect(
          RRect.fromRectAndRadius(cutOutRect, const Radius.circular(_radius)));
    final overlayPath =
        Path.combine(PathOperation.difference, fullPath, cutoutPath);
    canvas.drawPath(overlayPath, overlayPaint);

    // 取景框描边（弱边框）
    final framePaint = Paint()
      ..color = const Color(0x33FFFFFF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawRRect(
      RRect.fromRectAndRadius(cutOutRect, const Radius.circular(_radius)),
      framePaint,
    );

    // 四角高亮
    final cornerPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = _borderWidth
      ..strokeCap = StrokeCap.round;

    void drawCorner(Offset start, Offset mid, Offset end) {
      final path = Path()
        ..moveTo(start.dx, start.dy)
        ..lineTo(mid.dx, mid.dy)
        ..lineTo(end.dx, end.dy);
      canvas.drawPath(path, cornerPaint);
    }

    final r = _radius;
    final l = cutOutRect.left;
    final t = cutOutRect.top;
    final rr = cutOutRect.right;
    final b = cutOutRect.bottom;

    // 左上
    drawCorner(
      Offset(l + r, t + _cornerLength),
      Offset(l + r, t + r),
      Offset(l + _cornerLength, t + r),
    );
    // 右上
    drawCorner(
      Offset(rr - _cornerLength, t + r),
      Offset(rr - r, t + r),
      Offset(rr - r, t + _cornerLength),
    );
    // 左下
    drawCorner(
      Offset(l + _cornerLength, b - r),
      Offset(l + r, b - r),
      Offset(l + r, b - _cornerLength),
    );
    // 右下
    drawCorner(
      Offset(rr - r, b - _cornerLength),
      Offset(rr - r, b - r),
      Offset(rr - _cornerLength, b - r),
    );

    // 扫描线
    final y = cutOutRect.top + cutOutRect.height * scanLineProgress;
    final lineRect =
        Rect.fromLTWH(cutOutRect.left + 12, y - 1, cutOutRect.width - 24, 2);
    final linePaint = Paint()
      ..shader = const LinearGradient(
        colors: [
          Color(0x00FFFFFF),
          Color(0xFFFFFFFF),
          Color(0x00FFFFFF),
        ],
      ).createShader(lineRect);
    canvas.drawRRect(
      RRect.fromRectAndRadius(lineRect, const Radius.circular(999)),
      linePaint,
    );
  }

  @override
  bool shouldRepaint(covariant _ScannerOverlayPainter oldDelegate) {
    return oldDelegate.cutOutRect != cutOutRect ||
        oldDelegate.scanLineProgress != scanLineProgress;
  }
}
