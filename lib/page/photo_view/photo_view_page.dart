import 'package:flutter/material.dart';
import 'package:hello_flutter/util/image_util.dart';
import 'package:hello_flutter/widgets/my_app_bar.dart';
import 'package:photo_view/photo_view.dart';

/// 大图浏览
class PhotoViewPage extends StatefulWidget {
  const PhotoViewPage({
    Key? key,
    this.url = '',
  }) : super(key: key);

  final String url;

  @override
  _PhotoViewPageState createState() => _PhotoViewPageState();
}

class _PhotoViewPageState extends State<PhotoViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: MyAppBar(
        backImgColor: Colors.white,
        isBack: true,
        centerTitle: '',
        backgroundColor: Colors.transparent,
      ),
      body: PhotoView(
        imageProvider: ImageUtils.getImageProvider(widget.url),
      ),
    );
  }
}
