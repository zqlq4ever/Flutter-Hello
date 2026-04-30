import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hello_flutter/util/image_util.dart';

/// 图片加载（支持本地与网络图片）
class LoadImage extends StatelessWidget {
  const LoadImage(
    this.image, {
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.format = ImageFormat.png,
    this.holderImg = '',
    this.cacheWidth,
    this.cacheHeight,
  });

  final String image;
  final double? width;
  final double? height;
  final BoxFit fit;
  final ImageFormat format;
  final String holderImg;
  final int? cacheWidth;
  final int? cacheHeight;

  @override
  Widget build(BuildContext context) {
    //  网络图片 + 无图
    if (image.isEmpty || image.startsWith('http')) {
      final Widget placeholderImage =
          LoadAssetImage(holderImg, height: height, width: width, fit: fit);
      return CachedNetworkImage(
        imageUrl: image,
        placeholder: (_, __) => placeholderImage,
        errorWidget: (_, __, dynamic error) => placeholderImage,
        width: width,
        height: height,
        fit: fit,
        memCacheWidth: cacheWidth ?? 800,
        memCacheHeight: cacheHeight ?? 800,
      );
    }

    return LoadAssetImage(
      image,
      height: height,
      width: width,
      fit: fit,
      format: format,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }
}

/// 加载本地资源图片
class LoadAssetImage extends StatelessWidget {
  const LoadAssetImage(this.image,
      {super.key,
      this.width,
      this.height,
      this.cacheWidth,
      this.cacheHeight,
      this.fit,
      this.format = ImageFormat.png,
      this.color});

  final String image;
  final double? width;
  final double? height;
  final int? cacheWidth;
  final int? cacheHeight;
  final BoxFit? fit;
  final ImageFormat format;
  final Color? color;

  IconData? _fallbackIcon(String name) {
    switch (name) {
      case 'ic_arrow_right':
        return Icons.chevron_right_rounded;
      case 'ic_call':
        return Icons.call_rounded;
      case 'ic_scan':
        return Icons.qr_code_scanner_rounded;
      case 'ic_home':
        return Icons.home_rounded;
      case 'ic_contact':
        return Icons.contacts_rounded;
      case 'ic_data':
        return Icons.insert_chart_rounded;
      case 'order/order_search':
        return Icons.search_rounded;
      case 'order/order_delete':
        return Icons.close_rounded;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    if (image.isEmpty) {
      return SizedBox(
        height: height,
        width: width,
      );
    }

    final icon = _fallbackIcon(image);
    if (icon != null) {
      final size = (width ?? height ?? 24).toDouble();
      return SizedBox(
        width: width ?? size,
        height: height ?? size,
        child: Icon(
          icon,
          size: size,
          color: color,
        ),
      );
    }

    return Image.asset(
      ImageUtils.getImgPath(image, format: format),
      height: height,
      width: width,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
      fit: fit,
      color: color,
      errorBuilder: (context, error, stackTrace) {
        return SizedBox(
          height: height,
          width: width,
        );
      },

      /// 忽略图片语义
      excludeFromSemantics: true,
    );
  }
}
