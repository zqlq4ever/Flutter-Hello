import 'dart:io';

import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hello_flutter/res/colors.dart';
import 'package:hello_flutter/util/device_util.dart';
import 'package:hello_flutter/util/image_util.dart';
import 'package:hello_flutter/util/theme_util.dart';
import 'package:hello_flutter/util/toast_util.dart';
import 'package:image_picker/image_picker.dart';

class SelectedImage extends StatefulWidget {
  const SelectedImage({
    Key? key,
    this.url,
    this.heroTag,
    this.size = 80.0,
  }) : super(key: key);

  final String? url;
  final String? heroTag;
  final double size;

  @override
  SelectedImageState createState() => SelectedImageState();
}

class SelectedImageState extends State<SelectedImage> {
  final ImagePicker _picker = ImagePicker();
  ImageProvider? _imageProvider;
  XFile? pickedFile;

  Future<void> _getImage() async {
    try {
      pickedFile = await _picker.pickImage(source: ImageSource.gallery, maxWidth: 800);
      if (pickedFile != null) {
        if (DeviceUtil.isWeb) {
          _imageProvider = NetworkImage(pickedFile!.path);
        } else {
          _imageProvider = FileImage(File(pickedFile!.path));
        }
      } else {
        _imageProvider = null;
      }
      setState(() {});
    } catch (e) {
      if (e is MissingPluginException) {
        ToastUtil.show('当前平台暂不支持！');
      } else {
        ToastUtil.show('没有权限，无法打开相册！');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final ColorFilter _colorFilter = ColorFilter.mode(
        ThemeUtil.isDark(context) ? ColorConst.dark_unselected_item_color : ColorConst.text_gray,
        BlendMode.srcIn);

    Widget image = Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        // 图片圆角展示
        borderRadius: BorderRadius.circular(16.0),
        image: DecorationImage(
            image: _imageProvider ?? ImageUtils.getImageProvider(widget.url),
            fit: BoxFit.cover,
            colorFilter:
                _imageProvider == null && TextUtil.isEmpty(widget.url) ? _colorFilter : null),
      ),
    );

    if (widget.heroTag != null && !DeviceUtil.isWeb) {
      image = Hero(tag: widget.heroTag!, child: image);
    }

    return Semantics(
      label: '选择图片',
      hint: '跳转相册选择图片',
      child: InkWell(
        borderRadius: BorderRadius.circular(16.0),
        onTap: _getImage,
        child: image,
      ),
    );
  }
}
