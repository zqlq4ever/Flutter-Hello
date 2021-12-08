import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hello_flutter/res/colors.dart';
import 'package:hello_flutter/res/gaps.dart';
import 'package:hello_flutter/widgets/load_image.dart';
import 'package:hello_flutter/widgets/my_app_bar.dart';

/// 我的家 - 设置 - 账号管理
class AccountHomePage extends StatefulWidget {
  const AccountHomePage({Key? key}) : super(key: key);

  @override
  _AccountHomePageState createState() => _AccountHomePageState();
}

class _AccountHomePageState extends State<AccountHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConst.bg_color,
      appBar: const MyAppBar(
        backgroundColor: Colors.white,
        centerTitle: '账号管理',
      ),
      body: Column(
        children: [
          Gaps.vLine,
          _item('微信', '去绑定'),
          Gaps.vLine,
          _item('手机号', '12355556666'),
          Gaps.vLine,
          _item('修改密码', ''),
        ],
      ),
    );
  }

  _item(String title, String value) => Container(
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
      );
}