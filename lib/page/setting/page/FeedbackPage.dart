import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hello_flutter/page/setting/widget/feedback_type_dialog.dart';
import 'package:hello_flutter/res/colors.dart';
import 'package:hello_flutter/res/gaps.dart';
import 'package:hello_flutter/widgets/load_image.dart';
import 'package:hello_flutter/widgets/my_app_bar.dart';

/// 设置 - 问题反馈
class FeedbackPage extends StatefulWidget {
  const FeedbackPage({Key? key}) : super(key: key);

  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  //  输入框文本
  final TextEditingController _searchController = TextEditingController(text: "");

  //  输入框焦点
  final FocusNode _nodeSearch = FocusNode();
  final ValueNotifier<String> feedbackType = ValueNotifier<String>('硬件设备相关');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConst.bg_color,
      appBar: MyAppBar(
        backgroundColor: Colors.white,
        centerTitle: '问题反馈',
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Gaps.vGap8,
            ValueListenableBuilder<String>(
              valueListenable: feedbackType,
              builder: (context, value, child) {
                return _feedbackItem('反馈类型', value);
              },
            ),
            Gaps.vGap8,
            Container(
              padding: EdgeInsets.all(16),
              width: double.infinity,
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '问题描述',
                    style: TextStyle(
                      color: ColorConst.text,
                      fontSize: 16,
                    ),
                  ),
                  Gaps.vGap8,
                  _input(),
                  Gaps.vGap16,
                  _buildBody,
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _input() => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: TextField(
          minLines: 5,
          maxLines: 8,
          cursorWidth: 3,
          focusNode: _nodeSearch,
          controller: _searchController,
          decoration: InputDecoration(
              fillColor: Colors.transparent,
              contentPadding: EdgeInsets.all(0),
              counterText: '',
              border: InputBorder.none,
              hintText: '请尽量详细的描述您的问题'),
        ),
      );

  get _buildBody => GridView.builder(
        itemCount: 5,
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 16.0,
          crossAxisSpacing: 16.0,
          childAspectRatio: 1.0,
        ),
        itemBuilder: (BuildContext context, int index) {
          return _logo(
            'https://img1.baidu.com/it/u=874684164,351998096&fm=26&fmt=auto',
            isPhoto: index != 4,
          );
        },
      );

  _logo(String icon, {bool isPhoto = true}) {
    return Stack(
      children: [
        Visibility(
          visible: !isPhoto,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              border: Border.all(
                width: 1,
                color: ColorConst.bg_color,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add,
                  size: 24,
                  color: ColorConst.text_gray,
                ),
                Gaps.vGap8,
                Text(
                  '最多上传5张',
                  style: TextStyle(
                    color: ColorConst.text_gray,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ),
        Visibility(
          visible: isPhoto,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: AspectRatio(
              aspectRatio: 1,
              child: LoadImage(icon),
            ),
          ),
        ),
      ],
    );
  }

  _feedbackItem(String title, String value) => InkWell(
        onTap: () {
          FeedbackTypeDialog(context, (feedback) {
            feedbackType.value = feedback;
          });
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
              Gaps.hGap8,
              LoadImage(
                'ic_arrow_right',
                width: 20,
                height: 20,
              ),
              Gaps.hGap16,
            ],
          ),
        ),
      );
}
