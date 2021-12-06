import 'package:common_utils/common_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hello_flutter/page/photo_view/photoview_router.dart';
import 'package:hello_flutter/res/colors.dart';
import 'package:hello_flutter/res/gaps.dart';
import 'package:hello_flutter/router/fluro_navigate_util.dart';
import 'package:hello_flutter/util/other_util.dart';
import 'package:hello_flutter/util/toast_util.dart';
import 'package:hello_flutter/widgets/load_image.dart';
import 'package:hello_flutter/widgets/my_app_bar.dart';

/// 通讯录 - 联系人 - 联系人详情
class ContactDetailPage extends StatefulWidget {
  const ContactDetailPage({
    Key? key,
    this.isDevice = false,
    this.name = '',
    this.icon = '',
    this.id = '',
    this.phone = '',
    this.group = '',
  }) : super(key: key);

  final bool isDevice;
  final String name;
  final String icon;
  final String id;
  final String phone;
  final String group;

  @override
  _ContactDetailPageState createState() => _ContactDetailPageState();
}

class _ContactDetailPageState extends State<ContactDetailPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: ColorConst.bg_color,
        appBar: MyAppBar(
          backgroundColor: Colors.white,
          centerTitle: widget.isDevice ? '设备信息' : '联系人信息',
        ),
        body: Column(
          children: [
            _topPart(),
            _deviceItem(widget.isDevice),
            _contactItem(!widget.isDevice),
            _addButton(!widget.isDevice),
          ],
        ),
      );

  _deviceItem(bool visible) => Visibility(
        visible: visible,
        child: InkWell(
          onTap: () {
            ToastUtil.show('打开设备管理页面');
          },
          child: _item('设备', ''),
        ),
      );

  _contactItem(bool visible) => Visibility(
        visible: visible,
        child: Column(
          children: [
            _item('昵称', widget.name),
            _item('手机号', widget.phone),
            _item('分组', widget.group),
          ],
        ),
      );

  _addButton(bool visible) => Visibility(
        visible: visible,
        child: Expanded(
          child: Container(
            alignment: Alignment.bottomCenter,
            margin: EdgeInsets.all(24),
            child: MaterialButton(
              minWidth: double.infinity,
              height: 44,
              color: ColorConst.app_main,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24))),
              onPressed: () {},
              child: Text(
                "好友申请",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      );

  _topPart() => Container(
        width: double.infinity,
        child: Column(
          children: [
            _imageText(widget.icon, widget.name, () {
              NavigateUtil.push(
                  context,
                  '${PhotoViewRouter.photoViewPage}?'
                  'url=${EncryptUtil.encodeBase64('https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fpic1.win4000.com%2Fwallpaper%2F2020-05-18%2F5ec21c5eb3f2a.jpg&refer=http%3A%2F%2Fpic1.win4000.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1641118054&t=182061e5b0cc9ff835274723d48e5d6e')}');
            }),
            Gaps.vGap16,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _imageText('ic_video_call_blue', '视频', () {}),
                _imageText('ic_audio_call_blue', '语音', () {}),
                _imageText('ic_sim_call_blue', '电话', () {
                  print('object');
                  Util.launchTelURL(widget.phone);
                }),
              ],
            ),
            Gaps.vGap16,
          ],
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              ColorConst.app_main_200,
              ColorConst.app_main_400,
            ],
          ),
        ),
      );

  _imageText(String icon, String title, Function click) => Column(
        children: [
          Gaps.vGap24,
          ClipOval(
            child: InkWell(
              onTap: () => click(),
              child: LoadImage(
                icon,
                width: 50,
                height: 50,
              ),
            ),
          ),
          Gaps.vGap8,
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ],
      );

  _item(String title, String value) => Container(
        height: 50,
        color: Colors.white,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Gaps.hGap16,
            Text(
              title,
              style: TextStyle(
                color: ColorConst.text,
                fontSize: 16,
              ),
            ),
            Gaps.hGap8,
            Expanded(
              child: Text(
                value,
                textAlign: TextAlign.end,
                style: TextStyle(
                  fontSize: 16,
                  color: ColorConst.text,
                ),
              ),
            ),
            Visibility(
              visible: title == '设备',
              child: LoadImage(
                'ic_arrow_right',
                width: 20,
                height: 20,
              ),
            ),
            Gaps.hGap16,
          ],
        ),
      );
}
