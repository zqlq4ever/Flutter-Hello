import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hello_flutter/res/colors.dart';
import 'package:hello_flutter/res/gaps.dart';
import 'package:hello_flutter/router/fluro_navigate_util.dart';
import 'package:hello_flutter/util/device_util.dart';
import 'package:hello_flutter/util/other_util.dart';
import 'package:hello_flutter/widgets/load_image.dart';
import 'package:hello_flutter/widgets/my_app_bar.dart';

/// 设置 - 关于我们
class AboutPage extends StatefulWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConst.bg_color,
      appBar: const MyAppBar(
        backgroundColor: Colors.white,
        centerTitle: '关于我们',
      ),
      body: Column(
        children: [
          Gaps.vLine,
          _logo('ic_logo', 'Hello Flutter'),
          Gaps.vGap8,
          _item('隐私条款', url: 'https://juejin.cn/android'),
          Gaps.vLine,
          _item('用户协议', url: 'https://www.wanandroid.com/'),
          Gaps.vLine,
          _item('版本更新', value: 'v1.0.0'),
          Gaps.vGap8,
          _item('官网主页', url: 'https://www.baidu.com'),
        ],
      ),
    );
  }

  _logo(String icon, String title) {
    return Container(
      width: double.infinity,
      child: Column(
        children: [
          Gaps.vGap40,
          LoadImage(
            icon,
            width: 80,
            height: 80,
          ),
          Gaps.vGap8,
          Text(
            title,
            style: const TextStyle(
              color: ColorConst.text,
              fontSize: 16,
            ),
          ),
          Gaps.vGap32,
        ],
      ),
      color: Colors.white,
    );
  }

  _item(String title, {String value = '', String url = ""}) => InkWell(
        onTap: () {
          if (url.isNotEmpty) {
            _launchWebURL(title, url);
          }
        },
        child: Container(
          height: 50,
          color: Colors.white,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Gaps.hGap16,
              Text(
                title,
                style: const TextStyle(
                  color: ColorConst.text,
                  fontSize: 16,
                ),
              ),
              Gaps.hGap8,
              Expanded(
                child: Text(
                  value,
                  textAlign: TextAlign.end,
                  style: const TextStyle(
                    fontSize: 16,
                    color: ColorConst.text_gray,
                  ),
                ),
              ),
              Gaps.hGap8,
              const LoadImage(
                'ic_arrow_right',
                width: 20,
                height: 20,
              ),
              Gaps.hGap16,
            ],
          ),
        ),
      );

  void _launchWebURL(String title, String url) {
    if (DeviceUtil.isMobile) {
      NavigateUtil.goWebViewPage(context, title, url);
    } else {
      Util.launchWebURL(url);
    }
  }
}
