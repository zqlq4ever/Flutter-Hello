import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hello_flutter/models/contact_history/contact_history_device_bean.dart';
import 'package:hello_flutter/models/contact_history/contact_history_latest_bean.dart';
import 'package:hello_flutter/page/contact/widget/call_menu_dialog.dart';
import 'package:hello_flutter/res/colors.dart';
import 'package:hello_flutter/res/gaps.dart';
import 'package:hello_flutter/router/fluro_navigate_util.dart';
import 'package:hello_flutter/util/other_util.dart';
import 'package:hello_flutter/widgets/load_image.dart';
import 'package:hello_flutter/widgets/my_app_bar.dart';

import '../contact_router.dart';

/// 首页 - 通讯
class ContactHistoryPage extends StatefulWidget {
  const ContactHistoryPage({Key? key}) : super(key: key);

  @override
  _ContactHistoryPageState createState() => _ContactHistoryPageState();
}

class _ContactHistoryPageState extends State<ContactHistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorConst.bg_color,
        appBar: MyAppBar(
          backgroundColor: Colors.white,
          centerTitle: '通讯',
          rightText: '通讯录',
          isBack: false,
          onRightPressed: () => NavigateUtil.push(context, ContactRouter.contactListPage),
        ),
        body: Padding(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Gaps.vGap16,
                devicePart(),
                Gaps.vGap16,
                latestPart(),
                Gaps.vGap8,
              ],
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 8.0),
        ));
  }

  Card latestPart() => Card(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                '最近联系',
                style: TextStyle(
                  color: ColorConst.text,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            _latestAsync(),
            Gaps.vGap16,
          ],
        ),
      );

  _latestAsync() => FutureBuilder(
      future:
          DefaultAssetBundle.of(context).loadString('assets/data/ContactHistoryLatestData.json'),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Container();
        }
        //  json 解析为 List
        List result = json.decode(snapshot.data.toString());
        //  List 元素转为具体对象
        List<ContactHistoryLatestBean> latest =
            result.map((element) => ContactHistoryLatestBean.fromJson(element)).toList();

        return latestListView(latest);
      });

  latestListView(List<ContactHistoryLatestBean> data) => ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: data.length,
        itemBuilder: (context, index) => Stack(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Gaps.hGap16,
                ClipOval(
                  child: LoadImage(
                    data[index].contactPhoto ??
                        'https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fc-ssl.duitang.com%2Fuploads%2Fitem%2F202001%2F27%2F20200127073345_ixcrq.png&refer=http%3A%2F%2Fc-ssl.duitang.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1640414104&t=b2be48dcfae2dc885e9efaaac0831ac2',
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                  ),
                ),
                Gaps.hGap8,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data[index].contactName ?? "",
                      style: const TextStyle(
                        fontSize: 14,
                        color: ColorConst.text,
                      ),
                    ),
                    Text(
                      data[index].createTime ?? "",
                      style: const TextStyle(
                        fontSize: 14,
                        color: ColorConst.text_gray,
                      ),
                    ),
                  ],
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipOval(
                  child: InkWell(
                    onTap: () => showCallMenuDialog(context, (index) {
                      switch (index) {
                        //  视频
                        case 1:
                          break;
                        //  语音
                        case 2:
                          break;
                        //  电话
                        case 3:
                          Util.launchTelURL(data[index].phone ?? '');
                          break;
                      }
                    }),
                    child: const LoadImage(
                      'ic_call',
                      width: 32,
                      height: 32,
                    ),
                  ),
                ),
                Gaps.hGap16,
              ],
            ),
          ],
        ),
        separatorBuilder: (BuildContext context, int index) => Gaps.vGap12,
      );

  devicePart() => Card(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                '设备通话',
                style: TextStyle(
                  color: ColorConst.text,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            _deviceAsync(),
            Gaps.vGap16,
          ],
        ),
      );

  _deviceAsync() => FutureBuilder(
      future: DefaultAssetBundle.of(context)
          .loadString('assets/data/ContactHistoryDeviceListData.json'),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Container();
        }
        //  json 解析为 List
        List result = json.decode(snapshot.data.toString());
        //  List 元素转为具体对象
        List<ContactHistoryDeviceBean> device =
            result.map((element) => ContactHistoryDeviceBean.fromJson(element)).toList();

        return deviceListView(device);
      });

  deviceListView(List<ContactHistoryDeviceBean> data) => ListView.separated(
        shrinkWrap: true,
        //范围内进行包裹（内容多高ListView就多高）
        physics: const NeverScrollableScrollPhysics(),
        //禁止滚动
        itemCount: data.length,
        itemBuilder: (context, index) => Stack(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Gaps.hGap16,
                const ClipOval(
                  child: LoadImage(
                    'https://img0.baidu.com/it/u=1544923211,727191905&fm=15&fmt=auto',
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                  ),
                ),
                Gaps.hGap8,
                Text(
                  data[index].deviceNickname ?? "",
                  style: const TextStyle(
                    fontSize: 14,
                    color: ColorConst.text,
                  ),
                ),
                Visibility(
                  visible: data[index].isDfDevice == 1,
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    child: const Text(
                      '默认',
                      style: TextStyle(
                        fontSize: 12,
                        color: ColorConst.app_main,
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: ColorConst.app_main_55,
                      borderRadius: BorderRadius.circular((2.0)),
                    ),
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipOval(
                  child: InkWell(
                    onTap: () => showCallMenuDialog(context, (index) {
                      switch (index) {
                        case 1:
                          break;
                        case 2:
                          break;
                        case 3:
                          Util.launchTelURL(data[index].simPhone ?? '');
                          break;
                      }
                    }),
                    child: const LoadImage(
                      'ic_call',
                      width: 32,
                      height: 32,
                    ),
                  ),
                ),
                Gaps.hGap16,
              ],
            ),
          ],
        ),
        separatorBuilder: (BuildContext context, int index) => Gaps.vGap12,
      );
}
