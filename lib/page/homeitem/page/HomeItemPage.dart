import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:hello_flutter/models/contact_history/contact_history_device_bean.dart';
import 'package:hello_flutter/page/setting/setting_router.dart';
import 'package:hello_flutter/res/colors.dart';
import 'package:hello_flutter/res/gaps.dart';
import 'package:hello_flutter/router/fluro_navigate_util.dart';
import 'package:hello_flutter/widgets/load_image.dart';
import 'package:hello_flutter/widgets/my_app_bar.dart';

import '../home_item_page_router.dart';

class HomeItemPage extends StatefulWidget {
  const HomeItemPage({Key? key}) : super(key: key);

  @override
  _HomeItemPageState createState() => _HomeItemPageState();
}

class _HomeItemPageState extends State<HomeItemPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.manual,
        overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom],
      );
      SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        LoadAssetImage(
          'bg',
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.fill,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: MyAppBar(
            backgroundColor: Colors.transparent,
            centerTitle: '我的家',
            isBack: false,
          ),
          body: Column(
            children: [
              Gaps.vGap32,
              Stack(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(left: 24, right: 8),
                        child: ClipOval(
                          child: LoadImage(
                            'https://img0.baidu.com/it/u=3371242447,3161305562&fm=26&fmt=auto',
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Text(
                        '我是昵称',
                        style: TextStyle(
                          color: ColorConst.text,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      IconButton(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          alignment: Alignment.centerRight,
                          onPressed: () => NavigateUtil.push(context, HomeItemPageRouter.scan),
                          icon: ImageIcon(
                            AssetImage('assets/images/ic_scan.png'),
                          )),
                      Gaps.hGap18,
                      IconButton(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        alignment: Alignment.centerRight,
                        onPressed: () => NavigateUtil.push(context, SettingRouter.settingPage),
                        icon: Icon(Icons.settings),
                      ),
                      Gaps.hGap24,
                    ],
                  )
                ],
              ),
              Gaps.vGap32,
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: _deviceAsync(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

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

        return _deviceListView(device);
      });

  _deviceListView(List<ContactHistoryDeviceBean> data) => GridView.builder(
        itemCount: data.length,
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16.0,
          crossAxisSpacing: 16.0,
          childAspectRatio: 1.97,
        ),
        itemBuilder: (BuildContext context, int index) {
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Gaps.hGap16,
                ClipOval(
                  child: LoadImage(
                    'https://img2.baidu.com/it/u=1950742506,2138794826&fm=26&fmt=auto',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
                Gaps.hGap8,
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data[index].deviceNickname ?? "",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          color: ColorConst.text,
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 4),
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                                color: data[index].deviceState == 0 ? Colors.green : Colors.grey,
                                borderRadius: BorderRadius.all(Radius.circular(3))),
                          ),
                          Expanded(
                            child: Text(
                              data[index].deviceState == 0 ? '在线' : "离线",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12,
                                color: ColorConst.text_gray,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        },
      );
}
